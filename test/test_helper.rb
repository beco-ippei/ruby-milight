if ENV['CI']
  require 'coveralls'
  require 'codeclimate-test-reporter'
  Coveralls.wear!

  SimpleCov.formatters = [
    Coveralls::SimpleCov::Formatter,
    CodeClimate::TestReporter::Formatter,
  ]

  SimpleCov.start
  CodeClimate::TestReporter.start
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'milight'

require 'minitest/autorun'
