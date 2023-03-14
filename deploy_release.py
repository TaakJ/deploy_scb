import os
import datetime
import openpyxl
import glob
import pandas

class run_process_genfile():
    
    def __init__(self, date):
        self.date = date
        self.date_fmt = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')
        self._path = None
        self.str_mvp = ['MVP1','MVP2','MVP3','MVP4','MVP6']
        
        current_path = os.getcwd() + f'/output/{self.date}'
        filename = max(glob.glob(f'{current_path}/deployment_checklist_{self.date_fmt}.xlsx'), key=os.path.getmtime)
        if filename != "":
            df_sheet, df_ddl = self.separate_sheet(filename)
            self.create_for_adls(df_sheet, df_ddl)
            self.create_for_adb(df_sheet, df_ddl)
        else:
            raise ValueError("File not found !!")
        
    @property
    def path_define(self):
        return self._path
    
    @path_define.setter
    def path_define(self, path):
        self._path = path
        self.mvp1_path = os.path.join(self._path, 'SI-523_SR-10142_SR-10143_MVP1', self.date)
        self.mvp2_path = os.path.join(self._path, 'SI-523_SR-5512_SR-5622_MVP2', self.date)
        self.mvp3_path = os.path.join(self._path, 'SI-523_SR-5513_SR-5956_MVP3', self.date)
        self.mvp4_path = os.path.join(self._path, 'SI-523_SR-5515_SR-12745_MVP4', self.date)
        self.mvp6_path = os.path.join(self._path, 'SI-523_SR-16276_SR-16280_MVP6', self.date)
        return self._path
        
    def separate_sheet(self, filename):
        df_sheet = {}
        df_ddl = {}
        for mvp in self.str_mvp:
            try:
                # sheet
                sheet_name = f'Checklist_ADLS_{mvp}'
                df = pandas.read_excel(filename, sheet_name=sheet_name)
                df["Path"] = df[["Storage_Path", "File_Name"]].apply(lambda x: "/".join(x), axis =1)
                df["Full_Path"] = df[["Git_Path", "File_Name"]].apply(lambda x: "".join(x), axis =1)
                df["Deploy"] = df[["Storage", "Container", "Full_Path", "Path"]].apply(lambda x: ",".join(x), axis =1)
                df_sheet.update({mvp: df})
                
                # ddl sheet
                sheet_name = f'Checklist_DDL_{mvp}'
                ddl = pandas.read_excel(filename, sheet_name=sheet_name)
                ddl["Deploy"] = ddl[["Storage", "Container", "Git_Path", "Checklist"]].apply(lambda x: ",".join(x), axis =1)
                df_ddl.update({mvp: ddl})
                
            except:
                pass
            
        return df_sheet, df_ddl
    
    def create_for_adls(self, df_sheet, df_ddl):
        
        self.path_define = './adls'
        
        for mvp in self.str_mvp:
            if mvp == 'MVP1':
                os.makedirs(self.mvp1_path, exist_ok=True)
                # sheet
                if mvp in df_sheet.keys():
                    deploy_list = os.path.join(self.mvp1_path, f'00_deployList_SI-523_SR-10142_SR-10143_{mvp}_UAT.txt')       
                    df_sheet[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    deploy_list = os.path.join(self.mvp1_path, f'01_deployList_SI-523_SR-10142_SR-10143_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
            
            elif mvp == 'MVP2':
                os.makedirs(self.mvp2_path, exist_ok=True)
                # sheet
                if mvp in df_sheet.keys():
                    deploy_list = os.path.join(self.mvp2_path, f'00_deployList_SI-523_SR-5512_SR-5622_{mvp}_UAT.txt')
                    df_sheet[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    deploy_list = os.path.join(self.mvp2_path, f'01_deployList_SI-523_SR-5512_SR-5622_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
            
            elif mvp == 'MVP3':
                os.makedirs(self.mvp3_path, exist_ok=True)
                # sheet
                if mvp in df_sheet.keys():
                    deploy_list = os.path.join(self.mvp3_path, f'00_deployList_SI-523_SR-5513_SR-5956_{mvp}_UAT.txt')
                    df_sheet[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    deploy_list = os.path.join(self.mvp3_path, f'01_deployList_SI-523_SR-5513_SR-5956_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
            
            elif mvp == 'MVP4':
                os.makedirs(self.mvp4_path, exist_ok=True)
                # sheet  
                if mvp in df_sheet.keys():
                    deploy_list = os.path.join(self.mvp4_path, f'00_deployList_SI-523_SR-5515_SR-12745_{mvp}_UAT.txt')
                    df_sheet[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    deploy_list = os.path.join(self.mvp4_path, f'01_deployList_SI-523_SR-5515_SR-12745_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
                
            elif mvp == 'MVP6':
                os.makedirs(self.mvp6_path, exist_ok=True)
                # sheet
                if mvp in df_sheet.keys():
                    deploy_list = os.path.join(self.mvp6_path, f'00_deployList_SI-523_SR-16276_SR-16280_{mvp}_UAT.txt')
                    df_sheet[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    deploy_list = os.path.join(self.mvp6_path, f'01_deployList_SI-523_SR-16276_SR-16280_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(deploy_list, header=None, index=None, sep='\t')
                    
    def create_for_adb(self, df_sheet, df_ddl):
        
        self.path_define = './adb'
        
        def condition(x):
            #############################################################################
            #  state 1. 
            #  U24_Import_Interface_Mapping_Config_Deploy                                                                
            #  1. "ADB_01/Utilities/{mvp}/U24_Import_Interface_Mapping_Config_Deploy.json"  
            #  state 2.
            #  U22_Import_File_Config_02
            #  2. "ADB_01/Utilities/{mvp}/U22_Import_File_Config_02.json"
            #  state 3.
            #  U23_Import_Table_Definition_Deploy
            #  3. "ADB_01/Utilities/{mvp}/U23_Import_Table_Definition_Deploy.json"
            #############################################################################
            
            if x == "U03":
                state = 1
                return state
            elif x == 'U99':
                state = 2
                return state
            elif x == 'U02':
                state = 3
                return state
        
        for mvp in self.str_mvp:
            df_sheet[mvp]['Sub_Git_Path'] = df_sheet[mvp]['Git_Path'].str[26:29]
            df_sheet[mvp]['name_file'] = df_sheet[mvp]['Sub_Git_Path'].apply(condition)
            for state in df_sheet[mvp]['name_file'].unique():
                if state == 1:
                    content = "ADB_01/Utilities/{mvp}/U24_Import_Interface_Mapping_Config_Deploy.json"
                    if mvp == "MVP1" and df_sheet.keys():
                        files_name = f'03_deployList_SI-523_SR-10142_SR-10143_{mvp}_ImportConfig_UAT.txt'
                        detail = content.format(mvp=mvp)
                    if mvp == "MVP2" and df_sheet.keys():
                        files_name = f'03_deployList_SI-523_SR-5512_SR-5622_{mvp}_ImportConfig_UAT.txt'
                        detail = content.format(mvp=mvp)
                    if mvp == "MVP3" and df_sheet.keys():
                        files_name = f'03_deployList_SI-523_SR-5513_SR-5956_{mvp}_ImportConfig_UAT.txt'
                        detail = content.format(mvp=mvp)
                    if mvp == "MVP4" and df_sheet.keys():
                        files_name = f'03_deployList_SI-523_SR-5515_SR-12745_{mvp}_ImportConfig_UAT.txt'
                        detail = content.format(mvp=mvp)
                    if mvp == "MVP6" and df_sheet.keys():
                        files_name = f'03_deployList_SI-523_SR-16276_SR-16280_{mvp}_ImportConfig_UAT.txt'
                        detail = content.format(mvp=mvp)
                    
                    self.write_to_text(files_name, detail)
    
    def write_to_text(self, files_name, detail):
        print(files_name)
        print(detail)
                    
        # for content in df['name_file'].unique():
        #     # sheet
        #     if content == f'ADB_01/Utilities/{mvp}/U24_Import_Interface_Mapping_Config_Deploy.json':
        #         if mvp == "MVP1":
        #             deploy_list = os.path.join(self.mvp1_path, f'03_deployList_SI-523_SR-10142_SR-10143_{mvp}_ImportConfig_UAT.txt')
        #         elif mvp == "MVP2":
        #             deploy_list = os.path.join(self.mvp2_path, f'03_deployList_SI-523_SR-5512_SR-5622_{mvp}_ImportConfig_UAT.txt')
        #         elif mvp == "MVP3":
        #             deploy_list = os.path.join(self.mvp3_path, f'03_deployList_SI-523_SR-5513_SR-5956_{mvp}_ImportConfig_UAT.txt')
        #         elif mvp == "MVP4":
        #             deploy_list = os.path.join(self.mvp4_path, f'03_deployList_SI-523_SR-5515_SR-12745_{mvp}_ImportConfig_UAT.txt')
        #     else:
        #         if mvp == "MVP1":
        #             deploy_list = os.path.join(self.mvp1_path, f'02_deployList_SI-523_SR-10142_SR-10143_{mvp}_RegisterConfig_UAT.txt')
        #         elif mvp == "MVP2":
        #             deploy_list = os.path.join(self.mvp2_path, f'02_deployList_SI-523_SR-5512_SR-5622_{mvp}_RegisterConfig_UAT.txt')
        #         elif mvp == "MVP3":
        #             deploy_list = os.path.join(self.mvp3_path, f'02_deployList_SI-523_SR-5513_SR-5956_{mvp}_RegisterConfig_UAT.txt')
        #         elif mvp == "MVP4":
        #             deploy_list = os.path.join(self.mvp4_path, f'02_deployList_SI-523_SR-5515_SR-12745_{mvp}_RegisterConfig_UAT.txt')
            
        #     files = open(deploy_list,"w+")
        #     files.write(f"{content} ")
        #     files.close()
        
