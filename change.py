import os
import time
import filecmp
import difflib
import glob
import itertools
import datetime
import pandas

class check_files_for_deploy:
    
    def __init__(self, date):
        self.date = date 
        self.date_fmt = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')
        path = os.getcwd() + f'/filename/DDL/{self.date}'
        adls_path_view = r'D:\Document\Coding\Project\edwcloud_adls\src\VIEWS' + '/'  # right from git
        adls_path_table = r'D:\Document\Coding\Project\edwcloud_adls\src\TABLES' + '/'
        ddl_path = [path + '/VIEW/', path + '/TABLE/']
        adls_path = [adls_path_view, adls_path_table]
        self._compare_directories(ddl_path, adls_path)
        
        # current_path = os.getcwd() + f'/output/{self.date}'
        # filename = max(glob.glob(f'{current_path}/deployment_checklist_{self.date_fmt}.xlsx'), key=os.path.getmtime)
        # if filename != "":
        #     self.check_deploy_release()
        # else:
        #     raise ValueError("File not found !!")
        
        # self.str_mvp = ['MVP1','MVP2','MVP3','MVP4','MVP6']
        # self.list_ur = ['SI-523_SR-10142_SR-10143', 'SI-523_SR-5512_SR-5622', 'SI-523_SR-5513_SR-5956', 'SI-523_SR-5515_SR-12745']
        # for str_mvp, ur_number in zip(self.str_mvp, self.list_ur):
        #     path = os.getcwd() + os.path.join(f'/output/{self.date}', ur_number)
        #     filename = max(glob.glob(f'{path}/00_deployList_{ur_number}_{str_mvp}_UAT.txt'), key=os.path.getmtime)
            
        #     if filename != "":
        #         self.check_deploy_release(str_mvp, filename)
        #     else:
        #         print(f"Find not found deploy_release {str_mvp}!!")
    
    # def check_deploy_release(self, str_mvp,filename):
    #     df = pandas.read_csv(filename, sep=",", header=None, names=['Storage','Container','Full_Path','Path'])
    
    def _compare_directories(self, ddl_path, adls_path):
        
        print("============================ check change ==============================")
        for expected_dir, actual_dir in itertools.zip_longest(ddl_path, adls_path):
            if os.path.exists(expected_dir) and os.path.exists(actual_dir):
                dir_diff = filecmp.dircmp(expected_dir, actual_dir)
                diff_files = list(itertools.chain(dir_diff.diff_files, dir_diff.left_only)) # base from deploy
            else:
                raise Exception("Find not found folder for deploy !!")
                
            def safe_read_lines(path):
                if not os.path.exists(path):
                    return []
                f = open(path, encoding='cp437')
                try:
                    return f.readlines()
                finally:
                    f.close()
                
            for diff_file in diff_files:
                expected_file = os.path.join(expected_dir, diff_file)
                actual_file = os.path.join(actual_dir, diff_file)
                
                if not os.path.isdir(actual_file):
                    only = os.listdir(expected_file)
                    for filename in only:
                        print(f'{os.path.join(expected_file, filename)}: new directories/files from deploy not in git')
                break
            else:
                for common_dir in dir_diff.common_dirs:
                    expected_file = os.path.join(expected_dir, common_dir)
                    actual_file = os.path.join(actual_dir, common_dir)
                    common = list(set(os.listdir(expected_file)) & set(os.listdir(actual_file))) 
                    only = list(set(os.listdir(expected_file)) - set(os.listdir(actual_file))) 
                    
                    for filename in common:
                        flines = safe_read_lines(os.path.join(expected_file, filename))
                        glines = safe_read_lines(os.path.join(actual_file, filename))
                        d = difflib.Differ()
                        diffs = [x for x in d.compare(glines, flines) if x[0] in ('+', '-')]
                        
                        if diffs:
                            print(f'{os.path.join(actual_file, filename)} => Changes')
                            # print(diffs)
                        else:
                            print(f'{os.path.join(actual_file, filename)} => No Changes')
                    
                    # if only != []:
                    #     for filename in only:
                    #         print(f'{os.path.join(actual_file, filename)} => New add')
        print("================================================================")
        
        