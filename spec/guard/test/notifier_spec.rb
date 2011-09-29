# encoding: utf-8
require 'spec_helper'
require 'guard/test/notifier'

describe Guard::TestNotifier do

  describe "#notify(result, duration)" do
    context "no failure, no error" do
      it "displays a 'success' image" do
        result = mock('result', :run_count => 1, :assertion_count => 1, :failure_count => 0, :error_count => 0)
        Guard::Notifier.should_receive(:notify).with(any_args, :title => "Test::Unit results", :image => :success)
        described_class.notify(result, 0)
      end
    end

    context "1 failure" do
      it "displays a 'failed' image" do
        result = mock('result', :run_count => 1, :assertion_count => 1, :failure_count => 1, :error_count => 0)
        Guard::Notifier.should_receive(:notify).with(any_args, :title => "Test::Unit results", :image => :failed)
        described_class.notify(result, 0)
      end
    end

    context "1 error" do
      it "displays a 'failed' image" do
        result = mock('result', :run_count => 1, :assertion_count => 1, :failure_count => 0, :error_count => 1)
        Guard::Notifier.should_receive(:notify).with(any_args, :title => "Test::Unit results", :image => :failed)
        described_class.notify(result, 0)
      end
    end
  end

end
