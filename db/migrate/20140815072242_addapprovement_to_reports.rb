class AddapprovementToReports < ActiveRecord::Migration
  def change
    add_column :reports, :approvement, :integer
  end
end
