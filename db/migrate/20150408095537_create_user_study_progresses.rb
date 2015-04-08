class CreateUserStudyProgresses < ActiveRecord::Migration
  def change
    create_table :user_study_progresses do |t|
      t.integer :user_id
      t.integer :study_material_id
      t.string :rating

      t.timestamps
    end
    add_index :user_study_progresses, :user_id
  end
end
