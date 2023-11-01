#averaging the data for a learner using sql
clean_data_by_mean<- sqldf("SELECT learner_id, enrolled_at, detected_country, avg(time_taken) Mean_Time_spent_on_step
      FROM clean_data  
      GROUP BY learner_id")
clean_data_by_mean$month<- month(clean_data_by_mean$enrolled_at)

#counting the enrollments in separate months
count_month<- clean_data_by_mean %>%
  count(month)
#plotting the number of enrollments in a month
ggplot(data = count_month, mapping = aes(x=month))+
  geom_point(mapping = aes(y=n))+
  geom_line(mapping = aes(y=n))

color = grDevices::colors()[grep('gr(a|e)y', grDevices::colors(), invert = T)]
ggplot(clean_data_by_mean) +
  geom_point(aes(x = learner_id, y= Mean_Time_spent_on_step, fill=detected_country))+
  scale_fill_brewer(palette=c(rgb(170,93,152, maxColorValue=255))) + theme_minimal()
plot(clean_data_by_mean)

#extracting countries data with number of learners in the country
count_country<- clean_data_by_mean %>%
  count(detected_country)
detected_country_count<-sqldf("select detected_country, n from count_country order by n desc")
ggplot(detected_country_count,aes(x="", y=n, fill=detected_country))+
  geom_bar(stat="identity",width = 1,color="white")+
  coord_polar("y",start=0)

#calculating average time spent by learners in a month
total_time_spent_pm<-sqldf("SELECT month, (Mean_Time_spent_on_step)/count(learner_id) avgtimespent
      FROM clean_data_by_mean 
      GROUP BY month")
#plotting  the data of average time spent in a month
ggplot(data = total_time_spent_pm, mapping = aes(x=month))+
  geom_point(mapping = aes(y=avgtimespent))+
  geom_line(mapping = aes(y=avgtimespent))

#Calculating total time spent by a country with respect to total number of people in that country
(total_time_spent_pc<-sqldf("SELECT detected_country, count(learner_id) totalpeople, Mean_Time_spent_on_step as total_time_spent 
      FROM clean_data_by_mean 
      GROUP BY detected_country
      order by Mean_Time_spent_on_step desc"))
ggplot(data = accuracy_2,mapping = aes(fill=as.character(week_number),x= as.character(question_number), y=avg_accuracy))+
  geom_bar(position = "dodge",stat = "identity")

#Calculating total time spent by a country with respect to total number of people in that country
(total_time_spent_pc<-sqldf("SELECT detected_country, count(learner_id) totalpeople, Mean_Time_spent_on_step as total_time_spent 
      FROM clean_data_by_mean 
      GROUP BY detected_country
      order by Mean_Time_spent_on_step desc"))

#calculating total time spent by a country with respect to total number of people in that country
AverageTimeSpentByACountry<-sqldf("SELECT detected_country, count(learner_id) totalpeople,   Mean_Time_spent_on_step/count(learner_id) as average_time_spent 
      FROM clean_data_by_mean 
      GROUP BY detected_country
      order by totalpeople desc")
AverageTimeSpentByACountry <- na.omit(AverageTimeSpentByACountry)
sd <- sqldf("select * from AverageTimeSpentByACountry 
      where totalpeople>11")
    