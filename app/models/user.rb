class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :name, :phone_number

  has_many :user_study_progresses, dependent: :destroy
  has_many :study_materials, through: :user_study_progresses

  has_many :user_assessment_progresses, dependent: :destroy
  has_many :assessment_contents, through: :user_assessment_progresses

  has_many :user_chapter_progresses, dependent: :destroy
  has_many :chapters, through: :user_chapter_progresses

  def first_name
  	name.split(" ")[0]
  end

  def last_name
  	name.split(" ").last
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

  def subject_weight(term_chapters)
    
    term_weightage_total = 0
    term_chapters.each do |chapter|
      term_weightage_total += (chapter.weightage_min + chapter.weightage_max) / 2
    end
    
    return term_weightage_total
  end


  def predictive_score_calculator(term_chapters, user_term_chapters_cpi, user_term_fa_scores, user_term_sa_scores)

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
    term_weightage_contribution.each { |x| x[1] = (x[1] * $predictive_score_specs[:study_weightage] / term_weightage_total).round(2) }
    term_weightage_contribution = term_weightage_contribution.sort_by { |x| -x[1] }
    term_weightage_priortization.each { |x| x[1] = (x[1] * $predictive_score_specs[:study_weightage] / term_weightage_total).round(2) }
    term_weightage_priortization = term_weightage_priortization.sort_by { |x| -x[1] }

    fa_practiced = 0
    sa_practiced = 0
    if user_term_fa_scores.size > 0
      fa_practiced = user_term_fa_scores.inject(:+).to_f/user_term_fa_scores.size
    end    
    if user_term_sa_scores.size > 0
      sa_practiced = user_term_sa_scores.inject(:+).to_f/user_term_sa_scores.size
    end
    subject_practiced = fa_practiced + sa_practiced

    spi = (subject_studied * $predictive_score_specs[:study_weightage]) + (subject_practiced * $predictive_score_specs[:assessment_weightage])
    
    return { :spi => spi.round(0), :contribution_order => term_weightage_contribution, :priortization_order => term_weightage_priortization }
  end
  
end
