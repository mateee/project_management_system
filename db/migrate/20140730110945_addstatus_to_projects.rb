class AddstatusToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :status, :bool
  end
end
