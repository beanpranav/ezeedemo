class StudyMaterial < ActiveRecord::Base
	validates_presence_of :chapter_id, :material_type, :material_no, :name, :next_step, :admin_incharge

	belongs_to :chapter
	belongs_to :video_content
	belongs_to :interactive_content

	has_many :user_study_progresses, dependent: :destroy
  has_many :users, through: :user_study_progresses
end
