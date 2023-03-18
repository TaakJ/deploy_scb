import os
import glob
import datetime
import time
from split import run_process_split
from deploy_release import run_process_genfile
from merge import run_process_merge

class run_main:
    
    # Can specify deploy date
    date = "2023-03-18"
    re_deploy = ""
    date_fmt = datetime.datetime.strptime(date, '%Y-%m-%d').strftime('%Y%m%d')
    # Can specify storage 
    storage = "scbedwseasta001adlsuat"
    # Can specify container 
    container = "edw-ctn-landing"
    
    t1 = time.time()
    ## start split 
    print("start function split file ..")
    run_process_split(date=date, re_deploy=re_deploy).run()
    
    ## start merge 
    print("start function merge file ..")
    run_process_merge(date=date, storage=storage, container=container, re_deploy=re_deploy)

    # start genfile
    # print("start function gen file ..")
    # run_process_genfile(date=date)
    
    t2 = time.time() - t1
    print(f'Executed in {t2:0.2f} seconds.')

if __name__ == '__main__':
    run_main()