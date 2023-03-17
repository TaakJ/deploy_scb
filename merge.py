import pandas
import os
import glob
from pathlib import Path
import openpyxl 
import datetime
import shutil
from openpyxl.utils.dataframe import dataframe_to_rows
from change import check_files_for_deploy

class run_process_merge():
    
    def __init__(self, date, storage, container, re_deploy):
        
        self.date = date
        self.re_deploy = re_deploy
        if self.re_deploy == '':
            self.re_deploy = self.date
        
        self.storage = storage
        self.container = container
        self.date_fmt = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')
        self.str_mvp = ['MVP1','MVP2','MVP3','MVP4','MVP6']
        self.wb = openpyxl.load_workbook("./filename/deployment_checklist_xxxxxxx.xlsx")
        
        # output deployment_checklist
        self.path = os.getcwd() + f'/output/{self.date}'
        os.makedirs(self.path, exist_ok=True)
        self.sheet = self.wb.active
        
        current_path = os.getcwd() + f'/output/{self.date}'
        filename = max(glob.glob(f'{current_path}/template_{self.date_fmt}.xlsx'), key=os.path.getmtime)
        if filename != "":
            sheet1 = pandas.read_excel(filename, sheet_name='all')
            sheet2 = pandas.read_excel(filename, sheet_name='ddl')
        else:
            raise ValueError("File not found !!")
        
        df_int_mapp = self.source_int_mapp(sheet1) 
        df_sys_name = self.source_pl_config(sheet1)
        df_table_def = self.source_table_def(sheet1)
        
        if bool(df_int_mapp) is True and bool(df_sys_name) is True and bool(df_table_def):
            self.auto_gen_file(df_int_mapp, df_sys_name, df_table_def)
            
        df_ddl = self.source_ddl(sheet2)
        
    def auto_gen_file(self, df_int_mapp, df_sys_name, df_table_def):
        for mvp in self.str_mvp:
            sum_df = pandas.concat([df_table_def[mvp], df_int_mapp[mvp], df_sys_name[mvp]], axis=0, ignore_index=True)
            sum_df['Note UAT Deploy Date'] = self.date
            sum_df['Git_Path'] = sum_df['Storage_Path'].apply(lambda x: "{}/{}/{}/".format(self.date_fmt, x, mvp))
            sum_df["Path"] = sum_df[["Storage_Path", "File_Name"]].apply(lambda x: "/".join(x), axis =1)
            sum_df["Full_Path"] = sum_df[["Git_Path", "File_Name"]].apply(lambda x: "".join(x), axis =1)
            sum_df["Obsolete"] = ""
            sum_df["Checklist"] = sum_df[["Storage", "Container", "Full_Path","Path"]].apply(lambda x: ",".join(x), axis =1)  
            
            df_new = sum_df.loc[:, ['Storage', 'Container', 'Git_Path', 'Storage_Path','File_Name', 'Note UAT Deploy Date', 'Obsolete', 'Checklist']]
            if df_new.empty is False:
                self.write_from_source(df_new, mvp)
                print(f"{mvp} files count: {len(df_new)} rows and write to excel completed.")
            else:
                raise Exception("Dataframe is empty !!")
        
    def write_from_source(self, df, mvp):
        sheet_name = f'Checklist_ADLS_{mvp}'
        self.sheet = self.wb.create_sheet(sheet_name)
        self.sheet.title = sheet_name
        rows = dataframe_to_rows(df, header=True, index=False)
        
        for r_idx, row in enumerate(rows, 1):
            for c_idx, val in enumerate(row, 1):
                value = self.sheet.cell(row=r_idx, column=c_idx)
                value.value = val
        
        self.file_name = f'{self.path}/deployment_checklist_{self.date_fmt}.xlsx'
        self.wb.save(self.file_name)
    
    def write_list_mvp(self, df, sheet_name):
        
        self.sheet = self.wb.create_sheet(sheet_name)
        self.sheet.title = sheet_name
        for mvp in self.str_mvp:
            new_df = dict(tuple(df[mvp].loc[:, ["File_Name","MVP"]].groupby('MVP')))
            if 'MVP1' in new_df.keys():
                n = 1
                rows = dataframe_to_rows(new_df[mvp], header=True, index=False)
            elif 'MVP2' in new_df.keys():
                n = 4
                rows = dataframe_to_rows(new_df[mvp], header=True, index=False)
            elif 'MVP3' in new_df.keys():
                n = 7
                rows = dataframe_to_rows(new_df[mvp], header=True, index=False)
            elif 'MVP4' in new_df.keys():
                n = 10
                rows = dataframe_to_rows(new_df[mvp], header=True, index=False)
            elif 'MVP6' in new_df.keys():
                n = 13
                rows = dataframe_to_rows(new_df[mvp], header=True, index=False)
                
            for r_idx, row in enumerate(rows, 1):
                for c_idx, val in enumerate(row, n):
                    value = self.sheet.cell(row=r_idx, column=c_idx)
                    value.value = val
        
        self.file_name = f'{self.path}/deployment_checklist_{self.date_fmt}.xlsx'
        self.wb.save(self.file_name)
                
    def genarate_datafeame(self, list_mvp, path):
        
        dict_df = {}
        for str_mvp, mvp in zip(self.str_mvp, list_mvp):
            df = pandas.DataFrame(mvp['File_Name'], columns=['File_Name']).reset_index(drop=True)
            df['Storage'] = self.storage
            df['Container'] = self.container
            df['Storage_Path'] = f'utilities/import/{path}'
            df['MVP'] = str_mvp
            temp_cols = df.columns.tolist()
            re_cols = temp_cols[1:] + temp_cols[0:1]
            df = df[re_cols]
            
            dict_df.update({str_mvp: df})
            
        return dict_df
    
    def check_old_deploy(self, sheet):
        current_path = os.getcwd() + r'/filename/OLD_DEPLOY' 
        files_deploy = glob.glob(f'{current_path}/{self.re_deploy}/*')
        if files_deploy != []:
            df_old = pandas.read_excel(''.join(files_deploy), sheet_name=sheet)
        else:
            df_old = pandas.DataFrame()
        
        return df_old
    
    def check_file_in_folder(self, list_df, path):
        
        df_old = self.check_old_deploy(path)
        list_mvp = []
        for str_mvp, mvp in zip(self.str_mvp, list_df):
            if df_old.empty is False:
                mvp = pandas.merge(mvp, df_old, how='left', on=['LIST', 'MVP'], indicator=True)
                mvp = mvp[mvp['_merge'] == 'left_only'].drop('_merge',axis=1)
            # path stored
            current_path = os.getcwd() + f'/filename/{path}/{self.date}'
            
            if path != 'U99_PL_REGISTER_CONFIG':
                mvp['File_Name'] = mvp['LIST'].apply(lambda x:  f'{str(x).upper()}.csv')
            else:
                mvp['File_Name'] = mvp['LIST'].apply(lambda x:  f'REGISTER_CONFIG_SYSTEM_{str(x).upper()}.xlsx')
            
            print(f"count file path {str(path).lower()}: '{len(mvp)}' files on {str_mvp}")
            
            for full_name in mvp['File_Name']:
                if any(os.scandir(os.path.join(current_path, str_mvp))):
                    if os.path.isfile(os.path.join(current_path, str_mvp, full_name)) is False:
                        print(f'file {full_name} does not exist in {path}/{self.date}/{str_mvp}')
                        
            list_mvp.append(mvp)
            
        return list_mvp
        
    def crate_folder_mvp(self, files_name, dataframe, path):
        
        new_df = dataframe.apply(lambda x: x.astype(str).str.upper())
        
        # mvp1
        mvp1 = new_df[new_df['MVP'] == 'MVP1']
        mvp1 = mvp1[~mvp1.duplicated(subset=['LIST','MVP'])]
        # mvp2
        mvp2 = new_df[new_df['MVP'] == 'MVP2']
        mvp2 = mvp2[~mvp2.duplicated(subset=['LIST','MVP'])]
        # mvp3
        mvp3 = new_df[new_df['MVP'] == 'MVP3']
        mvp3 = mvp3[~mvp3.duplicated(subset=['LIST','MVP'])]
        # mvp4
        mvp4 = new_df[new_df['MVP'] == 'MVP4']
        mvp4 = mvp4[~mvp4.duplicated(subset=['LIST','MVP'])]
        # mvp6
        mvp6 = new_df[new_df['MVP'] == 'MVP6']
        mvp6 = mvp6[~mvp6.duplicated(subset=['LIST','MVP'])]
        
        parent_dir  = f"./filename/{path}/{self.date}"
        all_mvp = [mvp1,mvp2,mvp3,mvp4,mvp6]
        
        for str_mvp, all_mvp in zip(self.str_mvp, all_mvp):
            destination  = os.path.join(parent_dir, str_mvp)
            os.makedirs(destination, exist_ok=True)
            for name in all_mvp[all_mvp['LIST'].isin([f'REGISTER_CONFIG_SYSTEM_{x}' if path == 'U99_PL_REGISTER_CONFIG' else Path(x).stem for x in files_name])]['LIST'].values.tolist():
                if path != 'U99_PL_REGISTER_CONFIG':
                    full_name = f'{str(name).upper()}.csv'
                else:
                    full_name = f'{str(name).upper()}.xlsx'
                    
                if os.path.isfile(os.path.join(destination, full_name)) is False:
                    shutil.copy(os.path.join(parent_dir, full_name), destination)
                    print(f"Copy file: {full_name} to folder: '{str_mvp}'")
                
        return mvp1, mvp2, mvp3, mvp4, mvp6
        
    def source_int_mapp(self, dataframe):
        
        print("============== int_mapping ==============")
        df = dataframe.loc[dataframe['COL_NM'] == 'INTERFACE_NAME']
        print(f"count file int_mapping: {len(df)} files")
        
        current_path = os.getcwd() + r'/filename/U03_INT_MAPPING' 
        list_of_files = glob.glob(f'{current_path}/{self.date}/*')
        files_name = [Path(files).name for files in list_of_files]
        
        dict_df = {}
        if files_name != []:
            mvp1, mvp2, mvp3, mvp4, mvp6 = self.crate_folder_mvp(files_name, df, path='U03_INT_MAPPING')
            list_df = [mvp1, mvp2, mvp3, mvp4, mvp6]
            
            list_mvp = self.check_file_in_folder(list_df=list_df, path='U03_INT_MAPPING')
            dict_df = self.genarate_datafeame(list_mvp=list_mvp, path='U03_INT_MAPPING')
            self.write_list_mvp(dict_df, sheet_name='U03_INT_MAPPING')
            
        print("=========================================")
            
        return dict_df
    
    def source_pl_config(self, dataframe):
        
        print("============== pl_config ================")
        df = dataframe.loc[dataframe['COL_NM'] == 'SYSTEM_NAME']
        print(f"count file pl_config: {len(df)} files")
        
        current_path = os.getcwd() + r'/filename/U99_PL_REGISTER_CONFIG' 
        list_of_files = glob.glob(f'{current_path}/{self.date}/*')
        files_name = [Path(files).name for files in list_of_files]
        
        dict_df = {}
        if files_name != []:
            mvp1, mvp2, mvp3, mvp4, mvp6 = self.crate_folder_mvp(files_name, df, path='U99_PL_REGISTER_CONFIG')
            list_df = [mvp1, mvp2, mvp3, mvp4, mvp6]
            
            list_mvp = self.check_file_in_folder(list_df=list_df, path='U99_PL_REGISTER_CONFIG')
            dict_df = self.genarate_datafeame(list_mvp=list_mvp, path='U99_PL_REGISTER_CONFIG')
            self.write_list_mvp(dict_df, sheet_name='U99_PL_REGISTER_CONFIG')
            
        print("=========================================")
        
        return dict_df
        
    def source_table_def(self, dataframe):
        
        print("============== table_def ================")
        df = dataframe.loc[dataframe['COL_NM'] == 'TABLE']
        new_df = df.loc[~df.duplicated(subset=['LIST','MVP']), :] 
        new_df[['schema', 'table']] = new_df['LIST'].str.split(',', expand=True)
        new_df['LIST'] = new_df['schema'].map(str) + '_' + new_df['table'].map(str)
        print(f"count file table_def: {len(new_df)} files")
        
        current_path = os.getcwd() + r'/filename/U02_TABLE_DEFINITION' 
        list_of_files = glob.glob(f'{current_path}/{self.date}/*')
        files_name = [Path(files).name for files in list_of_files]
        
        dict_df = {}
        if files_name != []:
            mvp1, mvp2, mvp3, mvp4, mvp6 = self.crate_folder_mvp(files_name, new_df, path='U02_TABLE_DEFINITION')
            list_df = [mvp1, mvp2, mvp3, mvp4, mvp6]
            
            list_mvp = self.check_file_in_folder(list_df=list_df, path='U02_TABLE_DEFINITION')
            dict_df = self.genarate_datafeame(list_mvp=list_mvp, path='U02_TABLE_DEFINITION')
            self.write_list_mvp(dict_df, sheet_name='U02_TABLE_DEFINITION')
            
        print("=========================================")
        
        return dict_df
    
    def source_ddl(self, dataframe):
        
        print("================= ddl ===================")
        
        # self.date = self.re_deploy
        ddl_path = os.getcwd() + f'/filename/DDL/{self.date}'
        df = dataframe.loc[~dataframe.duplicated(subset=['VIEW_TABLE','GROUP_JOB_NAME', 'MVP']), :]
        if df.empty is False:
            new_df = df.copy()
            new_df[['Folder','File']] = df['VIEW_TABLE'].map(lambda x: str(x)[2:]).str.split(".", n=1, expand=True)
            print(f"count file ddl: {len(new_df)} files")
            
            df_mvp = dict(tuple(new_df.groupby('MVP')))
            dict_df = {}
            for mvp in self.str_mvp:
                
                if mvp in df_mvp.keys():
                    destination  = os.path.join(ddl_path, mvp)
                    
                    for fols, files in zip(df_mvp[mvp]["Folder"].values.tolist(), df_mvp[mvp]["File"].values.tolist()):
                        path_in = os.path.join(ddl_path, f'VIEWS/{fols}')
                        path_out =  os.path.join(destination, fols)
                        os.makedirs(path_out, exist_ok=True)
                        full_name = str(files) + '.sql'
                        
                        if os.path.isfile(os.path.join(path_in, full_name)):
                            # os.remove(os.path.join(path_out, full_name))
                            shutil.copy(os.path.join(path_in, full_name), path_out)
                            check = True
                        else:
                            print(f"file: {full_name} does not exist on folder: {fols}, '{mvp}'")
                            check = False
                            
                    # set dataframe
                    sum_df = df_mvp[mvp].reset_index(drop=True)
                    sum_df['File_Name'] = sum_df['File'].apply(lambda x: str(x).upper() + '.sql')
                    sum_df['Note UAT Deploy Date'] = self.date
                    sum_df['Storage'] = self.storage
                    sum_df['Container'] = self.container
                    sum_df['Storage_Path'] = sum_df[["Folder", "File_Name"]].apply(lambda x: "/".join(x), axis=1)
                    sum_df["Git_Path"] =  sum_df['Storage_Path'].apply(lambda x: "VIEWS/{}".format(x)) 
                    sum_df["Checklist"] =  sum_df['Storage_Path'].apply(lambda x: "ddl_script_replace/process_migration/{}".format(x)) 
                    sum_df['MVP'] = mvp
                    dict_df.update({mvp: sum_df})
            
        if check:
            check_files_for_deploy(self.date, ddl_path=ddl_path)._compare_directories
            self.write_from_ddl(dict_df=dict_df)
            
        print("=========================================")
        
    def write_from_ddl(self, dict_df):
        
        # write to sheet
        for mvp in self.str_mvp:
            if mvp in dict_df.keys():
                df_new = dict_df[mvp].loc[:, ['Storage', 'Container', 'Git_Path', 'Note UAT Deploy Date', 'Checklist']]
                print(f"{mvp} ddl files count: {len(df_new)} rows and write to excel completed.")
                
                sheet_name = f'Checklist_DDL_{mvp}'
                self.sheet = self.wb.create_sheet(sheet_name)
                self.sheet.title = sheet_name
                rows = dataframe_to_rows(df_new, header=True, index=False)
                for r_idx, row in enumerate(rows, 1):
                    for c_idx, val in enumerate(row, 1):
                        value = self.sheet.cell(row=r_idx, column=c_idx)
                        value.value = val
                
                self.file_name =  f'{self.path}/deployment_checklist_{self.date_fmt}.xlsx'
                self.wb.save(self.file_name)
                
            else:
                print(f"{mvp} ddl files is empty")
                