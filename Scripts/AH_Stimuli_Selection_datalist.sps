file handle input /name  = 'I:\shared\Eirini\AH\AHa\Stimuli\Picture selection\AH_Stimuli.txt'.
file handle datasav /name  = 'I:\shared\Eirini\AH\AHa\Stimuli\Picture selection\AH_Stimuli.sav'.

dataset close all.
output close all.

GET DATA
  /TYPE=TXT
  /FILE="input"
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  Item_number A3
  File_name A22
  English_name A22
  Dutch_name A22
  Other_A A22
  Other_B A22
  Compound F1.0
  Agreement_percentage A4
  DK_percentage A3.
CACHE.
EXECUTE.
DATASET NAME DataSet3 WINDOW=FRONT.

comp Agreement_percentage = replace(Agreement_percentage,"%","").
comp DK_percentage = replace(DK_percentage,"%","").
exe.

alter type Agreement_percentage (F3.0).
alter type Agreement_percentage (F3.0).
exe.

save out = 'datasav'.





