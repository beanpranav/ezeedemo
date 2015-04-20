class AddPracticeLevelToAssessmentContent < ActiveRecord::Migration
  def change
    add_column :assessment_contents, :practice_level, :string
  end
end
