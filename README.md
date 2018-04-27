# PFCensemble_ITI
Codes to reproduce the main results of Maggi et al., 2018 (https://www.biorxiv.org/content/early/2018/03/20/187948).

# Summary
This repository contains the matlab and python scripts to reproduce the main results of Maggi et al., 2018 paper. This work was based on the analysis of data available from https://crcns.org/data-sets/pfc/pfc-6/about-pfc-6 .

The codes starting with "Es_" are the codes to performe the main analyses (Recall matrix and decoder). Some pre-processing of the data is necessary to run those scripts. The functions called in the main scripts are also added into the repository (typically starting with "F_").

The two scripts "Figure2_DeltaRecall_Reward" and "Figure5_Classifier" reproduce the panels in Figure 2 and Figure 5 of the manuscript, respectively. All the Data and Processed Data required to compile those scripts are provided in the relative subfolder.

The Data subfolder contains only the behavioural data necessary to reproduce the figures. For the complete dataset refer to the link above.

The Processed Data subfolder containes the processed data necessary to reproduce the results in Figure 2 and 5 and many more results (such as Figure 3, Figure 6, part of Supplementary Figure S3, Supplementary Figure S8 and S9).
