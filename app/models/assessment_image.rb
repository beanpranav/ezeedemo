class AssessmentImage < ActiveRecord::Base
	
	has_attached_file :image, :styles => { :original => "400x400>" }
	validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

	validates_presence_of :assessment_content_id, :image_type, :image

	belongs_to :assessment_content
end
