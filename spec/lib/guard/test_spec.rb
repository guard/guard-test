require 'guard/test'

RSpec.describe Guard::Test do
  subject { described_class.new }
  let(:runner) { subject.instance_variable_get(:@runner) }

  before do
    allow(Guard::Compat::UI).to receive(:info)
  end

  describe "#initialize" do
    it "instantiates a new Runner" do
      expect(Guard::Test::Runner).to receive(:new)
      described_class.new
    end

    context "with options given" do
      it "passes fiven options to Guard::Test::Runner#new" do
        expect(Guard::Test::Runner).to receive(:new).with(rvm: ['1.8.7', '1.9.2'], bundler: false).and_return(double('runner', bundler?: true))

        described_class.new(rvm: ['1.8.7', '1.9.2'], bundler: false)
      end
    end
  end

  describe "#start" do
    context ":all_on_start option not specified" do
      it "displays a start message" do
        expect(Guard::Compat::UI).to receive(:info).with("Guard::Test #{Guard::TestVersion::VERSION} is running, with Test::Unit #{::Test::Unit::VERSION}!", reset: true)
        expect(subject).to receive(:run_all)

        subject.start
      end

      it "calls #run_all by default" do
        expect(subject).to receive(:run_all)

        subject.start
      end
    end

    context ":all_on_start option is false" do
      subject { described_class.new(all_on_start: false) }

      it "doesn't call #run_all" do
        expect(subject).to_not receive(:run_all)

        subject.start
      end
    end

  end

  describe "#run_all" do
    it "runs all tests specified by the default :test_paths with a message" do
      expect(runner).to receive(:run).with(["test/succeeding_test.rb", "test/succeeding_tests.rb", "test/test_old.rb", "test/unit/error/error_test.rb",  "test/unit/failing_test.rb"],message: "Running all tests"
      )
      subject.run_all
    end

    context "when :test_paths option specified" do
      subject { described_class.new(test_paths: ["test/unit/error"]) }

      it "runs all tests in specific directory" do
        expect(runner).to receive(:run).with(["test/unit/error/error_test.rb"], anything)
        subject.run_all
      end
    end

    it "cleans failed memory if passed" do
      expect(runner).to receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(false)
      subject.run_on_modifications(["test/unit"])

      expect(runner).to receive(:run).with(["test/succeeding_test.rb", "test/succeeding_tests.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], message: "Running all tests").and_return(true)
      subject.run_all

      expect(runner).to receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(true)
      subject.run_on_modifications(["test/unit"])
    end

    it "init test_paths for Inspector" do
      expect(runner).to receive(:run)
      expect(Guard::Test::Inspector).to receive(:test_paths=).with(["test"])
      subject.run_all
    end
  end

  describe "#reload" do
    it "should clear failed_path" do
      expect(runner).to receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(false)
      subject.run_on_modifications(["test/unit"])

      subject.reload

      expect(runner).to receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(true)
      expect(runner).to receive(:run).with(["test/succeeding_test.rb", "test/succeeding_tests.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], message: "Running all tests").and_return(true)
      subject.run_on_modifications(["test/unit"])
    end
  end

  describe "#run_on_modifications" do
    it "runs test after run_all" do
      expect(runner).to receive(:run)
      subject.run_all
      expect(runner).to receive(:run).with(["test/unit/error/error_test.rb"])
      subject.run_on_modifications(["test/unit/error/error_test.rb"])
    end

    it "init test_paths for Inspector" do
      expect(Guard::Test::Inspector).to receive(:test_paths=).with(["test"])
      subject.run_on_modifications([])
    end

    context ":all_after_pass option not specified" do
      it "runs test with under given paths, recursively" do
        expect(runner).to receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"])
        subject.run_on_modifications(["test/unit"])
      end

      it "calls #run_all by default if the changed specs pass after failing" do
        expect(runner).to receive(:run).with(["test/succeeding_test.rb"]).and_return(false, true)
        expect(runner).to receive(:run).with(["test/succeeding_test.rb", "test/succeeding_tests.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], message: "Running all tests")

        subject.run_on_modifications(["test/succeeding_test.rb"])
        subject.run_on_modifications(["test/succeeding_test.rb"])
      end

      it "doesn't call #run_all if the changed specs pass without failing" do
        expect(runner).to receive(:run).with(["test/succeeding_test.rb"]).and_return(true)
        expect(runner).to_not receive(:run).with(["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], message: "Running all tests")
        subject.run_on_modifications(["test/succeeding_test.rb"])
      end
    end

    context ":all_after_pass option is false" do
      subject { described_class.new(all_after_pass: false) }

      it "doesn't call #run_all if the changed specs pass after failing but the :all_after_pass option is false" do
        expect(runner).to receive(:run).with(["test/succeeding_test.rb"]).and_return(false, true)
        expect(runner).to_not receive(:run).with(["test/succeeding_test.rb", "test/test_old.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"], message: "Running all tests")

        subject.run_on_modifications(["test/succeeding_test.rb"])
        subject.run_on_modifications(["test/succeeding_test.rb"])
      end
    end

    context ":keep_failed option not specified" do
      subject { described_class.new(all_after_pass: false) }

      it "keeps failed specs and rerun later by default" do
        expect(runner).to receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(false)
        subject.run_on_modifications(["test/unit"])

        expect(runner).to receive(:run).with(["test/succeeding_test.rb", "test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(true)
        subject.run_on_modifications(["test/succeeding_test.rb"])

        expect(runner).to receive(:run).with(["test/succeeding_test.rb"]).and_return(true)
        subject.run_on_modifications(["test/succeeding_test.rb"])
      end
    end

    context ":keep_failed option is false" do
      subject { described_class.new(all_after_pass: false, keep_failed: false) }

      it "doesn't keep failed specs" do
        expect(runner).to receive(:run).with(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]).and_return(false)
        subject.run_on_modifications(["test/unit"])

        expect(runner).to receive(:run).with(["test/succeeding_test.rb"]).and_return(true)
        subject.run_on_modifications(["test/succeeding_test.rb"])

        expect(runner).to receive(:run).with(["test/succeeding_test.rb"]).and_return(true)
        subject.run_on_modifications(["test/succeeding_test.rb"])
      end
    end

  end

end
