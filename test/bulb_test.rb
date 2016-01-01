require 'test/unit'
require './lib/bulb'

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

  def test_defined_color
    {
      'violet': '00',
      'royal_blue': '10',
      'baby_blue': '20',
      'aqua': '30',
      'mint': '40',
      'seafoam_green': '50',
      'green': '60',
      'lime_green': '70',
      'yellow': '80',
      'yellow_orange': '90',
      'orange': 'a0',
      'red': 'b0',
      'pink': 'c0',
      'white': 'c2',
      'fusia': 'd0',
      'lilac': 'e0',
      'lavendar': 'f0',
    }.each do |(method, exp)|
      color = @bulb.send :defined_color, method
      assert_equal color, exp
    end

    %w[blue black gray].each do |method|
      color = @bulb.send :defined_color, method
      assert_nil color
    end
  end

  # test few patterns
  def test_message
    [
      ['41', '00', "A\x00U"],
      ['4E', 'A0', "N\xA0U"],
    ].each do |(cmd, val, exp)|
      msg = @bulb.send :message, cmd, val
      exp = exp.force_encoding('ascii-8bit')
      assert_equal msg, exp
    end
  end
end
