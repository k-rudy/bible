class Bible::Verse
  include Mongoid::Document

  belongs_to :book

  field :book_name
  field :chapter, type: Integer
  field :text, localize: true

  index book_name: 1

end
