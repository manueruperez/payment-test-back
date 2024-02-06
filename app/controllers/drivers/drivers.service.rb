class DriversService
  def get_drivers()
    all_drivers = Driver.all_drivers
  end

  def get_driver_for_rider(lat, long)
    drivers = get_drivers()
    closest_driver = drivers.min_by do |driver|
      driver_lat = driver.values[:latitude]
      driver_long = driver.values[:longitude]
      distance_between(lat, long, driver_lat, driver_long)
    end

    closest_driver.values

  end

  def distance_between(lat1, long1, lat2, long2)
    rad_per_deg = Math::PI / 180
    rm = 6371000

    lat1_rad = lat1.to_f * rad_per_deg
    lat2_rad = lat2.to_f * rad_per_deg
    lon1_rad = long1.to_f * rad_per_deg
    lon2_rad = long2.to_f * rad_per_deg


    a = Math.sin((lat2_rad - lat1_rad) / 2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin((lon2_rad - lon1_rad) / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a))

    rm * c
  end
end
