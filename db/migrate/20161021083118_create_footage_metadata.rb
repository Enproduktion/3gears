class CreateFootageMetadata < ActiveRecord::Migration
  def change
    create_table :footage_metadata do |t|
      t.references :footage
      t.string :country

      t.timestamps null: false
    end
  end
end
