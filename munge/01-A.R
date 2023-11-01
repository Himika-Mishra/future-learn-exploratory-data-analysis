# Example preprocessing script.
# Merging enrollment data from all iterations... (row bind)
enrolment_i1 = cyber.security.1_enrolments
enrolment_i2 = cyber.security.2_enrolments
enrolment_i3 = cyber.security.3_enrolments
enrolment_i4 = cyber.security.4_enrolments
enrolment_i5 = cyber.security.5_enrolments
enrolment_i6 = cyber.security.6_enrolments
enrolment_i7 = cyber.security.7_enrolments
enrolments = rbind(enrolment_i1, enrolment_i2, enrolment_i3, enrolment_i4, enrolment_i5, enrolment_i6, enrolment_i7)
# Select required columns
enroldata<-enrolments%>% select(learner_id, enrolled_at ,detected_country)

# Merging Step Activity data from all iterations... (row bind)
StepActivity_i1 = cyber.security.1_step.activity
StepActivity_i2 = cyber.security.2_step.activity
StepActivity_i3 = cyber.security.3_step.activity
StepActivity_i4 = cyber.security.4_step.activity
StepActivity_i5 = cyber.security.5_step.activity
StepActivity_i6 = cyber.security.6_step.activity
StepActivity_i7 = cyber.security.7_step.activity
StepActivity = rbind(StepActivity_i1, StepActivity_i2, StepActivity_i3, StepActivity_i4, StepActivity_i5, StepActivity_i6, StepActivity_i7)
# Select required columns
FinalStepActivity<-StepActivity%>% select(learner_id, first_visited_at, last_completed_at)
# Merging the data set
merged_data<-merge(enrolments, FinalStepActivity, by="learner_id", all = TRUE)

# Cleaning the dataset
clean_data=na.omit(merged_data)
# Converting the values who are null in a different way
clean_data[clean_data == ""] = NA
clean_data[clean_data == "--"] = NA
#clean_data=na.omit(clean_data)
#changing the date format
clean_data <- mutate(clean_data, first_visited_at=lubridate::as_datetime(first_visited_at))
clean_data <- mutate(clean_data, last_completed_at=lubridate::as_datetime(last_completed_at))
clean_data <- mutate(clean_data, enrolled_at=lubridate::as_datetime(enrolled_at))

clean_data$time_taken = clean_data$last_completed_at - clean_data$first_visited_at
head(clean_data)
clean_data$x=NULL
head(clean_data)
clean_data_new = na.omit(clean_data)
# Merging enrollment data from all iterations... (row bind)
ques_response_i1 = cyber.security.1_question.response
ques_response_i2 = cyber.security.2_question.response
ques_response_i3 = cyber.security.3_question.response
ques_response_i4 = cyber.security.4_question.response
ques_response_i5 = cyber.security.5_question.response
ques_response_i6 = cyber.security.6_question.response
ques_response_i7 = cyber.security.7_question.response
ques_response_total = rbind(ques_response_i1, ques_response_i2, ques_response_i3, ques_response_i4, ques_response_i5, ques_response_i6, ques_response_i7)

# Transforming the data
ques_response<-ques_response_total%>% select(learner_id,week_number,step_number, question_number ,correct)
#cleaning the data
ques_response[ques_response == ""] = NA
ques_response<-na.omit(ques_response)
#getting the data in order
ques_response<-sqldf("select  * from ques_response order by learner_id")
#transforming the data from character to numeric
ques_response$correct[ques_response$correct== "true"]<-1
ques_response$correct[ques_response$correct== "false"]<-0
#calculating the accuracy of a learner
acc_of_learner<-sqldf("select learner_id, week_number, question_number, avg(correct) accuracy from ques_response group by question_number, learner_id, week_number order by learner_id")
#calculating accuracy in a particular question and in a particular week
accuracy_2<-sqldf("select question_number,week_number, avg(accuracy) avg_accuracy from acc_of_learner group by question_number, week_number")

