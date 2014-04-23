class Bible::Verse
  include Mongoid::Document

  belongs_to :book, class_name: 'Bible::Book'

  field :chapter, type: Integer
  field :text, localize: true
  field :order, type: Integer

  index order: 1
  
  validates :order, uniqueness: { scope: [ :chapter, :book_id ] }
  
  default_scope ->{ asc(:order) }
  scope :of_chapter, ->(chapter) { where(chapter: chapter) }
end
