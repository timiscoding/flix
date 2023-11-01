class User < ApplicationRecord
  has_secure_password
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true
  validates :email, format: { with: /\S+@\S/ },
                   uniqueness: { case_sensitive: true }
  validates :password, length: { minimum: 3, allow_blank: true }
  validates :username, format: { with: /\A[A-Z0-9]+\z/i },
                        uniqueness: { case_sensitive: false }

  scope :by_name, -> { order(name: :asc) }
  scope :not_admins, -> { where(admin: false).by_name }

  before_save :format_username
  before_save :format_email
  before_save :set_slug

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def format_username
    self.username = username.downcase    
  end

  def format_email
    self.email = email.downcase    
  end

  def to_param
    slug
  end

  def set_slug
    self.slug = username.parameterize
  end
end
