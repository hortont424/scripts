#!/bin/bash

find /srv/share/public 2>&1 | sort > /tmp/.share.files.2
diff --suppress-common-lines --minimal /tmp/.share.files.1 /tmp/.share.files.2 | sed -e 's/^>/+/' -e 's/^</-/' | mail -s "/srv/share/public changes" -E hortont
mv /tmp/.share.files.2 /tmp/.share.files.1
