require 'spec_helper'

describe Guard::TestVersion do

  it 'has the right version number' do
    expect(described_class::VERSION).to eq '2.0.2'
  end

end
