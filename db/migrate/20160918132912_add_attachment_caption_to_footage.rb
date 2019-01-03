class AddAttachmentCaptionToFootage < ActiveRecord::Migration
  def self.up
    change_table :footage do |t|
      t.attachment :caption
    end
  end

  def self.down
    remove_attachment :footage, :caption
  end
end
