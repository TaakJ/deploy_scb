import pandas
import os
import glob
import asyncio
import datetime
import openpyxl 

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
        self.sheet.title = "sheet1"
        
    def run(self):
        loop = asyncio.get_event_loop()
        loop.run_until_complete(self.find_excel_file())
        
    async def spilt_sheet_ddl(self, latest_file):
        
        print("============== sheet_ddl ==============")
        df = pandas.read_excel(latest_file, sheet_name='Sheet2')
        dup = df.loc[df.duplicated('VIEW_TABLE'), :]
        # check column duplicate
        print(f"count dup sheet_ddl: {len(dup)}")
        print(f"delete dup sheet_ddl: {dup['VIEW_TABLE'].values.tolist()}")
        # drop dup and set to list
        drop_dup = df[~df.duplicated('VIEW_TABLE')]
        print(f"count after delete dup sheet_ddl: {len(drop_dup)}\n")
        
        sheet_ddl_to_list = str(list(drop_dup["VIEW_TABLE"])).replace(" ", "\n") # format output to list
        sheet_ddl_to_str = ',\n'.join(map(str, list(drop_dup["VIEW_TABLE"]))) # format output to string
        
        # write output excel
        column = self.sheet.cell(row=21, column=1)
        column.value ="- LIST DDL"
        value = self.sheet.cell(row=22, column=1)
        value.value = sheet_ddl_to_list
        self.wb.save(self.file_name)
        
        return 'sheet_ddl completed ..'
        
    async def spilt_table_def(self, dataframe):
        
        print("============== table_def ================")
        df = dataframe.loc[dataframe['COL_NM'] == 'TABLE']
        # check column duplicate
        dup = df.loc[df.duplicated('LIST'), :]
        print(f"count dup table_def: {len(dup)}")
        print(f"delete dup table_def: {dup['LIST'].values.tolist()}")
        # drop dup and set to list
        drop_dup = df[~df.duplicated('LIST')]
        print(f"count after delete dup table_def: {len(drop_dup)}\n")
        col = drop_dup["LIST"].str.split(",", n=1, expand=True)
        
        schema_to_list = str(list(col[0])).replace(" ", "") # format output to list
        # schema_to_str = ','.join(map(str, list(col[0])))
        table_to_list = str(list(col[1])).replace(" ", "")  # format output to str
        # table_to_str = ','.join(map(str, list(col[1])))
        
        # write to output schema excel
        column = self.sheet.cell(row=13, column=1)
        column.value = "- LIST_SCHEMA_NAME"
        value = self.sheet.cell(row=14, column=1)
        value.value = schema_to_list
        
        # write to output table excel
        column = self.sheet.cell(row=17, column=1)
        column.value = "- LIST_TABLE_NAME"
        value = self.sheet.cell(row=18, column=1)
        value.value = table_to_list
        
        self.wb.save(self.file_name)
        
        return 'table_def completed ..'
    
    async def spilt_system(self, dataframe):
        
        print("============= system_name ===============")
        df = dataframe.loc[dataframe['COL_NM'] == 'SYSTEM_NAME']
        
        # check column duplicate
        dup = df.loc[df.duplicated('LIST'), :]
        print(f"count dup system_name: {len(dup)}")
        print(f"delete dup system_name: {dup['LIST'].values.tolist()}")
        # drop dup and set to list
        drop_dup = df[~df.duplicated('LIST')]
        print(f"count after delete dup system_name: {len(drop_dup)}\n")
        
        sysname_to_list1 = str(list(drop_dup["LIST"])).replace(" ", "") # format output to list
        print(sysname_to_list1)
        sysname_to_str1 = ','.join(map(str, list(drop_dup["LIST"]))) # format output to str
        
        # Add REGISTER_CONFIG_SYSTEM_ format
        add_str = drop_dup[['LIST', 'COL_NM']]
        add_str['SUFFIX'] = add_str['LIST'].apply(lambda x: "{}{}".format('REGISTER_CONFIG_SYSTEM_', x))
        sysname_to_list2 = str(list(add_str["SUFFIX"])).replace(" ", "") # format output to list
        sysname_to_str2 = ','.join(map(str, list(add_str["SUFFIX"])))  # format output to str
        
        # write to output excel
        column = self.sheet.cell(row=5, column=1)
        column.value = "- LIST_SYSTEM_NAME"
        value = self.sheet.cell(row=6, column=1)
        value.value = sysname_to_str1
        
        # write to output excel
        column = self.sheet.cell(row=9, column=1)
        column.value = "- LIST_FULL_SYSTEM_NAME"
        value = self.sheet.cell(row=10, column=1)
        value.value = sysname_to_list2
        
        self.wb.save(self.file_name)
        
        return 'system_name completed ..'
    
    
    async def spilt_int_map(self, dataframe):
        
        print("============== int_mapping ==============")
        df = dataframe.loc[dataframe['COL_NM'] == 'INTERFACE_NAME']
        print(df)
        # check column duplicate
        dup = df.loc[df.duplicated('LIST'), :]
        print(f"count dup int_mapping: {len(dup)}")
        print(f"delete dup int_mapping: {dup['LIST'].values.tolist()}")
        # drop dup and set to list
        drop_dup = df[~df.duplicated('LIST')]
        print(f"count after delete dup int_mapping: {len(drop_dup)}")
        
        intmap_to_list = str(list(drop_dup["LIST"])).replace(" ", "") # format output to list
        intmap_to_str = ','.join(map(str, list(drop_dup["LIST"]))) # format output to string
        
        # write to output excel
        column = self.sheet.cell(row=1, column=1)
        column.value = "- LIST_INT_MAPPING"
        value = self.sheet.cell(row=2, column=1)
        value.value = intmap_to_list
        self.wb.save(self.file_name)
    
        return 'int_mapping completed ..'
        
        
    async def find_excel_file(self):
        
        current_path = os.getcwd() + '/parameter'
        list_of_files = glob.glob(f'{current_path}/*')
        try:
            latest_file = max(list_of_files, key=os.path.getmtime)
            dataframe = pandas.read_excel(latest_file, sheet_name='Sheet1')
            coros = [
                # *** Can comment function 
                asyncio.create_task(self.spilt_int_map(dataframe)),
                asyncio.create_task(self.spilt_system(dataframe)),
                asyncio.create_task(self.spilt_table_def(dataframe)),
                asyncio.create_task(self.spilt_sheet_ddl(latest_file))
            ]
            results = await asyncio.wait(coros)
            # print(f'Completed task: {len(results[0])}')
            # [print(f"- {completed_task.result()}") for completed_task in results[0]]    
            # print(f'Uncompleted task: {len(results[1])}')
            
        except ValueError as err:
            raise Exception("File not found !!")