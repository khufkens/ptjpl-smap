# CONVERT MODEL OUTPUT TO MONTHLY AND YEARLY DATASETS
# KH: generally does not alter the output results

import sys
import os
import glob
import numpy as np

res = 9
in_dir = './data/test_data_AJ/results/'
out_dir = './test/'

os.chdir(in_dir)
fileList = glob.glob('*.nc')

for fName in fileList:
  os.system('ncatted -a _FillValue,,o,f,NaN '+fName)
  os.system('ncatted -a _FillValue,,m,f,1.0e36 '+fName)
  print(fName + ' updated for NCO fill values')

years = [2015,2016,2017]
month_lookup={'2015':(4,12),'2016':(1,12),'2017':(1,4)}

for year in years:
 yyyy = str(year)
 inds = (month_lookup[yyyy])
 start_month = (inds[0])
 end_month   = (inds[1])
 for month in np.arange(start_month,end_month+1):
  mean_file_cmd = 'nces '
  mm = str(month).zfill(2)
  files = glob.glob('PTJPL_SMAP_ET_'+ yyyy + mm + '*_' + '9km_AM.nc')
  if len(files) != 0:
   for file_str in files:
    mean_file_cmd = mean_file_cmd + file_str + ' '
   print(mean_file_cmd)
   os.system(mean_file_cmd +' '+ out_dir+'PTJPL_SMAP_ET_'+yyyy+mm+'_mean_'+str(res)+'km.nc')
