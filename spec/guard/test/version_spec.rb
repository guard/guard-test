require 'spec_helper'
require 'guard/test/version'

describe Guard::TestVersion do

  describe "run" do
    it "should be in early development stage" do
      subject::VERSION.split('.')[0].to_i.should < 1
    end
  end

end
