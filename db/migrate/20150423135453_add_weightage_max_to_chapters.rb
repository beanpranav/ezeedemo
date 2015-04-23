class AddWeightageMaxToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :weightage_max, :integer

    change_table :chapters do |t|
    	t.rename :weightage, :weightage_min
    end

  end
end
