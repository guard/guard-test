# encoding: utf-8
require 'spec_helper'

describe FastfailGuardTestRunner do

  describe "#finished" do
    # Can't test...
    pending "with GUARD_TEST_NOTIFY=true" do
      it "should notify the results" do
        Guard::Notifier.turn_on
        Guard::Notifier.should_receive(:notify)

        system "bundle exec ruby -Itest -rubygems -r bundler/setup -r #{@lib_path.join('guard/test/runners/fastfail_guard_test_runner')} " \
        "-e \"GUARD_TEST_NOTIFY=true\" " \
        "-r ./test/succeeding_test.rb -- --runner=guard-fastfail 1>/dev/null"
      end
    end

    context "with GUARD_TEST_NOTIFY=false" do
      it "should not notify the results" do
        Guard::Notifier.turn_on
        Guard::Notifier.should_not_receive(:notify)

        system "bundle exec ruby -Itest -rubygems -r bundler/setup -r #{@lib_path.join('guard/test/runners/fastfail_guard_test_runner')} " \
        "-e \"GUARD_TEST_NOTIFY=false\" " \
        "-r ./test/succeeding_test.rb -- --runner=guard-fastfail 1>/dev/null"
      end
    end
  end

end
