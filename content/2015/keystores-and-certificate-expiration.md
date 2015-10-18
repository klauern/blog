+++
date = "2015-10-15T20:02:18-05:00"
draft = false
title = "keystores and certificate expiration"

+++

I've seldom had to work with the Java Keystore, but as more and more sites start
using SSL, it's grown more important to ensure that certificates stored on your
side don't arbitrarily expire.  This is especially important if you're not
simply relying or verifying intermediate and root certificates.  A self-signed
server certificate is oftentimes *easy enough* to do for some applications, and
that expiration can come quicker than you anticipate.

In this section, I'll demonstrate a little bit about how you can get at the
certificate store within the relatively standard JKS-format of the Java
Cryptography Keystore.  Other stores may not work this way, or may require
a different set of processes.

Side Note: I have to give credit where credit is due, and [this StackOverflow
answer](http://stackoverflow.com/a/10986535/7008)
provided a great starting point for getting things going.  It was essentially
the foundation for what you'll see in this post.

# Parsing the Keystore

To make this easy, I generally use the following libraries in most of my
projects:

1. [Google Guava](https://github.com/google/guava)
2. [Joda Time](http://www.joda.org/joda-time/)
   - Of course, if you're lucky enough to use Java 8, we'd be using
     [Java 8's Date and Time](http://www.oracle.com/technetwork/articles/java/jf14-date-time-2125367.html)
     library.  But, for a vast majority of users, we're stuck with 7 or less.
     Ah, c'est la vie.


Reading the Keystore is actually a pretty straight-forward process:

<pre>
<code class="language-java">
// import a ton of stuff
import com.google.common.collect.Lists;
import com.google.common.collect.Maps;
import org.joda.time.DateTime;
import org.joda.time.Days;

import java.io.FileInputStream;
import java.io.IOException;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableEntryException;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.util.*;

// ... more code, some method somewhere

KeyStore ks = KeyStore.getInstance(KeyStore.getDefaultType());
char[] pass = "changeit"; // or whatever

java.io.InputStream fis = null;
try {
    fis = Reader.class.getClassLoader().getResourceAsStream(file_path);
    ks.load(fis, pass);

    // Get Certificate listing

} finally {
    if (fis != null) {
        fis.close();
    }
}
</code>
</pre>


# Traversing Certificates and Aliases

From this point, we're able to read in and claim **success**! Nah, not really.
What do you want to do with this?  Well, in this case, our KeyStore will have
a lot of various certificates and trusts in it.  For our use, we simply want to
validate the ones that are going to expire.

With each certificate that we have, there are likely 1 or more other
certificates in a [**certificate chain**](https://support.dnsimple.com/articles/what-is-ssl-certificate-chain/).
We aren't simply going to find expired server certificates (although that's
laudable in and of itself), but we want to be sure we aren't going to suffer the
fate of thinking "well, our server cert passed, but this whole tree of servers'
intermediate certificates expired".

<pre>
<code class="language-java">
private static Map<String, List<Certificate>> getCertMap(KeyStore ks) throws KeyStoreException {
    Map<String, List<Certificate>> cert_map = Maps.newHashMap(); // Good 'ol Guava
    // Each KeyStore can return an "Enumeration" of aliases
    Enumeration<String> aliases = ks.aliases();
    while (aliases.hasMoreElements()) {
        String alias = aliases.nextElement();
        Certificate[] certs = ks.getCertificateChain(alias);
        // It's not a guarantee that you'll have ANY certificates
        if (certs != null && certs.length > 0) {
            cert_map.put(alias, Lists.newArrayList(certs));
        } else {
            Certificate cert = ks.getCertificate(alias);
            cert_map.put(alias, Lists.newArrayList(cert));
        }
    }
    return cert_map;
}
</code>
</pre>

# Filtering

Another assumption being made here is that if you have a certificate that's
going to expire, it's most likely an **X.509** certificate, and so we only need
to be concerned with a subset of certificates.

<pre>
<code class="language-java">
    private static Map<String, List<X509Certificate>> filterX509Certs(Map<String, List<Certificate>> cert_map) {
        Map<String, List<X509Certificate>> x509_map = Maps.newHashMap();
        for (Map.Entry<String, List<Certificate>> c : cert_map.entrySet()) {
            List<X509Certificate> certs = Lists.newArrayListWithCapacity(c.getValue().size());
            for (Certificate cert : c.getValue()) {
                // This is where the magic happens...
                if (cert.getType().equals("X.509")) {
                    // cast the type to X509Certificate
                    certs.add((X509Certificate) cert);
                }
            }
            x509_map.put(c.getKey(), certs);
        }
        return x509_map;
    }
</code>
</pre>

It took a lot longer to figure out that this one little line

<pre>
<code class="language-java">if (cert.getType().equals("X.509")) {
</code>
</pre>
is where you figure out the type.

# Finding by Date

Now that we have a mapped-listing of X.509 certificates and their chains mapped
to an alias, we can iterate over them to find by date:

<pre>
<code class="language-java">
private static List<X509Certificate> filterCertificates(List<X509Certificate> certs, int days_threshold) {
    List<X509Certificate> filtered = Lists.newArrayList();
    for (X509Certificate cert : certs) {
        DateTime expiration_date = new DateTime(cert.getNotAfter());
        int days_to_expiration = Days.daysBetween(DateTime.now(), expiration_date.getDays();
        if (days_to_expiration < days_threshold) {
            filtered.add(cert);
        }
    }
    return filtered;
}
</code>
</pre>

Here, we're simply making use of the excellent [Joda DateTime](http://www.joda.org/joda-time/quickstart.html)
to parse the `java.util.Date` object and compute the days between the curren
time and the expiration date.  I'd rather not worry about leap years, other
calendar types, etc., when computing things, so let's just let a great library
do that for us.

# Summary

I hope this overview of how to parse and compute expiration dates on
certificates in your Keystore can be of some use.  It's not hard, but half the
battle is figuring out **what** you need to know before you do it.
