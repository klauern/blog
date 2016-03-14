+++
date = "2016-03-13T20:00:00-05:00"
draft = false
title = "JVM GC Log Parsing"

+++

Along the same lines as my [previous post](netgearlogs), I had a need to
analyze a set of JVM Garbage Collector logs for event types.  Consider a log
entry like the following:

```
2016-02-11T23:39:01.847-0600: 6062789.760: [GC2016-02-11T23:39:01.848-0600: 6062789.761: [ParNew
Desired survivor size 178946048 bytes, new threshold 15 (max 15)
- age   1:    3565648 bytes,    3565648 total
- age   2:     278800 bytes,    3844448 total
- age   3:    1203288 bytes,    5047736 total
- age   4:      33184 bytes,    5080920 total
- age   5:    1717432 bytes,    6798352 total
- age   6:    1673032 bytes,    8471384 total
- age   7:     792920 bytes,    9264304 total
- age   8:     275424 bytes,    9539728 total
- age   9:     262384 bytes,    9802112 total
- age  10:     517584 bytes,   10319696 total
- age  11:       4576 bytes,   10324272 total
- age  12:     444104 bytes,   10768376 total
- age  13:      32080 bytes,   10800456 total
- age  14:     512392 bytes,   11312848 total
- age  15:     359904 bytes,   11672752 total
: 1416735K->15751K(1747648K), 0.0379220 secs] 4798752K->3399739K(8039104K), 0.0384330 secs] [Times: user=0.00 sys=0.32, real=0.04 secs]
Heap
 par new generation   total 1747648K, used 1145132K [0x00000005a0000000, 0x0000000620000000, 0x0000000620000000)
  eden space 1398144K,  80% used [0x00000005a0000000, 0x00000005e4ee9178, 0x00000005f5560000)
  from space 349504K,   4% used [0x000000060aab0000, 0x000000060ba11eb8, 0x0000000620000000)
  to   space 349504K,   0% used [0x00000005f5560000, 0x00000005f5560000, 0x000000060aab0000)
 concurrent mark-sweep generation total 6291456K, used 3383987K [0x0000000620000000, 0x00000007a0000000, 0x00000007a0000000)
 concurrent-mark-sweep perm gen total 941872K, used 553029K [0x00000007a0000000, 0x00000007d97cc000, 0x0000000800000000)
```

This kind of log entry is far from simple to understand.  I could go about
hand-writing another parser, but I don't know if it would be anywhere near the
same level of complexity.  In fact, for the most part, all I really wanted to
know was the following:

**2016-02-11T23:39:01.847-0600**: **6062789.760**: [GC2016-02-11T23:39:01.848-0600: 6062789.761: [**ParNew**

Trying to parse much else from the get-go seemed a bit much, and there's
a **lot** of output that I'd have to skip around just to find these entries.

Not knowing where to look, I threw a question out to one of my favorite go-to
tools for parsing JVM logs: [GCViewer](https://github.com/chewiebug/GCViewer).
There must be _something_ that you can use in there to parse out a log entry.
Reaching out to the developer in an issue, I was able to get pointed in the
[right direction](https://github.com/chewiebug/GCViewer/issues/164#issuecomment-195405552):

> Hi Nick,
>
> I see two options to get the information for your alerting:
>
>   1. use the command-line interface of GCViewer to generate a CSV file
>      containing a lot of information (java -jar gcviewer-1.3x.jar gc.log
>      summary.csv) -> parse the csv file and extract the information
>   2. `java/com/tagtraum/perf/gcviewer/imp/DataReaderFacade.java` and use
>      the resulting GCModel to extract the information you are looking for for
>      the alerts.
>
> Best regards,
> Jörg

I looked at #2, and found that this makes parsing a log file relatively
painless, and gives you a lot in the way of structural analysis of the logs
themselves.

## Using GCViewer for Log Parsing as an API

```java
package klauern;

import com.tagtraum.perf.gcviewer.imp.DataReaderException;
import com.tagtraum.perf.gcviewer.imp.DataReaderFacade;
import com.tagtraum.perf.gcviewer.model.*;

import java.util.Iterator;

public class EventParser {

    public static void main(String[] args) throws DataReaderException {
        System.out.println("Getting DataReader facade");
        DataReaderFacade drf = new DataReaderFacade();
        System.out.println("Loading model");
        GCModel model = drf.loadModel(new GCResource("src/test/resources/gc-log.current"));
        System.out.println("Model Loaded");

        System.out.println("List Full GC Events:\n");
        Iterator<GCEvent> full_gcs = model.getFullGCEvents();
        while (full_gcs.hasNext()) {
            GCEvent event = full_gcs.next();
            System.out.println("Date: " + event.getDatestamp() + " Pause: " + event.getPause());
        }
        System.out.println("List stop the world events:\n");
        Iterator<AbstractGCEvent<?>> stw_events = model.getStopTheWorldEvents();
        while (stw_events.hasNext()) {
            AbstractGCEvent<?> event = stw_events.next();
            System.out.println("Type: " + event.getTypeAsString() + " Date: " + event.getDatestamp() + " Pause: " + event.getPause());
        }

        System.out.println("List CMS GC events");
        Iterator<ConcurrentGCEvent> cms_gc_events = model.getConcurrentGCEvents();
        while (cms_gc_events.hasNext()) {
            ConcurrentGCEvent event = cms_gc_events.next();
            System.out.println("Date: " + event.getDatestamp() + " Pause: " + event.getPause());
        }
    }
}
```

This is just so simple, you have a lot at your fingertips.  Running this little
sample code on one of my example JVM logs produces the following:

```
Getting datareader facade
Loading model
Model Loaded
List Full GC Events:

List stop the world events:

Type: GC; ParNew Date: 2016-02-11T10:46:54.607-06:00 Pause: 0.058497
Type: GC; ParNew Date: 2016-02-11T10:47:34.438-06:00 Pause: 0.060133
Type: GC; ParNew Date: 2016-02-11T10:47:54.505-06:00 Pause: 0.057339
Type: GC; ParNew Date: 2016-02-11T10:47:56.742-06:00 Pause: 0.042955
.... # continues for a while
List CMS GC events
Date: 2016-02-11T15:04:21.175-06:00 Pause: 0.0
Date: 2016-02-11T15:04:23.193-06:00 Pause: 2.018
Date: 2016-02-11T15:04:23.193-06:00 Pause: 0.0
Date: 2016-02-11T15:04:23.231-06:00 Pause: 0.036
Date: 2016-02-11T15:04:23.231-06:00 Pause: 0.0
Date: 2016-02-11T15:04:28.254-06:00 Pause: 4.912
Date: 2016-02-11T15:04:29.004-06:00 Pause: 0.0
Date: 2016-02-11T15:04:34.463-06:00 Pause: 3.232
Date: 2016-02-11T15:04:34.463-06:00 Pause: 0.0
Date: 2016-02-11T15:04:34.491-06:00 Pause: 0.028
```

From this point, I can really pull together some good statistics on frequency,
rate of growth, high-activity, and create those smell tests that you wish you
knew before something blew up in your face.  In my work experience, it's not
often that people do enough testing with production-sized loads, or if they do,
they underestimate what those load look like.  It's the worst possible scenario
to have poor performance only in your production environment, as it is
a possible indicator that these kind of GC-related events were present in your
testing but were completely missed or avoided because they weren't visible.
