# Analysis script for Zormpa et al., Experiment 1
# Eirini Zormpa, June 2017

#Packages
library(lme4)
library(here)

#Read in data
load(here("AHa", "Data", "Processed", "AHa_all.RData"))

#Set contrasts
AHa_all$Probe_type_Base[AHa_all$Probe_type == "Foil"] <- -.5
AHa_all$Probe_type_Base[AHa_all$Probe_type == "Target"] <- .5

AHa_all$Stimulus_type_Base[AHa_all$Stimulus_type == "picture+word"] <- -.5  
AHa_all$Stimulus_type_Base[AHa_all$Stimulus_type == "picture"] <- .5  

AHa_all$Response_type_Base[AHa_all$Response_type == "silent"] <- -.5
AHa_all$Response_type_Base[AHa_all$Response_type == "aloud"] <- .5

########################################################## BASE MODEL ######################################################################

######################################################## *Overfitted 1 #########################################################

#With this random structure the model converged but was overfitted (high correlations between random effects)
Logit.0a <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base + (1+Stimulus_type_Base+Response_type_Base|ID) + (1+Probe_type_Base+Stimulus_type_Base+Response_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))

summary(Logit.0a)

######################################################## **output ########################################################
# Generalized linear mixed model fit by maximum likelihood (Laplace Approximation) ['glmerMod']
# Family: binomial  ( logit )
# Formula: Response_button ~ Probe_type_Base * Stimulus_type_Base * Response_type_Base +  (1 + Stimulus_type_Base + Response_type_Base | ID) + (1 + Probe_type_Base + Stimulus_type_Base + Response_type_Base | Subject)
# Data: AH_all
# Control: glmerControl(optimizer = "bobyqa", optCtrl = list(maxfun = 20000))

# AIC      BIC   logLik deviance df.resid 
# 5572.9   5746.8  -2762.4   5524.9    10360 
# 
# Scaled residuals: 
#   Min      1Q  Median      3Q     Max 
# -7.6449 -0.2067 -0.1144  0.2792  8.4354 
# 
# Random effects:
# Groups  Name               Variance  Std.Dev. Corr             
# ID      (Intercept)        0.4178077 0.64638                   
#         Stimulus_type_Base 0.0002948 0.01717  1.00             #overfitted
#         Response_type_Base 0.0107906 0.10388  1.00  1.00       #overfitted
# Subject (Intercept)        0.3344891 0.57835                   
#         Probe_type_Base    1.3739587 1.17216   0.17            
#         Stimulus_type_Base 0.1202954 0.34684  -0.32  0.60      
#         Response_type_Base 0.0528031 0.22979   0.64  0.27 -0.59
# Number of obs: 10384, groups:  ID, 256; Subject, 41
# 
# Fixed effects:
#                                                          Estimate Std. Error z value Pr(>|z|)    
#   (Intercept)                                           -0.51636    0.11119  -4.644 3.42e-06 ***
#   Probe_type_Base                                        5.87543    0.21662  27.124  < 2e-16 ***
#   Stimulus_type_Base                                     0.84524    0.11055   7.646 2.08e-14 ***
#   Response_type_Base                                     0.31005    0.09951   3.116  0.00183 ** 
#   Probe_type_Base:Stimulus_type_Base                     2.05049    0.21494   9.540  < 2e-16 ***
#   Probe_type_Base:Response_type_Base                     1.28129    0.20919   6.125 9.07e-10 ***
#   Stimulus_type_Base:Response_type_Base                  0.48901    0.16952   2.885  0.00392 ** 
#   Probe_type_Base:Stimulus_type_Base:Response_type_Base  0.76474    0.34579   2.212  0.02700 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#             (Intr) Prb__B Stm__B Rsp__B Pr__B:S__B P__B:R   S__B:R
# Prob_typ_Bs  0.058                                              
# Stmls_typ_B -0.012  0.348                                       
# Rspns_typ_B  0.301  0.130  0.010                                
# Prb__B:S__B  0.074  0.182 -0.156  0.112                         
# Prb__B:R__B  0.038  0.140  0.107 -0.191     0.146                  
# Stm__B:R__B  0.057  0.072  0.183  0.265     0.096   0.160       
# P__B:S__B:R  0.062  0.078  0.089  0.157     0.236   0.298   -0.177



######################################################## *Overfitted 2 #########################################################

# the confint function did not work for this model ("Profiling over both the residual variance and fixed effects is not numerically consistent with profiling over the fixed effects only"). We took this to mean that something was wrong with the solution space. To avoid this problem, we further reduced the random effect structure by removing effects that did not explain much of the variation, in this case the by-subject response type slope.

Logit.0b <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base+Response_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))

summary(Logit.0b)

