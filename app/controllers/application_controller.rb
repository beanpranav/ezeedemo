class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  ensure_security_headers :hsts => {:max_age => 631138519, :include_subdomain => true},
                          :x_frame_options  => {:value => 'SAMEORIGIN'},
                          :x_content_type_options => {:value => "nosniff"},
                          :x_xss_protection => {:value => 1, :mode => 'block'},
                          :csp => false

  before_filter :configure_permitted_parameters, if: :devise_controller?

  helper_method :instamojo_read_payment, :validate_admin, :cpi_calculator, :chapter_studied, :subject_studied, :predictive_score_calculator, :term_weight

  def user_status_update
    u = User.find(params[:user_id].index(""))
    u.status = params[:status]
    u.save
    redirect_to :back
  end

  protected

  # for allowing :name as a strong parameter while signup and account update.
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :email, :password, :phone_number, :role, :status)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :email, :password, :phone_number, :role, :status, :current_password, :term_1_payment, :term_2_payment)
    end
  end

  def instamojo_read_payment(payment_id)
    require 'open-uri'
    JSON.parse open("https://www.instamojo.com/api/1.1/payments/#{payment_id}/", "X-API-KEY" => ENV['INSTAMOJO_KEY'], "X-Auth-Token" => ENV['INSTAMOJO_TOKEN']).read
  end

  def instamojo_read_link(link_slug)
    require 'open-uri'
    JSON.parse open("https://www.instamojo.com/api/1.1/links/#{link_slug}/", "X-API-KEY" => ENV['INSTAMOJO_KEY'], "X-Auth-Token" => ENV['INSTAMOJO_TOKEN']).read
  end

  # def current_subdomain
  #   @current_subdomain = request.subdomains.first
  # end

  # validation
  def validate_admin
    if user_signed_in?
      unless current_user.role == "Admin"
        flash[:notice] = '<b>Sorry!</b> You need administrative access.'.html_safe
        redirect_to root_path
      end
    else
      flash[:notice] = '<b>Sorry!</b> You need administrative access.'.html_safe
      redirect_to root_path
    end
  end

  def validate_user
    unless user_signed_in?
      flash[:notice] = '<b>Sorry!</b> You need to be logged-in to access this page.'.html_safe
      redirect_to root_path
    end
  end

  # Chapter Calucations
  def cpi_calculator(smart_progress_ratio, concept_progress_ratio, mcq_progress_ratio, subjectiveq_progress_ratio)

    if smart_progress_ratio == $cpi_specs[0][:step_goals][:smart_goal]
      # just begun
      if (concept_progress_ratio >= $cpi_specs[1][:step_goals][:concept_goal]) or (mcq_progress_ratio >= $cpi_specs[2][:step_goals][:mcq_goal] and subjectiveq_progress_ratio >= $cpi_specs[2][:step_goals][:subjectiveq_goal])
        # weak
        if (concept_progress_ratio == $cpi_specs[2][:step_goals][:concept_goal] and mcq_progress_ratio >= $cpi_specs[2][:step_goals][:mcq_goal] and subjectiveq_progress_ratio >= $cpi_specs[2][:step_goals][:subjectiveq_goal]) or (concept_progress_ratio >= $cpi_specs[1][:step_goals][:concept_goal] and mcq_progress_ratio >= $cpi_specs[3][:step_goals][:mcq_goal] and subjectiveq_progress_ratio >= $cpi_specs[3][:step_goals][:subjectiveq_goal])
          # moderate
          if (concept_progress_ratio == $cpi_specs[3][:step_goals][:concept_goal] and mcq_progress_ratio >= $cpi_specs[3][:step_goals][:mcq_goal] and subjectiveq_progress_ratio >= $cpi_specs[3][:step_goals][:subjectiveq_goal])
            # strong
            if mcq_progress_ratio == $cpi_specs[4][:step_goals][:mcq_goal]
              # jedi
              cpi_level = 5
            else
              cpi_level = 4
            end
          else
            cpi_level = 3
          end
        else
          cpi_level = 2
        end
      else
        cpi_level = 1
      end
    else
      cpi_level = 0
    end

    return cpi_level
  end


  def chapter_studied(smart_progress_ratio, concept_progress_ratio, mcq_studied_ratio, subjectiveq_progress_ratio)

    study_weightage_value = (smart_progress_ratio * $chapter_studied_specs[:study_weightage][:smart] + concept_progress_ratio * $chapter_studied_specs[:study_weightage][:concept]) * $chapter_studied_specs[:study_weightage][:overall] 
    assessment_weightage_value = (mcq_studied_ratio * $chapter_studied_specs[:assessment_weightage][:mcq] + subjectiveq_progress_ratio * $chapter_studied_specs[:assessment_weightage][:subjectiveq]) * $chapter_studied_specs[:assessment_weightage][:overall]
    
    unless (study_weightage_value + assessment_weightage_value).nan?
      return (study_weightage_value + assessment_weightage_value).round(0)
    end
  
  end


  # Subject Calculations
  def subject_studied(term_chapters, user_term_chapters_studied)

    term_weightage_total = 0
    user_term_weightage = 0

    term_chapters.each do |chapter|
      average_chapter_weightage = (chapter.weightage_min + chapter.weightage_max) / 2
      term_weightage_total += average_chapter_weightage      
      user_progress = user_term_chapters_studied.select { |x| x["chapter_id"] == chapter.id }
      if user_progress[0] != nil
        chapter_studied = user_progress[0].chapter_studied
        user_term_weightage += chapter_studied * average_chapter_weightage if chapter_studied != nil
      end 
    end

    return user_term_weightage/term_weightage_total
  end



  def predictive_score_calculator(term_chapters, user_term_chapters_cpi, user_term_fas, user_term_sas)

    term_weightage_total = 0
    user_term_weightage = 0
    term_weightage_contribution = []
    term_weightage_priortization = []

    term_chapters.sort_by(&:chapterNumber).each do |chapter|
      
      average_chapter_weightage = (chapter.weightage_min + chapter.weightage_max) / 2
      term_weightage_total += average_chapter_weightage      
      user_progress = user_term_chapters_cpi.select { |x| x["chapter_id"] == chapter.id }
      
      if user_progress[0] != nil
        chapter_cpi = $cpi_specs[user_progress[0].cpi_level][:step_score] 
        chapter_cpi_max = $cpi_specs[4][:step_score] 
        if chapter_cpi == nil
          term_weightage_contribution << [chapter.id, 0 * average_chapter_weightage]
          term_weightage_priortization << [chapter.id, chapter_cpi_max * average_chapter_weightage]
        else
          user_term_weightage += chapter_cpi * average_chapter_weightage 
          term_weightage_contribution << [chapter.id, (chapter_cpi) * average_chapter_weightage]
          term_weightage_priortization << [chapter.id, (chapter_cpi_max - chapter_cpi) * average_chapter_weightage]
        end
      end 

    end

    subject_studied = user_term_weightage/term_weightage_total
    term_weightage_contribution.each { |x| x[1] = (x[1] * $predictive_score_specs[user_term_sas.count][:study_weightage] / term_weightage_total).round(2) }
    term_weightage_contribution = term_weightage_contribution.sort_by { |x| -x[1] }
    term_weightage_priortization.each { |x| x[1] = (x[1] * $predictive_score_specs[user_term_sas.count][:study_weightage] / term_weightage_total).round(2) }
    term_weightage_priortization = term_weightage_priortization.sort_by { |x| -x[1] }

    fa_practiced = 0
    if user_term_fas.count > 0
      user_term_fas.each do |fa|
        fa_practiced += fa.score if fa.score >= 0
      end
      fa_practiced = fa_practiced.to_f/user_term_fas.count
    end 
    fa_score = fa_practiced*100/15

    sa_practiced = 0
    if user_term_sas.count > 0
      user_term_sas.each do |sa|
        sa_practiced += sa.score if sa.score >= 0
      end
      sa_practiced = sa_practiced.to_f/user_term_sas.count
    end 
    sa_score = sa_practiced*100/90

    spi = (subject_studied * $predictive_score_specs[user_term_sas.count][:study_weightage]) + (fa_score * $predictive_score_specs[user_term_sas.count][:fa_weightage]) + (sa_score * $predictive_score_specs[user_term_sas.count][:sa_weightage])
    
    return { :spi => spi.round(0), :contribution_order => term_weightage_contribution, :priortization_order => term_weightage_priortization, :fa_average => fa_practiced.round(1), :sa_average => sa_practiced.round(1) }
  end


  def term_weight(term_chapters)
    term_weight = 0
    term_chapters.each do |chapter|
      min = chapter.weightage_min
      max = chapter.weightage_max
      if min == nil
        min = 0
        max = 0
      end
      term_weight += (chapter.weightage_min + chapter.weightage_max) / 2
    end

    return term_weight
  end
end