# encoding: utf-8
require 'spec_helper'

describe Guard::Test::Runner do

  describe ".runners" do
    it "returns [default fastfail] base on files present in the runners folder" do
      described_class.runners.should == %w[default fastfail]
    end
  end

  describe "#initialize" do
    describe "sets the @runner instance variable from options" do
      it "uses the default runner without :runner option given" do
        runner = described_class.new
        runner.instance_variable_get(:@runner_name).should == 'default'
      end

      it "uses the given :runner option if available" do
        runner = described_class.new(:runner => 'fastfail')
        runner.instance_variable_get(:@runner_name).should == 'fastfail'
      end

      it "uses the default runner if the given :runner option is not an available runner" do
        runner = described_class.new(:runner => 'unknown')
        runner.instance_variable_get(:@runner_name).should == 'default'
      end
    end
  end

  describe "#run" do
    context "in empty folder" do
      before(:each) do
        Dir.stub(:pwd).and_return("empty")
      end

      context "when no :bundler option was given on initialize" do
        subject do
          runner = described_class.new
          runner.stub(:turn?) { false }
          runner
        end

        it "runs without bundler" do
          subject.should_receive(:system).with(
            "ruby -Itest -r #{@lib_path.join('guard/test/runners/default_guard_test_runner')} " \
            "\"./test/succeeding_test.rb\" --runner=guard-default"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :bundler option set to true on initialize" do
        subject do
          runner = described_class.new(:bundler => true)
          runner.stub(:turn?) { false }
          runner
        end

        it "runs with bundler" do
          subject.should_receive(:system).with(
            "bundle exec " \
            "ruby -Itest -r bundler/setup -r #{@lib_path.join('guard/test/runners/default_guard_test_runner')} " \
            "\"./test/succeeding_test.rb\" --runner=guard-default"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end
    end

    context "in a folder containing a Gemfile" do
      context "when no :bundler option was given on initialize" do
        subject do
          runner = described_class.new
          runner.stub(:turn?) { false }
          runner
        end

        it "runs with bundler" do
          subject.should_receive(:system).with(
            "bundle exec " \
            "ruby -Itest -r bundler/setup " \
            "-r #{@lib_path.join('guard/test/runners/default_guard_test_runner')} " \
            "\"./test/succeeding_test.rb\" --runner=guard-default"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :bundler option set to false on initialize" do
        subject do
          runner = described_class.new(:bundler => false)
          runner.stub(:turn?) { false }
          runner
        end

        it "runs without bundler" do
          subject.should_receive(:system).with(
            "ruby -Itest " \
            "-r #{@lib_path.join('guard/test/runners/default_guard_test_runner')} " \
            "\"./test/succeeding_test.rb\" --runner=guard-default"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when no :runner option was given on initialize" do
        subject do
          runner = described_class.new
          runner.stub(:turn?) { false }
          runner
        end

        it "displays message with the tests that will be fired" do
          Guard::UI.should_receive(:info).with(
            "Running (default runner): test/unit/error/error_test.rb test/unit/failing_test.rb", :reset => true
          )

          dev_null { subject.run(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]) }
        end

        it "runs with the --runner options set to 'guard-default' and require default_guard_test_runner" do
          subject.should_receive(:system).with(
            "bundle exec " \
            "ruby -Itest -r bundler/setup " \
            "-r #{@lib_path.join('guard/test/runners/default_guard_test_runner')} " \
            "\"./test/succeeding_test.rb\" --runner=guard-default"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      %w[default fastfail].each do |runner_name|
        context "when the :runner is '#{runner_name}'" do
          subject do
            runner = described_class.new(:runner => runner_name)
            runner.stub(:turn?) { false }
            runner
          end

          it "displays a message mentionning the runner and the test files that will be run" do
            Guard::UI.should_receive(:info).with(
              "Running (#{runner_name} runner): test/unit/error/error_test.rb test/unit/failing_test.rb", :reset => true
            )

            dev_null { subject.run(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]) }
          end

          it "requires #{runner_name}_guard_test_runner and runs with the --runner=guard-#{runner_name} option in the command line" do
            subject.should_receive(:system).with(
              "bundle exec " \
              "ruby -Itest -r bundler/setup "\
              "-r #{@lib_path.join("guard/test/runners/#{runner_name}_guard_test_runner")} " \
              "\"./test/succeeding_test.rb\" --runner=guard-#{runner_name}"
            )

            subject.run(["test/succeeding_test.rb"])
          end
        end
      end

      context "when the :rvm option is given" do
        subject do
          runner = described_class.new(:rvm => ['1.8.7', '1.9.2'])
          runner.stub(:turn?) { true }
          runner
        end

        it "runs with rvm exec" do
          subject.should_receive(:system).with(
            "rvm 1.8.7,1.9.2 exec turn -Itest \"./test/succeeding_test.rb\""
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :cli option is given" do
        subject do
          runner = described_class.new(:cli => '--pretty')
          runner.stub(:turn?) { true }
          runner
        end

        it "adds the cli option at the end of the command" do
          subject.should_receive(:system).with(
            "turn -Itest \"./test/succeeding_test.rb\" --pretty"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :message option is given" do
        it "displays it" do
          Guard::UI.should_receive(:info).with("That test is failing!!!", :reset => true)
          runner = described_class.new

          dev_null { runner.run(["test/unit/failing_test.rb"], :message => "That test is failing!!!") }
        end
      end

      it "loads and executes all the tests files" do
        runner = described_class.new
        runner.stub(:turn?) { false }
        runner.should_receive(:system).with(
          "bundle exec " \
          "ruby -Itest -r bundler/setup " \
          "-r #{@lib_path.join('guard/test/runners/default_guard_test_runner')} " \
          "\"./test/error/error_test.rb\" \"./test/unit/failing_test.rb\" --runner=guard-default"
        )

        runner.run(["test/error/error_test.rb", "test/unit/failing_test.rb"])
      end

      context "with turn present" do
        subject do
          runner = described_class.new
          runner.stub(:turn?) { true }
          runner
        end

        it "use the turn executable instead of ruby" do
          subject.should_receive(:system).with(
            "turn -Itest \"./test/succeeding_test.rb\""
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

    end

  end # #run

end
