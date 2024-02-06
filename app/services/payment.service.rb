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
      puts "********************************"
      puts "request: #{response}"
      puts "********************************"

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
  puts "response11: #{payload}"

  response = RestClient.post(url, payload, {
    content_type: :json,
    accept: :json,
    authorization: "Bearer prv_test_SedRXry89OGlKjjsNJNOMdFpechLTWsK"
  })
  response
  end
end
