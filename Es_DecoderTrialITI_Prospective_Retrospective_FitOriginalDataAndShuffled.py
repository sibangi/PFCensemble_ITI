# -*- coding: utf-8 -*-
"""
Created on Tue Sep 13 14:19:00 2016

@author: Silvia Maggi
Code adapted from http://scikit-learn.org/stable/auto_examples/classification/plot_classifier_comparison.html

# Code source: Gaël Varoquaux
#              Andreas Müller
# Modified for documentation by Jaques Grobler
# License: BSD 3 clause

This script quantified the decoder accuracy for outcome, direction and light
from the population firing rate. It computes also the decoder accuracy for the 
shuffled control model. Ten classifiers are tested here but only three have 
been shown in Maggi et a., 2018   
"""

import numpy as np
#import MyLib
from scipy.io import matlab
import matplotlib.pylab as pl
import seaborn as sb
from scipy.stats import sem
from sklearn.cross_validation import LeaveOneOut
from sklearn.preprocessing import StandardScaler
from sklearn.neighbors import KNeighborsClassifier
from sklearn.svm import SVC
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier, AdaBoostClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.discriminant_analysis import QuadraticDiscriminantAnalysis
from sklearn.linear_model import LogisticRegression

# Load_Behavior loads all the behavioural datasets for each sessions
# Behav is a structure where each element is a 6 colums data:
# 1st: trial start (ms)
# 2nd: Trial end  (ms)
# 3rd: trial rule (1: go right, 2: go the lit arm; 
#      3: go left, 4: go to dark arm)
# 4th: correct (1) or incorrect (0) trial
# 5th: the animal went right (0) or left (1)
# 6th: light location (switched on randomly at the beginning of each trial, 
#      even for left/right tasks). 1 or 0 (right or left)
Behav = []
exec(open('Load_Behavior.py').read()) 


############################################################
# Test different classification methods
names = ["Nearest Neighbors", "Linear SVM", "RBF SVM", "Decision Tree",
                 "Random Forest", "AdaBoost", "Naive Bayes", "Linear Discriminant Analysis",
                 "Quadratic Discriminant Analysis","LogisticRegression"]

classifiers = [
    KNeighborsClassifier(3),
    SVC(kernel="linear", C=0.025),
    SVC(gamma=.5, C=1),
    DecisionTreeClassifier(max_depth=5),
    RandomForestClassifier(max_depth=5, n_estimators=10, max_features=1),
    AdaBoostClassifier(),
    GaussianNB(),
    LinearDiscriminantAnalysis(),
    QuadraticDiscriminantAnalysis(),
    LogisticRegression()]
############################################################                              
ngrps = np.shape(names)[0]
LearnSes = [0, 2, 6, 13, 18, 27, 31, 40, 43, 45] # ID for the learning sessions
ndata = 50 # number of sessions 
nsez = 6 # number of maze partition +1
nperm = 10 # number of permutation for the shuffle control
TrType = 'ITI' # here defined Trial or ITI
decode = ['outcome', 'direction', 'light'] # task features to decode
############################################################  

