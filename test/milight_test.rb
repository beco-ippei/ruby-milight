require 'test_helper'

class MilightTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Milight::VERSION
  end
end
