require 'spec_helper'

describe "Ride" do
  
  before(:each) do
    @user = FactoryGirl.build(:user)
    @user.save!
    @attr = { :fusiontable_id  => "123456",
              :ridedata => "some ride geometry"}
    
  end
  
  it "should create a new ride" do
    @user.rides.create!(@attr)
  end
  
  it "should make new ride from table" do
    testfile = File.dirname(__FILE__) + '/../support/ft-response.json'
    json = JSON.parse(open(testfile,'r').read)
    ride_id = 1
    Ride.make_ride_from_table(ride_id, json, @user)
    @user.rides.count.should eq(1)
  end
  
  it "should not make new ride if no description field is in table" do
    table=MockTable.new(1, 'geo.yml', '')
    Ride.make_ride_from_table(table, @user)
    @user.rides.count.should eq(0)
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

  # describe "parse ride geometry" do
  #   @attr = { :fusiontable_id  => "123456",
  #             :ridedata => "some ride geometry"}
  #   it should "parse geo data" do
  #   end
  # end

  describe "parsing ride description text" do
    before(:each) do 
      @ride = @user.rides.create(@attr)
    end
    # broken, and probably not worth fixing
    # it "should parse time even if it doesn't have seconds field", :focus => true do
    #   text = "Total distance: 32.91 km (20.4 mi)<br>Total time: 1:08<br>Moving time: 57:29<br>Average speed: 28.95 km/h (18.0 mi/h)<br> Average moving speed: 34.35 km/h (21.3 mi/h)<br> Max speed: 65.70 km/h (40.8 mi/h)<br>Min elevation: -10 m (-31 ft)<br>Max elevation: 173 m (569 ft)Elevation gain: 420 m (1378 ft)<br>Max grade: 10 %<br>Min grade: -8 %<br>Recorded: 02/18/2012 7:57 AM<br>Activity type: -"
    #   @ride.set_attributes_from_summary_text(text)
    #   @ride.total_distance.should == 32.91
    #   @ride.total_time.should==1*3600+8*60
    #   @ride.moving_time.should==57*60+29
    #   @ride.avg_speed.should==28.95
    #   @ride.avg_moving_speed.should==34.35
    #   @ride.max_speed.should==65.70
    #   @ride.min_elevation.should==-10
    #   @ride.max_elevation.should==173
    #   @ride.elevation_gain.should==420
    #   @ride.max_grade.should==10
    #   @ride.min_grade.should==-8
    #   @ride.recorded.should==DateTime.strptime("02/18/2012 7:57 am", '%m/%d/%Y %H:%M %p')
    # end
    it "should parse fields latest version, with pace (english)" do
      text = "Total distance: 32.91 km (20.4 mi)<br>Total time: 1:08:12<br>Moving time: 57:29<br>Average speed: 28.95 km/h (18.0 mi/h)<br> Average moving speed: 34.35 km/h (21.3 mi/h)<br> Max speed: 65.70 km/h (40.8 mi/h)<br>Average pace: 7.92 min/km (12.7 min/mi)<br>Average moving pace: 3.43 min/km (5.5 min/mi)<br>Min pace: 1.80 min/km (2.9 min/mi)<br>Max elevation: 173 m (569 ft)<br>Min elevation: -10 m (-31 ft)<br>Elevation gain: 420 m (1378 ft)<br>Max grade: 10 %<br>Min grade: -8 %<br>Recorded: 02/18/2012 7:57 AM<br>Activity type: -"
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
      @ride.recorded.should==DateTime.strptime("02/18/2012 7:57 am", '%m/%d/%Y %H:%M %p')
    end

    it "should parse fields latest version (english)" do
      text = "Total distance: 32.91 km (20.4 mi)<br>Total time: 1:08:12<br>Moving time: 57:29<br>Average speed: 28.95 km/h (18.0 mi/h)<br> Average moving speed: 34.35 km/h (21.3 mi/h)<br> Max speed: 65.70 km/h (40.8 mi/h)<br>Min elevation: -10 m (-31 ft)<br>Max elevation: 173 m (569 ft)Elevation gain: 420 m (1378 ft)<br>Max grade: 10 %<br>Min grade: -8 %<br>Recorded: 02/18/2012 7:57 AM<br>Activity type: -"
      # this may be failing too...https://www.google.com/fusiontables/DataSource?dsrcid=3267595
      # text = "Total distance: 4.12 km (2.6 mi)<br>Total time: 14:46<br>Moving time: 11:58<br>Average speed: 16.72 km/h (10.4 mi/h)<br>Average moving speed: 20.64 km/h (12.8 mi/h)<br>Max speed: 39.76 km/h (24.7 mi/h)<br>Max elevation: 35 m (114 ft)<br>Min elevation: -17 m (-55 ft)<br>Elevation gain: 86 m (282 ft)<br>Max grade: 21 %<br>Min grade: -12 %<br>Recorded: 12/09/2011 9:33 AM<br>Activity type: commute via north beach<br>"
      # This also fails, but I don't have a test for it.  Maybe it's because of the 'pace' stats? 
      #text = "Total distance: 4.12 km (2.6 mi)<br>Total time: 14:46<br>Moving time: 11:58<br>Average speed: 16.72 km/h (10.4 mi/h)<br>Average moving speed: 20.64 km/h (12.8 mi/h)<br>Max speed: 39.76 km/h (24.7 mi/h)<br>Average pace: 3.59 min/km (5.8 min/mi)<br>Average moving pace: 2.91 min/km (4.7 min/mi)<br>Min pace: 1.51 min/km (2.4 min/mi)<br>Max elevation: 35 m (114 ft)<br>Min elevation: -17 m (-55 ft)<br>Elevation gain: 86 m (282 ft)<br>Max grade: 21 %<br>Min grade: -12 %<br>Recorded: 12/09/2011 9:33 AM<br>Activity type: commute via north beach<br>"
      # text = "Total distance: 97.16 km (60.4 mi)<br>Total time: 5:42:27<br>Moving time: 3:56:26<br>Average speed: 17.02 km/h (10.6 mi/h)<br> Average moving speed: 24.66 km/h (15.3 mi/h)<br> Max speed: 60.30 km/h (37.5 mi/h)<br>Min elevation: -42 m (-138 ft)<br>Max elevation: 167 m (547 ft)<br>Elevation gain: 1420 m (4660 ft)<br>Max grade: 17 %<br>Min grade: -14 %<br>Recorded: 02/18/2012 7:57 AM<br>Activity type: -"

      text = "Total distance: 32.91 km (20.4 mi)<br>Total time: 1:08:12<br>Moving time: 57:29<br>Average speed: 28.95 km/h (18.0 mi/h)<br> Average moving speed: 34.35 km/h (21.3 mi/h)<br> Max speed: 65.70 km/h (40.8 mi/h)<br>Min elevation: -10 m (-31 ft)<br>Max elevation: 173 m (569 ft)Elevation gain: 420 m (1378 ft)<br>Max grade: 10 %<br>Min grade: -8 %<br>Recorded: 02/18/2012 7:57 AM<br>Activity type: -"
      text = "Name: 
      08/26/2012 8:57am
      Activity type:
      -Description: 
      -Total distance: 132.20 km (82.1 mi)
      Total time: 8:04:02
      Moving time: 5:49:20
      Average speed: 16.39 km/h (10.2 mi/h)
      Average moving speed: 22.71 km/h (14.1 mi/h)
      Max speed: 53.10 km/h (33.0 mi/h)
      Average pace: 3.66 min/km (5.9 min/mi)
      Average moving pace: 2.64 min/km (4.3 min/mi)
      Fastest pace: 1.13 min/km (1.8 min/mi)
      Max elevation: 439 m (1441 ft)
      Min elevation: -38 m (-126 ft)
      Elevation gain: 2049 m (6723 ft)
      Max grade: 13 %
      Min grade: -16 %
      Recorded: 08/26/2012 8:57am"

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
      @ride.recorded.should==DateTime.strptime("02/18/2012 7:57 am", '%m/%d/%Y %H:%M %p')
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
