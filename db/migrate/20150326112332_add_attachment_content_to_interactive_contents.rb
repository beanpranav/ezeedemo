class AddAttachmentContentToInteractiveContents < ActiveRecord::Migration
  def self.up
    change_table :interactive_contents do |t|
      t.attachment :content
    end
  end

  def self.down
    remove_attachment :interactive_contents, :content
  end
end
