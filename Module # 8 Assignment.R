#Import dataset
students <- read.table(file.choose(), header = TRUE, sep = ",")
students

#Calculate mean grade by sex using plyr, and write output to a file
if(!require(plyr)){install.packages("plyr")}
library(plyr)
students_gendered_mean = ddply(students,"Sex",transform,Grade.Average=mean(Grade))
write.table(students_gendered_mean, "Students_Gendered_Mean")
write.table(students_gendered_mean,"Students_Gendered_Mean",sep=",")

#Subset rows where the name contains the letter 'i'
i_students <- subset(students, grepl("i", students$Name, ignore.case=T))

#Write the filtered data set and convert it to CSV
write.table(i_students,"DataSubset",sep=",")
