require 'spec_helper'
require "#{File.dirname(__FILE__)}/../../../lib/guard/test/formatter"

class FormatterTest
  include Formatter
end

describe Formatter do
  subject { FormatterTest.new }

  describe "#print_results(test_count, assertion_count, failure_count, error_count, duration, options = {})" do
    it "should colorize output with 'pass' color if no fail nor error" do
        subject.should_receive(:puts_with_color).with(any_args, "pass")
        subject.send(:print_results, 1, 1, 0, 0, 0)
    end

    it "should colorize output with 'failure' color if at least one fail" do
        subject.should_receive(:puts_with_color).with(any_args, "failure")
        subject.send(:print_results, 1, 1, 1, 0, 0)
    end

    it "should colorize output with 'error' color if no fail and at least one error" do
        subject.should_receive(:puts_with_color).with(any_args, "error")
        subject.send(:print_results, 1, 1, 0, 1, 0)
    end
  end

  describe "#notify_results(test_count, assertion_count, failure_count, error_count, duration)" do
    describe ":success image" do
      before(:each) do
        Guard::Notifier.should_receive(:notify).with(any_args, :title => "Test::Unit results", :image => :success)
      end

      specify { subject.send(:notify_results, 1, 1, 0, 0, 0) }
    end

    describe ":failed image" do
      before(:each) do
        Guard::Notifier.should_receive(:notify).with(any_args, :title => "Test::Unit results", :image => :failed)
      end

      specify { subject.send(:notify_results, 1, 1, 1, 0, 0) }
      specify { subject.send(:notify_results, 1, 1, 0, 1, 0) }
    end
  end

end
