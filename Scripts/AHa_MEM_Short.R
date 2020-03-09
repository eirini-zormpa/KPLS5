# Analysis of a shortened dataset from Experiment 1 (to match the size of the dataset from Experiment 2)
# Eirini Zormpa, August 2017

#Packages
library(lme4)
library(here)

#Read in data
load(here("AHa", "Data", "Processed", "AHa_all.RData"))

AHa_short <- AH_all %>%
  filter(MemoryTrial <= 232)

save(AHa_short, file=here("AHa", "Data", "Processed", "AHa_short.RData"))

#set contrasts
AHa_short$Response_button <- as.factor(AHa_short$Response_button)

AHa_short$Probe_type_Base[AHa_short$Probe_type == "Foil"] <- -.5
AHa_short$Probe_type_Base[AHa_short$Probe_type == "Target"] <- .5

AHa_short$Stimulus_type_Base[AHa_short$Stimulus_type == "picture+word"] <- -.5  
AHa_short$Stimulus_type_Base[AHa_short$Stimulus_type == "picture"] <- .5  

AHa_short$Response_type_Base[AHa_short$Response_type == "silent"] <- -.5
AHa_short$Response_type_Base[AHa_short$Response_type == "aloud"] <- .5

########################################################### BASE MODEL ###########################################################

#Like before, this converges but is overfitted -- I want to compare with my full analysis so I rewmove the same random effects as before
Short.0a <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base + (1+Stimulus_type_Base+Response_type_Base|ID) + (1+Probe_type_Base+Stimulus_type_Base+Response_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.0a)

# AIC      BIC      logLik  deviance  df.resid 
# 5026.7   5198.3  -2489.4   4978.7     9386 
# 
# Scaled residuals: 
#   Min      1Q  Median      3Q     Max 
# -8.3237 -0.2078 -0.1153  0.2722  9.1204 
# 
# Random effects:
#   Groups  Name               Variance  Std.Dev. Corr             
# ID      (Intercept)        4.388e-01 0.662396                  
#         Stimulus_type_Base 2.595e-06 0.001611 1.00                  #overfitted
#         Response_type_Base 1.131e-02 0.106353 1.00  1.00            #overfitted
# Subject (Intercept)        3.436e-01 0.586209                  
#         Probe_type_Base    1.349e+00 1.161679  0.22            
#         Stimulus_type_Base 1.378e-01 0.371150 -0.37  0.50      
#         Response_type_Base 5.863e-02 0.242139  0.79  0.23 -0.69     #overfitted
# Number of obs: 9410, groups:  ID, 256; Subject, 41
# 
# Fixed effects:
#                                                           Estimate Std. Error z value Pr(>|z|)    
#   (Intercept)                                            -0.4639     0.1137  -4.080 4.51e-05 ***
#   Probe_type_Base                                         5.9148     0.2191  27.000  < 2e-16 ***
#   Stimulus_type_Base                                      0.8484     0.1168   7.263 3.78e-13 ***
#   Response_type_Base                                      0.3145     0.1049   3.000   0.0027 ** 
#   Probe_type_Base:Stimulus_type_Base                      2.0213     0.2275   8.886  < 2e-16 ***
#   Probe_type_Base:Response_type_Base                      1.4231     0.2247   6.334 2.39e-10 ***
#   Stimulus_type_Base:Response_type_Base                   0.4316     0.1787   2.415   0.0157 *  
#   Probe_type_Base:Stimulus_type_Base:Response_type_Base   0.8224     0.3646   2.256   0.0241 *  
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# Correlation of Fixed Effects:
#             (Intr) Prb__B Stm__B Rsp__B Pr__B:S__B P__B:R S__B:R
# Prob_typ_Bs  0.093                                              
# Stmls_typ_B -0.028  0.311                                       
# Rspns_typ_B  0.354  0.115  0.000                                
# Prb__B:S__B  0.080  0.193 -0.133  0.116                         
# Prb__B:R__B  0.040  0.168  0.109 -0.167  0.157                  
# Stm__B:R__B  0.068  0.076  0.200  0.270  0.102      0.176       
# P__B:S__B:R  0.065  0.092  0.094  0.172  0.259      0.301 -0.140

#Base model used
Short.0 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.0)

