require_relative 'riders/riders.controller'
require_relative 'drivers/drivers.controller'

module InitControllers
    def self.registered(app)
      RidersController.registered(app)
      DriversController.registered(app)
    end
  end