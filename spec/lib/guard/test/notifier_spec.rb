require 'spec_helper'
require 'guard/test/notifier'

describe Guard::Test::Notifier do

  describe "#notify(result, duration)" do
    context "no failure, no error" do
      it "displays a 'success' image" do
        result = create_mock_result
        expect(Guard::Compat::UI).to receive(:notify).with(anything, title: "Test::Unit results", image: :success)
        described_class.notify(result, 0)
      end
    end

    context "1 failure" do
      it "displays a 'failed' image" do
        result = create_mock_result(failure_count: 1)
        expect(Guard::Compat::UI).to receive(:notify).with(anything, title: "Test::Unit results", image: :failed)
        described_class.notify(result, 0)
      end
    end

    context "1 error" do
      it "displays a 'failed' image" do
        result = create_mock_result(error_count: 1)
        expect(Guard::Compat::UI).to receive(:notify).with(anything, title: "Test::Unit results", image: :failed)
        described_class.notify(result, 0)
      end
    end
  end

end

def create_mock_result(options={})
  default = {run_count: 1, assertion_count: 1, failure_count: 0, error_count: 0}
  options = default.merge(options)
  # passed? if no failures or errors
  options[:passed?] = (0 == options[:failure_count] && 0 == options[:error_count])
  double('result', options)
end

