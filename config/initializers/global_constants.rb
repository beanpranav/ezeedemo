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


$mock_sa_specs = { 
	"science" => {
								:instructions => "<li>All questions are compulsory.</li>
											<li>The question paper comprises of two sections, A and B. You are to attempt both the sections.</li>
											<li>Questions 1 to 3 in section A are one mark questions. These are to be answered in one word or in one sentence.</li>
											<li>Questions 4 to 6 in section A are two marks questions. These are to be answered in about 30 words each.</li>
											<li>Questions 7 to 18 in section A are three marks questions. These are to be answered in about 50 words each.</li>
											<li>Questions 19 to 24 in section A are five marks questions. These are to be answered in about 70 words each.</li>
											<li>Questions 25 to 27 in section B are 2 marks questions and Questions 28 to 36 are multiple choice questions based on practical skills. Each question of multiple choice questions is a one mark question. You are to select one most appropriate response out of the four provided to you.</li>",
								:paper_pattern => {
											"Section A - 1 mark questions" => {:marks => 1, :practical_skills => false, :count => 3, :question_no => 1 },
											"Section A - 2 marks questions" => {:marks => 2, :practical_skills => false, :count => 3, :question_no => 4 },
											"Section A - 3 marks questions" => {:marks => 3, :practical_skills => false, :count => 12, :question_no => 7 },
											"Section A - 5 marks questions" => {:marks => 5, :practical_skills => false, :count => 6, :question_no => 19 },
											"Section B - 2 marks MCQs" => {:marks => 2, :practical_skills => true, :count => 3, :question_no => 25 },
											"Section B - 1 mark MCQs" => {:marks => 1, :practical_skills => true, :count => 19, :question_no => 28 }
							}
	},
	"maths" => {
							:instructions => "<li>All questions are compulsory.</li>
											<li>The question paper comprises of 31 questions divided into four sections A, B, C and D. You are to attempt all the four sections.</li>
											<li>Questions 1 to 4 in section A are one mark questions. These are MCQs. Choose the correct option.</li>
											<li>Questions 5 to 10 in section B are two marks questions.</li>
											<li>Questions 11 to 20 in section C are three marks questions.</li>
											<li>Questions 21 to 31 in section D are four marks questions.</li>
											<li>There is no overall choice in the question paper. Use of calculators is not permitted.</li>",
							:paper_pattern => {
											"Section A - 1 mark MCQs" => {:marks => 1, :practical_skills => false, :count => 4, :question_no => 1 },
											"Section B - 2 marks questions" => {:marks => 2, :practical_skills => false, :count => 6, :question_no => 5 },
											"Section C - 3 marks questions" => {:marks => 3, :practical_skills => false, :count => 10, :question_no => 11 },
											"Section D - 4 marks questions" => {:marks => 4, :practical_skills => false, :count => 11, :question_no => 21 }
							}
	}
}
