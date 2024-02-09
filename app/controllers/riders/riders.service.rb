require_relative '../../services/payment.service'
require_relative '../../services/rides.service'
require_relative '../drivers/drivers.service'

$payment_service = PaymentsService.new
$drivers_service = DriversService.new
$rides_service = RidesService.new


class RidersService

    def request_payment_source(params)
      rider_id = params[:rider_id]
      rider = get_rider_by_id(rider_id)
      if rider.nil?
        return { status: 400, body: { success: false, message: "No rider found with id #{rider_id} " } }
      end
      acceptation_token = $payment_service.get_token_acceptation()
      payment_source_token = get_paymentmethod_token_by_rider_id(rider_id)
      if payment_source_token.nil?
        return { status: 400, body: { success: false, message: "User does not have a valid payment method." } }
      end

      payment_source = $payment_service.create_payment_source(rider[:email], payment_source_token, acceptation_token)
      source_id = payment_source['data']['id']
      response = PaymentMethod.update_payment_method_source_id(rider_id, source_id)

      return { status: 200, body: { success: false, message: "User does not have a valid payment method.", response:  response} }
    end

    def request_ride(params)
      rider_id = params[:rider_id]
      lat = params[:curent_location][:lat]
      long = params[:curent_location][:long]
      rider = get_rider_by_id(rider_id)

      if rider.nil?
        return { status: 400, body: { success: false, message: "No rider found with id #{rider_id} " } }
      end

      driver_assigned = $drivers_service.get_driver_for_rider(lat,long)

      if driver_assigned.nil?
        return { status: 400, body: { success: false, message: "No driver founded" } }
      end

      payment_source_token = get_paymentmethod_token_by_rider_id(rider_id)
      if payment_source_token.nil?
        return { status: 400, body: { success: false, message: "User does not have a valid payment method." } }
      end

      ride = $rides_service.create_ride(rider, driver_assigned, params[:curent_location], params[:finall_location])

      return {
        status: 200,
        body: {
            success: true,
            message: "Your ride was created.",
            driver_info: {
              name: driver_assigned[:name],
              email: driver_assigned[:email]
            }
          }
        }
    end

    def get_rider_by_id(rider_id)
      rider = Rider.find_by_id(rider_id)
      rider ? rider.values: nil
    end

    def get_paymentmethod_token_by_rider_id(rider_id)
      payment_method = PaymentMethod.where(rider_id: rider_id).first
      payment_method ? payment_method.payment_source_token : nil
    end

    def get_paymentmethod_by_rider_id(rider_id)
      payment_method = PaymentMethod.where(rider_id: rider_id).first
      payment_method ? payment_method : nil
    end
  end
