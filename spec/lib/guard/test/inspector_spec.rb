require 'guard/test/inspector'

RSpec.describe Guard::Test::Inspector do

  describe "clean" do
    before { subject.test_paths = ["test"] }

    it "should add all test files under the given dir" do
      expect(subject.clean(["test"])).to \
      eq ["test/succeeding_test.rb", "test/succeeding_tests.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove non-test files" do
      expect(subject.clean(["test/succeeding_test.rb", "bob.rb"])).to eq ["test/succeeding_test.rb"]
    end

    it "should remove non-existing test files" do
      expect(subject.clean(["test/succeeding_test.rb", "bob_test.rb"])).to eq ["test/succeeding_test.rb"]
    end

    it "should remove non-existing test files (2)" do
      expect(subject.clean(["test/bar_test.rb"])).to eq []
    end

    it "should keep test folder path" do
      expect(subject.clean(["test/succeeding_test.rb", "test/unit"])).to \
      eq ["test/succeeding_test.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove duplication" do
      expect(subject.clean(["test", "test"])).to \
      eq ["test/succeeding_test.rb", "test/succeeding_tests.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove test folder includes in other test folder" do
      expect(subject.clean(["test/unit", "test"])).to \
      eq ["test/succeeding_test.rb", "test/succeeding_tests.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove test files includes in test folder" do
      expect(subject.clean(["test/unit/failing_test.rb", "test"])).to \
      eq ["test/succeeding_test.rb", "test/succeeding_tests.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    it "should remove test files includes in test folder (2)" do
      expect(subject.clean(["test/unit/failing_test.rb", "test/unit/error/error_test.rb", "test/unit/error"])).to \
      eq ["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]
    end

    context "when test_paths is not default" do
      before { subject.test_paths = ["test/unit/error"] }

      it "should clean paths not specified" do
        expect(subject.clean(['test/succeeding_test.rb', 'test/unit/error/error_test.rb'])).to \
        eq ['test/unit/error/error_test.rb']
      end
    end

  end

end
