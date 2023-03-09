import os
import time
from split import run_process_split
from deploy_release import run_process_genfile
from merge import run_process_merge
from change import check_files_for_deploy

class run_main:
    
    # Can specify deploy date
    date = "2023-02-27"
    # Can specify storage 
    storage = "scbedwseasta001adlsuat"
    # Can specify container 
    container = "edw-ctn-landing"
    
    t1 = time.time()
    ## start split parameter
    run_process_split(date=date).run()
    
    ## start merge 
    # run_process_merge(date=date, storage=storage, container=container)
    
    ## start genfile
    # run_process_genfile(date=date)
    
    ## start change
    # check_files_for_deploy(date=date)
    
    t2 = time.time() - t1
    print(f'Executed in {t2:0.2f} seconds.')

if __name__ == '__main__':
    run_main()