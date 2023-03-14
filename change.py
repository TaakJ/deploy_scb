import os
import time
import filecmp
import difflib
import glob
import itertools
import datetime
import pandas
from pathlib import Path

class check_files_for_deploy:
    
    def __init__(self, date, ddl_path):
        self.date = date 
        self.ddl_path = ddl_path
        
        # specify path edwcloud_adls from git
        os.chdir('../')
        main_path = os.getcwd()
        # git edwcloud_adls
        adls_path_view = os.path.join(main_path, 'edwcloud_adls/src/VIEWS/')
        adls_path_table = os.path.join(main_path, 'edwcloud_adls\src\TABLES/')
        self.adls_path = [adls_path_view, adls_path_table]
        
        ddl_path_view = os.path.join(self.ddl_path, 'VIEWS/')
        ddl_path_table = os.path.join(self.ddl_path, 'TABLES/')
        
        if os.path.isdir(ddl_path_view) is False and os.path.isdir(ddl_path_table) is True:
            raise FileNotFoundError(f"Please Check Folder Views on {self.date}")
        else:
            os.makedirs(ddl_path_table, exist_ok=True)
        self.ddl_path = [ddl_path_view, ddl_path_table]
    
    @property
    def _compare_directories(self):
        
        for ddl_path, git_path in itertools.zip_longest(self.ddl_path, self.adls_path):
            if os.path.exists(ddl_path) and os.path.exists(git_path):
                dir_diff = filecmp.dircmp(ddl_path, git_path)
                diff_files = list(itertools.chain(dir_diff.diff_files, dir_diff.left_only)) # base from deploy
                
            def safe_read_lines(path):
                if not os.path.exists(path):
                    return []
                f = open(path, encoding='cp437')
                try:
                    return f.readlines()
                finally:
                    f.close()
                
            for diff_file in diff_files:
                expected_file = os.path.join(ddl_path, diff_file)
                actual_file = os.path.join(git_path, diff_file)
                
                if not os.path.isdir(actual_file):
                    only = os.listdir(expected_file)
                    for filename in only:
                        print(f'{os.path.join(expected_file, filename)}: new directories/files from deploy not in git')
                break
            else:
                
                i = 1
                for common_dir in dir_diff.common_dirs:
                    expected_file = os.path.join(ddl_path, common_dir)
                    actual_file = os.path.join(git_path, common_dir)
                    common = list(set(os.listdir(expected_file)) & set(os.listdir(actual_file))) 
                    only = list(set(os.listdir(expected_file)) - set(os.listdir(actual_file))) 
                    for filename in common:
                        flines = safe_read_lines(os.path.join(expected_file, filename))
                        glines = safe_read_lines(os.path.join(actual_file, filename))
                        d = difflib.Differ()
                        diffs = [x for x in d.compare(glines, flines) if x[0] in ('+', '-')]
                        shema_views = Path(actual_file).stem
                        if diffs:
                            print(f'{i}. {os.path.join(shema_views, filename)} => Changes')
                        else:
                            print(f'{i}. {os.path.join(shema_views, filename)} => No Changes')
                        i += 1
