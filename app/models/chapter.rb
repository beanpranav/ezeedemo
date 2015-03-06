class Chapter < ActiveRecord::Base
	validates_presence_of :name, :chapterNumber, :subject_id

	extend FriendlyId
  friendly_id :name, use: :slugged

  def should_generate_new_friendly_id?
  	name_changed?
  end

  belongs_to :subject
end
