class AddAdminNotesToStudyMaterial < ActiveRecord::Migration
  def change
    add_column :study_materials, :admin_notes, :text
  end
end
