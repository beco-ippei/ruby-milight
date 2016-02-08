require 'test_helper'

class Milight::BulbTest < Minitest::Test
  def setup
    @bulb = ::Milight::Bulb.new ip: '127.0.0.1'
  end

  def test_initialize_ip_is_nil
    #TODO: impl
  end

  def test_color_code
    [
      [   0, '00'],
      [  10, '0a'],
      [  64, '40'],
      [ 255, 'ff'],
      ['a0', 'a0'],
      ['10', '10'],
    ].each do |(val, exp)|
      code = @bulb.send :color_code, val
      assert_equal exp, code, "when val is [#{val}]"
    end
  end

  def test_invalid_color_code
    [-1, 256, 10000, '', '0.', nil].each do |val|
      code = @bulb.send :color_code, val
      assert_nil code, "when val is '#{val}'"
    end
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

  def test_invalid_brightness
    [-1, 101, 'a'].each do |arg|
      val = @bulb.send :brightness, arg
      assert_nil val
    end
  end

  def test_defined_color
    {
      'violet': '00',
      'royal_blue': '10',
      'blue': '10',
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
      'fusia': 'd0',
      'lilac': 'e0',
      'lavendar': 'f0',
    }.each do |(method, exp)|
      color = @bulb.send :defined_color, method
      assert_equal color, exp
    end
  end

  def test_not_defined_color
    %w[hoge black gray].each do |method|
      color = @bulb.send :defined_color, method
      assert_nil color
    end
  end

  # test few patterns
  def test_message
    [
      ['41', '00', "A\x00U"],
      ['4E', 'A0', "N\xA0U"],
      ['C2', '00', "\xC2\x00U"],
    ].each do |(cmd, val, exp)|
      msg = @bulb.send :message, cmd, val
      exp = exp.force_encoding('ascii-8bit')
      assert_equal msg, exp
    end
  end
end
