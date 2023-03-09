import pandas
import os
import glob
import asyncio
import datetime
import openpyxl 
from openpyxl.utils.dataframe import dataframe_to_rows

class run_process_split():
    
    def __init__(self, date):
        self.date = date
        self.date_fmt = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')        
        self.wb = openpyxl.Workbook()
        parent_dir  = "./output"
        path = os.path.join(parent_dir, self.date)
        os.makedirs(path, exist_ok=True)
        self.file_name = f'{path}/gen_parameter_{self.date_fmt}.xlsx'
        self.sheet = self.wb.active
        
    def run(self):
        loop = asyncio.get_event_loop()
        loop.run_until_complete(self.find_excel_file())
        
    def join_mvp(self, drop_dup):
        parent_dir  = "./filename"
        ## last_update 20230220
        mvp_file = "SCB and list of GJ and Sys_20230220_update ctl_ID on GJ sheet.xlsx"
        mvp_df = pandas.read_excel(os.path.join(parent_dir, mvp_file), sheet_name='3. Group Job', skiprows=3)
        
        df1 = drop_dup.apply(lambda x: x.astype(str).str.upper())
        df2 = mvp_df.apply(lambda x: x.astype(str).str.upper())
        m_df = pandas.merge(df1, df2, left_on='GROUP_JOB_NAME', right_on='Group Job')
        m_df = m_df.drop(m_df.columns[5:], axis=1)  
        
        return m_df
    
    def check_period_deploy(self, mvp_drop_dup, period_deploy, sheet):
        
        df1 = mvp_drop_dup.apply(lambda x: x.astype(str).str.upper())
        df2 = period_deploy.apply(lambda x: x.astype(str).str.upper())
        grouped = pandas.merge(df1, df2, left_on='GROUP_JOB_NAME', right_on='GROUP_JOB_NAME', how='left')
        
        self.sheet = self.wb.create_sheet(sheet)
        self.sheet.title = sheet
        
        rows = dataframe_to_rows(grouped, header=True, index=False)
        for r_idx, row in enumerate(rows, 1):
            for c_idx, val in enumerate(row, 1):
                value = self.sheet.cell(row=r_idx, column=c_idx)
                value.value = val
                
        self.wb.save(self.file_name)
        
        return grouped
    
    def write_to_gen_parameter(self, write_list, sheet):
        
        self.sheet = self.wb.create_sheet(sheet)
        self.sheet.title = sheet
        column = ['MVP1', 'MVP2', 'MVP3', 'MVP4', 'MVP6']
        i = 0
        for (col, li_val) in zip(column, write_list):
            for val in li_val:
                column = self.sheet.cell(row=i + 1, column=1)
                column.value = col
                value = self.sheet.cell(row=i + 2, column=1)
                value.value = val
                i += 3
            
        self.wb.save(self.file_name)
        
    async def spilt_sheet_ddl(self, dataframe, period_deploy):
        
        print("============== ddl ==============")
        
        # check column duplicate
        mvp_dup = dataframe.loc[dataframe.duplicated(subset=['VIEW_TABLE','GROUP_JOB_NAME','MVP']), :]
        print(f"count duplicated table_definitaion: {len(mvp_dup)}")
        print(f"delete duplicated table_definitaion: {mvp_dup['VIEW_TABLE'].values.tolist()}")
        ## drop duplicate and set to list
        mvp_drop_dup = dataframe[~dataframe.duplicated(subset=['VIEW_TABLE','GROUP_JOB_NAME','MVP'])]
        print(f"count after delete duplicated table_definitaion: {len(mvp_drop_dup)}")
        
        ## check name duplicate 
        new_df = mvp_drop_dup[~mvp_drop_dup.duplicated(subset=['VIEW_TABLE','MVP'])]
        ## check with deploy from sheet period ./output/template_{date_deploy}.xlsx
        self.check_period_deploy(new_df, period_deploy, sheet='ddl')
        
        mvp1 = new_df[new_df['MVP'] == 'MVP1']
        mvp2 = new_df[new_df['MVP'] == 'MVP2']
        mvp3 = new_df[new_df['MVP'] == 'MVP3']
        mvp4 = new_df[new_df['MVP'] == 'MVP4']
        mvp6 = new_df[new_df['MVP'] == 'MVP6']
        
        ## format output to list
        mvp1_to_list = str(list(mvp1["VIEW_TABLE"])).replace(" ", "\n")
        mvp2_to_list = str(list(mvp2["VIEW_TABLE"])).replace(" ", "\n")
        mvp3_to_list = str(list(mvp3["VIEW_TABLE"])).replace(" ", "\n")
        mvp4_to_list = str(list(mvp4["VIEW_TABLE"])).replace(" ", "\n")
        mvp6_to_list = str(list(mvp6["VIEW_TABLE"])).replace(" ", "\n")
        
        write_list = [[mvp1_to_list], [mvp2_to_list], [mvp3_to_list], [mvp4_to_list], [mvp6_to_list]]
        self.write_to_gen_parameter(write_list=write_list, sheet="list_ddl")
        
        return 'sheet_ddl completed ..'
    
    async def spilt_table_def(self, dataframe, period_deploy):
        
        print("============== table_def ==============")
        df = dataframe.loc[dataframe['COL_NM'] == 'TABLE']
        
        ## check column duplicate MVP
        mvp_dup = df.loc[df.duplicated(subset=['LIST','GROUP_JOB_NAME','MVP']), :]
        print(f"count duplicated table_definitaion: {len(mvp_dup)}")
        print(f"delete duplicated table_definitaion: {mvp_dup['LIST'].values.tolist()}")
        ## drop duplicate MVP and set to list
        mvp_drop_dup = df[~df.duplicated(subset=['LIST','GROUP_JOB_NAME','MVP'])]
        print(f"count after delete duplicated table_definitaion: {len(mvp_drop_dup)}")
        
        ## check name duplicate 
        new_df = mvp_drop_dup[~mvp_drop_dup.duplicated(subset=['LIST','MVP'])]
        ## check with deploy from sheet period ./output/template_{date_deploy}.xlsx
        self.check_period_deploy(new_df, period_deploy, sheet='table_definition')
        
        mvp1 = new_df[new_df['MVP'] == 'MVP1']
        mvp2 = new_df[new_df['MVP'] == 'MVP2']
        mvp3 = new_df[new_df['MVP'] == 'MVP3']
        mvp4 = new_df[new_df['MVP'] == 'MVP4']
        mvp6 = new_df[new_df['MVP'] == 'MVP6']

        spilt_col1 = mvp1["LIST"].str.split(",", n=1, expand=True)
        spilt_col2 = mvp2["LIST"].str.split(",", n=1, expand=True)
        spilt_col3 = mvp3["LIST"].str.split(",", n=1, expand=True)
        spilt_col4 = mvp4["LIST"].str.split(",", n=1, expand=True)
        spilt_col6 = mvp6["LIST"].str.split(",", n=1, expand=True)
        
        ## schema / table MVP1
        write_list = []
        if spilt_col1.empty is False:
            schema_to_list1 = str(list(spilt_col1[0])).replace(" ", "")
            table_to_list1 = str(list(spilt_col1[1])).replace(" ", "")
            grouped = [f"schema: {schema_to_list1}", f"table: {table_to_list1}"]
            write_list.append(grouped)
        else:
            grouped = ["schema: []", "table: []"]
            write_list.append(grouped)
            
        ## schema / table MVP2
        if spilt_col2.empty is False:
            schema_to_list2 = str(list(spilt_col2[0])).replace(" ", "")
            table_to_list2 = str(list(spilt_col2[1])).replace(" ", "")
            grouped = [f"schema: {schema_to_list2}", f"table: {table_to_list2}"]
            write_list.append(grouped)
        else:
            grouped = ["schema: []", "table: []"]
            write_list.append(grouped)
            
        ## schema / table MVP3
        if spilt_col3.empty is False:
            schema_to_list3 = str(list(spilt_col3[0])).replace(" ", "")
            table_to_list3 = str(list(spilt_col3[1])).replace(" ", "")
            grouped = [f"schema: {schema_to_list3}", f"table: {table_to_list3}"]
            write_list.append(grouped)
        else:
            grouped = ["schema: []", "table: []"]
            write_list.append(grouped)
            
        ## schema / table MVP4
        if spilt_col4.empty is False:
            schema_to_list4 = str(list(spilt_col4[0])).replace(" ", "")
            table_to_list4 = str(list(spilt_col4[1])).replace(" ", "")
            grouped = [f"schema: {schema_to_list4}", f"table: {table_to_list4}"]
            write_list.append(grouped)
        else:
            grouped = ["schema: []", "table: []"]
            write_list.append(grouped)
            
        ## schema / table MVP6
        if spilt_col6.empty is False:
            schema_to_list6 = str(list(spilt_col6[0])).replace(" ", "")
            table_to_list6 = str(list(spilt_col6[1])).replace(" ", "")
            grouped = [f"schema: {schema_to_list6}", f"table: {table_to_list6}"]
            write_list.append(grouped)
        else:
            grouped = ["schema: []", "table: []"]
            write_list.append(grouped)
        
        self.write_to_gen_parameter(write_list=write_list, sheet="list_table_definition")
        
        return 'table_def completed ..'
    
    async def spilt_system(self, dataframe, period_deploy):
        
        print("============== system_name ==============")
        df = dataframe.loc[dataframe['COL_NM'] == 'SYSTEM_NAME']
        
        # check column duplicate 
        mvp_dup = df.loc[df.duplicated(subset=['LIST','GROUP_JOB_NAME','MVP']), :]
        print(f"count duplicated system_name: {len(mvp_dup)}")
        print(f"delete duplicated system_name: {mvp_dup['LIST'].values.tolist()}")
        ## drop duplicate and set to list
        mvp_drop_dup = df[~df.duplicated(subset=['LIST','GROUP_JOB_NAME','MVP'])]
        print(f"count after delete duplicated system_name: {len(mvp_drop_dup)}")
        
        # check name duplicate 
        new_df = mvp_drop_dup[~mvp_drop_dup.duplicated(subset=['LIST','MVP'])]
        # check with deploy from sheet period ./output/template_{date_deploy}.xlsx
        self.check_period_deploy(new_df, period_deploy, sheet='system_name')
        
        ## check name duplicate 
        mvp1 = new_df[new_df['MVP'] == 'MVP1']
        mvp2 = new_df[new_df['MVP'] == 'MVP2']
        mvp3 = new_df[new_df['MVP'] == 'MVP3']
        mvp4 = new_df[new_df['MVP'] == 'MVP4']
        mvp6 = new_df[new_df['MVP'] == 'MVP6']
        
        ## format output to str
        mvp1_to_str = ','.join(map(str, list(mvp1["LIST"])))
        mvp2_to_str = ','.join(map(str, list(mvp2["LIST"])))
        mvp3_to_str = ','.join(map(str, list(mvp3["LIST"])))
        mvp4_to_str = ','.join(map(str, list(mvp4["LIST"])))
        mvp6_to_str = ','.join(map(str, list(mvp6["LIST"])))
        
        write_list = [[mvp1_to_str], [mvp2_to_str], [mvp3_to_str], [mvp4_to_str], [mvp6_to_str]]
        self.write_to_gen_parameter(write_list=write_list, sheet="list_system_name")
        
        ######## Add REGISTER_CONFIG_SYSTEM_ format ############
        add_column = pandas.DataFrame(mvp_drop_dup)
        add_column['SUFFIX'] = add_column['LIST'].apply(lambda x: "{}{}".format('REGISTER_CONFIG_SYSTEM_', x))
        
        # check name duplicate 
        new_add_str = add_column[~add_column.duplicated(subset=['LIST','MVP'])]
        # check with deploy from sheet period ./output/template_{date_deploy}.xlsx
        self.check_period_deploy(new_add_str, period_deploy, sheet='add_suffix_system_name')
        
        add_mvp1 = new_add_str[new_add_str['MVP'] == 'MVP1']
        add_mvp2 = new_add_str[new_add_str['MVP'] == 'MVP2']
        add_mvp3 = new_add_str[new_add_str['MVP'] == 'MVP3']
        add_mvp4 = new_add_str[new_add_str['MVP'] == 'MVP4']
        add_mvp6 = new_add_str[new_add_str['MVP'] == 'MVP6']

        ## format output to list
        mvp1_to_list = str(list(add_mvp1["SUFFIX"])).replace(" ", "")
        mvp2_to_list = str(list(add_mvp2["SUFFIX"])).replace(" ", "")
        mvp3_to_list = str(list(add_mvp3["SUFFIX"])).replace(" ", "")
        mvp4_to_list = str(list(add_mvp4["SUFFIX"])).replace(" ", "")
        mvp6_to_list = str(list(add_mvp6["SUFFIX"])).replace(" ", "")
        
        write_list = [[mvp1_to_list], [mvp2_to_list], [mvp3_to_list], [mvp4_to_list], [mvp6_to_list]]
        self.write_to_gen_parameter(write_list=write_list, sheet="list_add_suffix_system_name")
        
        return 'system_name completed ..'
    
    async def spilt_int_mapp(self, dataframe, period_deploy):
        
        print("============== int_mapping ==============")
        df = dataframe.loc[dataframe['COL_NM'] == 'INTERFACE_NAME']
        
        # check column duplicate 
        mvp_dup = df.loc[df.duplicated(subset=['LIST','GROUP_JOB_NAME','MVP']), :]
        print(f"count duplicated int_mapping: {len(mvp_dup)}")
        print(f"delete duplicated int_mapping: {mvp_dup['LIST'].values.tolist()}")
        ## drop duplicate  and set to list
        mvp_drop_dup = df[~df.duplicated(subset=['LIST','GROUP_JOB_NAME','MVP'])]
        print(f"count after delete duplicated int_mapping: {len(mvp_drop_dup)}")
        
        ## check name duplicate 
        new_df = mvp_drop_dup[~mvp_drop_dup.duplicated(subset=['LIST','MVP'])]
        # check with deploy from sheet period ./output/template_{date_deploy}.xlsx
        self.check_period_deploy(new_df, period_deploy, sheet='int_mapping')
        
        mvp1 = new_df[new_df['MVP'] == 'MVP1']
        mvp2 = new_df[new_df['MVP'] == 'MVP2']
        mvp3 = new_df[new_df['MVP'] == 'MVP3']
        mvp4 = new_df[new_df['MVP'] == 'MVP4']
        mvp6 = new_df[new_df['MVP'] == 'MVP6']
        
        # format output to list
        mvp1_to_list = str(list(mvp1["LIST"])).replace(" ", "")
        mvp2_to_list = str(list(mvp2["LIST"])).replace(" ", "")
        mvp3_to_list = str(list(mvp3["LIST"])).replace(" ", "")
        mvp4_to_list = str(list(mvp4["LIST"])).replace(" ", "")
        mvp6_to_list = str(list(mvp6["LIST"])).replace(" ", "")
        
        write_list = [[mvp1_to_list], [mvp2_to_list], [mvp3_to_list], [mvp4_to_list], [mvp6_to_list]]
        self.write_to_gen_parameter(write_list=write_list, sheet="list_int_mapping")

        return 'int_mapping completed ..'
        
    async def find_excel_file(self):
        
        current_path = os.getcwd() + '/parameter'
        list_of_files = glob.glob(f'{current_path}/*')
        
        try:
            latest_file = max(list_of_files, key=os.path.getmtime)
            sheet1 = self.join_mvp(drop_dup=pandas.read_excel(latest_file, sheet_name='all'))
            sheet2 = self.join_mvp(drop_dup=pandas.read_excel(latest_file, sheet_name='ddl'))
            sheet3 = pandas.read_excel(latest_file, sheet_name='period')
            
            with pandas.ExcelWriter(f'./output/{self.date}/template_{self.date_fmt}.xlsx') as writer:
                sheet1.to_excel(writer, sheet_name='all', index=False)
                sheet2.to_excel(writer, sheet_name='ddl', index=False, columns=['VIEW_TABLE', 'GROUP_JOB_NAME', 'MVP'])
                sheet3.to_excel(writer, sheet_name='period', index=False)
            
            coros = [
                asyncio.create_task(self.spilt_int_mapp(sheet1, sheet3)),
                asyncio.create_task(self.spilt_system(sheet1, sheet3)),
                asyncio.create_task(self.spilt_table_def(sheet1, sheet3)),
                asyncio.create_task(self.spilt_sheet_ddl(sheet2, sheet3))
            ]
            results = await asyncio.wait(coros)
            print(f'Completed task: {len(results[0])}')
            [print(f"- {completed_task.result()}") for completed_task in results[0]]    
            print(f'Uncompleted task: {len(results[1])}')
            
        except ValueError as err:
            raise Exception("File not found !!")