require 'test/unit'

class FailingTest < Test::Unit::TestCase
  def test_failing
    assert_equal(true, false)
  end
end
