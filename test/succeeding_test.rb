class SucceedingTest < Test::Unit::TestCase
  def test_succeeding1
    assert_equal(true, true)
  end
  def test_succeeding2
    sleep(1)
    assert_equal(true, true)
  end
  def test_succeeding3
    assert_equal(true, true)
  end
end
