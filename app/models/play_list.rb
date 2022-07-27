class PlayList < ApplicationRecord
  belongs_to :user
  has_many :line_items, dependent: :destroy
  has_many :tracks, through: :line_items

  validates :title, presence: true
end
