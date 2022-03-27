class Book < ApplicationRecord
  belongs_to :user
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags


  validates :title, presence: true
  validates :body, presence: true, length: { maximum: 200 }

  def save_tag(sent_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    old_tags = current_tags - sent_tags
    new_tags = sent_tags - current_tags

    old_tags.each do |old_name|
      self.book_tags.delete Tag.find_by(name:old_name)
    end

    new_tags.each do |new_name|
      new_book_tag = Tag.find_or_create_by(name:new_name)
      self.tags << new_book_tag
    end
  end
end
