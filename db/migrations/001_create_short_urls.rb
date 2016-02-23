Sequel.migration do
  up do
    create_table(:short_urls) do
      primary_key :id
      String    :url, null: false
      String    :shortcode, null: false, unique: true
      Integer   :redirect_count, default: 0

      DateTime  :created_at,  null: false
      DateTime  :updated_at,  null: false

      index [:shortcode]
    end
  end

  down do
  end
end