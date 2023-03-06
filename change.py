import os
import time
import filecmp
import difflib 
import itertools

class check_files_for_deploy:
    
    def __init__(self, date):
        self.date = date 
        
        parent_dir  = "./filename/DDL/"
        path = os.path.join(parent_dir, self.date)
    
        adls_path_view = r'D:\Document\Coding\Project\edwcloud_adls\src\VIEWS' + '/'  # right from git
        adls_path_table = r'D:\Document\Coding\Project\edwcloud_adls\src\TABLES' + '/'
        ddl_path = [path + '/VIEW/', path + '/TABLE/']
        adls_path = [adls_path_view, adls_path_table]
        
        # self._compare_directories(ddl_path, adls_path)
            
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
        
        