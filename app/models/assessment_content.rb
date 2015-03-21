class AssessmentContent < ActiveRecord::Base
	validates_presence_of :video_content_id, :question, :choice_a, :choice_b, :choice_c, :choice_d, :answer, :difficulty_level, :next_step
	
	belongs_to :video_content
end
