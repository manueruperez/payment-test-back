require 'net/http'
require 'uri'
require 'rest-client'
require 'json'

class PaymentsService
  def get_payment_data_object(email, card_token, amount=5000,currency='COP', description='description')
    if !email || !card_token
      return nil
    end
    payment_data = {
      amount: amount,
      currency: currency,
      customer_email: email,
      payment_method: {
        type: 'CARD',
        token: card_token
      },
      reference: 'referencia_de_pago',
      description: description
    }
    payment_data
  end

  def request_payment(payment_data)

    uri = URI(ENV['PAYMENT_API_TRANSACTIONS'])
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path)
    request['Authorization'] = "Bearer #{ENV['PAYMENT_PRIVATE_SECRET_KEY']}"
    request['Content-Type'] = 'application/json'
    request.body = payment_data.to_json

    begin
      response = http.request(request)
      if response.code == '200'
        result = JSON.parse(response.body)
        if result['status'] == 'APPROVED'
          return { success: true, message: 'Payment approved' }
        else
          return { success: false, message: "Payment failed. ERROR: #{result['message']}" }
        end
      else
        return { success: false, message: "Error with payment connection. HTTP Error: #{response.code}" }
      end
    rescue StandardError => e
      return { success: false, message: "Error with payment request: #{e.message}" }
    end
  end

  def get_token_acceptation()
    uri = URI("#{ENV['PAYMENT_API_SANDBOX']}/merchants/#{ENV['PAYMENT_PUBLIC_SECRET_KEY']}")
    response = Net::HTTP.get_response(uri)
    response = JSON.parse(response.body)
    acceptance_token = response["data"]["presigned_acceptance"]["acceptance_token"]
    acceptance_token
  end

  def create_payment_source(customer_email,token,acceptance_token)
    url = "https://sandbox.wompi.co/v1/payment_sources"
    payload = {
      type: "CARD",
      token: token,
      acceptance_token: acceptance_token,
      customer_email: customer_email,
    }.to_json

    response = RestClient.post(url, payload, {
      content_type: :json,
      accept: :json,
      authorization: "Bearer prv_test_SedRXry89OGlKjjsNJNOMdFpechLTWsK"
    })

    return JSON.parse(response)
  end

  def calculate_amount(meters_distance, speed_km_h = 40)
    base_rate = 3500
    cost_per_km = 1000
    cost_per_minute = 200

    km_distance = meters_distance / 1000.0

    spended_time_hours = km_distance / speed_km_h
    spended_time_minutes = spended_time_hours * 60

    cost_distance = km_distance * cost_per_km
    cost_time = spended_time_minutes * cost_per_minute

    importe_total = base_rate + cost_distance + cost_time

    return importe_total
  end

  def create_transaction(
    acceptance_token,
    amount_in_cents,
    customer_email,
    token_card,
    payment_source_id,
    reference,
    rider)

    url = "#{ENV['PAYMENT_API_SANDBOX']}/transactions"
    payload = {
      acceptance_token: acceptance_token,
      amount_in_cents: amount_in_cents.round,
      currency: 'COP',
      customer_email: customer_email,
      payment_method: {
        type: "CARD",
        token: token_card,
        installments: 2
      },
      payment_source_id: payment_source_id,
      redirect_url: "https://mitienda.com.co/pago/resultado",
      reference: reference,
      customer_data: {
        phone_number: "573307654321",
        full_name: rider[:name],
        legal_id: "1234567890",
        legal_id_type: "CC"
      },
    }.to_json
    response = RestClient.post(url, payload, {
      content_type: :json,
      accept: :json,
      authorization: "Bearer #{ENV['PAYMENT_PRIVATE_SECRET_KEY']}"
    })
    return JSON.parse(response.body)
  end

  def get_transaction_by_id_transaction(idTransaction)
    url = "#{ENV['PAYMENT_API_SANDBOX']}/transactions/#{idTransaction}"

    begin
      response = RestClient.get(url, {
        accept: :json,
        authorization: "Bearer #{ENV['PAYMENT_PRIVATE_SECRET_KEY']}" # Asume que usas una variable de entorno para tu clave secreta
      })
      transaction = JSON.parse(response.body)
      return transaction
    rescue RestClient::ExceptionWithResponse => e
      # Maneja errores de la petición HTTP, por ejemplo, imprimiendo el código de estado y la respuesta
      puts "HTTP Request Failed with response code #{e.response.code}"
      puts e.response.body
      return nil
    rescue JSON::ParserError => e
      # Maneja errores de parseo JSON
      puts "JSON Parsing Error: #{e.message}"
      return nil
    end
  end

end
