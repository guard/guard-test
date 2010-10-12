require 'spec_helper'

describe Guard::TestVersion do
  
  describe "run" do
    it "should be in early development stage" do
      subject::VERSION.should < "1.0.0"
    end
  end
  
end
