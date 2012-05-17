# Mock the strava-api for testing
class MockClub
  attr_accessor :id, :name, :member_ids
  def initialize(id, name)
    @id = id
    @name = name
    @member_ids = [1, 2]
  end
  def members
    member_ids.map{|m| MockMember.new(m, "name")}
  end
end

class MockMember
  attr_accessor :id, :name
  def initialize(id, name)
    @id = id
    @name = name
  end
end

class MockRide
  attr_accessor :id, :elevation_gain, :start_date
  def initialize(id, elevation_gain, date)
    @id = id
    @elevation_gain = elevation_gain
    @start_date = date
  end
end

class MockApi
  attr_accessor :rides, :club
  def initialize(size)
    @club =  MockClub.new(2207, 'coretech') 
    @club.member_ids = (1..size).to_a
    @rides = [MockRide.new(2207, 1000, Date.today), MockRide.new(1, 1000, Date.today - 1)]
  end
  def rides(params)
    return [] if params[:offset] > 0
    @rides
  end
  def ride_show(id)
    @rides.detect {|ride| ride.id == id}
  end
  def drop_ride
    @rides.shift
  end
  def clubs(string)
    [ @club ]
  end
  def club_show(id)
    @club
  end
end

