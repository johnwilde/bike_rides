module RidesHelper

  KM2MI = 0.6213
  M2FT = 3.280

  def km_units
    use_metric ?  "km" :  "mi"
  end

  def m_units
    use_metric ?  "m" :  "ft"
  end

  def speed_units
    use_metric ?  "km/hr" :  "mi/hr"
  end

  def temp_units
    use_metric ? "C" : "F"
  end

  def moving_time_hm(ride)
    sec_to_hm(ride.moving_time)
  end

  def sec_to_hm(sec_in)
    t=Time.at(sec_in)
    t.utc.strftime("%H:%M")
  end

  def use_metric
    signed_in? ? current_user.use_metric_units : true
  end

  def total_distance(ride)
    use_metric ? ride.total_distance : ride.total_distance*KM2MI
  end

  def avg_moving_speed(ride)
    use_metric ? ride.avg_moving_speed : ride.avg_moving_speed*KM2MI
  end

  def max_speed(ride)
    use_metric ? ride.max_speed : ride.max_speed*KM2MI
  end

  def elevation_gain(ride)
    use_metric ? ride.elevation_gain : ride.elevation_gain*M2FT
  end

  def temperature(ride)
    return if !ride.weather
    data = JSON.parse(ride.weather)
    temp_m = data['tempm']
    temp_i = data['tempi']
    use_metric ? temp_m : temp_i
  end

end
