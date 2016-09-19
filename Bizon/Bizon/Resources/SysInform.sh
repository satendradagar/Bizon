#!/bin/sh
#


details=$(ioreg -l -w0 -p IODeviceTree)
echo $details
