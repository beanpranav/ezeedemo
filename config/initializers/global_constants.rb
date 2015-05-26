$cpi_specs = { 
    0 => {
                :status => "NOT STARTED", 
                :status_message => "Chapter Preparedness Index (CPI) indicates that you still have to start the chapter",
                :step_score => 0,
                :step_goals => { :smart_goal => 1, :concept_goal => 0, :mcq_goal => 0, :subjectiveq_goal => 0 },
                :step_message => "Our recommended next step is to start with Visual Notes for this chapter to get an overview"
                },
    1 => {
                :status => "JUST BEGUN", 
                :status_message => "Chapter Preparedness Index (CPI) indicates that you have started learning this chapter, good job!",
                :step_score => 10,
                :step_goals => { :smart_goal => 1, :concept_goal => 0.5, :mcq_goal => 0, :subjectiveq_goal => 0 },
                :step_message => "Our recommended next steps you can focus on going through concept videos"
                },
    2 => {
                :status => "WEAK", 
                :status_message => "Chapter Preparedness Index (CPI) indicates that you are likely to score atleast 30%, keep moving!",
                :step_score => 30,
                :step_goals => { :smart_goal => 1, :concept_goal => 1, :mcq_goal => 0.25, :subjectiveq_goal => 0.5 },
                :step_message => "Our recommended next steps to take your CPI to the next level is to complete the concept videos and start with the Q&A prep"
                },
    3 => {
                :status => "MODERATE", 
                :status_message => "Chapter Preparedness Index (CPI) indicates that you are likely to score around 50%, keep moving!",
                :step_score => 50,
                :step_goals => { :smart_goal => 1, :concept_goal => 1, :mcq_goal => 0.75, :subjectiveq_goal => 1 },
                :step_message => "Our recommended next steps is to focus on improving MCQ score and become Strong in this chapter "
                },
    4 => {
                :status => "STRONG", 
                :status_message => "Chapter Preparedness Index (CPI) indicates that you are likely to score around 75%, well prepared!",
                :step_score => 75,
                :step_goals => { :smart_goal => 1, :concept_goal => 1, :mcq_goal => 1, :subjectiveq_goal => 1 },
                :step_message => "Our recommended next steps is to improve your exam preparedness by taking Mock FAs and Mock SAs"
                },
    5 => {
                :status => "JEDI MASTER", 
                :status_message => "Chapter Preparedness Index (CPI) indicates that you have prepared this chapter to almost perfection and likely to score around 90%",
                :step_score => 90,
                :step_goals => { :smart_goal => 1, :concept_goal => 1, :mcq_goal => 1, :subjectiveq_goal => 1 },
                :step_message => "Next steps? Are you kidding me - You are the Jedi Master!"
                }
}


$chapter_studied_specs = { 
													:study_weightage => { :overall => 40, :smart => 0.25, :concept => 0.75 }, 
													:assessment_weightage => { :overall => 60 , :mcq => 0.4, :subjectiveq => 0.6 }
												}

$predictive_score_specs = { 
														0 => { :study_weightage => 0.6, :fa_weightage => 0.1, :sa_weightage => 0.3 },
														1 => { :study_weightage => 0.5, :fa_weightage => 0.1, :sa_weightage => 0.4 },
														2 => { :study_weightage => 0.4, :fa_weightage => 0.1, :sa_weightage => 0.5 },
														3 => { :study_weightage => 0.3, :fa_weightage => 0.1, :sa_weightage => 0.6 },
														4 => { :study_weightage => 0.2, :fa_weightage => 0.1, :sa_weightage => 0.7 }
													}


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
											"Section A - 1 mark each" => {:marks => 1, :practical_skills => false, :count => 3, :question_no => 1 },
											"Section A - 2 marks each" => {:marks => 2, :practical_skills => false, :count => 3, :question_no => 4 },
											"Section A - 3 marks each" => {:marks => 3, :practical_skills => false, :count => 12, :question_no => 7 },
											"Section A - 5 marks each" => {:marks => 5, :practical_skills => false, :count => 6, :question_no => 19 },
											"Section B - 2 marks each" => {:marks => 2, :practical_skills => true, :count => 3, :question_no => 25 },
											"Section B - 1 mark each" => {:marks => 1, :practical_skills => true, :count => 19, :question_no => 28 }
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
											"Section A - 1 mark each" => {:marks => 1, :practical_skills => false, :count => 4, :question_no => 1 },
											"Section B - 2 marks each" => {:marks => 2, :practical_skills => false, :count => 6, :question_no => 5 },
											"Section C - 3 marks each" => {:marks => 3, :practical_skills => false, :count => 10, :question_no => 11 },
											"Section D - 4 marks each" => {:marks => 4, :practical_skills => false, :count => 11, :question_no => 21 }
							}
	}
}

$pricing_faqs = {
    0 => {  :question => "How does your pricing compare with other solutions? Is it worth it?",
            :answer => "Alternative solutions may offer less price as compared to CBSE Hacker but they provide base content only and is of no value beyond study material already available. Just google study material and you will find a lot of the same content online - for free. CBSE Hacker on other hand does not focus on quantity, it provides smart learning techniques blended in the well defined, quality content to give students the winning edge. <em>The difference between them and us is the same as that between a textbook and a tutor teaching from that textbook.</em> And because we are online we can do what tutions can do at less than half their price."
        },
    1 => {  :question => "I'm already paying for tutions - Why do I need this?",
            :answer => "Your parents have put you in the best tutions and they make sure that you work 10 times as hard by giving you more content and more tests. At the end of the day, what you learn is based on your own self-study and to need be able to smartly manage so much work within minimum time. You need someone to tell you exactly what is the right thing study for YOU - <em>that is what we do for you.</em>"
        },
    2 => {  :question => "Do you provide a guarantee with your product? What if I doesn't work for me?",
            :answer => "Yes. We have money back policy. If you follow the system, you will 100% experience improvement in school results within first few months.  We are so confident in the efforts of our team and learning experts that we offer have <em>a 60-Day return policy</em>. If you don’t benefit from our method of simplification then call us and we will return your investment."
        },
    3 => {  :question => "What are my payment options?",
            :answer => "You can pay using your Credit Card or Debit Card or even through <em>NetBanking</em>"
        },
    4 => {  :question => "What happens if I don’t upgrade?",
            :answer => "Upgrade only if CBSE Hacker is right for you. If not, there’s no need to cancel anything. <em>We don't want to burden you anymore.</em> Your account remains active and your progress remains intact in case you decide to study or upgrade at a later time."
        },
    5 => {  :question => "Do you provide a volume discount for bulk licenses?",
            :answer => "Yes. We do work with schools, tutions and dealers on a case-by-case basis and combine our techniques with content customized to their needs. Please write us at <a href=\"mailto:info@ezeelearning.com\" class=\"font-green\">info@ezeelearning.com</a> or call us at <em>992-291-5273</em> to setup a meeting."
        },
    6 => {  :question => "I have more questions. Who do I ask?",
            :answer => "Write us at <a href=\"mailto:info@ezeelearning.com\" class=\"font-green\">info@ezeelearning.com</a> or call us at <em>992-291-5273</em>. We’d be happy to chat with you."
        }
} 
