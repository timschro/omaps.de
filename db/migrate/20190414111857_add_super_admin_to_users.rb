class AddSuperAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_superadmin, :boolean
  end
end
