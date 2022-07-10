class Track < ApplicationRecord
  belongs_to :user
  belongs_to :artist
  
  accepts_nested_attributes_for :artist
end
