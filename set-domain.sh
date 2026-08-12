#!/bin/bash
# Switch the whole site from one domain to another in one command.
#
#   ./set-domain.sh https://www.smithlakespropertyreview.com
#
# Run it from inside this folder, then commit and push. Nothing else to change.
set -e
NEW="${1%/}"
if [ -z "$NEW" ]; then echo "Usage: ./set-domain.sh https://www.yourdomain.com"; exit 1; fi
OLD=$(grep -o 'https://[a-z0-9.-]*vercel\.app' index.html | head -1)
if [ -z "$OLD" ]; then OLD=$(grep -oE 'rel="canonical" href="https://[^"]+"' index.html | grep -oE 'https://[^/"]+' | head -1); fi
echo "Rewriting $OLD  ->  $NEW"
for f in *.html *.md *.txt *.xml; do
  [ -f "$f" ] || continue
  perl -pi -e "s{\Q$OLD\E}{$NEW}g" "$f"
done
echo "Done. Files updated:"; grep -l "$NEW" *.html *.md *.txt *.xml
echo
echo "Next: git add -A && git commit -m 'Point site at $NEW' && git push"
