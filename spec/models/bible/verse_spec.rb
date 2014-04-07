require 'spec_helper'

describe Bible::Verse do
  it { should belong_to :book }

  it { should have_field(:text) }
  it { should have_field(:chapter).of_type(Integer) }

end
