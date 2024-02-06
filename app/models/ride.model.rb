class Ride < Sequel::Model
    many_to_one :rider
    many_to_one :driver
    def self.create_ride(ride_attributes)
        Ride.create(ride_attributes)
    end
end
