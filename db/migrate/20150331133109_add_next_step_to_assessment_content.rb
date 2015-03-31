class AddNextStepToAssessmentContent < ActiveRecord::Migration
  def change
    add_column :assessment_contents, :next_step, :string
  end
end
