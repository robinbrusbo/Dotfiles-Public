#!/usr/bin/env python3

# When logging in if the computer time is 22:00 - 06:00, turn on redshift

import datetime
import os

timestamp = datetime.datetime.now().time()
start = datetime.time(6)
end = datetime.time(22)
if not start < timestamp < end:
    os.system("nohup redshift-gtk & disown & rm nohup.out")
