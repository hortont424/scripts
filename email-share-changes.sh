#!/bin/bash

find /srv/share/public 2>&1 | sort > /tmp/.share.files.2
diff /tmp/.share.files.1 /tmp/.share.files.2 | sed -e 's/^>/+/' -e 's/^</-/' | mail -E hortont
mv /tmp/.share.files.2 /tmp/.share.files.1
