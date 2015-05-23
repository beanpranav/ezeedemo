class PagesController < ApplicationController

  def home
  	if user_signed_in?
	  	@subjects = Subject.where(standard: 10).order('id DESC')

	  	@user_chapter_progresses = UserChapterProgress.where(user_id: current_user.id)
	  	@subjects.each do |subject|
	  		subject.chapters.each do |chapter|
			  	
			  	chapter_progress = @user_chapter_progresses.find { |x| x.chapter_id == chapter.id }
			  	if (chapter_progress == nil)
			  	  chapter_progress = UserChapterProgress.new user_id: current_user.id, chapter_id: chapter.id, cpi_level: 0, chapter_studied: 0
			  	  chapter_progress.save
			  	end

			  end
			end
	  end
  end

  def common_dashboard
  	@subjects = Subject.where(standard: 10).order('id DESC')
  end

  def user_admin_dashboard
  	@users = User.all
  	@today = Time.new.yday

  	free_users = @users.select { |x| x.term_1_payment == 0 and x.term_2_payment == 0 }
  	@free_users = free_users.sort_by { |x| @today - x.last_sign_in_at.yday }
  	
  	@paid_users = @users.select { |x| x.term_1_payment > 0 or x.term_2_payment > 0 }
  	
  end
end
