class Ride < ActiveRecord::Base
  attr_accessible :fusiontable_id

  validates :fusiontable_id, :presence  => true
end
