# == Schema Information
#
# Table name: users
#
#  id               :integer         primary key
#  provider         :string(255)
#  uid              :string(255)
#  name             :string(255)
#  created_at       :timestamp
#  updated_at       :timestamp
#  token            :string(255)
#  secret           :string(255)
#  admin            :boolean         default(FALSE)
#  ride_id          :integer
#  email            :string(255)
#  use_metric_units :boolean
#


class User < ActiveRecord::Base
 has_many :rides, :dependent  => :destroy
 
 def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["user_info"]["name"]
      user.email = auth["user_info"]["email"]
    end
  end

end
