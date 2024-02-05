class DriversController
  def self.registered(app)
    app.post '/drivers/finish-rides' do
      # Descripción: Finaliza un viaje dado su ID y la ubicación final, calcula el costo total y crea una transacción en Wompi.

      # Datos requeridos en la solicitud: ride_id, final_location (latitud, longitud).

      # Validaciones: Confirmar que el ride_id es válido, el viaje no haya sido finalizado previamente, y que el driver_id corresponda al conductor del viaje.
      
      # Respuesta esperada: Confirmación de viaje finalizado y detalles del costo total.
    end
  end
end