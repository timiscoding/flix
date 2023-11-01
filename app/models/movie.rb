class Movie < ApplicationRecord
  has_many :reviews, -> { order(created_at: :desc) }, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :fans, through: :favorites, source: :user
  has_many :characterizations, dependent: :destroy
  has_many :genres, through: :characterizations
  has_one_attached :main_image

  RATINGS = %w[G PG PG-13 M R NC-17].freeze

  validates :title, presence: true, uniqueness: true
  validates :released_on, :duration, presence: true
  validates :description, length: { minimum: 25 }
  validates :total_gross, numericality: { greater_than_or_equal_to: 0 }
  validates :rating, inclusion: { in: RATINGS }

  validate :acceptable_image

  scope :released, -> { where('released_on < ?', Time.now).order(released_on: :desc) }
  scope :upcoming, -> { where('released_on > ?', Time.now) }
  scope :recent, ->(max = 5) { released.limit(max) }
  scope :hits, -> { released.where('total_gross >= ?', 300_000_000).reorder(total_gross: :desc) }
  scope :flops, -> { released.where('total_gross < ?', 225_000_000).order(total_gross: :asc) }
  scope :grossed_less_than, ->(amount) { released.where('total_gross < ?', amount) }
  scope :grossed_more_than, ->(amount) { released.where('total_gross >= ?', amount) }

  before_save :set_slug

  def flop?
    total_gross < 225_000_000
  end

  def average_stars
    reviews.average(:stars) || 0
  end

  def average_stars_as_percent
    average_stars / 5.0 * 100
  end

  def set_slug
    self.slug = title.parameterize
  end

  def to_param
    slug
  end

  private

  def acceptable_image
    return unless main_image.attached?

    errors.add(:main_image, 'is too big') unless main_image.blob.byte_size <= 1.megabyte

    acceptable_types = ['image/jpeg', 'image/png']

    return if acceptable_types.include? main_image.blob.content_type

    errors.add(:main_image, 'must be JPEG or PNG')
  end
end
