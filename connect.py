import os, uuid
import datetime
import openpyxl
from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient


class run_process_connect():
    
    def __init__(self, date):
        self.date = date
    
    def connect_storage(self):
        print("OK")
    
    @property
    def download_from_storage(self):
        self.date_fmt = datetime.datetime.strptime(self.date, '%Y-%m-%d').strftime('%Y%m%d')        
        self.wb = openpyxl.Workbook()
        parent_dir  = "./filename/DDL"
        path = os.path.join(parent_dir, self.date)
        os.makedirs(path, exist_ok=True)
        