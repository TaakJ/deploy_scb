import os
import time
import filecmp
import difflib
import glob
import itertools
import datetime
import pandas

class check_files_for_deploy:
    
    def __init__(self, date, ddl_path):
        self.date = date 
        self.ddl_path = ddl_path
        
        ddl_path_view = os.path.join(self.ddl_path, 'VIEWS/')
        ddl_path_table = os.path.join(self.ddl_path, 'TABLES/')
        
        # if os.path.isdir(ddl_path_view) is False and os.path.isdir(ddl_path_table) is True:
        #     raise FileNotFoundError(f"Please Check Folder Views on {self.date}")
        # else:
        #     os.makedirs(ddl_path_table, exist_ok=True)
            
        # specify path edwcloud_adls from git
        adls_path_view = r'D:\Document\Coding\Project\edwcloud_adls\src\VIEWS' + '/'
        adls_path_table = r'D:\Document\Coding\Project\edwcloud_adls\src\TABLES' + '/'
        self.adls_path = [adls_path_view, adls_path_table]
    
    @property
    def _compare_directories(self):
        a = ''
        # for expected_dir, actual_dir in itertools.zip_longest(ddl_path, self.adls_path):
        #     if os.path.exists(expected_dir) and os.path.exists(actual_dir):
        #         dir_diff = filecmp.dircmp(expected_dir, actual_dir)
        #         diff_files = list(itertools.chain(dir_diff.diff_files, dir_diff.left_only)) # base from deploy
        #     else:
        #         raise Exception("Find not found folder for deploy !!")
                
        #     def safe_read_lines(path):
        #         if not os.path.exists(path):
        #             return []
        #         f = open(path, encoding='cp437')
        #         try:
        #             return f.readlines()
        #         finally:
        #             f.close()
                
        #     for diff_file in diff_files:
        #         expected_file = os.path.join(expected_dir, diff_file)
        #         actual_file = os.path.join(actual_dir, diff_file)
                
        #         if not os.path.isdir(actual_file):
        #             only = os.listdir(expected_file)
        #             for filename in only:
        #                 print(f'{os.path.join(expected_file, filename)}: new directories/files from deploy not in git')
        #         break
        #     else:
        #         for common_dir in dir_diff.common_dirs:
        #             expected_file = os.path.join(expected_dir, common_dir)
        #             actual_file = os.path.join(actual_dir, common_dir)
        #             common = list(set(os.listdir(expected_file)) & set(os.listdir(actual_file))) 
        #             only = list(set(os.listdir(expected_file)) - set(os.listdir(actual_file))) 
                    
        #             for filename in common:
        #                 flines = safe_read_lines(os.path.join(expected_file, filename))
        #                 glines = safe_read_lines(os.path.join(actual_file, filename))
        #                 d = difflib.Differ()
        #                 diffs = [x for x in d.compare(glines, flines) if x[0] in ('+', '-')]
                        
        #                 if diffs:
        #                     print(f'{os.path.join(actual_file, filename)} => Changes')
        #                     # print(diffs)
        #                 else:
        #                     print(f'{os.path.join(actual_file, filename)} => No Changes')
                            
        
        