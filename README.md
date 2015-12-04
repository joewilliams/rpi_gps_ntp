### RaspberryPi NTP+GPS setup

#### Hardware
* RaspberryPi 2 B
* GPS board
  * http://ava.upuaut.net/store/index.php?route=product/product&path=59_60&product_id=117
* Antenna
  * http://www.amazon.com/gp/product/B00JE4GV8S

#### Usage
* Clone this repo to your rpi
* `sudo ./bootstrap.sh`

#### Debugging and Testing Tools
* `sudo ppstest /dev/pps0`
* `sudo minicom /dev/ttyAMA0`
* `cgps -s`
* `gpspipe -w`
* `/opt/ntp/ntp-4.2.8p4/bin/ntpq -p`

#### Resources
* http://www.satsignal.eu/ntp/Raspberry-Pi-quickstart.html
* http://ava.upuaut.net/?p=726
* http://www.satsignal.eu/ntp/Raspberry-Pi-NTP.html
* https://www.eecis.udel.edu/~mills/ntp/html/monopt.html
* http://www.catb.org/gpsd/gpsd-time-service-howto.html
