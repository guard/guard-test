require 'test_helper'

# encoding: utf-8
class FailingTest < Test::Unit::TestCase
  def test_failing1
    assert_equal(true, false)
  end
  def test_failing2
    assert_equal(true, false)
  end
end
