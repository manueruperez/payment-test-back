Sequel.migration do
    up do
      create_table(:drivers) do
        primary_key :id
        String :name, null: false
        String :email, unique: true, null: false
        Float :latitude
        Float :longitude
        DateTime :created_at
        DateTime :updated_at
      end
    end
  
    down do
      drop_table(:drivers)
    end
  end