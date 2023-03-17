import os
import glob
import datetime
import time
from split import run_process_split
from deploy_release import run_process_genfile
from merge import run_process_merge

class run_main:
    
    # Can specify deploy date
    date = "2023-03-17"
    re_deploy = ""
    date_fmt = datetime.datetime.strptime(date, '%Y-%m-%d').strftime('%Y%m%d')
    # Can specify storage 
    storage = "scbedwseasta001adlsuat"
    # Can specify container 
    container = "edw-ctn-landing"
    
    path = os.getcwd() + f'/output/{date}'
    
    t1 = time.time()
    ## start split parameter
    print("start split file to parameter ..")
    run_process_split(date=date, re_deploy=re_deploy).run()
    
    ## start merge 
    run_process_merge(date=date, storage=storage, container=container, re_deploy=re_deploy)
    
    ## start genfile
    if glob.glob(f'{path}/deployment_checklist_{date_fmt}.xlsx'):
        print("start gen file ..")
        run_process_genfile(date=date)
    
    t2 = time.time() - t1
    print(f'Executed in {t2:0.2f} seconds.')

if __name__ == '__main__':
    run_main()