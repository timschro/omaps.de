class AddDisciplineToMap < ActiveRecord::Migration[5.2]
  def change
    create_table(:disciplines) do |t|
      t.string :name
      t.string :short_name

      t.timestamps
    end
    add_column :maps, :discipline_id, :integer
  end
end
