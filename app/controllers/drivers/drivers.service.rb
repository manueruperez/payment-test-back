require_relative '../riders/riders.service.rb'

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
    # distance in meters
    rm * c
  end

  def finish_ride(params)
    driver_id = params[:driver_id]
    rides_in_progress = Ride.rides_in_progress_by_idRider(driver_id)
    rider = $riders_service.get_rider_by_id(rides_in_progress[0].values[:rider_id])
    payment_data = $riders_service.get_paymentmethod_by_rider_id(rides_in_progress[0].values[:rider_id])

    acceptation_token = $payment_service.get_token_acceptation()

    distance_between = distance_between(
      rides_in_progress[0].values[:start_latitude],
      rides_in_progress[0].values[:start_longitude],
      rides_in_progress[0].values[:end_latitude],
      rides_in_progress[0].values[:end_longitude])
    amount = $payment_service.calculate_amount(distance_between)

    transaction = $payment_service.create_transaction(
        acceptation_token,
        amount,
        rider[:email],
        payment_data.values[:payment_source_token],
        payment_data.values[:source_id],
        "ride-#{Time.now.strftime("%Y%m%d%H%M%S")}",
        rider
      )

    Ride.add_transaction_to_ride(
      rides_in_progress[0].values[:id],
      transaction["data"]["id"],
      amount
      )
    sleep 2
    transaction_status = $payment_service.get_transaction_by_id_transaction(transaction["data"]["id"])

    Ride.update_ride_status(
      rides_in_progress[0].values[:id],
      transaction_status['data']['status'] === 'APPROVED'? 'payed': 'pending_confirmation'
      )

    puts "transaction #{transaction_status['data']['status']}"
    return { status: 200,
             body: {
                success: true,
                message: "ride finished",
                transacrion: transaction_status['data']['status']
              }
          }
  end
end
