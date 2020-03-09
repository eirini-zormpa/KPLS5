cd 'I:\shared\Eirini\AH\AHa'.

file handle Stimuli /name = 'Stimuli\AH_Normed_data.sav'.
file handle Grouped /name = 'I:\shared\Eirini\AH\AHa\Stimuli\AH_Grouped_stim.sav'.

dataset close all.
output close all.

get file = 'Stimuli'.
cache.
dataset name Stimuli window = front.

numeric Random (F3.0).

COMPUTE Random=RV.UNIFORM(1,2000). 
EXECUTE.

sort cases by Random.

compute id=$CASENUM.
  FORMAT id (F3.0).
  EXECUTE.

compute Group = 0.
if id < 129 Group = 1.
if id > 128 Group = 2.
exe.

save out = 'Grouped'.