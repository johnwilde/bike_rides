require 'spec_helper'

describe RidesController do

  render_views

  describe "GET 'index'" do
    it "should be successful" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

  describe "GET 'update'" do 
    before(:each) do
    attr={ :total_distance  => 100,
           :total_time  => 1000,
           :moving_time  => 900,
           :avg_speed  => 10,
           :avg_moving_speed => 12,
           :max_speed => 15,
           :min_elevation => 0,
           :max_elevation => 100,
           :elevation_gain => 50,
           :max_grade => 10,
           :min_grade => -1,
           :recorded => "Tue Aug 23 06:32:43 PDT 2011".to_datetime }
    end
    
    it "should redirect if update is valid" do

    end

    
  end
end
