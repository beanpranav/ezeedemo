class StudyMaterial < ActiveRecord::Base
	validates_presence_of :name, :video_source, :video_duration, :chapter_id

	belongs_to :chapter
end
