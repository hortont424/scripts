#!/usr/bin/env python

import pynotify
import os

os.system("/usr/bin/xsetbg /home/hortont/.bkg.jpg");
os.system("/usr/bin/xrandr --output VGA --off");
os.system("/usr/bin/xrandr --output LVDS --auto -s 1024x768");

pynotify.init("Projector");
n = pynotify.Notification("Projector Disabled", "it's not clear what I should say here", "stock_fullscreen");
n.set_timeout(1500);
n.set_urgency(pynotify.URGENCY_LOW);
n.show();
