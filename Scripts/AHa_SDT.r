# Signal detection analysis for Zormpa et al., Experiment 1
# Eirini Zormpa, June 2017

# This is reported in the Appendix

# Packages
library(here)
library(tidyr)
library(dplyr)
library(ggplot2)

#Read in data
load(here("AHa", "Data", "Processed", "AHa_all.RData"))

#Create new column, specifying the type of response, "hit" for correctly recognised old items, "miss" for not recognised old items
#"fa" (false alarms) for falsely recognised new items, "cr" (correct rejection) for correctly identified new items
#the mutate command from dplyr creates a new column, the first argument is the dataset, the second the name of the new column
#To compute the values of the new column we use ifelse(test, yes, no), specifically a nested elseif statement. 
AHa_all <- mutate(AH_all,
                 MemResponse = ifelse(Target_button==1,
                                      ifelse(Response_button==1,"hit","miss"),
                                      ifelse(Response_button==1,"fa","cr")))
rm(AH_all)

#Counting how many trials there were in each condition.
#Normally this should be 32 but I've excluded (from the naming data) the trials in which there was a naming error and 
#I've excluded (from the memory data) the repeated items so there are a couple less trials in each condition for some.
#This creates a dataset with the number of trials for each naming condition that participants COULD get correct in the memory task.
AHa_bycondition <- count(AHa_all, Subject, Probe_type, Stimulus_type, Response_type)
colnames(AHa_bycondition)[5] <- "condition_count"

#Counting how many trials there were for each of the memory conditions (hit, miss, fa, cr).
#The first dataset has double the rows because there are 8 values for each participant Stimulus_status x Stimulus_type x Response_type
#In the second dataset Stimulus_status is redundant because it is incorporated in the memory response outcomes.
AHa_bymemres <- count(AHa_all, Subject, Probe_type, Stimulus_type, Response_type, MemResponse)
colnames(AHa_bymemres)[6] <- "memresponse_count"


#Now I have two separate datasets, one with the number of trials in each conditions and one with the performance in these conditions.
#First, I need to get the proportion of hits or FAs/targets. I do this in separate datasets for each.
Targets <- filter(AHa_bycondition, Probe_type == "Target")
Hits <- filter(AHa_bymemres, MemResponse == "hit")
H <- inner_join(Targets, Hits, by = c("Subject", "Probe_type", "Stimulus_type", "Response_type")) %>%
  mutate(propHits=memresponse_count / condition_count) %>%
  ungroup() %>% select(Subject, Stimulus_type, Response_type, propHits) 

Foils <- filter(AHa_bycondition, Probe_type == "Foil")
FAs <- filter(AHa_bymemres, MemResponse == "fa")
FA <- inner_join(Foils, FAs, by = c("Subject", "Probe_type", "Stimulus_type", "Response_type")) %>%
  mutate(propFAs=memresponse_count / condition_count) %>%
  ungroup() %>% select(Subject, Stimulus_type, Response_type, propFAs)

#And now combine them
AHa_signaldetection <- left_join(H,FA, by = c("Subject", "Stimulus_type", "Response_type"))

#Perfect accuracy implies an infinite d'.
#A common adjustment to avoid infinite values is to convert proportions of 0 and 1 to 1/(2N) and 1-1/(2N) respectively,
#where N  is the number of trials on which the proportion is based. (Macmillan & Creelman, 2005)
AHa_signaldetection$propFAs[is.na(AHa_signaldetection$propFAs)] <- 1/64
AHa_signaldetection$propHits[AHa_signaldetection$propHits=="1"]<-1-(1/64)


#d' = z(H) - z(F)
#and c = -1/2[z(H)+z(F)]
#where z is the inverse of the normal distribution function.
#The z transformation converts a hit or false-alarm rate to a z score (i.e., to standard deviation units).(Macmillan & Creelman, 2005)
#In R, the inverse of the cumulative normal distribution is given by qnorm.
AHa_signaldetection <- mutate(AHa_signaldetection, invh = qnorm(propHits, mean = 0, sd = 1))
AHa_signaldetection <- mutate(AHa_signaldetection, invfa = qnorm(propFAs, mean = 0, sd = 1))
AHa_signaldetection <- mutate(AHa_signaldetection, dprime = invh - invfa)
AHa_signaldetection <- mutate(AHa_signaldetection, criterion = -(invh+invfa)/2)

ggplot(AHa_signaldetection)+
  geom_point(aes(x=dprime,y=paste(Response_type,Stimulus_type)))+
  facet_wrap(~Subject)


#Helper functions -  taken from http://www.cookbook-r.com/Graphs/Plotting_means_and_error_bars_(ggplot2)/.
#IMPORTANT: these functions use plyr, NOT dplyr, as I've been using in most scripts. Make sure to unload plyr after running this otherwise parts of the next scripts won't work.

#normDataWithin
source(here("Helper functions", "normDataWithin.R"))
#summarySE
source(here("Helper functions", "summarySE.R"))
#summarySEwithin
source(here("Helper functions", "summarySEwithin.R"))

Da_Results <- summarySEwithin(AHa_signaldetection, measurevar="dprime", withinvars=c("Stimulus_type", "Response_type"), idvar="Subject", na.rm=TRUE, conf.interval=.95)
Ca_Results <- summarySEwithin(AHa_signaldetection, measurevar="criterion", withinvars=c("Stimulus_type", "Response_type"), idvar="Subject", na.rm=TRUE, conf.interval=.95)

detach("package:plyr", unload=TRUE)
library(here)

save(AHa_signaldetection, file=here("AHa", "Data", "Processed", "AHa_signaldetection.RData"))
save(Da_Results, file=here("AHa", "Data", "Processed", "Da_Results.RData"))
save(Ca_Results, file=here("AHa", "Data", "Processed", "Ca_Results.RData"))