class FailingTest < Test::Unit::TestCase
  def test_failing1
    sleep(1)
    assert_equal(true, false)
  end
  def test_failing2
    assert_equal(true, false)
  end
  def test_failing3
    assert_equal(true, false)
  end
end
