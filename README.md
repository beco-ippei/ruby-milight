# Milight

[![Build Status](https://travis-ci.org/beco-ippei/ruby-milight.svg?branch=master)](https://travis-ci.org/beco-ippei/ruby-milight)
[![Coverage Status](https://coveralls.io/repos/github/beco-ippei/ruby-milight/badge.svg)](https://coveralls.io/github/beco-ippei/ruby-milight)

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
* led-bulb controller class
  `lib/milight/bulb.rb`
* bridge-box wifi setup command
  `bin/milight setup`
* TODO: console tool
  `bin/milight console`
* TODO: add to group tool
  `bin/milight group_add [1-4]`

---

# TODO

usage
---
* use gem
* how to setup
* add bulb to group (init bulbs)

localize
---
* English ....
* 日本語/japanese (?)

bulb module
---
* disco modes
* support "double white" bulb

tools
---
* console tool (like 'bin/console')
* add to group tool

tests
---
* test messasing
* other

