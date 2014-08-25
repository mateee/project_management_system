class AddstatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :status, :bool
  end
end