# AIC      BIC      logLik deviance df.resid 
# 5016.0   5123.2  -2493.0   4986.0     9395 
# 
# Scaled residuals: 
#   Min       1Q   Median      3Q     Max 
# -8.9031 -0.2071 -0.1200  0.2716  8.9244 
# 
# Random effects:
# Groups  Name               Variance Std.Dev. Corr             
# ID      (Intercept)        0.4238   0.6510                    
# Subject (Intercept)        0.3183   0.5641                    
#         Probe_type_Base    1.3718   1.1712    0.20            
#         Stimulus_type_Base 0.1410   0.3756   -0.42  0.50      
# Number of obs: 9410, groups:  ID, 256; Subject, 41
# 
# Fixed effects:
#                                                           Estimate  Std. Error    z value    Pr(>|z|)    
#   (Intercept)                                            -0.46932     0.11048      -4.248     2.16e-05 ***
#   Probe_type_Base                                         5.87002     0.21727      27.017      < 2e-16 ***
#   Stimulus_type_Base                                      0.84454     0.11675      7.234      4.70e-13 ***
#   Response_type_Base                                      0.31711     0.08855      3.581      0.000342 ** 
#   Probe_type_Base:Stimulus_type_Base                      1.99103     0.19452      10.236      < 2e-16 ***
#   Probe_type_Base:Response_type_Base                      1.16962     0.17725      6.599      4.15e-11 ***
#   Stimulus_type_Base:Response_type_Base                   0.39156     0.17717      2.210      0.027095 *  
#   Probe_type_Base:Stimulus_type_Base:Response_type_Base   0.81308     0.35402      2.297      0.021637 *  
#   ---
#   Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
# 
# Correlation of Fixed Effects:
#              (Intr) Prb__B Stm__B Rsp__B Pr__B:S__B P__B:R  S__B:R
# Prob_typ_Bs  0.075                                              
# Stmls_typ_B -0.051  0.322                                       
# Rspns_typ_B  0.096  0.053  0.129                                
# Prb__B:S__B  0.090  0.150 -0.127  0.135                         
# Prb__B:R__B  0.048  0.108  0.120 -0.157   0.152                  
# Stm__B:R__B  0.066  0.063  0.186  0.305   0.108      0.163       
# P__B:S__B:R  0.059  0.068  0.091  0.162   0.213      0.305  -0.160

################################################################# MODEL COMPARISONS #################################################################

############################################################## *Response bias ##############################################################

#no intercept
Short.1 <- glmer(Response_button ~ 0 + Probe_type_Base*Stimulus_type_Base*Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.1)

anova(Short.0, Short.1)

#         Df    AIC    BIC  logLik deviance   Chisq   Chi Df    Pr(>Chisq)    
# Short.1 14 5029.6 5129.7 -2500.8   5001.6                            
# Short.0 15 5016.0 5123.2 -2493.0   4986.0   15.571       1    7.947e-05 ***

#no probe type (Target vs. Foil)
Short.2 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Probe_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.2)

anova(Short.0, Short.2)

#         Df    AIC    BIC  logLik deviance   Chisq     Chi Df    Pr(>Chisq)    
# Short.2 14 5133.8 5233.8 -2552.9   5105.8                             
# Short.0 15 5016.0 5123.1 -2493.0   4986.0   119.75         1    < 2.2e-16 ***

#no stimulus type (Picture-only vs. Picture+word)
#this somehow not converges which is extremely weird because I ran all of these on a separate computer and it converged -- that's where the values below come from. Every single other model gave an identical output to the output I got from the other computer. In any case, this is a response bias measure which I don't discuss much. My original model is definitely overfitted so I would have to change the random effect structure which I would rather not do for this.
Short.3 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Stimulus_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.3)

anova(Short.0, Short.3)

#         Df    AIC    BIC  logLik  deviance    Chisq     Chi Df    Pr(>Chisq)    
# Short.3 14 5052.9 5153.0 -2512.4    5024.9                             
# Short.0 15 5016.0 5123.2 -2493.0    4986.0    38.89         1    4.485e-10 ***

#no response type (Aloud vs. Silent)
Short.4 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.4)

anova(Short.0, Short.4)

#         Df    AIC    BIC    logLik  deviance    Chisq     Chi Df  Pr(>Chisq)   
# Short.4 14   5026 5126.1     -2499      4998                            
# Short.0 15   5016 5123.2     -2493      4986    12.019        1   0.0005265 **

#no stimulus*response
Short.5 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Stimulus_type_Base:Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.5)

anova(Short.0, Short.5)

#         Df    AIC    BIC  logLik deviance    Chisq   Chi Df   Pr(>Chisq)  
# Short.5 14 5018.6 5118.7 -2495.3   4990.6                           
# Short.0 15 5016.0 5123.2 -2493.0   4986.0    4.586        1    0.03223 *

################################################################ *Sensitivity ################################################################

#no main effect of stimulus
Short.6 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Probe_type_Base:Stimulus_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.6)

anova(Short.0, Short.6)

#         Df    AIC    BIC  logLik deviance Chisq   Chi Df  Pr(>Chisq)    
# Short.6 14 5115.8 5215.9 -2543.9   5087.8                            
# Short.0 15 5016.0 5123.2 -2493.0   4986.0 101.78      1   < 2.2e-16 ***

#no main effect of response
Short.7 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Probe_type_Base:Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.7)

anova(Short.0, Short.7)

#         Df    AIC    BIC  logLik deviance    Chisq   Chi Df Pr(>Chisq)    
# Short.7 14 5055.9 5156.0   -2514   5027.9                             
# Short.0 15 5016.0 5123.2   -2493   4986.0   41.923       1  9.494e-11 ***

#no three-way interaction
Short.8 <- glmer(Response_button ~ Probe_type_Base*Stimulus_type_Base*Response_type_Base - Probe_type_Base:Stimulus_type_Base:Response_type_Base + (1|ID) + (1+Probe_type_Base+Stimulus_type_Base|Subject), data = AHa_short, family = binomial, control = glmerControl(optimizer = "bobyqa", optCtrl=list(maxfun=20000)))
summary(Short.8)

anova(Short.0, Short.8)

#         Df    AIC    BIC  logLik deviance  Chisq    Chi Df Pr(>Chisq)  
# Short.8 14   5019 5119.1 -2495.5   4991                           
# Short.0 15   5016 5123.2 -2493.0   4986    4.958        1    0.02597 *