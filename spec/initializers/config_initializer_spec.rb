require 'spec_helper'

describe CONFIG do
  subject { CONFIG }

  it 'should be accessible through symbol keys of any deep' do
    expect(subject[:sources][:ru][:url]).to eq("http://google.com")
  end
end
