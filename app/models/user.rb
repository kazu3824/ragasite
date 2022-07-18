class User < ApplicationRecord

  GUEST_EMAIL = "guest@example.com"

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :profile_image
  has_many :tracks, dependent: :destroy
  has_many :track_favorites, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :track_favorited_trackss, through: :track_favorites, source: :track
  has_many :play_lists, dependent: :destroy

  def get_profile_image
    (profile_image.attached?) ? profile_image : "no_image.jpg"
  end

  def self.guest
    find_or_create_by!(email: GUEST_EMAIL) do |user|
       user.password = SecureRandom.urlsafe_base64
       user.name = "guestuser"
    end
  end

  def guest?
    email == GUEST_EMAIL
  end
end
