# DSCI100GroupProject

## Setup

1. Install anaconda.
2. Create conda env: `conda create --name dsci100_project python=3.7`
3. Activate the cond env: `conda activate dsci100_project`
4. Added conda channel: `conda config --add channels conda-forge`
5. Install key packages.
 ```
 conda install -c conda-forge jupyter
 conda install -c conda-forge r-irkernel
 conda install -c conda-forge r-tidyverse
 conda install -c conda-forge r-tidymodels
 conda install -c conda-forge r-ggally
 conda install -c conda-forge r-cowplot
 conda install -c conda-forge r-kknn
 ```


## Data Source
https://archive.ics.uci.edu/ml/datasets/Heart+Disease

## Notes on Dataset

- Hungarian: `reprocessed.hungarian.data`
  - delimiter: `" "` (space)
- Cleveland: `processed.cleveland.data`
  - delimiter: `","` (comma)
- Switzerland: `processed.switzerland.data`
  - delimiter: `","` (comma)
- Long Beach VA: `processed.va.data`
  - delimiter: `","` (comma)
