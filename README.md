# Neural Ensemble Reactivation During Inter-Trial Intervals

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
![MATLAB](https://img.shields.io/badge/MATLAB-0076A8?style=flat&logo=mathworks&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat&logo=python&logoColor=white)
![scikit-learn](https://img.shields.io/badge/scikit--learn-F7931E?style=flat&logo=scikitlearn&logoColor=white)

Analysis code and data for:

> **Maggi, S. et al. (2018).** *Prefrontal cortex ensemble reactivation during inter-trial intervals.*
> [bioRxiv preprint](https://www.biorxiv.org/content/early/2018/03/20/187948)

## Overview

This repository investigates how neural population activity in the prefrontal cortex (PFC) is reactivated during inter-trial intervals (ITIs) of a rule-switching decision-making task. The analysis spans 50 recording sessions and asks whether ensemble patterns during ITIs carry information about past outcomes and future decisions.

Key analyses include:

- **Recall matrices** — pairwise similarity of population vectors across ITIs, measuring ensemble reactivation strength
- **Residual recall** — controlling for temporal autocorrelation via inter-spike-interval (ISI) shuffling
- **Multi-classifier decoding** — 10 classifiers (KNN, Linear SVM, RBF SVM, Decision Tree, Random Forest, AdaBoost, Naive Bayes, LDA, QDA, Logistic Regression) decode task features from population firing rates
- **Prospective and retrospective coding** — whether ITI activity predicts upcoming or reflects previous trial outcomes, directions, and cue locations
- **Session-type comparisons** — learning sessions vs rule-change vs stable performance

Original electrophysiology data from [CRCNS pfc-6](https://crcns.org/data-sets/pfc/pfc-6/about-pfc-6).

## Repository Structure

```
PFCensemble_ITI/
├── Es_DecoderTrialITI_...py       # Multi-classifier decoder (Python/scikit-learn)
├── Es_Recall_ShuffleISI.m         # Recall matrix computation with ISI shuffle control
│
├── Figure2_DeltaRecall_Reward.m   # Figure 2: Delta recall between error/correct ITIs
├── Figure5_Classifier.m           # Figures 5–6: Classifier accuracy across session types
│
├── F_DeleteCell_spikingCell.m     # Filter neurons by minimum spike count
├── F_SimilarityMatrix.m           # Compute population vector similarity matrices
├── Load_Behavior.m                # Load behavioural data for all 50 sessions
├── Load_CellType.m                # Load neuron classification metadata
├── figure_properties.m            # Shared figure formatting parameters
├── nansem.m                       # Standard error of the mean (NaN-safe)
├── b2r.m                          # Blue-to-red diverging colormap (third-party)
│
├── Data/                          # Behavioural data (50 sessions, date-stamped)
└── Processed Data/                # Pre-computed results (recall matrices, classifier scores)
```

## Quick Start

### Reproduce figures (MATLAB)

```matlab
% Figure 2: ensemble reactivation and reward-driven recall
run('Figure2_DeltaRecall_Reward.m')

% Figures 5–6: classifier accuracy across session types
run('Figure5_Classifier.m')
```

### Run the decoder pipeline (Python)

```python
python Es_DecoderTrialITI_Prospective_Retrospective_FitOriginalDataAndShuffled.py
```

## Methods

| Method | Language | Application |
|---|---|---|
| Population vector correlation | MATLAB | Recall and similarity matrices |
| ISI shuffle control | MATLAB | Residual recall (temporal autocorrelation removal) |
| Leave-one-out cross-validation | Python | Decoder accuracy estimation |
| 10-classifier comparison | Python | Robust decoding of outcome, direction, cue from firing rates |
| Kolmogorov–Smirnov test | MATLAB | Error vs correct recall distributions |
| Sign test | MATLAB | Session-level delta recall significance |

## Dependencies

**MATLAB:**
- Statistics and Machine Learning Toolbox (`kstest2`, `boxplot`)

**Python:**
- numpy, scipy, matplotlib, seaborn
- scikit-learn (`KNeighborsClassifier`, `SVC`, `RandomForestClassifier`, `LinearDiscriminantAnalysis`, `LogisticRegression`, etc.)

## Data

The `Data/` folder contains behavioural data for 50 recording sessions. The `Processed Data/` folder contains pre-computed recall matrices and classifier scores needed to reproduce the figures.

For the complete electrophysiology dataset, see [CRCNS pfc-6](https://crcns.org/data-sets/pfc/pfc-6/about-pfc-6).

## Citation

If you use this code or data, please cite:

> Maggi, S. et al. (2018). *Prefrontal cortex ensemble reactivation during inter-trial intervals.*
> [bioRxiv:187948](https://www.biorxiv.org/content/early/2018/03/20/187948)

## License

This project is licensed under the MIT License — see [LICENSE](LICENSE) for details.
