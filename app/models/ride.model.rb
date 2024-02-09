class Ride < Sequel::Model
    many_to_one :rider
    many_to_one :driver
    def self.create_ride(ride_attributes)
        Ride.create(ride_attributes)
    end
    def self.rides_in_progress_by_idRider(idDriver)
        where(driver_id: idDriver, status:'in_progress').all
    end
    def self.add_transaction_to_ride(idRide, idTransaction, amount)
      Ride.where(id: idRide).update(transaction_id: idTransaction, total_amount:amount)
    end
    def self.update_ride_status(idRide,status)
        Ride.where(id: idRide).update(status:status)
      end
end
