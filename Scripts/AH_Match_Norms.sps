cd 'I:\shared\Eirini\AH\AHa'.

file handle Stimuli /name = 'Stimuli\Picture selection\AH_Stimuli.sav'. /*dataset that you have.
file handle SubtLexNL /name = 'I:\shared\Hoedemaker\Language Analysis Tools\SPSSCorpora\SUBTLEX-NL.sav'. /*SUBTLEX-NL.
file handle Boss /name = 'I:\shared\Eirini\AH\AHa\Stimuli\Pictures\Normative data\BossNorms.sav'.
file handle DataOut /name = 'I:\shared\Eirini\AH\AHa\Stimuli\AH_Normed_data.sav'.

dataset close all.
output close all.

get file = 'Stimuli'.
cache.
dataset name Stimuli window = front.

/*Match frequency.
get file = 'SubtLexNL' /keep Word Lg10WF.
cache.
dataset name SubtLexNL.
dataset activate SubtLexNL.

/*Match primes.
Rename Variables Word = MatchedString.
Rename Variables Lg10WF = Lg10WF.

sort cases by MatchedString.

dataset activate Stimuli.
Rename Variables Dutch_name = MatchedString.
Alter Type MatchedString (A26).
sort cases by MatchedString.

match files /file = * /file = 'SubtLexNL' by MatchedString.
exe.

Alter Type Item_number (A3).

sel if Item_number ne ' '.
exe.

if MatchedString = lag(MatchedString) and sysmis(Lg10WF) Lg10WF = lag(Lg10WF).
exe.

rename variables matchedstring = Dutch_name.

/*Match BOSS Norms.
get file = 'Boss' /keep filename familiarity visualcomplexity manipulability.
cache.
dataset name Boss window = front.

rename variables filename = matchedstring.
comp matchedstring = replace(matchedstring, ".jpg", "").
EXECUTE.

* comp matchedstring = lower(matchedstring).
 * EXECUTE.

 * comp matchedstring = replace(matchedstring, " *", "").
 * exe.

sort cases by matchedstring.

dataset activate Stimuli.

rename variables file_name = matchedstring.

comp matchedstring = replace(matchedstring, ".jpg", "").
exe.

sort cases by matchedstring.

Alter Type MatchedString (A20).

match files /file = * /file = 'Boss' by matchedstring.
exe.

sel if item_number ne ' '.
exe.

comp Letters = char.length(Dutch_name).
exe.

rename variables matchedstring = File_name.

save out = 'DataOut'.