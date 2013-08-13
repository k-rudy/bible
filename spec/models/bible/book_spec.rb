require 'spec_helper'

describe Bible::Book do
  it { should have_many :verses }

  it { should have_fields(:name, :title, :title_full) }
  it { should have_field(:chapters_count).of_type(Integer) }

end
