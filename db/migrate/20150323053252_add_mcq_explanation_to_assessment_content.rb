class AddMcqExplanationToAssessmentContent < ActiveRecord::Migration
  def change
    add_column :assessment_contents, :mcq_explanation, :text

    change_table :assessment_contents do |t|
      t.rename :choice_a, :answer_a
      t.rename :choice_b, :answer_b
      t.rename :choice_c, :answer_c
      t.rename :choice_d, :answer_d
      t.rename :answer, :mcq_answer
      t.rename :next_step, :teacher_name
      t.rename :difficulty_level, :content_type
    end

  end
end
