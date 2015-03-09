class AddMaterialTypeToStudyMaterial < ActiveRecord::Migration
  def change
    add_column :study_materials, :material_type, :string
  end
end
