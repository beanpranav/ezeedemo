class StudyMaterial < ActiveRecord::Base
	validates_presence_of :material_type, :name, :video_source, :chapter_id

	belongs_to :chapter
end
