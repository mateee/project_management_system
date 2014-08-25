class CreateOneTasks < ActiveRecord::Migration
  def change
    create_table :one_tasks do |t|
      t.uuid :guid
      t.string :wbs_code, :limit => 150
      t.string :task_name
      t.string :supply_name
      t.integer :work
      t.date :start_at
      t.date :end_at
      t.integer :duration_day
      t.boolean :milestone
      t.string :wbs_code_child, :limit => 150
      t.string :wbs_code_parent, :limit => 150
      t.integer :objects
      t.integer :parents
      t.integer :priority
      t.boolean :joined_field
      t.boolean :congestion
      t.text :work_plan
      t.boolean :managed_by_effort
      t.boolean :hide_bar
      t.text :source_group
      t.string :state, :limit => 50
      t.decimal :sv
      t.float :spi
      t.boolean :equal_can_split_task
      t.boolean :equal_assign
      t.text :accent_source
      t.text :text1
      t.string :owner_assign, :limit => 255
      t.string :source_type, :limit => 100
      t.string :type_t, :limit => 50
      t.boolean :assignment
      t.text :source_names
      t.references :task, index: true

      t.timestamps
    end
  end
end
