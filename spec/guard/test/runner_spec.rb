# encoding: utf-8
require 'spec_helper'

describe Guard::Test::Runner do

  describe "#initialize" do
    describe "sets the @runner instance variable from options" do
      it "sets default options" do
        runner = described_class.new
        runner.instance_variable_get(:@options)[:bundler].should be_true
        runner.instance_variable_get(:@options)[:rvm].should be_empty
        runner.instance_variable_get(:@options)[:drb].should be_false
        runner.instance_variable_get(:@options)[:cli].should eql ""
      end

      it "sets option :bundler" do
        runner = described_class.new(:bundler => true)
        runner.instance_variable_get(:@options)[:bundler].should be_true
      end

      it "sets option :rvm" do
        runner = described_class.new(:rvm => '1.9.2')
        runner.instance_variable_get(:@options)[:rvm].should eql '1.9.2'
      end

      it "sets option :drb" do
        runner = described_class.new(:drb => true)
        runner.instance_variable_get(:@options)[:drb].should be_true
      end

      it "sets option :cli" do
        runner = described_class.new(:cli => '--show-detail-immediately')
        runner.instance_variable_get(:@options)[:cli].should eql '--show-detail-immediately'
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

        it "runs with the --runner options set to 'guard-default' and require default_guard_test_runner" do
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
