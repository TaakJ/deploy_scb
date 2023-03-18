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
    
    # path
    path_main  = os.getcwd()
    path_output = path_main + f'/output/{date}'
    path_table_def = path_main + f'/filename/U02_TABLE_DEFINITION/{date}'
    os.makedirs(path_table_def,exist_ok=True)
    path_int_mapp = path_main + f'/filename/U03_INT_MAPPING/{date}'
    os.makedirs(path_int_mapp,exist_ok=True)
    path_pl_register = path_main + f'/filename/U99_PL_REGISTER_CONFIG/{date}'
    os.makedirs(path_pl_register,exist_ok=True)
    path_pl_ddl = path_main + f'/filename/DDL/{date}'
    os.makedirs(path_pl_ddl,exist_ok=True)
    
    t1 = time.time()
    ## start split parameter
    print("start function split file to parameter ..")
    run_process_split(date=date, re_deploy=re_deploy).run()
    
    ## start merge 
    if any(os.scandir(path_table_def)) and any(os.scandir(path_int_mapp)) and any(os.scandir(path_pl_register)) and any(os.scandir(path_pl_ddl)):
        print("start function merge file ..")
        run_process_merge(date=date, storage=storage, container=container, re_deploy=re_deploy)

    ## start genfile
    # if glob.glob(f'{path_output}/deployment_checklist_{date_fmt}.xlsx'):
    #     print("start gen file ..")
    #     run_process_genfile(date=date)
    
    t2 = time.time() - t1
    print(f'Executed in {t2:0.2f} seconds.')

if __name__ == '__main__':
    run_main()