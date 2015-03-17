class AddAttachmentContentToVideoContents < ActiveRecord::Migration
  def self.up
    change_table :video_contents do |t|
      t.attachment :content
    end
  end

  def self.down
    remove_attachment :video_contents, :content
  end
end
