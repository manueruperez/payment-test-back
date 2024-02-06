require_relative '../../services/payment.service'

$payment_service = PaymentsService.new


class RidersService
    def request_payment_source(params)
      rider_id = params[:rider_id]
      rider = get_rider_by_id(rider_id)
      if rider.nil?
        return { status: 400, body: { success: false, message: "No rider found with id #{rider_id} " } }
      end
      acceptation_token = $payment_service.get_token_acceptation()
      payment_source_token = get_paymentmethod_by_rider_id(rider_id)
      if payment_source_token.nil?
        return { status: 400, body: { success: false, message: "User does not have a valid payment method." } }
      end

      payment_source = $payment_service.create_payment_source(rider[:email], payment_source_token, acceptation_token)

      puts "#{rider[:email]}"
      return { status: 400, body: { success: false, message: "User does not have a valid payment method." } }

    end
    def request_ride(params)
      rider_id = params[:rider_id]
      rider = get_rider_by_id(rider_id)
      if rider.nil?
        return { status: 400, body: { success: false, message: "No rider found with id #{rider_id} " } }
      end
      payment_source_token = get_paymentmethod_by_rider_id(rider_id)
      if payment_source_token.nil?
        return { status: 400, body: { success: false, message: "User does not have a valid payment method." } }
      end
      payment = process_payment(rider[:email], payment_source_token)
      return {
        status: 200,
        body: {
          success: true,
          message: "User does not have a valid payment method.",
          token: payment_source_token
          }
        }
    end
    def get_rider_by_id(rider_id)
      rider = Rider.find_by_id(rider_id)
      rider ? rider.values: nil
    end
    def get_paymentmethod_by_rider_id(rider_id)
      payment_method = PaymentMethod.where(rider_id: rider_id).first
      payment_method ? payment_method.payment_source_token : nil
    end
    def process_payment(rider_email, payment_source_token)
      payment_data_object = $payment_service.get_payment_data_object(rider_email,payment_source_token)
      # if nill do something
      # puts "payment_data_object: #{payment_data_object}"
      payment = $payment_service.request_payment(payment_data_object)
      puts "payment_data_object: #{payment}"
    end
  end

  # def request_ride(params)
  #   rider_id = params['rider_id']
  #   payment_source_token = get_paymentmethod_by_rider_id(rider_id)

  #   if payment_source_token.nil?
  #     return { status: 400, body: { success: false, message: "User does not have a valid payment method." } }
  #   end

  #   # Implementa aquí la lógica para crear el viaje.
  #   # Esto puede incluir verificar la disponibilidad de conductores, crear el registro del viaje, etc.
  #   # Simularemos la creación del viaje para el propósito de este ejemplo.

  #   ride = create_ride(rider_id, params) # Asume que esta función implementa la lógica de negocio necesaria.

  #   if ride
  #     { status: 200, body: { success: true, message: "Ride requested successfully.", ride: ride } }
  #   else
  #     { status: 500, body: { success: false, message: "Failed to request ride." } }
  #   end
  # end

  # private

  # def get_paymentmethod_by_rider_id(rider_id)
  #   payment_method = PaymentMethod.where(rider_id: rider_id).first
  #   payment_method ? payment_method.payment_source_token : nil
  # end

  # def create_ride(rider_id, params)
  #   # Implementa la lógica para crear el viaje aquí.
  #   # Este método debe devolver un hash con la información del viaje o nil si la creación falla.
  #   # Este es un ejemplo simplificado.
  #   { id: 1, driver_assigned: "Driver Name", details: "Ride details" } # Simulación de un viaje creado
  # end
