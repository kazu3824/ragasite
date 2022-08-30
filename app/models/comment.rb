class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :track

  validates :body, presence: true,length:{maximum:100}
end
