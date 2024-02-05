class Ride < Sequel::Model
    many_to_one :rider
    many_to_one :driver
    
end