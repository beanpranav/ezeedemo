$cpi_specs = { 
	0 => {
				:status => "NOT STARTED", 
				:status_message => "Chapter Preparedness Index (CPI) indicates that you are likely to score around 0%",
				:step_score => 0,
				:step_goals => { :smart_goal => 1, :concept_goal => 0, :mcq_goal => 0, :subjectiveq_goal => 0 },
				:step_message => "Our recommended next steps<br> to take your CPI to the next level"
				},
	1 => {
				:status => "JUST BEGUN", 
				:status_message => "Chapter Preparedness Index (CPI) indicates that you are likely to score around 10%",
				:step_score => 10,
				:step_goals => { :smart_goal => 1, :concept_goal => 0.5, :mcq_goal => 0, :subjectiveq_goal => 0 },
				:step_message => "Our recommended next steps to take your CPI to the next level"
				},
	2 => {
				:status => "WEAK", 
				:status_message => "Chapter Preparedness Index (CPI) indicates that you are likely to score around 30%",
				:step_score => 30,
				:step_goals => { :smart_goal => 1, :concept_goal => 1, :mcq_goal => 0.25, :subjectiveq_goal => 0.5 },
				:step_message => "Our recommended next steps to take your CPI to the next level"
				},
	3 => {
				:status => "MODERATE", 
				:status_message => "Chapter Preparedness Index (CPI) indicates that you are likely to score around 50%",
				:step_score => 50,
				:step_goals => { :smart_goal => 1, :concept_goal => 1, :mcq_goal => 0.75, :subjectiveq_goal => 1 },
				:step_message => "Our recommended next steps to take your CPI to the next level"
				},
	4 => {
				:status => "STRONG", 
				:status_message => "Chapter Preparedness Index (CPI) indicates that you are likely to score around 75%",
				:step_score => 75,
				:step_goals => { :smart_goal => 1, :concept_goal => 1, :mcq_goal => 1, :subjectiveq_goal => 1 },
				:step_message => "Our recommended next steps to take your CPI to the next level"
				},
	5 => {
				:status => "JEDI MASTER", 
				:status_message => "Chapter Preparedness Index (CPI) indicates that you are likely to score around 90%",
				:step_score => 90,
				:step_goals => { :smart_goal => 1, :concept_goal => 1, :mcq_goal => 1, :subjectiveq_goal => 1 },
				:step_message => "Our recommended next steps to take your CPI to the next level"
				}
}


$chapter_studied_specs = { 
													:study_weightage => { :overall => 40, :smart => 0.25, :concept => 0.75 }, 
													:assessment_weightage => { :overall => 60 , :mcq => 0.4, :subjectiveq => 0.6 }
												}

$predictive_score_specs = { :study_weightage => 0.6, :assessment_weightage => 0.4 }



