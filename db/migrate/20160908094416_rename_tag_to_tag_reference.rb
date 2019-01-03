class RenameTagToTagReference < ActiveRecord::Migration
  def change
    rename_table :tags, :tag_references
  end
end
