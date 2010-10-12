require 'spec_helper'

describe Guard::Test::Runner do
  
  describe "run" do
    it "should display message with the tests that will be fired" do
      Guard::UI.should_receive(:info).with("Running: test/unit/failing_test.rb test/unit/pending/pending_test.rb", :reset => true)
      dev_null { subject.run(["test/unit/failing_test.rb", "test/unit/pending/pending_test.rb"]) }
    end
    
    it "should display custom message if one given" do
      Guard::UI.should_receive(:info).with("That test is failing!!!", :reset => true)
      dev_null { subject.run(["test/unit/failing_test.rb"], :message => "That test is failing!!!") }
    end
    
    it "should run with RSpec 2 and without bundler" do
      subject.should_receive(:system).with("ruby -r#{@lib_path.join('guard/test/guard_test_unit_runner')} -Itest -e \"%w[test/unit/failing_test.rb test/unit/pending/pending_test.rb].each { |f| load f }\" \"test/unit/failing_test.rb\" \"test/unit/pending/pending_test.rb\" --runner=guard")
      dev_null { subject.run(["test/unit/failing_test.rb", "test/unit/pending/pending_test.rb"]) }
    end
  end
  
end