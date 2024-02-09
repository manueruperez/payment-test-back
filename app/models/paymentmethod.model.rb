class PaymentMethod < Sequel::Model(:payment_methods)
    many_to_one :rider
    def self.payment_method_by_idRider(idRider)
        where(rider_id: idDriver).all
    end
    def self.update_payment_method_source_id(idRider, new_source_id)
        PaymentMethod.where(rider_id: idRider).update(source_id: new_source_id)
    end
end
