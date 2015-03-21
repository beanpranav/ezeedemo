class AddContentToVideoContent < ActiveRecord::Migration
  def change
    add_column :video_contents, :content, :text
  end
end
