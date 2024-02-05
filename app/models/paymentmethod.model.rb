class PaymentMethod < Sequel::Model(:payment_methods)
    many_to_one :rider
    def self.payment_method_by_idRider(idRider)
        where(rider_id: idRider).all
      end
  end