for d in np.arange(0,len(decode)):
    
    score = np.zeros((ndata,nsez-1,ngrps))
    score_retro = np.zeros((ndata,nsez-1,ngrps))
    score_train = np.zeros((ndata,nsez-1,ngrps))
    score_train_retro = np.zeros((ndata,nsez-1,ngrps))
    
    score_shuf = np.zeros((ndata,nsez-1,ngrps))
    score_retro_shuf = np.zeros((ndata,nsez-1,ngrps))
    
    for k in np.arange(0,ndata): 

        # check for the presence of binary features
        if np.shape(np.unique(Behav[k][decode[d]][:-1]))[0]==1:
            continue
        
        # load Trial or ITI firing rate for each cell in the 5 section of the 
        # linearized maze. Then identify the prospective and retrospective 
        # classification of the Trials/ITIs for each decoded feature 
        if TrType == 'ITI':
            ITITrial = matlab.loadmat(('Processed Data/ITI_LinearizedFiringRateAlongMaze_%i_nsez_%i.mat' %(k+1,nsez)))
            erID_retro = np.where(Behav[k][decode[d]][:-1]==0)[0]
            corID_retro = np.where(Behav[k][decode[d]][:-1]==1)[0]
            erID = np.where(Behav[k][decode[d]][1:]==0)[0]
            corID = np.where(Behav[k][decode[d]][1:]==1)[0]
        elif TrType == 'Trial':
            ITITrial = matlab.loadmat(('Processed Data/Trial_LinearizedFiringRateAlongMaze_%i_nsez_%i.mat' %(k+1,nsez)))
            erID = np.where(Behav[k][decode[d]]==0)[0]
            corID = np.where(Behav[k][decode[d]]==1)[0]
            erID_retro = np.where(Behav[k][decode[d]][:-1]==0)[0]
            corID_retro = np.where(Behav[k][decode[d]][:-1]==1)[0]
            
        for section in np.arange(0,nsez-1):
            
            Data = ITITrial['Firing'][:,:,section]
             
            if TrType == 'ITI':
                X_retro = Data
                y_retro = Behav[k][decode[d]][:-1]
                ############################################################
                X = Data
                y = Behav[k][decode[d]][1:]
            elif TrType == 'Trial':
                X = Data
                y = Behav[k][decode[d]]
                ############################################################
                X_retro = Data[1:,:]
                y_retro = Behav[k][decode[d]][:-1]
            ############################################################    
            # Standardize features by removing the nanmean and scaling to unit variance
            X = StandardScaler().fit_transform(X)
            X_retro = StandardScaler().fit_transform(X_retro)
            #******************************
            # Random train and test subsets of my data using leave-one-out 
            loo = LeaveOneOut(y.shape[0])
            
            nome = 0
            for name, clf in zip(names, classifiers):
                scoreCoef = []; scoreCoefEr = []; scoreCoefCor = []
                scoreCoef_retro = []; scoreCoefEr_retro = []; scoreCoefCor_retro = []
                
                scoreCoef_train = []; scoreCoef_train_retro = [];
    
                scoreCoef_shuf = []; scoreCoef_retro_shuf = [];                       
                
                for train, test in loo:            
                    # Prospective component
                    X_train, X_test = X[train], X[test]
                    y_train, y_test = y[train], y[test] 
                    if 2 <= np.sum(y[train]) <= np.shape(y_train)[0]-2:
                        clf.fit(X_train, y_train)
                        scoreCoef.append(clf.score(X_test, y_test))
                        scoreCoef_train.append(clf.score(X_train, y_train))
    
                        # Shuffled Prospective component
                        for perm in np.arange(0,nperm):              
                            y_sh = np.random.permutation(y)
                            X_train, X_test = X[train], X[test]
                            y_train_sh, y_test_sh = y_sh[train], y_sh[test] 
                            if 2 <= np.sum(y_sh[train]) <= np.shape(y_train_sh)[0]-2:
                                clf.fit(X_train, y_train_sh)
                                scoreCoef_shuf.append(clf.score(X_test, y_test_sh))
                        
                    # ***********************
                    # Retrospective component
                    if train[-1]==np.shape(y_retro)[0]:
                        train = train[:-1]
                    elif test == np.shape(y_retro)[0]:
                        continue
                    X_train_retro, X_test_retro = X_retro[train], X_retro[test]
                    y_train_retro, y_test_retro = y_retro[train], y_retro[test] 
                    
                    if 2 <= np.sum(y_retro[train]) <= np.shape(y_train_retro)[0]-2:
                        clf.fit(X_train_retro, y_train_retro)
                        scoreCoef_retro.append(clf.score(X_test_retro, y_test_retro))  
                        scoreCoef_train_retro.append(clf.score(X_train_retro, y_train_retro))
    
                        # Shuffled Retrospective component
                        for perm in np.arange(0,nperm):              
                            y_retro_sh = np.random.permutation(y_retro)
                            X_train_retro, X_test_retro = X_retro[train], X_retro[test]
                            y_train_retro_sh, y_test_retro_sh = y_retro_sh[train], y_retro_sh[test]                     
                            if 2 <= np.sum(y_retro_sh[train]) <= np.shape(y_train_retro_sh)[0]-2:
                                clf.fit(X_train_retro, y_train_retro_sh)
                                scoreCoef_retro_shuf.append(clf.score(X_test_retro, y_test_retro_sh))  
                        
                score[k,section,nome] = np.mean(scoreCoef)
                score_shuf[k,section,nome] = np.mean(scoreCoef_shuf)
                score_retro_shuf[k,section,nome] = np.mean(scoreCoef_retro_shuf)
                # ********************            
                score_retro[k,section,nome] = np.mean(scoreCoef_retro)
                # ********************
                score_train[k,section,nome] = np.mean(scoreCoef_train)
                score_train_retro[k,section,nome] = np.mean(scoreCoef_train_retro)
                # ********************
                nome += 1
           
    score[score==0]=['nan']
    score_retro[score_retro==0]=['nan']
    score_shuf[score_shuf==0]=['nan']
    score_retro_shuf[score_retro_shuf==0]=['nan']
    score_train[score_train==0]=['nan']
    score_train_retro[score_train_retro==0]=['nan']
    
    SCORE = np.array(score)
    SCORE_retro = np.array(score_retro)
    
    SCORE_shuf = np.array(score_shuf) 
    SCORE_retro_shuf = np.array(score_retro_shuf)
    
    SCORE_train = np.array(score_train)
    SCORE_train_retro = np.array(score_train_retro)
    
    NonLearn = np.setxor1d(np.arange(0,ndata),LearnSes)
  
