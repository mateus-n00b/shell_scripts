#!/usr/bin/env python
import Tkinter
import os,time

def gatekeeper():
    p = Tkinter.Tk()
    initial_pos = p.winfo_pointerxy()
    while 1:
        posxy = p.winfo_pointerx()
        if posxy != initial_pos:
            os.system("gnome-session-quit --force")
        time.sleep(0.5)
