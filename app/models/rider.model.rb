class Rider < Sequel::Model
    one_to_many :rides
    one_to_many :payment_methods
    def self.all_riders
      self.all
    end
    def self.find_by_id(id)
      self[id]
    end
  end