#    Save the SCORE matrices into file
#    np.savez(TrType+'_ScoreMatrixFromClassifier_LinearizedFR_FitOriginalAndShuffledData_'+decode[d], 
#             SCORE=SCORE, SCORE_retro=SCORE_retro, SCORE_shuf=SCORE_shuf, SCORE_retro_shuf=SCORE_retro_shuf)
    
    
    pl.figure()
    for gr in np.arange(0,ngrps):
        pl.subplot(2,5,gr+1)
        pl.errorbar(np.arange(1,nsez),np.nanmean(SCORE[LearnSes,:,gr],0),sem(SCORE[LearnSes,:,gr],0,nan_policy='omit'),fmt='bo-',label='Prospective')
        pl.errorbar(np.arange(1,nsez),np.nanmean(SCORE_shuf[LearnSes,:,gr],0),sem(SCORE_shuf[LearnSes,:,gr],0,nan_policy='omit'),fmt='r^-',label='Shuffled Prospective')
        pl.plot([0,nsez],[0.5,0.5],'k--')
        pl.ylim((0, 1.1))
        pl.ylabel(TrType+' Score learn '+decode[d])
        pl.xlabel('Maze position')
        pl.title(names[gr]+' prosp')
        pl.hold(True)
    pl.subplot(2,5,1)
    pl.legend()
    
    pl.figure()
    for gr in np.arange(0,ngrps):
        pl.subplot(2,5,gr+1)
        pl.errorbar(np.arange(1,nsez),np.nanmean(SCORE_retro[LearnSes,:,gr],0),sem(SCORE_retro[LearnSes,:,gr],0,nan_policy='omit'),fmt='bo-',label='Retrospective')
        pl.errorbar(np.arange(1,nsez),np.nanmean(SCORE_retro_shuf[LearnSes,:,gr],0),sem(SCORE_retro_shuf[LearnSes,:,gr],0,nan_policy='omit'),fmt='r^-',label='Shuffled Retrospective')
        pl.plot([0,nsez],[0.5,0.5],'k--')
        pl.ylim((0, 1.1))
        pl.ylabel(TrType+' Score learn'+decode[d])
        pl.xlabel('Maze position')
        pl.title(names[gr]+' retrosp')
        pl.hold(True)
    pl.subplot(2,5,1)
    pl.legend()
    
    pl.figure()
    for gr in np.arange(0,ngrps):
        pl.subplot(2,5,gr+1)
        pl.errorbar(np.arange(1,nsez),np.nanmean(SCORE[NonLearn,:,gr],0),sem(SCORE[NonLearn,:,gr],0,nan_policy='omit'),fmt='bo-',label='Prospective')
        pl.errorbar(np.arange(1,nsez),np.nanmean(SCORE_shuf[NonLearn,:,gr],0),sem(SCORE_shuf[NonLearn,:,gr],0,nan_policy='omit'),fmt='r^-',label='Shuffled Prospective')
        pl.plot([0,nsez],[0.5,0.5],'k--')
        pl.ylim((0, 1.1))
        pl.ylabel(TrType+' Score non-learn'+decode[d])
        pl.xlabel('Maze position')
        pl.title(names[gr]+' prosp')
        pl.hold(True)
    pl.subplot(2,5,1)
    pl.legend()
    
    pl.figure()
    for gr in np.arange(0,ngrps):
        pl.subplot(2,5,gr+1)
        pl.errorbar(np.arange(1,nsez),np.nanmean(SCORE_retro[NonLearn,:,gr],0),sem(SCORE_retro[NonLearn,:,gr],0,nan_policy='omit'),fmt='bo-',label='Retrospective')
        pl.errorbar(np.arange(1,nsez),np.nanmean(SCORE_retro_shuf[NonLearn,:,gr],0),sem(SCORE_retro_shuf[NonLearn,:,gr],0,nan_policy='omit'),fmt='r^-',label='Shuffled Retrospective')
        pl.plot([0,nsez],[0.5,0.5],'k--')
        pl.ylim((0, 1.1))
        pl.ylabel(TrType+' Score non-learn'+decode[d])
        pl.xlabel('Maze position')
        pl.title(names[gr]+' retrosp')
        pl.hold(True)
    pl.subplot(2,5,1)
    pl.legend()

