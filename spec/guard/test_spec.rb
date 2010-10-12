require 'spec_helper'

describe Guard::Test do
  
  describe "start" do
    it "should display a watching message" do
      Guard::UI.should_receive(:info).with("Guard::Test is guarding your tests!")
      subject.start
    end
  end
  
  describe "run_all" do
    it "should run all test with a message" do
      Guard::Test::Runner.should_receive(:run).with(["test/succeeding_test.rb", "test/unit/failing_test.rb", "test/unit/pending/pending_test.rb"], :message => "Running all tests")
      subject.run_all
    end
  end
  
  describe "run_on_change" do
    it "should run test with under given paths, recursively" do
      Guard::Test::Runner.should_receive(:run).with(["test/unit/failing_test.rb", "test/unit/pending/pending_test.rb"], {})
      subject.run_on_change(["test/unit"])
    end
  end
  
end