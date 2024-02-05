Sequel.migration do
    up do
      create_table(:rides) do
        primary_key :id
        foreign_key :rider_id, :riders
        foreign_key :driver_id, :drivers
        Float :start_latitude
        Float :start_longitude
        Float :end_latitude
        Float :end_longitude
        Integer :total_amount # Podría ser calculado al finalizar el viaje
        String :status, default: 'requested' # Opciones: requested, in_progress, completed
        DateTime :start_time
        DateTime :end_time
        DateTime :created_at
        DateTime :updated_at
      end
    end
  
    down do
      drop_table(:rides)
    end
  end
  