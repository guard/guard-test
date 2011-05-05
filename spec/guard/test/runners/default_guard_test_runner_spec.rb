# encoding: utf-8
require 'spec_helper'
require "#{File.dirname(__FILE__)}/../../../../lib/guard/test/runners/default_guard_test_runner"

describe DefaultGuardTestRunner do

  describe "#finished" do
    subject { described_class.new(double('suite').as_null_object) }

    pending "with GUARD_TEST_NOTIFY=true" do
      it "should call notify_results with the tests results" do
        Guard::Notifier.should_receive(:notify)

        system "ruby -Itest -rubygems -r #{@lib_path.join('guard/test/runners/default_guard_test_runner')} " \
        "-e \"%w[test/succeeding_test.rb].each { |path| load path }; GUARD_TEST_NOTIFY=true\" " \
        "\"test/succeeding_test.rb\" --runner=guard-default"
      end
    end
  end

end
