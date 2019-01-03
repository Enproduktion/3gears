class AddTagRefToTagReference < ActiveRecord::Migration
  def change
    add_reference :tag_references, :tag, index: true, foreign_key: true
  end
end
