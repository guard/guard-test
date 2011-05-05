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
        Guard::Test::Runner.should_receive(:new).with(:runner => 'fastfail', :notify => false, :rvm => ['1.8.7', '1.9.2'], :bundler => false).and_return(mock('runner', :bundler? => true))

        described_class.new([], :runner => 'fastfail', :notify => false, :rvm => ['1.8.7', '1.9.2'], :bundler => false)
      end
    end
  end

  describe "#start" do
    subject { described_class.new }

    it "displays a start message" do
      Guard::UI.should_receive(:info).with("Guard::Test is running!")

      subject.start
    end
  end

  describe "#run_all" do
    subject { described_class.new }

    it "runs all test with a message" do
      subject.instance_variable_get(:@runner).should_receive(:run).with(
        ["test/succeeding_test.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], :message => "Running all tests"
      )

      subject.run_all
    end
  end

  describe "#run_on_change" do
    subject { described_class.new }

    it "runs test with under given paths, recursively" do
      subject.instance_variable_get(:@runner).should_receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"])

      subject.run_on_change(["test/unit"])
    end
  end

end
