class ChangeVideoSourceToNextStep < ActiveRecord::Migration
  
  def change
  	change_table :study_materials do |t|
      t.rename :video_source, :next_step
      t.rename :model_source, :admin_incharge
      t.rename :video_duration, :material_no
    end

    add_column :study_materials, :video_content_id, :integer
    add_column :study_materials, :interactive_content_id, :integer

    change_column :study_materials, :next_step, :string
    change_column :study_materials, :admin_incharge, :string

  end

end
