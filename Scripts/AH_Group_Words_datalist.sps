file handle input /name = 'I:\shared\Eirini\AH\AHa\Stimuli\Picture selection\Words_grouped.txt'.
file handle GroupOut /name = 'I:\shared\Eirini\AH\AHa\Stimuli\Picture selection\AH_Words_grouped.sav'.

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
  Item_number F3.0
  File_name A18
  English_name A20
  Dutch_name A17
  Other_A A16
  Other_B A17
  Compound F1.0
  Agreement_Percentage F3.0
  DK_percentage F3.0
  Lg10WF F3.2
  Familiarity F3.2
  Visual_complexity F3.2
  Manipulability F3.2
  Letters F2.0
  Random F4.0
  ID F3.0
  Group F1.0.
CACHE.
EXECUTE.
DATASET NAME DataSet1 WINDOW=FRONT.

save out = 'GroupOut'.