file handle StimInp /name = 'I:\shared\Eirini\AH\AHa\Stimuli\Stimuli auditing\AH_Lists_audit.txt'.
file handle DataOut /name = 'I:\shared\Eirini\AH\AHa\Stimuli\AH_Lists_audit.sav'.

dataset close all.
output close all.

GET DATA
  /TYPE=TXT
  /FILE="StimInp"
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  Identifier A9
  File_name A21
  English_name A21
  Dutch_name A21
  Other_A A21
  Other_B A21
  V1 F1.0
  List F1.0
  Compound F1.0
  Agreement_Percentage F3.0
  DK_percentage F2.0
  Lg10WF F6.4
  Familiarity F4.2
  Visual_complexity F4.2
  Manipulability F4.2
  Letters F2.0.
CACHE.
EXECUTE.
DATASET NAME Lists WINDOW=FRONT.

delete variables V1.

/*identifier parser.
string v0 (A3) v1 (A1) v2 (A1) v3 (A1).

comp v0 = substr(identifier, 1,3).
comp v1 = substr(identifier, 5,1).
comp v2 = substr(identifier, 6,1).
comp v3 = substr(identifier, 7,1).
exe.

compute ID = number(v0, F3.0).
compute Stimulus_status = number(v1, F1.0).
compute Stimulus_type = number(v2, F1.0).
compute Response_type = number(v3, F1.0).
exe.

Format ID (F3.0).
Format Stimulus_status (F1.0).
Format Stimulus_type (F1.0).
Format Response_type (F1.0).
exe.

value labels Stimulus_status 1 'Target' 2 'Foil'.
value labels Stimulus_type 1 'Picture' 2 'Picture+Word'.
value labels Response_type 1 'Silent' 2 'Aloud'.

delete variables v0 to v3.

save out = 'DataOut'.