######################################################## **output ########################################################
# AIC      BIC   logLik deviance df.resid 
# 5563.9   5701.6  -2762.9   5525.9    10365 
# 
# Scaled residuals: 
#   Min      1Q  Median      3Q     Max 
# -7.6179 -0.2071 -0.1159  0.2790  8.1646 
# 
# Random effects:
#   Groups  Name               Variance Std.Dev. Corr             
# ID      (Intercept)        0.40279  0.6347                    
# Subject (Intercept)        0.33289  0.5770                    
#         Probe_type_Base    1.37930  1.1744    0.17            
#         Stimulus_type_Base 0.12116  0.3481   -0.32  0.60      
#         Response_type_Base 0.04834  0.2199    0.61  0.27 -0.60        #this is not explaining much of the variance
# Number of obs: 10384, groups:  ID, 256; Subject, 41
# 
# Fixed effects:
#                                                          Estimate   Std. Error z value  Pr(>|z|)    
#   (Intercept)                                           -0.51651    0.11074   -4.664    3.10e-06 ***
#   Probe_type_Base                                        5.85852    0.21486   27.267    < 2e-16 ***
#   Stimulus_type_Base                                     0.84488    0.11039   7.653     1.96e-14 ***
#   Response_type_Base                                     0.31710    0.09839   3.223     0.00127 ** 
#   Probe_type_Base:Stimulus_type_Base                     2.02936    0.18537   10.948    < 2e-16 ***
#   Probe_type_Base:Response_type_Base                     1.17807    0.18202   6.472     9.65e-11 ***
#   Stimulus_type_Base:Response_type_Base                  0.47869    0.16901   2.832     0.00462 ** 
#   Probe_type_Base:Stimulus_type_Base:Response_type_Base  0.73038    0.34239   2.133     0.03291 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#   (Intr) Prb__B Stm__B Rsp__B Pr__B:S__B P__B:R S__B:R
# Prob_typ_Bs  0.057                                              
# Stmls_typ_B -0.016  0.357                                       
# Rspns_typ_B  0.262  0.132  0.013                                
# Prb__B:S__B  0.083  0.143 -0.148  0.128                         
# Prb__B:R__B  0.045  0.108  0.117 -0.182  0.137                  
# Stm__B:R__B  0.057  0.066  0.181  0.271  0.098      0.150       
# P__B:S__B:R  0.062  0.061  0.094  0.166  0.214      0.286 -0.187



############################################### *Base model used ###############################################

Logit.0 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))

summary(Logit.0)


######################################################## **output ########################################################
# AIC      BIC   logLik deviance df.resid 
# 5561.1   5669.8  -2765.6   5531.1    10369 
# 
# Scaled residuals: 
#   Min      1Q  Median      3Q     Max 
# -7.2105 -0.2058 -0.1178  0.2785  8.0814 
# 
# Random effects:
#   Groups  Name               Variance Std.Dev. Corr       
#   ID      (Intercept)        0.4028   0.6347              
#   Subject (Intercept)        0.3171   0.5632              
#           Probe_type_Base    1.3892   1.1786    0.15      
#           Stimulus_type_Base 0.1318   0.3630   -0.37  0.60
# Number of obs: 10384, groups:  ID, 256; Subject, 41
# 
# Fixed effects:
#                                                          Estimate Std. Error z value   Pr(>|z|)    
#   (Intercept)                                           -0.52147    0.10885  -4.791    1.66e-06 ***
#   Probe_type_Base                                        5.83709    0.21504  27.144     < 2e-16 ***
#   Stimulus_type_Base                                     0.84320    0.11138   7.570    3.73e-14 ***
#   Response_type_Base                                     0.30448    0.08406   3.622    0.000292 ***
#   Probe_type_Base:Stimulus_type_Base                     2.00714    0.18476  10.864     < 2e-16 ***
#   Probe_type_Base:Response_type_Base                     1.06961    0.16821   6.359    2.03e-10 ***
#   Stimulus_type_Base:Response_type_Base                  0.45196    0.16815   2.688    0.007191 ** 
#   Probe_type_Base:Stimulus_type_Base:Response_type_Base  0.74346    0.33592   2.213    0.026882 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#             (Intr) Prb__B Stm__B Rsp__B Pr__B:S__B P__B:R S__B:R
# Prob_typ_Bs  0.043                                              
# Stmls_typ_B -0.041  0.360                                       
# Rspns_typ_B  0.084  0.046  0.111                                
# Prb__B:S__B  0.080  0.140 -0.154  0.130                         
# Prb__B:R__B  0.040  0.095  0.114 -0.198   0.132                  
# Stm__B:R__B  0.055  0.060  0.168  0.295   0.096     0.142       
# P__B:S__B:R  0.055  0.056  0.080  0.140   0.194     0.295   -0.201


######################################################## **95% Confidence Intervals ########################################################
confint(Logit.0, method = "profile")

