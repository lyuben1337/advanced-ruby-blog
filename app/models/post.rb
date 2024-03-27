class Post < ApplicationRecord
  has_rich_text :content

  validates :title, presence: true
  validates :content, presence: true

  has_one :user
  has_many :comments

  scope :sorted, -> {order(arel_table[:published_at].desc.nulls_first)}
  scope :draft, -> {where(published_at: nil)}
  scope :published, -> {where("published_at <= ?", Time.now)}
  scope :scheduled, -> {where("published_at > ?", Time.now)}

  def draft?
    published_at.nil?
  end

  def published?
    published_at? && published_at <= Time.now
  end

  def schedule?
    published_at? && published_at > Time.now
  end

  def status
    case
    when draft?
      "Draft"
    when published?
      "Published"
    when schedule?
      "Scheduled"
    else
      "Status not determined"
    end
  end

end



