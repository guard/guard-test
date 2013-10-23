# encoding: utf-8
require 'spec_helper'

describe Guard::TestVersion do

  describe "run" do
    it "should be in early development stage" do
      described_class::VERSION.should eq '2.0.0'
    end
  end

end
