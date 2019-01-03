class AddFieldsToMetadata < ActiveRecord::Migration
  def change
    add_column :footage_metadata, :cast, :text # comma seperated list of names
    add_column :footage_metadata, :original_format, :text
    add_column :footage_metadata, :original_length, :text # in foot
    add_column :footage_metadata, :original_language, :text
    add_column :footage_metadata, :year_of_reference, :integer
    add_column :footage_metadata, :genre, :text
    add_column :footage_metadata, :citations, :text # comma seperated list of links
    add_column :footage_metadata, :source, :text
  end
end
