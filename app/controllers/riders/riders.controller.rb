require_relative 'riders.service'

$riders_service = RidersService.new

class RidersController
  def self.registered(app)
    app.post '/riders/payment-method' do
      result = $riders_service.request_payment_source(json_params)
      status result[:status]
      result[:body].to_json
    end

    app.post '/riders/request-ride' do
      result = $riders_service.request_ride(json_params)
      status result[:status]
      result[:body].to_json
    end
  end
 end
