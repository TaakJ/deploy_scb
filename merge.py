import pandas
import os
import glob
from pathlib import Path
import openpyxl 
import datetime


class run_process_merge():
    
    def __init__(self, date, storage, container):
        self.date = date
        self.storage = storage
        self.container = container
        self.wb = openpyxl.load_workbook("./filename/deployment_checklist_xxxxxxx.xlsx")
        parent_dir  = "./output"
        self.path = os.path.join(parent_dir, self.date)
        os.makedirs(self.path, exist_ok=True)
        self.wb.active
        
        df1 = self.source_table_def()
        df2 = self.source_int_mapp()
        df3 = self.source_pl_config()
        
        sum_df = pandas.concat([df1, df2, df3], axis=0, ignore_index=True)
        if sum_df.empty:
            raise Exception("Dataframe is empty !!")
        else:
            self.write_from_source(sum_df)
        
    def source_table_def(self):
        
        current_path = os.getcwd() + r'/filename/U02_TABLE_DEFINITION' 
        list_of_files = glob.glob(f'{current_path}/{self.date}/*')
        filename = [Path(files).name for files in list_of_files]
        if filename != []:
            df = pandas.DataFrame(filename, columns=['File_Name'])
            df['Storage'] = self.storage
            df['Container'] = self.container
            df['Storage_Path'] = r'utilities/import/U02_TABLE_DEFINITION'
            temp_cols = df.columns.tolist()
            re_cols = temp_cols[1:] + temp_cols[0:1]
            df = df[re_cols]
        else:
            df = pandas.DataFrame()
            
        return df
    
    def source_int_mapp(self):
        
        current_path = os.getcwd() + r'/filename/U03_INT_MAPPING' 
        list_of_files = glob.glob(f'{current_path}/{self.date}/*')
        filename = [Path(files).name for files in list_of_files]
        
        if filename != []:
            df = pandas.DataFrame(filename, columns=['File_Name'])
            df['Storage'] = self.storage
            df['Container'] = self.container
            df['Storage_Path'] = r'utilities/import/U03_INT_MAPPING'
            temp_cols = df.columns.tolist()
            re_cols = temp_cols[1:] + temp_cols[0:1]
            df = df[re_cols]
        else:
            df = pandas.DataFrame()
            
        return df
    
    def source_pl_config(self):
        
        current_path = os.getcwd() + r'/filename/U99_PL_REGISTER_CONFIG' 
        list_of_files = glob.glob(f'{current_path}/{self.date}/*')
        filename = [Path(files).name for files in list_of_files]
        
        if filename != []:
            df = pandas.DataFrame(filename, columns=['File_Name'])
            df['Storage'] = self.storage
            df['Container'] = self.container
            df['Storage_Path'] = r'utilities/import/U99_PL_REGISTER_CONFIG'
            temp_cols = df.columns.tolist()
            re_cols = temp_cols[1:] + temp_cols[0:1]
            df = df[re_cols]
        else:
            df = pandas.DataFrame()
            
        return df
    
    def write_from_source(self, df):
        
        sheet = self.wb['Checklist_ADLS']
        df['Note UAT Deploy Date'] = self.date
        
        start_rows = 1
        # Storage Column
        for r_idx, values in enumerate(df['Storage'], start_rows + 1):
            sheet.cell(row=r_idx, column=1, value=values)
            
        # Container Column
        for r_idx, values in enumerate(df['Container'], start_rows + 1):
            sheet.cell(row=r_idx, column=2, value=values)
            
        # Storage_Path Column
        for r_idx, values in enumerate(df['Storage_Path'], start_rows + 1):
            sheet.cell(row=r_idx, column=4, value=values)
            
        # Storage_Path Column
        for r_idx, values in enumerate(df['File_Name'], start_rows + 1):
            sheet.cell(row=r_idx, column=5, value=values)
            
        # Note UAT Deploy Date Column
        for r_idx, values in enumerate(df['Note UAT Deploy Date'], start_rows + 1):
            sheet.cell(row=r_idx, column=7, value=values)
        
        # Git_Path
        df['Note UAT Deploy Date'] = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')
        df["Git_Path"] = df[["Note UAT Deploy Date", "Storage_Path"]].apply(lambda x: "/".join(x), axis =1).apply(lambda x: f"{x}/")
        for r_idx, values in enumerate(df['Git_Path'], start_rows + 1):
            sheet.cell(row=r_idx, column=3 ,value=values)
        
        # Checklist
        df["Path"] = df[["Storage_Path", "File_Name"]].apply(lambda x: "/".join(x), axis =1)
        df["Full_Path"] = df[["Git_Path", "File_Name"]].apply(lambda x: "".join(x), axis =1)
        df["Checklist"] = df[["Storage", "Container", "Full_Path","Path"]].apply(lambda x: ",".join(x), axis =1)
        for r_idx, values in enumerate(df['Checklist'], start_rows + 1):
            sheet.cell(row=r_idx, column=8 ,value=values)
            
        date_fmt = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')
        self.wb.save(f'{self.path}/deployment_checklist_{date_fmt}.xlsx')