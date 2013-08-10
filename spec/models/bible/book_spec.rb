require 'spec_helper'

describe Bible::Book do
  it { should have_many :verses }
end
