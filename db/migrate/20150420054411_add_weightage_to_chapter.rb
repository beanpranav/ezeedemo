class AddWeightageToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :weightage, :integer
  end
end
