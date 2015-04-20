class Chapter < ActiveRecord::Base
	validates_presence_of :name, :chapterNumber, :subject_id, :term, :weightage

	extend FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
  	name_changed?
  end

  belongs_to :subject
  has_many :study_materials, dependent: :destroy
end
