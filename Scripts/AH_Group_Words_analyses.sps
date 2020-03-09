file handle input /name = 'I:\shared\Eirini\AH\AHa\Stimuli\Picture selection\AH_Words_grouped.sav'.
file handle out /name = 'I:\shared\Eirini\AH\AHa\Stimuli\Picture selection\AH_Words_grouped.spv'.

dataset close all.
output close all.

get file = 'input'.
cache.
dataset name Stimuli window = front.

sort cases by group.
split file by group.
freq compound.
freq DK_percentage.
split file off.

mea Agreement_percentage by group.
mea Lg10WF by group.
mea Familiarity by group.
mea Visual_complexity by group.
mea  Manipulability by group.
mea  Letters by group.

GRAPH
  /HISTOGRAM=Agreement_percentage
  /PANEL ROWVAR=Group ROWOP=CROSS.

GRAPH
  /HISTOGRAM=Lg10WF
  /PANEL ROWVAR=Group ROWOP=CROSS.

GRAPH
  /HISTOGRAM=Familiarity
  /PANEL ROWVAR=Group ROWOP=CROSS.

GRAPH
  /HISTOGRAM=Visual_complexity
  /PANEL ROWVAR=Group ROWOP=CROSS.

GRAPH
  /HISTOGRAM=Manipulability
  /PANEL ROWVAR=Group ROWOP=CROSS.

GRAPH
  /HISTOGRAM= Letters
  /PANEL ROWVAR=Group ROWOP=CROSS.

 * EXAMINE VARIABLES=Compound Agreement_percentage DK_percentage Lg10WF Familiarity Visual_complexity 
    Manipulability Letters BY Group
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

 * sort cases by group.

 * EXAMINE VARIABLES=Compound Agreement_percentage DK_percentage Lg10WF Familiarity Visual_complexity 
    Manipulability Letters BY Group
  /PLOT BOXPLOT HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

T-TEST GROUPS=Group(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Agreement_percentage
  /CRITERIA=CI(.95).

T-TEST GROUPS=Group(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=DK_percentage
  /CRITERIA=CI(.95).

T-TEST GROUPS=Group(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Lg10WF
  /CRITERIA=CI(.95).

T-TEST GROUPS=Group(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Familiarity
  /CRITERIA=CI(.95).

T-TEST GROUPS=Group(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Visual_complexity
  /CRITERIA=CI(.95).


T-TEST GROUPS=Group(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Manipulability
  /CRITERIA=CI(.95).

T-TEST GROUPS=Group(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Letters
  /CRITERIA=CI(.95).

T-TEST GROUPS=Group(1 2)
  /MISSING=ANALYSIS
  /VARIABLES=Compound
  /CRITERIA=CI(.95).

output save outfile = 'out'.