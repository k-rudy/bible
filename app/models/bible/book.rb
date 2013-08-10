class Bible::Book
  include Mongoid::Document

  has_many :verses

  field :name
  field :title, localize: true
  field :chapters_count, type: Integer

  index name: 1
end
