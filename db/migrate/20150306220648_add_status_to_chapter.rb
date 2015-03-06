class AddStatusToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :status, :string
  end
end
