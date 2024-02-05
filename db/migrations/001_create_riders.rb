Sequel.migration do
    change do
      create_table(:riders) do
        primary_key :id
        String :name
        String :email
        DateTime :created_at
        DateTime :updated_at
      end
    end
  end
  