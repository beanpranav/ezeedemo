class InteractiveContent < ActiveRecord::Base

	has_attached_file :content
  do_not_validate_attachment_file_type :content

	validates_presence_of :content_type, :content, :name, :production_date, :producer_name

	has_many :study_materials
end
