class AssessmentContent < ActiveRecord::Base
	validates_presence_of :video_content_id, :content_type, :question, :answer_a, :teacher_name
	
	belongs_to :video_content
end
