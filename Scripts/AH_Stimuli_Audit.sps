cd 'I:\shared\Eirini'.

file handle DataOut /name = 'AH\AHa\Stimuli\AH_Lists_audit.sav'.
file handle out /name  = 'AH\AHa\Stimuli\AH_audit.spv'.

dataset close all.
output close all.

get file = 'DataOut'.
cache.
dataset name Stimuli window = front.

comp English_name = replace(English_name, ".jpg", "").
exe.

freq list.

cross Stimulus_status by list

cross Stimulus_type by list.

cross Response_type by list.

cross Stimulus_type by Response_type by list.

cross Dutch_name by list.

cross Dutch_name by Stimulus_type by Response_type.

cross Stimulus_status by Response_type.

cross Stimulus_status by Stimulus_type.

output save outfile = 'out'.