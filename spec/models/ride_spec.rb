require 'spec_helper'

describe "Ride" do
  
  before(:each) do
    @user = Factory(:user)
    @attr = { :fusiontable_id  => "123456",
              :ridedata => "some ride geometry"}
    
  end
  
  it "should create a new ride" do
    @user.rides.create!(@attr)
  end
  
  it "should get authenticated fusion table" do
   @ft = Ride.get_fusiontable(@user)
   @ft.auth_handler.access_token.should eq(@user.token)
  end

  it "should make new ride from table" do
    table=MockTable.new(1)
    Ride.make_ride_from_table(table, @user)
    @user.rides.count.should eq(1)
  end

  it "should require ridedata" do
    no_ridedata_ride = @user.rides.new(@attr.merge(:ridedata => ""))
    no_ridedata_ride.should_not be_valid
  end

  describe "user associations" do
    before(:each) do
      @ride = @user.rides.create(@attr)
    end
    
    it "should have a user attribute" do
      @ride.should respond_to(:user)
    end

    it "should have the right associated user" do
      @ride.user_id.should == @user.id
      @ride.user.should == @user
    end
  end

  describe "parsing ride description text" do
    before(:each) do 
      @ride = @user.rides.create(@attr)
    end

    it "should parse fields (english)" do
      text = "Total Distance: 32.91 km (20.4 mi)Total Time: 1:08:12Moving Time: 57:29Average Speed: 28.95 km/h (18.0 mi/h) Average Moving Speed: 34.35 km/h (21.3 mi/h) Max Speed: 65.70 km/h (40.8 mi/h)Min Elevation: -10 m (-31 ft)Max Elevation: 173 m (569 ft)Elevation Gain: 420 m (1378 ft)Max Grade: 10 %Min Grade: -8 %Recorded: Tue Aug 23 06:32:43 PDT 2011Activity type: -"
      @ride.set_attributes_from_summary_text(text)
      @ride.total_distance.should == 32.91
      @ride.total_time.should==1*3600+8*60+12
      @ride.moving_time.should==57*60+29
      @ride.avg_speed.should==28.95
      @ride.avg_moving_speed.should==34.35
      @ride.max_speed.should==65.70
      @ride.min_elevation.should==-10
      @ride.max_elevation.should==173
      @ride.elevation_gain.should==420
      @ride.max_grade.should==10
      @ride.min_grade.should==-8
      @ride.recorded.should==DateTime.parse("Tue Aug 23 06:32:43 PDT 2011")
    end

    it "should parse fields (spanish)" do
      text= "Distancia total: 3,90 km (2,4 mi)Tiempo total: 22:58Tiempo en movimiento: 16:55Velocidad promedio: 10,19 km/h (6,3 mi/h) Velocidad promedio en movimiento: 13,84 km/h (8,6 mi/h) Velocidad m?xima: 20,70 km/h (12,9 mi/h)Elevaci?n m?nima: 90 m (295 ft)Elevaci?n m?xima: 130 m (425 ft)Aumento de elevaci?n: 19 m (61 ft)Pendiente m?xima: 5 %Pendiente m?nima: -3 %Grabado: dom jun 19 13:26:13 GMT+02:00 2011Tipo de actividad: -"
      @ride.set_attributes_from_summary_text(text)
      @ride.total_distance.should == 3.90
      @ride.total_time.should==22*60+58
      @ride.moving_time.should==16*60+55
      @ride.avg_speed.should==10.19
      @ride.avg_moving_speed.should==13.84
      @ride.max_speed.should==20.70
      @ride.min_elevation.should==90
      @ride.max_elevation.should==130
      @ride.elevation_gain.should==19
      @ride.max_grade.should==5
      @ride.min_grade.should==-3
      @ride.recorded.should==DateTime.parse("Grabado: dom jun 19 13:26:13 GMT+02:00 2011")
    end

  end
end
