## Eirini Zormpa, Max Planck Institute for Psycholinguistics, eirini.zormpa@mpi.nl
## AH project Experiment 1 dataset building script
## June 2017, updated JUly 2019

# OVERVIEW --------------------------------------------------------------------------------------------------------------------------------------------

# In this experiment, participants first completed a picture naming task, in which they saw labels superimposed on pictures they had to name. The labels could be the real names of the pictures (picture+word condition) or something unreadable (picture-only condition). We used a delayed naming paradigm, meaning that participants first saw the picture and label and later saw a square signalling whether they needed to respond aloud (green square) or silently in their heads (red square). Afterwards, they completed a filler task. Finally, they completed a self-paced Yes/No recognition memory task in which they saw all the pictures from the naming task (along with their original labels) as well as an equal number of foils (also with superimposed real or non-word labels).

# The main research question in the study related to the memory data: The DV is the log odds of "Yes" responses. The naming latency and accuracy data are used to decide which trials and participants need to be excluded. The naming latencies were also used as a check our delayed naming paradigm worked -- we compared the average naming latency data of the participants in this experiment to the average naming latency data of pilot participants without the delayed naming to ensure the participants in the main experiment were faster (i.e., they used the preview time to come up with a response). Participants that are slower or show strange distributions can then be excluded. All trials were participants made an incorrect response are also excluded.

# The data from the filler task are not analysed.

#Packages
# install what you don't have
# install.packages("here")
# install.packages("readr")
# install.packages("dplyr")
# install.packages("magrittr")
# install.packages("ggplot2")

library(here)
library(dplyr)
library(readr)
library(magrittr)
library(ggplot2)


# NAMING ----------------------------------------------------------------------------------------------------------------------------------------------

# This includes the naming latency and naming accuracy data. The naming latencies were extracted by manually annotating all responses from recordings in Praat. Naming accuracy was also scored manually. Responses that were judged as correct included the expected words of course but also synonyms. That is because the stimuli used at test were the pictures themselves and not the words I was expecting people to say following the responses of the eight Dutch native speakers from whom we collected naming agreement scores. Furthermore, the recording times for this experiment was not very long, meaning some correct responses were not captured in the audio recordings. I would note these cases during the experiment and mark them as correct during the annotation.

# *Latencies -------------------------------------------------------------------------------------------------------------------------------------------

#First, read in naming onset data (42 participantss *128 items *3 = 16128). One participant (AH06) is already excluded because I made a mistake during testing. The way the naming data were annotated created three chunks. The first chunk contained the "aloud" or "silent" condition to make it easier to evaluate whether the participant had missed a trial or not. The second chunk contained the target word. The third chunk was used for comments such as "missed" or the word the participant had actually produced. The two boundaries used to create the three chunks were the onset and offset of the word. We only care about the onset here. The two final variables "Real_onset" and "onset_ms" were manually created in Excel. The onset as counted in Praat was at the beginning of the recording. However, the participants had a preview of the picture and label for 800ms. So the "Real_onset" adds the praat onset and the 800ms. The "onset_ms" just multiplied the "onset" by 1000.
nam_onsets <- read_delim(here("AHa", "Data", "Raw", "Naming","AH_SS_NamingOnsets.txt"),
                         delim = "\t") %>%
  select(-offset) %>%
  rename(praat_label = label)

#Keep only the aloud items (42*64 = 2688) and get rid of unnecessary lines from praat annotation (time before and after word). The silent items have no onset and the two chunks with the condition and comments are not useful to me.
aloud_onsets <- filter(nam_onsets, Response_type == "aloud")  %>%
  filter(as.character(praat_label) == as.character(Dutch_name))

#Sanity check (same number of aloud trials from all participants)
sanity_check <- aloud_onsets %>%
  group_by(Subject) %>%
  summarise(no_rows = length(Subject))

# *Accuracy -----------------------------------------------------------------------------------------------------------------------------------------

#Read in naming data
header = c("Subject","NamingTrial","ID","Probe_type","Stimulus_type","Response_type","File_name","English_name","Dutch_name","Other_A","Other_B","List", "Compound", "Agreement_percentage", "DK_percentage", "Lg10WF", "Familiarity", "Visual_complexity", "Manipulability", "Letters", "Non-word", "CorrectName", "Response")
filelist = list.files(path = here("AHa", "Data", "Raw", "Naming", "Logfiles"), pattern = ".*.txt")

naming <- read_delim(here("AHa", "Data", "Raw", "Naming", "Logfiles", filelist[1]), delim="\t", col_names = header, locale = locale("nl"), skip = 1)

for (i in 2:length(filelist)){
  naming2 <- read_delim(here("AHa", "Data", "Raw", "Naming", "Logfiles", filelist[i]), delim="\t", col_names = header, locale = locale("nl"), skip = 1)
  naming <- merge(naming, naming2, all = T)
}

rm(naming2)

naming %<>% 
  select (Subject, ID, Probe_type, Stimulus_type, Response_type, English_name, Dutch_name, CorrectName) %>%
  arrange(Subject, Dutch_name)

#M = 97.9
nam_acc <- mean(naming$CorrectName)
  
#Check how accurate individual participants are with naming
NamAccuracy_cond <- summarise(group_by(naming, Subject, Stimulus_type, Response_type),
                              mean.correct = mean(CorrectName))

ggplot(NamAccuracy_cond)+
  geom_point(aes(x=mean.correct,y=paste(Response_type,Stimulus_type)))+
  facet_wrap(~Subject)

