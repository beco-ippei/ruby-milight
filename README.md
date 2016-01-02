# ruby-milight
controller ruby-api for milight or limitless-led
(milight and limitless-led and easy-bulb is
 same bridge-box controllable products)

### API Document
http://www.limitlessled.com/dev/


# components
* local controller (working on LAN)
* gateway server (working on Internet)

components messaging each other.
use web-socket ??

---

# TODO
setup
---
* ?) connect bridge-box and setup wifi config
  or configure by Appli
* get bridge-box IP-Address (from LAN)
* configure this app (make or overwrite config file ?)

boot local-controller / env
---
* load config
  * get bridge-box network segment (24bit)
  * server url
* bulb controller
  * lib/bulb.rb
  * and tests
  * sample app
  * controll by groups

... writing.

