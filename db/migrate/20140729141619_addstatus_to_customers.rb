class AddstatusToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :status, :bool
  end
end
