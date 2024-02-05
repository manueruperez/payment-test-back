require 'net/http'
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
end
