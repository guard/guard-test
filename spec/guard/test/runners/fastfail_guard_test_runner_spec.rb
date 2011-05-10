# encoding: utf-8
require 'spec_helper'
require "#{File.dirname(__FILE__)}/../../../../lib/guard/test/runners/fastfail_guard_test_runner"

describe FastfailGuardTestRunner do

  describe "#finished" do
    subject { described_class.new(double('suite').as_null_object) }

    context "with GUARD_TEST_NOTIFY=true" do
      it "should call notify_results with the tests results" do
        if Guard::Notifier.enabled?
          Guard::Notifier.should_receive(:notify)
        else
          Guard::Notifier.should_not_receive(:notify)
        end

        system "ruby -Itest -rubygems -r #{@lib_path.join('guard/test/runners/fastfail_guard_test_runner')} " \
        "-e \"%w[test/succeeding_test.rb].each { |path| load path }; GUARD_TEST_NOTIFY=true\" " \
        "\"test/succeeding_test.rb\" --runner=guard-fastfail 1>/dev/null"
      end
    end

    context "with GUARD_TEST_NOTIFY=false" do
      it "should call notify_results with the tests results" do
        Guard::Notifier.should_not_receive(:notify)

        system "ruby -Itest -rubygems -r #{@lib_path.join('guard/test/runners/fastfail_guard_test_runner')} " \
        "-e \"%w[test/succeeding_test.rb].each { |path| load path }; GUARD_TEST_NOTIFY=false\" " \
        "\"test/succeeding_test.rb\" --runner=guard-fastfail 1>/dev/null"
      end
    end
  end

end
