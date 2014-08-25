class AddTimestampsToReports < ActiveRecord::Migration
  def change
    add_timestamps(:reports)
  end
end