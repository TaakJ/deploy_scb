import os
import datetime
import openpyxl
import glob
import pandas
import time
import shutil
from pathlib import Path, PurePath

class run_process_genfile:
    
    def __init__(self, date):
        self.date = date
        self.date_fmt = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')
        self._path = None
        self.str_mvp = ['MVP1','MVP2','MVP3','MVP4','MVP6']
        
        current_path = os.getcwd() + f'/output/{date}'
        
        filename = f'{current_path}/deployment_checklist_{self.date_fmt}.xlsx'
        df_sheet, df_ddl = self.separate_sheet(filename)
        print(df_sheet)
        self.create_for_adls(df_sheet, df_ddl)
        self.create_for_adb(df_sheet, df_ddl)
        
    @property
    def path_define(self):
        return self._path
    
    @path_define.setter
    def path_define(self, path):
        
        self._path = path
        self.mvp1_path = Path(os.path.join(self._path, 'SI-523_SR-10142_SR-10143_MVP1', self.date))
        if self.mvp1_path.exists():
            shutil.rmtree(self.mvp1_path)
        self.mvp2_path = Path(os.path.join(self._path, 'SI-523_SR-5512_SR-5622_MVP2', self.date))
        if self.mvp2_path.exists():
            shutil.rmtree(self.mvp2_path)
        self.mvp3_path = Path(os.path.join(self._path, 'SI-523_SR-5513_SR-5956_MVP3', self.date))
        if self.mvp3_path.exists():
            shutil.rmtree(self.mvp3_path)
        self.mvp4_path = Path(os.path.join(self._path, 'SI-523_SR-5515_SR-12745_MVP4', self.date))
        if self.mvp4_path.exists():
            shutil.rmtree(self.mvp4_path)
        self.mvp6_path = Path(os.path.join(self._path, 'SI-523_SR-16276_SR-16280_MVP6', self.date))
        if self.mvp6_path.exists():
            shutil.rmtree(self.mvp6_path)
        
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
                
            except:
                pass
            
            try:
                # ddl 
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
                    textfiles = os.path.join(self.mvp1_path, f'00_deployList_SI-523_SR-10142_SR-10143_{mvp}_UAT.txt')
                    df_sheet[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    textfiles = os.path.join(self.mvp1_path, f'01_deployList_SI-523_SR-10142_SR-10143_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
            
            elif mvp == 'MVP2':
                os.makedirs(self.mvp2_path, exist_ok=True)
                # sheet
                if mvp in df_sheet.keys():
                    textfiles = os.path.join(self.mvp2_path, f'00_deployList_SI-523_SR-5512_SR-5622_{mvp}_UAT.txt')
                    df_sheet[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    textfiles = os.path.join(self.mvp2_path, f'01_deployList_SI-523_SR-5512_SR-5622_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
            
            elif mvp == 'MVP3':
                os.makedirs(self.mvp3_path, exist_ok=True)
                # sheet
                if mvp in df_sheet.keys():
                    textfiles = os.path.join(self.mvp3_path, f'00_deployList_SI-523_SR-5513_SR-5956_{mvp}_UAT.txt')
                    df_sheet[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    textfiles = os.path.join(self.mvp3_path, f'01_deployList_SI-523_SR-5513_SR-5956_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
            
            elif mvp == 'MVP4':
                os.makedirs(self.mvp4_path, exist_ok=True)
                # sheet  
                if mvp in df_sheet.keys():
                    textfiles = os.path.join(self.mvp4_path, f'00_deployList_SI-523_SR-5515_SR-12745_{mvp}_UAT.txt')
                    df_sheet[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    textfiles = os.path.join(self.mvp4_path, f'01_deployList_SI-523_SR-5515_SR-12745_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
                
            elif mvp == 'MVP6':
                os.makedirs(self.mvp6_path, exist_ok=True)
                # sheet
                if mvp in df_sheet.keys():
                    textfiles = os.path.join(self.mvp6_path, f'00_deployList_SI-523_SR-16276_SR-16280_{mvp}_UAT.txt')
                    df_sheet[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
                # ddl
                if mvp in df_ddl.keys():
                    textfiles = os.path.join(self.mvp6_path, f'01_deployList_SI-523_SR-16276_SR-16280_{mvp}_UAT.txt')
                    df_ddl[mvp]["Deploy"].to_csv(textfiles, header=None, index=None, sep='\t')
                    
    def create_for_adb(self, df_sheet, df_ddl):
        
        self.path_define = './adb'
        sub_path='Job'
        
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
            
            # ddl
            try:
                content = "ADB_03/Setup/99_Run_replace_DDL_Databrick_loop.json"
                if mvp == "MVP1" and "MVP1" in df_ddl.keys():
                    # job
                    ur = 'SI-523_SR-10142_SR-10143'
                    textfiles = Path(os.path.join(self.mvp1_path, sub_path, f'01_deployList_{ur}_{mvp}_createDDL_UAT.txt'))
                    self.write_to_text(textfiles, content.format(mvp=mvp))
                    
                if mvp == "MVP2" and "MVP2" in df_ddl.keys():
                    # job
                    ur = 'SI-523_SR-5512_SR-5622'
                    textfiles = Path(os.path.join(self.mvp2_path, sub_path, f'01_deployList_{ur}_{mvp}_createDDL_UAT.txt'))
                    self.write_to_text(textfiles, content.format(mvp=mvp))
                    
                if mvp == "MVP3" and "MVP3" in df_ddl.keys():
                    # job
                    ur = 'SI-523_SR-5513_SR-5956'
                    textfiles = Path(os.path.join(self.mvp3_path, sub_path, f'01_deployList_{ur}_{mvp}_createDDL_UAT.txt'))
                    self.write_to_text(textfiles, content.format(mvp=mvp))
                    
                if mvp == "MVP4" and "MVP4" in df_ddl.keys():
                    # job
                    ur = 'SI-523_SR-5515_SR-12745'
                    textfiles = Path(os.path.join(self.mvp4_path, sub_path, f'01_deployList_{ur}_{mvp}_createDDL_UAT.txt'))
                    self.write_to_text(textfiles, content.format(mvp=mvp))
                
                if mvp == "MVP6" and "MVP6" in df_ddl.keys():
                    # job
                    ur = 'SI-523_SR-16276_SR-16280'
                    textfiles = Path(os.path.join(self.mvp6_path, sub_path, f'01_deployList_{ur}_{mvp}_createDDL_UAT.txt'))
                    self.write_to_text(textfiles, content.format(mvp=mvp))
            except:
                pass
            
            try:
                
                df_sheet[mvp]['Sub_Git_Path'] = df_sheet[mvp]['Git_Path'].str[26:29]
                df_sheet[mvp]['state'] = df_sheet[mvp]['Sub_Git_Path'].apply(condition)
                
                for state in df_sheet[mvp]['state'].unique():
                    if state == 1:
                        content = "ADB_03/Utilities/{mvp}/U24_Import_Interface_Mapping_Config_Deploy.json"
                        if mvp == "MVP1" and "MVP1" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-10142_SR-10143'
                            textfiles = Path(os.path.join(self.mvp1_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U24_Import_Interface_Mapping_Config_Deploy"
                            self.create_for_notebook(self.mvp1_path, df_sheet, ur, mvp, job_name)
                            
                            
                        if mvp == "MVP2" and "MVP2" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-5512_SR-5622'
                            textfiles = Path(os.path.join(self.mvp2_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U24_Import_Interface_Mapping_Config_Deploy"
                            self.create_for_notebook(self.mvp2_path, df_sheet, ur, mvp, job_name)
                            
                        if mvp == "MVP3" and "MVP3" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-5513_SR-5956'
                            textfiles = Path(os.path.join(self.mvp3_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U24_Import_Interface_Mapping_Config_Deploy"
                            self.create_for_notebook(self.mvp3_path, df_sheet, ur, mvp, job_name)
                        
                        if mvp == "MVP4" and "MVP4" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-5515_SR-12745'
                            textfiles = Path(os.path.join(self.mvp4_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U24_Import_Interface_Mapping_Config_Deploy"
                            self.create_for_notebook(self.mvp4_path, df_sheet, ur, mvp, job_name)
                        
                        if mvp == "MVP6" and "MVP6" in  df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-16276_SR-16280'
                            textfiles = Path(os.path.join(self.mvp6_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U24_Import_Interface_Mapping_Config_Deploy"
                            self.create_for_notebook(self.mvp6_path, df_sheet, ur, mvp, job_name)
                            
                    elif state == 2:
                        content = "ADB_03/Utilities/{mvp}/U22_Import_File_Config_02.json"
                        if mvp == "MVP1"  and "MVP1" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-10142_SR-10143'
                            textfiles = Path(os.path.join(self.mvp1_path, sub_path, f'02_deployList_{ur}_{mvp}_RegisterConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U22_Import_File_Config_Deploy"
                            self.create_for_notebook(self.mvp1_path, df_sheet, ur, mvp, job_name)
                            
                        if mvp == "MVP2" and "MVP2" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-5512_SR-5622'
                            textfiles = Path(os.path.join(self.mvp2_path, sub_path, f'02_deployList_{ur}_{mvp}_RegisterConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U22_Import_File_Config_Deploy"
                            self.create_for_notebook(self.mvp2_path, df_sheet, ur, mvp, job_name)
                            
                        if mvp == "MVP3" and "MVP3" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-5513_SR-5956'
                            textfiles = Path(os.path.join(self.mvp3_path, sub_path, f'02_deployList_{ur}_{mvp}_RegisterConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U22_Import_File_Config_Deploy"
                            self.create_for_notebook(self.mvp3_path, df_sheet, ur, mvp, job_name)
                        
                        if mvp == "MVP4" and "MVP4" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-5515_SR-12745'
                            textfiles = Path(os.path.join(self.mvp4_path, sub_path, f'02_deployList_{ur}_{mvp}_RegisterConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U22_Import_File_Config_Deploy"
                            self.create_for_notebook(self.mvp4_path, df_sheet, ur, mvp, job_name)
                        
                        if mvp == "MVP6" and "MVP6" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-16276_SR-16280'
                            textfiles = Path(os.path.join(self.mvp6_path, sub_path, f'02_deployList_{ur}_{mvp}_RegisterConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U22_Import_File_Config_Deploy"
                            self.create_for_notebook(self.mvp6_path, df_sheet, ur, mvp, job_name)
                            
                    elif state == 3:
                        content = "ADB_03/Utilities/{mvp}/U23_Import_Table_Definition_Deploy.json"
                        if mvp == "MVP1" and "MVP1" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-10142_SR-10143'
                            textfiles = Path(os.path.join(self.mvp1_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U23_Import_Table_Definition_Deploy"
                            self.create_for_notebook(self.mvp1_path, df_sheet, ur, mvp, job_name)
                            
                        if mvp == "MVP2"  and "MVP2" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-5512_SR-5622'
                            textfiles = Path(os.path.join(self.mvp2_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U23_Import_Table_Definition_Deploy"
                            self.create_for_notebook(self.mvp2_path, df_sheet, ur, mvp, job_name)
                            
                        if mvp == "MVP3" and "MVP3" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-5513_SR-5956'
                            textfiles = Path(os.path.join(self.mvp3_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U23_Import_Table_Definition_Deploy"
                            self.create_for_notebook(self.mvp3_path, df_sheet, ur, mvp, job_name)
                            
                        if mvp == "MVP4" and "MVP4" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-5515_SR-12745'
                            textfiles = Path(os.path.join(self.mvp4_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U23_Import_Table_Definition_Deploy"
                            self.create_for_notebook(self.mvp4_path, df_sheet, ur, mvp, job_name)
                        
                        if mvp == "MVP6" and "MVP6" in df_sheet.keys():
                            # job
                            ur = 'SI-523_SR-16276_SR-16280'
                            textfiles = Path(os.path.join(self.mvp6_path, sub_path, f'03_deployList_{ur}_{mvp}_ImportConfig_UAT.txt'))
                            self.write_to_text(textfiles, content.format(mvp=mvp))
                            
                            # Notebook
                            job_name = "U23_Import_Table_Definition_Deploy"
                            self.create_for_notebook(self.mvp6_path, df_sheet, ur, mvp, job_name)
                    
            except:
                pass
                
    def create_for_notebook(self, path, df_sheet, ur, mvp, job_name):
        
        sub_path='Notebook'
        
        # content
        df_sheet[mvp]["Run"] = "PYTHON"
        df_sheet[mvp]["Type"] = "DBC"
        df_sheet[mvp]["Storage"] = f"/Shared/Utilities/{mvp}"
        df_sheet[mvp]["Job"] = job_name
        df_sheet[mvp]["Full_Path"] = f"Utilities/{mvp}/{job_name}.dbc"
        df_sheet[mvp]["Notebook"] = df_sheet[mvp][["Run", "Type", "Storage", "Job", "Full_Path"]].apply(lambda x: ",".join(x), axis =1)
        content = ''.join(df_sheet[mvp]["Notebook"].unique())
        
        # write to text
        textfiles = Path(os.path.join(path, sub_path, f'00_deployList_{ur}_{mvp}.txt'))
        self.write_to_text(textfiles, content.format(mvp=mvp))
                
    def write_to_text(self, textfiles, content):
        if textfiles.exists():
            with open(textfiles, "a+") as writer:
                writer.seek(0)
                data = writer.read(100)
                if len(data) > 0 :
                    writer.write("\n")
                writer.write(content)
                writer.close()
        else:
            textfiles.parent.mkdir(exist_ok=True, parents=True)
            textfiles.write_text(content) 
            

