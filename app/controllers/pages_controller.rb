class PagesController < ApplicationController
  before_action :validate_admin, only: [:user_admin_dashboard]
  before_action :validate_user, only: [:thank_you, :pricing]

  def home
  	if user_signed_in?
	  	@subjects = Subject.where(standard: 10).order('id DESC')
      @user_term_payment = [current_user.term_1_payment, current_user.term_2_payment]

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
    @user_term_payment = [0,0]
  end

  def user_admin_dashboard
  	@users = User.all
  	@today = Time.new.yday

  	free_users = @users.select { |x| x.term_1_payment == 0 and x.term_2_payment == 0 }
  	@free_users = free_users.sort_by { |x| @today - x.last_sign_in_at.yday }
  	
  	@paid_users = @users.select { |x| x.term_1_payment > 0 or x.term_2_payment > 0 }
  end

  def pricing
  end

  def thank_you
    if params[:status] == "success"
      @payment_info = instamojo_read_payment(params[:payment_id])["payment"]
      u = User.find_by(email: @payment_info["buyer_email"])
      u.phone_number = @payment_info["buyer_phone"]
      
      if @payment_info["link_slug"] == "aaaaa"
        u.term_1_payment = 11
        u.term_2_payment = 11
      end
      if @payment_info["link_slug"] == "cbsehacker-term-1-package"
        u.term_1_payment = @payment_info["amount"]
        u.term_2_payment = 0
      end
      if @payment_info["link_slug"] == "cbsehacker-term-2-package"
        u.term_1_payment = 0
        u.term_2_payment = @payment_info["amount"]
      end
      if @payment_info["link_slug"] == "cbsehacker-full-package"
        u.term_1_payment = @payment_info["amount"]/2
        u.term_2_payment = @payment_info["amount"]/2
      end

      u.save
      redirect_to thank_you_path
    else
      @payment_info = {}
    end
  end
end
