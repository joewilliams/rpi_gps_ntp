#!/bin/bash
set -e

NTP_VER='4.2.8p4'

apt-get -y update
apt-get -y upgrade
apt-get -y dist-upgrade
rpi-update

cat packages | while read package; do
  apt-get -y install $package
done

apt-get remove --purge ntp

echo 'dtoverlay=pps-gpio,gpiopin=18' >> /boot/config.txt
echo 'pps-gpio' >> /etc/modules

LINENO=`grep -n ttyAMA0 /etc/inittab | cut -d: -f1`
sed "${LINENO}d" /etc/inittab | sudo tee /etc/inittab

cmdlinefile1=`sed s/console\=ttyAMA0\,115200// /boot/cmdline.txt`
echo ${cmdlinefile1} | sed s/kgdboc\=ttyAMA0\,115200// | sudo tee /boot/cmdline.txt

ln -s /dev/ttyAMA0 /dev/gps0

wget http://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-${NTP_VER}.tar.gz
tar zxf ntp-${NTP_VER}.tar.gz
cd ntp-${NTP_VER}

mkdir -p /opt/ntp/etc /opt/ntp/ntp-${NTP_VER}

./configure --prefix=/opt/ntp/ntp-${NTP_VER} \
  --enable-linuxcaps \
  --disable-all-clocks \
  --disable-parse-clocks \
  --enable-NMEA \
  --enable-ATOM \
  --enable-GPSD \
  --enable-ntpdate-step \
  --disable-hourly-todr-sync \
  --disable-nls \
  --disable-autokey \
  --without-net-snmp-config \
  --with-crypto

make -j 5
make install

mkdir /opt/ntp/lib
chown nobody /opt/ntp/lib

mkdir /var/log/ntpstats
chown nobody /var/log/ntpstats

cp -a etc /opt/ntp/
cp -a service /opt/ntp/
ln -s /opt/ntp/service /etc/service/ntpd

echo 'DEVICES="/dev/ttyAMA0"' >> /etc/default/gpsd
# gpsd is useful for making sure the gps is getting a lock and data
# but will also hog the NMEA serial so ntp can't use it
#echo 'START_DAEMON="true"' >> /etc/default/gpsd

echo ''
echo 'done! please reboot'