#To join the timing onsets with the aloud items first separate aloud and silent items from naming data (5376/2 = 2688)
aloud <- naming %>%
  filter(Response_type == "aloud")

silent <- naming %>%
  filter(Response_type == "silent")

#Filtering out incorrect trials
aloud_all <- inner_join(aloud_onsets, aloud, by = c("Subject", "Dutch_name", "Stimulus_type", "Response_type"))%>%
  select(-onset) %>%
  rename(onset = Real_onset) %>%
  mutate(onset = onset - 800)

aloud_correct <- aloud_all %>% filter(CorrectName == 1)

Picture_onsets_sub <- aloud_correct %>%
  filter(Stimulus_type == "picture") %>%
  group_by(Subject) %>%
  summarise(mean.RT=mean(onset)) %>%
  arrange(Subject)

ggplot() +
  geom_histogram(binwidth = 15, aes(x=mean.RT),data=Picture_onsets_sub)

Picture_onsets_trial <- aloud_correct %>%
  filter(Stimulus_type == "picture")

ggplot() +
  geom_histogram(binwidth = 20, aes(x=onset),data=Picture_onsets_trial)+
  facet_wrap(~Subject)

#Participant 33 seems slower than the rest with a right-tailed distribution and is excluded
lat_33 <- aloud_correct %>% filter(Subject=="AH33")

# M = 572, SD = 209
mean_33 <- summarise(lat_33, mean.RT = mean(onset), sd.RT = sd(onset))

# exclude participant 33
aloud_correct %<>% filter(Subject != "AH33")

# M = 477, SD = 185
Picture_onsets_descr <- aloud_correct %>%
  filter(Stimulus_type == "picture") %>%
  summarise(mean.RT = mean(onset), sd.RT = sd(onset))


# M = 402, SD = 83.5
PicWord_onsets_descr <- aloud_correct %>%
  filter(Stimulus_type == "picture+word") %>%
  summarise(mean.RT = mean(onset), sd.RT = sd(onset))

PicWord_onsets_sub <- aloud_correct %>%
  filter(Stimulus_type == "picture+word") %>%
  group_by(Subject) %>%
  arrange(Subject)

ggplot() +
  geom_histogram(binwidth = 15, aes(x=onset),data=PicWord_onsets_sub)

PicWords_onsets_trial <- aloud_correct %>%
  filter(Stimulus_type == "picture+word")

ggplot() +
  geom_histogram(binwidth = 20, aes(x=onset),data=PicWords_onsets_trial)+
  facet_wrap(~Subject)


#... filter out the *silent* responses of participant 33
silent %<>% filter(Subject != "AH33")

#And then join the aloud and silent responses.
naming_correct <- full_join(aloud_correct, silent, by = c("Subject", "Dutch_name", "Stimulus_type", "Response_type", "ID", "Probe_type", "English_name", "CorrectName"))

####################################################################### MEMORY ###########################################################################

#Read in memory data (256*42=10752)
header = c("Subject","MemoryTrial","ID","Probe_type","Stimulus_type","Response_type","File_name","English_name","Dutch_name","Other_A","Other_B","List", "Compound", "Agreement_percentage", "DK_percentage", "Lg10WF", "Familiarity", "Visual_complexity", "Manipulability", "Letters", "Non-word", "Target_button", "Response_button", "Correct", "RT", "Repeated")

filelist = list.files(path = here("AHa", "Data", "Raw", "Memory"), pattern = ".*.txt")

memory <- read_delim(here("AHa", "Data", "Raw", "Memory", filelist[1]), delim="\t", col_names = header, locale = locale("nl"), skip = 1)

for (i in 2:length(filelist)){
  memory2 <- read_delim(here("AHa", "Data", "Raw", "Memory", filelist[i]), delim="\t", col_names = header, locale = locale("nl"), skip = 1)
  memory <- merge(memory, memory2, all = T)
}

rm(memory2)

# 10752-256 = 10496
memory %<>% select (Subject, MemoryTrial, ID, Probe_type, Stimulus_type, Response_type, English_name, Dutch_name, Target_button, Response_button, Correct, RT, Repeated) %>% 
  filter(Subject != "AH33")

# find out how many repeated items there were (31) and exclude them (repeated items were incorrectly used in naming but refer to objects used as foils in the memory task)
repeated <- sum(memory$Repeated)

memory %<>% filter(Repeated == 0)

#Check how accurate individual participants in the memory task
MemAccuracy_cond <- summarise(group_by(memory, Subject, Stimulus_type, Response_type),
                              proportion_correct = mean(Correct))

ggplot(MemAccuracy_cond)+
  geom_point(aes(x=proportion_correct,y=paste(Response_type,Stimulus_type)))+
  facet_wrap(~Subject)

#I am dividing the memory trials into to targets and foils to join them with the naming data. Probably not the best way to do it, but it works.
Memory_targets <- filter(memory, Probe_type == "Target")
Memory_foils <- filter(memory, Probe_type == "Foil")

#First join the targets, i.e. how people did in the naming task with how they responded to the same stims in the memory task. This will get rid of the incorrect naming trials in the memory dataset.
AH_Targets <- inner_join(naming_correct, Memory_targets)

#And then join everything together.
AH_all <- full_join(AH_Targets, Memory_foils)

#Save dataset
save(AH_all, file = here("AHa", "Data", "Processed", "AHa_all.RData"))
