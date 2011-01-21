require 'spec_helper'

describe Guard::Test::Runner do

  describe "run" do

    context "in empty folder" do
      before(:each) do
        Dir.stub(:pwd).and_return("empty")
        subject.set_test_unit_runner
      end

      it "should run without bundler" do
        subject.should_receive(:system).with(
          "ruby -rubygems -r#{@lib_path.join('guard/test/runners/default_test_unit_runner')} -Ilib " \
          "-e \"%w[test/succeeding_test.rb].each { |f| load f }\" \"test/succeeding_test.rb\" --runner=guard-default"
        )
        dev_null { subject.run(["test/succeeding_test.rb"]) }
      end

      context "when specifying the rvm option" do
        before(:each) { @options = { :rvm => ['1.8.7', '1.9.2'] } }

        it "should run with rvm exec" do
          subject.should_receive(:system).with(
            "rvm 1.8.7,1.9.2 exec " \
            "ruby -rubygems -r#{@lib_path.join('guard/test/runners/default_test_unit_runner')} -Ilib " \
            "-e \"%w[test/succeeding_test.rb].each { |f| load f }\" \"test/succeeding_test.rb\" --runner=guard-default"
          )
          subject.run(["test/succeeding_test.rb"], @options)
        end
      end

      context "when no test_unit_runner is specified" do
        before(:each) { subject.set_test_unit_runner }

        it "should display message with the tests that will be fired" do
          Guard::UI.should_receive(:info).with(
            "\nRunning (default runner): test/unit/error/error_test.rb test/unit/failing_test.rb", :reset => true
          )
          dev_null { subject.run(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]) }
        end

        it "should run with the --runner options set to 'guard-default' and require default_test_unit_runner" do
          subject.should_receive(:system).with(
            "ruby -rubygems -r#{@lib_path.join('guard/test/runners/default_test_unit_runner')} -Ilib " \
            "-e \"%w[test/succeeding_test.rb].each { |f| load f }\" \"test/succeeding_test.rb\" --runner=guard-default"
          )
          dev_null { subject.run(["test/succeeding_test.rb"]) }
        end
      end

      %w[default fastfail].each do |runner|
        context "when specifying the '#{runner}' test_unit_runner" do
          before(:each) { subject.set_test_unit_runner(:runner => runner) }

          it "should display message with the tests that will be fired" do
            Guard::UI.should_receive(:info).with(
              "\nRunning (#{runner} runner): test/unit/error/error_test.rb test/unit/failing_test.rb", :reset => true
            )
            dev_null { subject.run(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]) }
          end

          it "should run with the --runner options set to 'guard-#{runner}' and require #{runner}_test_unit_runner" do
            subject.should_receive(:system).with(
              "ruby -rubygems -r#{@lib_path.join("guard/test/runners/#{runner}_test_unit_runner")} -Ilib " \
              "-e \"%w[test/succeeding_test.rb].each { |f| load f }\" \"test/succeeding_test.rb\" --runner=guard-#{runner}"
            )
            dev_null { subject.run(["test/succeeding_test.rb"]) }
          end

          it "should display custom message if one given" do
            Guard::UI.should_receive(:info).with("\nThat test is failing!!!", :reset => true)
            dev_null { subject.run(["test/unit/failing_test.rb"], :message => "That test is failing!!!") }
          end

          it "should load all the tests files" do
            subject.should_receive(:system).with(
              "ruby -rubygems -r#{@lib_path.join("guard/test/runners/#{runner}_test_unit_runner")} -Ilib " \
              "-e \"%w[test/unit/error/error_test.rb test/unit/failing_test.rb].each { |f| load f }\" " \
              "\"test/unit/error/error_test.rb\" \"test/unit/failing_test.rb\" --runner=guard-#{runner}"
            )
            dev_null { subject.run(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]) }
          end

          it "should execute all the test files" do
            subject.should_receive(:system).with(
              "ruby -rubygems -r#{@lib_path.join("guard/test/runners/#{runner}_test_unit_runner")} -Ilib " \
              "-e \"%w[test/succeeding_test.rb test/unit/failing_test.rb].each { |f| load f }\" " \
              "\"test/succeeding_test.rb\" \"test/unit/failing_test.rb\" --runner=guard-#{runner}"
            )
            dev_null { subject.run(["test/succeeding_test.rb", "test/unit/failing_test.rb"]) }
          end
        end
      end
    end

    context "in a folder containing a Gemfile" do
      before(:each) { subject.set_test_unit_runner }

      it "should run with bundler" do
        subject.should_receive(:system).with(
          "bundle exec " \
          "ruby -rubygems -r#{@lib_path.join('guard/test/runners/default_test_unit_runner')} -Ilib " \
          "-e \"%w[test/succeeding_test.rb].each { |f| load f }\" \"test/succeeding_test.rb\" --runner=guard-default"
        )
        dev_null { subject.run(["test/succeeding_test.rb"]) }
      end

      context "when setting the bundler option to false" do
        before(:each) { @options = { :bundler => false } }

        it "should run without bundler" do
          subject.should_receive(:system).with(
            "ruby -rubygems -r#{@lib_path.join('guard/test/runners/default_test_unit_runner')} -Ilib " \
            "-e \"%w[test/succeeding_test.rb].each { |f| load f }\" \"test/succeeding_test.rb\" --runner=guard-default"
          )
          subject.run(["test/succeeding_test.rb"], @options)
        end
      end
    end

  end # run

  describe "#set_test_unit_runner" do
    context "when not specifying a specific runner" do
      it "should set test_unit_runner to default with no options given" do
        subject.set_test_unit_runner
        subject.test_unit_runner.should == 'default'
      end
    end

    context "when given 'default' as the runner" do
      it "should set test_unit_runner to default" do
        subject.set_test_unit_runner(:runner => 'default')
        subject.test_unit_runner.should == 'default'
      end
    end

    context "when given 'fastfail' as the runner" do
      it "should set test_unit_runner to fastfail" do
        subject.set_test_unit_runner(:runner => 'fastfail')
        subject.test_unit_runner.should == 'fastfail'
      end
    end
  end

end
