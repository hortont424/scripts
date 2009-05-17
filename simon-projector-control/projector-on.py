#!/usr/bin/env python

import pynotify
import os

os.system("/usr/bin/xsetroot -solid black");
os.system("/usr/bin/xrandr --output VGA --auto --right-of LVDS");

pynotify.init("Projector");
n = pynotify.Notification("Projector Enabled", "give detected size of VGA port here", "stock_fullscreen");


n.set_urgency(pynotify.URGENCY_LOW);
n.show();
