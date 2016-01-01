require 'test/unit'
require './lib/bulb'
#require 'debugger'

class BulbTest < Test::Unit::TestCase
  def setup
    @bulb = Bulb.new '127.0.0.1', 80
  end

  def test_brightness
    [
      [  0, '02'],
      [ 10, '04'],
      [ 20, '07'],
      [ 30, '09'],
      [ 90, '24'],
      [100, '27'],
    ].each do |(arg, exp)|
      val = @bulb.send :brightness, arg
      assert_equal val, exp
    end
  end
end
