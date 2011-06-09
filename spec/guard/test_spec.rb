# encoding: utf-8
require 'spec_helper'

describe Guard::Test do

  describe "#initialize" do
    it "instantiates a new Runner" do
      Guard::Test::Runner.should_receive(:new).and_return(mock('runner', :bundler? => true))

      described_class.new
    end

    context "with options given" do
      it "passes fiven options to Guard::Test::Runner#new" do
        Guard::Test::Runner.should_receive(:new).with(:runner => 'fastfail', :rvm => ['1.8.7', '1.9.2'], :bundler => false).and_return(mock('runner', :bundler? => true))

        described_class.new([], :runner => 'fastfail', :rvm => ['1.8.7', '1.9.2'], :bundler => false)
      end
    end
  end

  describe "#start" do
    context ":all_on_start option not specified" do
      subject { described_class.new([]) }

      it "displays a start message" do
        ::Guard::UI.should_receive(:info).with("Guard::Test #{Guard::TestVersion::VERSION} is running, with Test::Unit #{::Test::Unit::VERSION}!", :reset => true)
        subject.stub(:run_all)

        subject.start
      end

      it "calls #run_all by default" do
        subject.should_receive(:run_all)

        subject.start
      end
    end

    context ":all_on_start option is false" do
      subject { described_class.new([], :all_on_start => false) }

      it "doesn't call #run_all" do
        subject.should_not_receive(:run_all)

        subject.start
      end
    end

  end

  describe "#run_all" do
    subject { described_class.new }

    it "runs all test with a message" do
      subject.instance_variable_get(:@runner).should_receive(:run).with(
        ["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], :message => "Running all tests"
      )

      subject.run_all
    end

    it "cleans failed memory if passed" do
      subject.instance_variable_get(:@runner).should_receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(false)
      subject.run_on_change(["test/unit"])

      subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], :message => "Running all tests").and_return(true)
      subject.run_all

      subject.instance_variable_get(:@runner).should_receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(true)
      subject.run_on_change(["test/unit"])
    end
  end

  describe "#reload" do
    it "should clear failed_path" do
      subject.instance_variable_get(:@runner).should_receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(false)
      subject.run_on_change(["test/unit"])

      subject.reload

      subject.instance_variable_get(:@runner).should_receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(true)
      subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], :message => "Running all tests").and_return(true)
      subject.run_on_change(["test/unit"])
    end
  end

  describe "#run_on_change" do
    context ":all_after_pass option not specified" do
      subject { described_class.new([]) }

      it "runs test with under given paths, recursively" do
        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"])

        subject.run_on_change(["test/unit"])
      end

      it "calls #run_all by default if the changed specs pass after failing" do
        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb"]).and_return(false, true)
        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], :message => "Running all tests")

        subject.run_on_change(["test/succeeding_test.rb"])
        subject.run_on_change(["test/succeeding_test.rb"])
      end

      it "doesn't call #run_all if the changed specs pass without failing" do
        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb"]).and_return(true)
        subject.instance_variable_get(:@runner).should_not_receive(:run).with(["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], :message => "Running all tests")
        subject.run_on_change(["test/succeeding_test.rb"])
      end
    end

    context ":all_after_pass option is false" do
      subject { described_class.new([], :all_after_pass => false) }

      it "doesn't call #run_all if the changed specs pass after failing but the :all_after_pass option is false" do
        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb"]).and_return(false, true)
        subject.instance_variable_get(:@runner).should_not_receive(:run).with(["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], :message => "Running all tests")

        subject.run_on_change(["test/succeeding_test.rb"])
        subject.run_on_change(["test/succeeding_test.rb"])
      end
    end

    context ":keep_failed option not specified" do
      subject { described_class.new([], :all_after_pass => false) }

      it "keeps failed specs and rerun later by default" do
        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(false)
        subject.run_on_change(["test/unit"])

        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(true)
        subject.run_on_change(["test/succeeding_test.rb"])

        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb"]).and_return(true)
        subject.run_on_change(["test/succeeding_test.rb"])
      end
    end

    context ":keep_failed option is false" do
      subject { described_class.new([], :all_after_pass => false, :keep_failed => false) }

      it "doesn't keep failed specs" do
        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(false)
        subject.run_on_change(["test/unit"])

        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb"]).and_return(true)
        subject.run_on_change(["test/succeeding_test.rb"])

        subject.instance_variable_get(:@runner).should_receive(:run).with(["test/succeeding_test.rb"]).and_return(true)
        subject.run_on_change(["test/succeeding_test.rb"])
      end
    end

  end

end
