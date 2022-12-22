[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7464071.svg)](https://zenodo.org/record/7464071)

# SRIL34
Configuration of the SRIL34 model. The model domain covers the area around Sri Lanka with aproximatly 1/60th degree resolution, and is based on GEBCO bathymetry. It uses ERA5 forcing data and Copernicus (CMEMS) reanalysis data.

![Bathymetry (2)](https://user-images.githubusercontent.com/43344192/174807810-a73619a2-6298-438f-ac64-65f1306a1d9e.png)

# Repository Content

This repository contains the scripts and initialisation file to run the SRIL34 model (physics only), as well as the SRIL34-ERSEM (passive tracers) configuration. It contains instructions for: 
- setting up paths and file directory structure
- compiling xios
- compiling NEMO and tools
- compiling FABM and ERSEM 
- setting up the SRIL34 domain 
- installing PyNEMO  
- creating open boundary conditions 
- Creating ERA5 forcing 
- running the SRIL34 model. 

# Getting Started

To get started, clone this repository

```
git clone https://github.com/NOC-MSM/SRIL34.git
```

then follow the instructions on the [wiki](https://github.com/NOC-MSM/SRIL34/wiki)
 

