class LineItem < ApplicationRecord
  belongs_to :play_list
  belongs_to :track
  # acts_as_list scope: :play_list
end
