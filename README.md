# ptjpl-smap
PT-JPLsm Model 
Code to run the global model used in Purdy et al., 2018

Details on the model can be found below
https://www.sciencedirect.com/science/article/pii/S0034425718304401

## default reference run

An environment file has been create to run in a consistent python environment.

This file can be loaded using:

```
conda env create -f environment.yml
```

and activated using

```
conda activate ptjpl
```

The code has been adjusted to run a default analysis on data put in
`data/test_data_AJ`. This contains all required data and the `config.json`
required to run the latest code release (i.e. `_run_ptjpl_smap_global_gp_rhsm_.py`).

An Rproj file has been added to load the repository as an R project, to allow
for quick spatial analysis. Analysis scripts are in the `analysis` folder with
figures stored in the `figures` folder.