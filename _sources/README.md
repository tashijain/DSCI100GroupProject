# DSCI-100 Group Project


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
 conda install -c conda-forge ghp-import
 ```


## Build and Publish
1. Open a terminal (powershell or otherwise).
2. Activate conda environment: `conda activate dsci100_project`
4. Move to your project root folder: `cd ABSOLUTE/PATH/TO/PROJECT/FOLDER`
5. Build page: `jupyter-book build .`
6. Publish html to Github Pages: `ghp-import -n -p -f _build/html`


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
