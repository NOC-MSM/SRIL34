% Note: this is based on the GCOMS1K repository https://github.com/NOC-MSM/GCOMS1k/wiki/GCOMS1k-Domains

addpath(genpath('/login/jdha/matlab/new_matlab/utilities/ann_mwrapper'))

git_path='/work/<user>/GCOMS1k/STARTFILES/';
projects_path='/work/<user>/GCOMS1k/';

domain_path='/work/<user>/GCOMS1k/INPUTS/';
domain_outpath='/work/<user>GCOMS1k/OUTPUT/';
assess_path='/work/<user>/GCOMS1k/ASSESSMENT/';

parent_path_coords='<PATH>';
parent_path='<PATH>';
Re=6367456.0*pi/180;
tiny=1e-6;
