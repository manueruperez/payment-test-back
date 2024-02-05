require_relative 'riders.service'

$riders_service = RidersService.new

class RidersController
  def self.registered(app)

    app.get '/riders' do
      riders = $riders_service.get_all_riders
      content_type :json
      riders
    end

    app.post '/riders/request-ride' do
      result = $riders_service.request_ride(json_params)
      status result[:status]
      result[:body].to_json
    end
  end
 end
