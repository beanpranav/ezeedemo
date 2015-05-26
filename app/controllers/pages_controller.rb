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
    if Rails.env == 'development'
      @payment_term_1 = 2000.00
      @payment_term_2 = 2000.00
      @payment_full = 3000.00
    else
      @payment_term_1 = instamojo_read_link("cbsehacker-term-1-package")["link"]["base_price"]
      @payment_term_2 = instamojo_read_link("cbsehacker-term-2-package")["link"]["base_price"]
      @payment_full = instamojo_read_link("cbsehacker-full-package")["link"]["base_price"]
      
    end

    @science = Subject.find_by(standard: 10, name: "Science")
    @maths = Subject.find_by(standard: 10, name: "Maths")

    @science_chapters = @science.chapters
    @science_free = @science_chapters.select { |x| x.status == "Free" }
    @science_term_1 = @science_chapters.select { |x| x.term == 1 }
    @science_term_2 = @science_chapters.select { |x| x.term == 2 }

    @science_study_material = 0
    @science_assessments = 0
    @science_chapters.each do |chapter|
      @science_study_material += chapter.study_materials.count
      @concept_materials = chapter.study_materials.select { |x| x["material_type"] == "Quick Concepts" }
      @concept_materials.each do |material| 
        if material.video_content != nil && material.video_content.assessment_contents != nil
          @science_assessments += material.video_content.assessment_contents.count
        end
      end
    end

    @science_free_study_material = 0
    @science_free_assessments = 0
    @science_free.each do |chapter|
      @science_free_study_material += chapter.study_materials.count
      @concept_materials.each do |material| 
        if material.video_content != nil && material.video_content.assessment_contents != nil
          @science_free_assessments += material.video_content.assessment_contents.count
        end
      end
    end

    @science_term_1_study_material = 0
    @science_term_1_assessments = 0
    @science_term_1.each do |chapter|
      @science_term_1_study_material += chapter.study_materials.count
      @concept_materials.each do |material| 
        if material.video_content != nil && material.video_content.assessment_contents != nil
          @science_term_1_assessments += material.video_content.assessment_contents.count
        end
      end
    end

    @science_term_2_study_material = 0
    @science_term_2_assessments = 0
    @science_term_2.each do |chapter|
      @science_term_2_study_material += chapter.study_materials.count
      @concept_materials.each do |material| 
        if material.video_content != nil && material.video_content.assessment_contents != nil
          @science_term_2_assessments += material.video_content.assessment_contents.count
        end
      end
    end

    @maths_chapters = @maths.chapters
    @maths_free = @maths_chapters.select { |x| x.status == "Free" }
    @maths_term_1 = @maths_chapters.select { |x| x.term == 1 }
    @maths_term_2 = @maths_chapters.select { |x| x.term == 2 }

    @maths_study_material = 0
    @maths_assessments = 0
    @maths_chapters.each do |chapter|
      @maths_study_material += chapter.study_materials.count
      @concept_materials = chapter.study_materials.select { |x| x["material_type"] == "Quick Concepts" }
      @concept_materials.each do |material| 
        if material.video_content != nil && material.video_content.assessment_contents != nil
          @maths_assessments += material.video_content.assessment_contents.count
        end
      end
    end

    @maths_free_study_material = 0
    @maths_free_assessments = 0
    @maths_free.each do |chapter|
      @maths_free_study_material += chapter.study_materials.count
      @concept_materials = chapter.study_materials.select { |x| x["material_type"] == "Quick Concepts" }
      @concept_materials.each do |material| 
        if material.video_content != nil && material.video_content.assessment_contents != nil
          @maths_free_assessments += material.video_content.assessment_contents.count
        end
      end
    end

    @maths_term_1_study_material = 0
    @maths_term_1_assessments = 0
    @maths_term_1.each do |chapter|
      @maths_term_1_study_material += chapter.study_materials.count
      @concept_materials = chapter.study_materials.select { |x| x["material_type"] == "Quick Concepts" }
      @concept_materials.each do |material| 
        if material.video_content != nil && material.video_content.assessment_contents != nil
          @maths_term_1_assessments += material.video_content.assessment_contents.count
        end
      end
    end

    @maths_term_2_study_material = 0
    @maths_term_2_assessments = 0
    @maths_term_2.each do |chapter|
      @maths_term_2_study_material += chapter.study_materials.count
      @concept_materials = chapter.study_materials.select { |x| x["material_type"] == "Quick Concepts" }
      @concept_materials.each do |material| 
        if material.video_content != nil && material.video_content.assessment_contents != nil
          @maths_term_2_assessments += material.video_content.assessment_contents.count
        end
      end
    end

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
