#!/sbin/sh

OUTFD=/proc/self/fd/$2
ZIPFILE="$3"

ui_print() {
  echo -e "ui_print $1\nui_print " >>$OUTFD
}

bin=/tmp/bin/zstd
if [ -d $bin ]; then
  rm -rf $bin
fi
mkdir -p $bin
unzip "$ZIPFILE" bin/zstd/* -d /tmp
chmod -R 0777 $bin

ui_print " "
ui_print " HyperZK Premium Activate"
ui_print " "

serial=$(getprop ro.serialno)
serial_value="9b156b6e"
rom=$(getprop persist.sys.zk.ver)
rom_value="v3"

ui_print " Checking serial code..."
ui_print " "

sleep 1

ui_print " Your serial code is $serial"
ui_print " "

if [ "$serial" == "$serial_value" ] || [ "$rom" == "$rom_value" ]; then
  ui_print " You have paid, activating ..."
  ui_print " "
  sleep 1
  mount -o rw -t auto /dev/block/mapper/vendor_a /vendor
  echo "on post-fs
    setprop persist.sys.paid true" > /vendor/etc/init/hw/vendor.sensor.qti.rc

else
  ui_print " You are a thief, aborting ..."
  ui_print " "
  sleep 1
  exit 0
fi

ui_print " Active successfully !"
exit 0
