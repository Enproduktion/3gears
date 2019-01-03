class AddTextToMediumTimeTags < ActiveRecord::Migration
  def change
    add_column :medium_time_tags, :text, :text
  end
end
