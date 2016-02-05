# Milight

[![Build Status](https://travis-ci.org/beco-ippei/ruby-milight.svg?branch=master)](https://travis-ci.org/beco-ippei/ruby-milight)
[![Coverage Status](https://coveralls.io/repos/github/beco-ippei/ruby-milight/badge.svg?branch=add_ci_settings)](https://coveralls.io/github/beco-ippei/ruby-milight?branch=add_ci_settings)

A ruby wrapper project for milight api.

controller ruby-api for milight or limitless-led
(milight and limitless-led and easy-bulb is
 same bridge-box controllable products)

## API Document
http://www.limitlessled.com/dev/

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'milight'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install milight


# components
* local controller (working on LAN)
* [may be not] gateway server (working on Internet)

components messaging each other.
use web-socket ??

---

# TODO
setup
---
* ?) connect bridge-box and setup wifi config
  or configure by Appli
* ~~get bridge-box IP-Address (from LAN)~~
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

