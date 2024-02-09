
class RidesService
  def create_ride (rider, driver, start_location, end_location)
    ride_data ={
      rider_id:rider[:id],
      driver_id: driver[:id],
      start_latitude:start_location[:lat],
      start_longitude:start_location[:long],
      end_latitude:end_location[:lat],
      end_longitude:end_location[:long],
      status: 'in_progress'
    }
    ride_response = Ride.create_ride(ride_data)
    ride_response.values
  end
end
