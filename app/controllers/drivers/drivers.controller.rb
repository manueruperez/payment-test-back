require_relative 'drivers.service'
$drivers_service = DriversService.new
class DriversController
  def self.registered(app)
    app.post '/drivers/finish-rides' do
      result = $drivers_service.finish_ride(json_params)
      status result[:status]
      result[:body].to_json
    end
  end
end
