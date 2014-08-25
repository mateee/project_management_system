class AddspecialToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :special, :string, :limit => 20
  end
end
