# encoding: utf-8
require 'spec_helper'

describe Guard::Test::Inspector do

  describe "clean" do
    before { subject.test_paths = ["test"] }

    it "should add all test files under the given dir" do
      subject.clean(["test"]).should \
      == ["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove non-test files" do
      subject.clean(["test/succeeding_test.rb", "bob.rb"]).should == ["test/succeeding_test.rb"]
    end

    it "should remove non-existing test files" do
      subject.clean(["test/succeeding_test.rb", "bob_test.rb"]).should == ["test/succeeding_test.rb"]
    end

    it "should remove non-existing test files (2)" do
      subject.clean(["test/bar_test.rb"]).should == []
    end

    it "should keep test folder path" do
      subject.clean(["test/succeeding_test.rb", "test/unit"]).should \
      == ["test/succeeding_test.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove duplication" do
      subject.clean(["test", "test"]).should \
      == ["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove test folder includes in other test folder" do
      subject.clean(["test/unit", "test"]).should \
      == ["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove test files includes in test folder" do
      subject.clean(["test/unit/failing_test.rb", "test"]).should \
      == ["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove test files includes in test folder (2)" do
      subject.clean(["test/unit/failing_test.rb", "test/unit/error/error_test.rb", "test/unit/error"]).should \
      == ["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    context "when test_paths is not default" do
      before { subject.test_paths = ["test/unit/error"] }

      it "should clean paths not specified" do
        subject.clean(['test/succeeding_test.rb', 'test/unit/error/error_test.rb']).should \
        == ['test/unit/error/error_test.rb']
      end
    end

  end

end
