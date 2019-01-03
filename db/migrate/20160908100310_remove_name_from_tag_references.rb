class RemoveNameFromTagReferences < ActiveRecord::Migration
  def change
    remove_column :tag_references, :name
  end
end