#                                                         2.5 %     97.5 %
# .sig01                                                 0.53251744  0.7466000
# .sig02                                                 0.42977946  0.7494040
# .sig03                                                -0.24841686  0.5085440
# .sig04                                                -0.69894906  0.2580413
# .sig05                                                 0.88511011  1.5899887
# .sig06                                                -0.05802614  0.8607758
# .sig07                                                 0.14903940  0.6229116
# (Intercept)                                           -0.74543755 -0.3055015
# Probe_type_Base                                        5.41882330  6.2976705
# Stimulus_type_Base                                     0.62200121  1.0868192
# Response_type_Base                                     0.13374905  0.4771576
# Probe_type_Base:Stimulus_type_Base                     1.63145362  2.3962109
# Probe_type_Base:Response_type_Base                     0.72976400  1.4179570
# Stimulus_type_Base:Response_type_Base                  0.10952473  0.7979104
# Probe_type_Base:Stimulus_type_Base:Response_type_Base  0.05889590  1.4370372


############################################################# MODEL COMPARISONS ############################################################

############################################################# *Response bias #############################################################

########################################## **no intercept ##########################################
Logit.1 <- glmer(Response_button ~ 0 +Probe_type_Base*Stimulus_type_Base*Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))

summary(Logit.1)

anova(Logit.0, Logit.1)

#         Df    AIC    BIC  logLik deviance  Chisq  Chi Df  Pr(>Chisq)    
# Logit.1 14 5578.4 5679.8 -2775.2   5550.4                             
# Logit.0 15 5561.1 5669.8 -2765.6   5531.1  19.241     1   1.152e-05 ***


########################################## **no probe type (Target vs. Foil) ##########################################
Logit.2 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Probe_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))

summary(Logit.2)

anova(Logit.0, Logit.2)

#         Df    AIC    BIC  logLik deviance  Chisq    Chi Df   Pr(>Chisq)    
# Logit.2 14 5679.7 5781.2 -2825.9   5651.7                             
# Logit.0 15 5561.1 5669.8 -2765.6   5531.1  120.63       1    < 2.2e-16 ***

########################################## **no stimulus type (Picture-only vs. Picture+word) ##########################################
Logit.3 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Stimulus_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))

summary(Logit.3)

anova(Logit.0, Logit.3)

#         Df    AIC    BIC  logLik deviance  Chisq  Chi Df  Pr(>Chisq)    
# Logit.3 14 5601.0 5702.5 -2786.5   5573.0                             
# Logit.0 15 5561.1 5669.8 -2765.6   5531.1  41.906      1  9.578e-11 ***

########################################## **no response type (Aloud vs. Silent) ##########################################
Logit.4 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))

summary(Logit.4)

anova(Logit.0, Logit.4)

#         Df    AIC    BIC  logLik deviance  Chisq    Chi Df  Pr(>Chisq)    
# Logit.4 14 5571.4 5672.9 -2771.7   5543.4                             
# Logit.0 15 5561.1 5669.8 -2765.6   5531.1  12.302        1  0.0004524 ***

######################################## **no stimulus*response  #######################################
Logit.5 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Stimulus_type_Base:Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))

summary(Logit.5)

anova(Logit.0, Logit.5)

#         Df    AIC    BIC  logLik deviance  Chisq    Chi Df    Pr(>Chisq)  
# Logit.5 14 5565.9 5667.4 -2768.9   5537.9                           
# Logit.0 15 5561.1 5669.8 -2765.6   5531.1  6.7995        1    0.009118 **

############################################################## *Sensitivity ##############################################################

#################### **no probe*stimulus (main effect of stimulus type) ###################
Logit.6 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Probe_type_Base:Stimulus_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))

summary(Logit.6)

anova(Logit.0, Logit.6)


#         Df    AIC    BIC  logLik   deviance  Chisq    Chi Df  Pr(>Chisq)    
# Logit.6 14 5673.8 5775.3 -2822.9   5645.8                             
# Logit.0 15 5561.1 5669.8 -2765.6   5531.1    114.69       1   < 2.2e-16 ***


######################################## **no probe*response (main effect of response type) #######################################
Logit.7 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Probe_type_Base:Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Logit.7)

anova(Logit.0, Logit.7)

#         Df    AIC    BIC  logLik deviance  Chisq    Chi Df  Pr(>Chisq)    
# Logit.7 14 5597.8 5699.3 -2784.9   5569.8                             
# Logit.0 15 5561.1 5669.8 -2765.6   5531.1  38.74        1   4.841e-10 ***



################################### **no prob*stim*resp (interaction) ###################################
Logit.8 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Probe_type_Base:Stimulus_type_Base:Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_all, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Logit.8)

anova(Logit.0, Logit.8)

#         Df    AIC    BIC  logLik deviance  Chisq    Chi Df   Pr(>Chisq)  
# Logit.8 14 5563.7 5665.2 -2767.9   5535.7                           
# Logit.0 15 5561.1 5669.8 -2765.6   5531.1  4.6023       1    0.03193 *
