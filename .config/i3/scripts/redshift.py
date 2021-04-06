#!/usr/bin/env python3

# When logging in if the computer time is 22:00 - 06:00, turn on redshift

import datetime
import os
import time

start = datetime.time(6)
end = datetime.time(21)
while True:
    time.sleep(60)
    timestamp = datetime.datetime.now().time()
    if not start < timestamp < end:
        os.system("nohup redshift-gtk & disown & rm nohup.out")
        break
