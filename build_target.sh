#!/bin/sh
ant -lib ant/lib/jsch-0.1.55.jar targetplatform -Dupload=true -Dversion=$1
