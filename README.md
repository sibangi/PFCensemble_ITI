# PFCensemble_ITI
Code to reproduce the main results of Maggi et al., 2018 (https://www.biorxiv.org/content/early/2018/03/20/187948).

# Summary
This repository contains the matlab and python scripts to reproduce the main results of the Maggi et al., 2018 paper. This work was based on the analysis of data available from https://crcns.org/data-sets/pfc/pfc-6/about-pfc-6 .

The code starting with "Es_" are the scripts to performe the main analyses (Recall matrix and decoder). Some pre-processing of the data is necessary to run those scripts. The functions called in the main scripts are also included in the repository (typically starting with "F_").

The two scripts "Figure2_DeltaRecall_Reward" and "Figure5_Classifier" reproduce the panels in Figure 2, Figure 5 and 6 of the manuscript. All the Data and Processed Data required to compile those scripts are provided in the relative subfolders:

The Data subfolder contains only the behavioural data necessary to reproduce the figures. For the complete dataset refer to the link above.

The Processed Data subfolder containes the processed data necessary to reproduce the results in Figure 2, 5 and 6, and many more results in the paper (such as Figure 3, part of Supplementary Figure S3, Supplementary Figure S8 and S9).
