# encoding: utf-8
require 'spec_helper'
require "#{File.dirname(__FILE__)}/../../../lib/guard/test/ui"

describe Guard::Test::UI do

  describe "#print_results(test_count, assertion_count, failure_count, error_count, duration, options = {})" do
    context "no failure, no error" do
      it "colorizes output with 'pass' color" do
        result = mock('result', :run_count => 1, :assertion_count => 1, :failure_count => 0, :error_count => 0)
        described_class.should_receive(:color_puts).ordered.with(an_instance_of(String))
        described_class.should_receive(:color_puts).ordered.with(an_instance_of(String), :color => :pass)

        described_class.send(:results, result, 0)
      end
    end

    context "1 failure" do
      it "colorizes output with 'failure' color" do
        result = mock('result', :run_count => 1, :assertion_count => 1, :failure_count => 1, :error_count => 0)
        described_class.should_receive(:color_puts).ordered.with(an_instance_of(String))
        described_class.should_receive(:color_puts).ordered.with(an_instance_of(String), :color => :failure)

        described_class.send(:results, result, 0)
      end
    end

    context "1 error" do
      it "colorizes output with 'error' color" do
        result = mock('result', :run_count => 1, :assertion_count => 1, :failure_count => 0, :error_count => 1)
        described_class.should_receive(:color_puts).ordered.with(an_instance_of(String))
        described_class.should_receive(:color_puts).ordered.with(an_instance_of(String), :color => :error)

        described_class.send(:results, result, 0)
      end
    end
  end

end
