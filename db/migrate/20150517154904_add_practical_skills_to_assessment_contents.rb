class AddPracticalSkillsToAssessmentContents < ActiveRecord::Migration
  def change
    add_column :assessment_contents, :practical_skills, :boolean, default: false
    add_column :assessment_contents, :marks, :integer
  end
end
