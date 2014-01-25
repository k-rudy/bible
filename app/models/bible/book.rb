class Bible::Book
  include Mongoid::Document

  has_many :verses, class_name: 'Bible::Verse'

  field :name
  field :title, localize: true
  field :title_full, localize: true
  field :chapters_count, type: Integer
  field :order, type: Integer

  index name: 1
  index order: 1
end
