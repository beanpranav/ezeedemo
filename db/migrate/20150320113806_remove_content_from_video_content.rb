class RemoveContentFromVideoContent < ActiveRecord::Migration
	def self.up
    remove_attachment :video_contents, :content
  end
 
  def self.down
    add_attachment :video_contents, :content
  end
end
