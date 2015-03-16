class StudyMaterial < ActiveRecord::Base
	validates_presence_of :chapter_id, :material_type, :material_no, :name, :next_step, :admin_incharge

	belongs_to :chapter
end
