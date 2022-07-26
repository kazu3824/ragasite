class LineItem < ApplicationRecord
  belongs_to :play_list
  belongs_to :track
end
