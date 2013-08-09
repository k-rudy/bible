require 'spec_helper'

describe Bible::Verse do
  it { should belong_to :book }
end
