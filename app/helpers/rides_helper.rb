module RidesHelper

  KM2MI = 0.6213
  M2FT = 3.280

  def km_units
    if use_metric
      "km"
    else
      "mi"
    end
  end

  def m_units
    if use_metric
      "m"
    else
      "ft"
    end
  end

  def speed_units
    if use_metric
      "km/hr"
    else
      "mi/hr"
    end
  end

  def moving_time_hm(ride)
    sec_to_hm(ride.moving_time)
  end

  def sec_to_hm(sec_in)
    t=Time.at(sec_in)
    t.utc.strftime("%H:%M")
  end

  def use_metric
    if signed_in?
      current_user.use_metric_units
    else
      true
    end
  end

  def total_distance
    if use_metric
      total_distance
    else
      total_distance*KM2MI
    end
  end

  def avg_moving_speed
    if use_metric
      avg_moving_speed
    else
      avg_moving_speed*KM2MI
    end
  end

  def max_speed
    if use_metric
      max_speed
    else
      max_speed*KM2MI
    end
  end

  def elevation_gain
    if use_metric
      elevation_gain
    else
      elevation_gain*M2FT
    end
  end

end
