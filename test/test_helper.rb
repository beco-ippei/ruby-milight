if ENV['CI']
  require 'coveralls'
  Coveralls.wear!

  SimpleCov.formatters = [
    Coveralls::SimpleCov::Formatter,
  ]
  SimpleCov.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'milight'

require 'minitest/autorun'
