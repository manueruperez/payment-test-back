class Driver < Sequel::Model
    one_to_many :rides
    def self.all_drivers
      self.all
    end
  end
