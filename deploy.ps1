Write-Host "Deploying updates to GitHub..."

# Build the project.
hugo -t "klauern-hugo-zen"

# Add changes to git.
git add -A

# Commit changes.
git commit -m "rebuilding site on $(date)"

# Push source and build repos.
git push origin master
git subtree push --prefix=public https://github.com/klauern/blog.git gh-pages
