class AssessmentContent < ActiveRecord::Base
	validates_presence_of :video_content_id, :content_type, :question, :answer_a, :teacher_name, :next_step

	belongs_to :video_content
	
	has_many :assessment_images, dependent: :destroy
	accepts_nested_attributes_for :assessment_images, allow_destroy: true
end
