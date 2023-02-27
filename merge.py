import pandas
import os
import glob
from pathlib import Path
import openpyxl 
import datetime
import shutil
from openpyxl.utils.dataframe import dataframe_to_rows

class run_process_merge():
    
    def __init__(self, date, storage, container):
        
        self.date = date
        self.storage = storage
        self.container = container
        self.date_fmt = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')
        self.str_mvp = ['MVP1','MVP2','MVP3','MVP4','MVP6']
        self.wb = openpyxl.load_workbook("./filename/deployment_checklist_xxxxxxx.xlsx")
        
        # output deployment_checklist
        parent_dir  = "./output"
        self.path = os.path.join(parent_dir, self.date)
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
        
        for mvp in self.str_mvp:
            sum_df = pandas.concat([df_table_def[mvp], df_int_mapp[mvp], df_sys_name[mvp]], axis=0, ignore_index=True)
            sum_df['Note UAT Deploy Date'] = self.date
            sum_df['Git_Path'] = sum_df['Storage_Path'].apply(lambda x: "{}/{}/".format(self.date_fmt, x))
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
    
    def genarate_datafeame(self, list_df, path):
        
        dict_df = {}
        for str_mvp, mvp in zip(self.str_mvp, list_df):
            mvp['File_Name'] = mvp['LIST'].apply(lambda x: str(x).upper() + '.csv')
            df = pandas.DataFrame(mvp['File_Name'], columns=['File_Name']).reset_index(drop=True)
            df['Storage'] = self.storage
            df['Container'] = self.container
            df['Storage_Path'] = f'utilities/import/{path}'
            temp_cols = df.columns.tolist()
            re_cols = temp_cols[1:] + temp_cols[0:1]
            df = df[re_cols]
            dict_df.update({str_mvp: df})
        
        return dict_df
    
    def check_file_in_folder(self, list_df, path):
        for mvp, file in zip(self.str_mvp, list_df):
            current_path = os.getcwd() + f'/filename/{path}/{self.date}'
            
            for name in file['LIST']:
                full_name = str(name).upper() + '.csv'
                self.full_path = os.path.join(current_path, mvp, full_name)
                
                if os.path.isfile(self.full_path) is False:
                    print(f'file {full_name} does not exist in {path}/{self.date}/{mvp}')
        
    def crate_folder_mvp(self, files_name, dataframe, path):
        
        new_df = dataframe.apply(lambda x: x.astype(str).str.upper())
        mvp1 = new_df[new_df['MVP'] == 'MVP1']
        mvp2 = new_df[new_df['MVP'] == 'MVP2']
        mvp3 = new_df[new_df['MVP'] == 'MVP3']
        mvp4 = new_df[new_df['MVP'] == 'MVP4']
        mvp6 = new_df[new_df['MVP'] == 'MVP6']
        
        parent_dir  = f"./filename/{path}/{self.date}"
        all_mvp = [mvp1,mvp2,mvp3,mvp4,mvp6] 
        
        for str_mvp, all_mvp in zip(self.str_mvp, all_mvp):
            destination  = os.path.join(parent_dir, str_mvp)
            # print(f"Create folder and move file on {str_mvp}")
            os.makedirs(destination, exist_ok=True)
            for file_name in all_mvp[all_mvp['LIST'].isin([Path(x).stem for x in files_name])]['LIST'].values.tolist():
                full_name = f'{str(file_name).upper()}.csv'
                if os.path.isfile(os.path.join(destination, full_name)):
                    os.remove(os.path.join(destination, full_name))
                
                shutil.move(os.path.join(parent_dir, full_name), destination)
                print(f"Move file: {full_name} to folder: '{str_mvp}'")
                
        return mvp1, mvp2, mvp3, mvp4, mvp6
        
    def source_int_mapp(self, dataframe):
        
        print("============== int_mapping ==============")
        df = dataframe.loc[dataframe['COL_NM'] == 'INTERFACE_NAME']
        new_df = df.loc[~df.duplicated(subset=['LIST','MVP']), :]
        print(f"count file int_mapping: {len(new_df)} files")
        
        current_path = os.getcwd() + r'/filename/U03_INT_MAPPING' 
        list_of_files = glob.glob(f'{current_path}/{self.date}/*')
        files_name = [Path(files).name for files in list_of_files]

        if files_name != []:
            mvp1, mvp2, mvp3, mvp4, mvp6 = self.crate_folder_mvp(files_name, new_df, path='U03_INT_MAPPING')
            list_df = [mvp1, mvp2, mvp3, mvp4, mvp6]
            self.check_file_in_folder(list_df=list_df, path='U03_INT_MAPPING')
            dict_df = self.genarate_datafeame(list_df=list_df, path='U03_INT_MAPPING')
            
        print("=========================================")
            
        return dict_df
    
    def source_pl_config(self, dataframe):
        
        print("============== pl_config ================")
        df = dataframe.loc[dataframe['COL_NM'] == 'SYSTEM_NAME']
        new_df = df.loc[~df.duplicated(subset=['LIST','MVP']), :]
        add_col = pandas.DataFrame(new_df)
        add_col['LIST'] = add_col['LIST'].apply(lambda x: "{}{}".format('REGISTER_CONFIG_SYSTEM_', x))
        print(f"count file pl_config: {len(add_col)} files")
        
        current_path = os.getcwd() + r'/filename/U99_PL_REGISTER_CONFIG' 
        list_of_files = glob.glob(f'{current_path}/{self.date}/*')
        files_name = [Path(files).name for files in list_of_files]
        if files_name != []:
            mvp1, mvp2, mvp3, mvp4, mvp6 = self.crate_folder_mvp(files_name, add_col, path='U99_PL_REGISTER_CONFIG')
            list_df = [mvp1, mvp2, mvp3, mvp4, mvp6]
            self.check_file_in_folder(list_df=list_df, path='U99_PL_REGISTER_CONFIG')
            dict_df = self.genarate_datafeame(list_df=list_df, path='U99_PL_REGISTER_CONFIG')
            
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
        
        if files_name != []:
            mvp1, mvp2, mvp3, mvp4, mvp6 = self.crate_folder_mvp(files_name, new_df, path='U02_TABLE_DEFINITION')
            list_df = [mvp1, mvp2, mvp3, mvp4, mvp6]
            self.check_file_in_folder(list_df=list_df, path='U02_TABLE_DEFINITION')
            dict_df = self.genarate_datafeame(list_df=list_df, path='U02_TABLE_DEFINITION')
            
        print("=========================================")
        
        return dict_df
    