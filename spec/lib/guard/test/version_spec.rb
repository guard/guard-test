# encoding: utf-8
require 'spec_helper'

describe Guard::TestVersion do

  describe "run" do
    it "should be in early development stage" do
      expect(described_class::VERSION).to eq '2.0.1'
    end
  end

end
