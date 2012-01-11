# encoding: utf-8
require 'spec_helper'

describe Guard::Test::Runner do

  describe "#initialize" do
    describe "sets the @runner instance variable from options" do
      it "sets default options" do
        runner = described_class.new
        runner.instance_variable_get(:@options)[:bundler].should be_true
        runner.instance_variable_get(:@options)[:rubygems].should be_false
        runner.instance_variable_get(:@options)[:rvm].should be_empty
        runner.instance_variable_get(:@options)[:drb].should be_false
        runner.instance_variable_get(:@options)[:cli].should eql ""
      end

      describe ":bundler option" do
        context "with the :drb option set to true" do
          it "uses drb but not bundler" do
            runner = described_class.new(:drb => true, :bundler => true)
            runner.should be_drb
            runner.should_not be_bundler
          end
        end

        context "with the :drb option set to false" do
          it "uses bundler but not drb" do
            runner = described_class.new(:drb => false, :bundler => true)
            runner.should_not be_drb
            runner.should be_bundler
          end
        end
      end

      describe ":rubygems option" do
        context "with the :bundler option set to true" do
          it "uses bundler but not rubygems" do
            runner = described_class.new(:bundler => true, :rubygems => true)
            runner.should be_bundler
            runner.should_not be_rubygems
          end
        end

        context "with the :bundler option set to false" do
          it "uses rubygems but not bundler" do
            runner = described_class.new(:bundler => false, :rubygems => true)
            runner.should_not be_bundler
            runner.should be_rubygems
          end
        end
      end

      describe ":rvm option" do
        it "sets the option in the instance @options hash" do
          runner = described_class.new(:rvm => '1.9.2')
          runner.instance_variable_get(:@options)[:rvm].should eq '1.9.2'
        end
      end

      describe ":drb option" do
        it "uses drb" do
          runner = described_class.new(:drb => true)
          runner.should be_drb
        end
      end

      describe ":cli option" do
        it "sets the option in the instance @options hash" do
          runner = described_class.new(:cli => '--show-detail-immediately')
          runner.instance_variable_get(:@options)[:cli].should eq '--show-detail-immediately'
        end
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
          runner
        end

        it "runs without bundler" do
          subject.should_receive(:system).with(
            "ruby -Itest -r #{@lib_path.join('guard/test/guard_test_runner')} " \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "\"./test/succeeding_test.rb\" --use-color --runner=guard"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :bundler option set to true on initialize" do
        subject do
          runner = described_class.new(:bundler => true)
          runner
        end

        it "runs with bundler" do
          subject.should_receive(:system).with(
            "bundle exec " \
            "ruby -Itest -r bundler/setup -r #{@lib_path.join('guard/test/guard_test_runner')} " \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "\"./test/succeeding_test.rb\" --use-color --runner=guard"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end
    end

    context "in a folder containing a Gemfile" do
      context "when no :bundler option was given on initialize" do
        subject do
          runner = described_class.new
          runner
        end

        it "runs with bundler" do
          subject.should_receive(:system).with(
            "bundle exec " \
            "ruby -Itest -r bundler/setup " \
            "-r #{@lib_path.join('guard/test/guard_test_runner')} " \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "\"./test/succeeding_test.rb\" --use-color --runner=guard"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :bundler option set to false on initialize" do
        subject do
          runner = described_class.new(:bundler => false)
          runner
        end

        it "runs without bundler" do
          subject.should_receive(:system).with(
            "ruby -Itest " \
            "-r #{@lib_path.join('guard/test/guard_test_runner')} " \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "\"./test/succeeding_test.rb\" --use-color --runner=guard"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end
      
      context "when the :rubygems option set to true (and :bundler to false) on initialize" do
        subject do
          runner = described_class.new(:bundler => false, :rubygems => true)
          runner
        end

        it "runs without bundler and require rubygems" do
          subject.should_receive(:system).with(
            "ruby -Itest -rubygems -r #{@lib_path.join('guard/test/guard_test_runner')} " \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "\"./test/succeeding_test.rb\" --use-color --runner=guard"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when no :runner option was given on initialize" do
        subject do
          runner = described_class.new
          runner
        end

        it "displays message with the tests that will be fired" do
          Guard::UI.should_receive(:info).with(
            "Running: test/unit/error/error_test.rb test/unit/failing_test.rb", :reset => true
          )

          dev_null { subject.run(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]) }
        end

        it "runs with the --runner options set to 'guard' and require default_guard_test_runner" do
          subject.should_receive(:system).with(
            "bundle exec " \
            "ruby -Itest -r bundler/setup " \
            "-r #{@lib_path.join('guard/test/guard_test_runner')} " \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "\"./test/succeeding_test.rb\" --use-color --runner=guard"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :rvm option is given" do
        subject do
          runner = described_class.new(:rvm => ['1.8.7', '1.9.2'])
          runner
        end

        it "runs with rvm exec" do
          subject.should_receive(:system).with(
            "rvm 1.8.7,1.9.2 exec " \
            "bundle exec " \
            "ruby -Itest -r bundler/setup " \
            "-r #{@lib_path.join('guard/test/guard_test_runner')} " \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "\"./test/succeeding_test.rb\" --use-color --runner=guard"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :cli option is given" do
        subject do
          runner = described_class.new(:cli => '--pretty')
          runner
        end

        it "adds the cli option at the end of the command" do
          subject.should_receive(:system).with(
          "bundle exec " \
          "ruby -Itest -r bundler/setup " \
          "-r #{@lib_path.join('guard/test/guard_test_runner')} " \
          "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
          "\"./test/succeeding_test.rb\" --use-color --runner=guard --pretty"
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
        runner.should_receive(:system).with(
          "bundle exec " \
          "ruby -Itest -r bundler/setup " \
          "-r #{@lib_path.join('guard/test/guard_test_runner')} " \
          "-e \"%w[test/error/error_test.rb test/unit/failing_test.rb].each { |p| load p }\" " \
          "\"./test/error/error_test.rb\" \"./test/unit/failing_test.rb\" --use-color --runner=guard"
        )

        runner.run(["test/error/error_test.rb", "test/unit/failing_test.rb"])
      end

    end

  end # #run

end
