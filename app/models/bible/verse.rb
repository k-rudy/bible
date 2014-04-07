class Bible::Verse
  include Mongoid::Document

  belongs_to :book

  field :chapter, type: Integer
  field :text, localize: true
  field :order, type: Integer

  index order: 1
end
