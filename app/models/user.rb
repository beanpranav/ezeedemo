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

  def first_name
  	name.split(" ")[0]
  end

  def last_name
  	name.split(" ").last
  end

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
    
    return (study_weightage_value + assessment_weightage_value).round(0)
  
  end
  
end
