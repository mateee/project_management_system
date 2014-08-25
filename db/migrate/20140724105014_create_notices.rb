class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.text :message
      t.references :doer, index: true
      t.references :target, index: true

      t.timestamps
    end
  end
end
