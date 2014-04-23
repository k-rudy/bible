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
  
  default_scope ->{ asc(:order) }
  scope :by_title, ->(title) { where(title: title) }
  scope :starting_from, ->(book_order) { where(order: { '$gte' => book_order }) }
  
  # Order of the latest book verse
  # 
  # @return [Integer] latest verse order or if there are no verses yet - returns 0
  def latest_verse_order(chapter)
    verses.of_chapter(chapter).last.try(:order) || 0
  end
end
