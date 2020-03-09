cd 'I:\shared\Eirini\AH\AHa\Stimuli\Pictures\Normative data'.

file handle Norms1 /name = 'Appendix_S1.txt'.
file handle Norms2 /name = 'SI1.txt'.

file handle temp /name = 'temp.sav'.

file handle BossNormsFull /name = 'BossNorms.sav'.


dataset close all.
output close all.

GET DATA
  /TYPE=TXT
  /FILE="Norms1"
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  Filename A20
  Modalname A27
  Modalnameagreement A4
  Hvalue F4.0
  DKO A3
  DKN A3
  TOT A3
  Modalcategory A17
  Categoryagreement A4
  Hcat F4.0
  Familiarity F3.0
  Visualcomplexity F3.0
  Objectagreement F3.0
  Viewpointagreement F3.0
  NMI F1.0
  Manipulability F3.0
  Livingnonliving A2.
CACHE.
EXECUTE.
DATASET NAME NormsOne WINDOW=FRONT.

alter type Hvalue (F3.2).
alter type Hcat (F3.2).
alter type Familiarity (F3.2).
alter type Visualcomplexity (F3.2).
alter type Objectagreement (F3.2).
alter type Viewpointagreement (F3.2).
alter type Manipulability (F3.2).

delete variables Modalnameagreement.
delete variables Modalcategory.
delete variables Categoryagreement.
delete variables Hcat.
delete variables Livingnonliving.
delete variables NMI.

sel if modalname ne ' '.
exe.

compute Bosslist = 1.

GET DATA
  /TYPE=TXT
  /FILE="Norms2"
  /DELCASE=LINE
  /DELIMITERS="\t"
  /ARRANGEMENT=DELIMITED
  /FIRSTCASE=2
  /IMPORTCASE=ALL
  /VARIABLES=
  Filename A20
  DKO A3
  DKN A3
  TOT A3
  Modalname A27
  NA A4
  Hvalue F4.2
  Familiarity F4.2
  Visualcomplexity F4.2
  Objectagreement F4.2
  Viewpointagreement F4.2
  Manipulability F4.2.
CACHE.
EXECUTE.
DATASET NAME NormsTwo WINDOW=FRONT.

sel if modalname ne ' '.
exe.

save out = 'temp'.
dataset close NormsTwo.

get file  = 'temp' /keep Filename ModalName Hvalue DKO DKN TOT Familiarity Visualcomplexity Objectagreement Viewpointagreement Manipulability.
cache.
dataset name NormsTwo.

compute Bosslist = 2.

DATASET ACTIVATE NormsOne.
ADD FILES /FILE=*
  /FILE='NormsTwo'.
EXECUTE.

SORT CASES by Filename.

 save out = 'BossNormsFull'.
