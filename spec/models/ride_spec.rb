# == Schema Information
#
# Table name: rides
#
#  id             :integer         not null, primary key
#  fusiontable_id :integer
#  created_at     :datetime
#  updated_at     :datetime
#  ridedata       :text
#  centroid_lat   :float
#  centroid_lon   :float
#  bb_sw_lat      :float
#  bb_sw_lon      :float
#  bb_ne_lat      :float
#  bb_ne_lon      :float
#  user_id        :integer
#

require 'spec_helper'

describe Ride do
  pending "add some examples to (or delete) #{__FILE__}"
end
