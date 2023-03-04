import os
import datetime
import openpyxl
import glob
import pandas

class run_process_genfile():
    
    def __init__(self, date):
        self.date = date
        self.date_fmt = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')
        
        parent_dir  = f"./output/{self.date}"
        self.mvp1_path = os.path.join(parent_dir, 'SI-523_SR-10142_SR-10143')
        os.makedirs(self.mvp1_path, exist_ok=True)
        self.mvp2_path = os.path.join(parent_dir, 'SI-523_SR-5512_SR-5622')
        os.makedirs(self.mvp2_path, exist_ok=True)
        self.mvp3_path = os.path.join(parent_dir, 'SI-523_SR-5513_SR-5956')
        os.makedirs(self.mvp3_path, exist_ok=True)
        self.mvp4_path = os.path.join(parent_dir, 'SI-523_SR-5515_SR-12745')
        os.makedirs(self.mvp4_path, exist_ok=True)
        # self.mvp6_path = os.path.join(parent_dir, 'SI-523_SR-10142_SR-10143')
        # os.makedirs( self.mvp1_path, exist_ok=True)
        
        self.str_mvp = ['MVP1','MVP2','MVP3','MVP4','MVP6']
        current_path = os.getcwd() + f'/output/{self.date}'
        filename = max(glob.glob(f'{current_path}/deployment_checklist_{self.date_fmt}.xlsx'), key=os.path.getmtime)
        if filename != "":
            df_sheet = self.separate_sheet(filename)
            self.create_textfile(df_sheet)
        else:
            raise ValueError("File not found !!")
        
    def separate_sheet(self, filename):
        
        df_sheet = {}
        for mvp in self.str_mvp:
            sheet_name = f'Checklist_ADLS_{mvp}'
            df = pandas.read_excel(filename, sheet_name=sheet_name)
            df["Path"] = df[["Storage_Path", "File_Name"]].apply(lambda x: "/".join(x), axis =1)
            df["Full_Path"] = df[["Git_Path", "File_Name"]].apply(lambda x: "".join(x), axis =1)
            df["Deploy"] = df[["Storage", "Container", "Full_Path", "Path"]].apply(lambda x: ",".join(x), axis =1)
            
            df_sheet.update({mvp: df["Deploy"]})
            
        return df_sheet
    
    def create_textfile(self, df_sheet):
        
        for mvp in self.str_mvp:
            if mvp == 'MVP1':
                deploy_list = os.path.join(self.mvp1_path, f'00_deployList_SI-523_SR-10142_SR-10143_{mvp}_UAT.txt')       
                df_sheet[mvp].to_csv(deploy_list, header=None, index=None, sep='\t')
            if mvp == 'MVP2':
                deploy_list = os.path.join(self.mvp2_path, f'00_deployList_SI-523_SR-5512_SR-5622_{mvp}_UAT.txt')
                df_sheet[mvp].to_csv(deploy_list, header=None, index=None, sep='\t')  
            if mvp == 'MVP3':
                deploy_list = os.path.join(self.mvp3_path, f'00_deployList_SI-523_SR-5513_SR-5956_{mvp}_UAT.txt')
                df_sheet[mvp].to_csv(deploy_list, header=None, index=None, sep='\t')
            if mvp == 'MVP4':
                deploy_list = os.path.join(self.mvp4_path, f'00_deployList_SI-523_SR-5515_SR-12745_{mvp}_UAT.txt')
                df_sheet[mvp].to_csv(deploy_list, header=None, index=None, sep='\t')
        
        print()