class CreateMediumTimeTags < ActiveRecord::Migration
  def change
    create_table :medium_time_tags do |t|
      t.references :medium, index: true, foreign_key: true
      t.references :tag, index: true, foreign_key: true
      t.integer :start_time
      t.integer :end_time

      t.timestamps null: false
    end
  end
end
