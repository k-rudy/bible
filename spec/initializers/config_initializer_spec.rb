require 'spec_helper'

describe CONFIG do
  subject { CONFIG }

  it 'should be accessible through symbol keys of any deep' do
    expect(subject[:sources][:ru][:url]).to be_present
  end
end
