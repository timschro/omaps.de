class AddGoogleMapsToRailsAdmin < ActiveRecord::Migration[5.2]
  def change
    add_column :maps, :google_map, :text
  end
end
