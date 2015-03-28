class AddAttachmentImageToAssessmentImages < ActiveRecord::Migration
  def self.up
    change_table :assessment_images do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :assessment_images, :image
  end
end
