# -*- coding: utf-8 -*-
# coding: utf-8
#sudo pip install Pillow

#gem install xcodeproj
#pod cache clean --all
#pod repo update
#pod update

#!/usr/bin/python

#from biplist import *
from array import *
import math
import os
import sys
import argparse
import plistlib
#import requests
import json

#需要pip3 install pandas
import pandas as pd 

import csv


def csv_to_json(csv_file_path, json_file_path):
    # Read the CSV file and parse its contents
    with open(csv_file_path, 'r', encoding='utf-8') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        data = [row for row in csv_reader]
    
    #print(data)
    # Write the parsed data to a JSON file
    with open(json_file_path, 'w', encoding='utf-8') as json_file:
        json.dump(data, json_file, ensure_ascii=False, indent=4)

# def csv_to_json(csv_file_path, json_file_path):
#     if os.path.exists(csv_file_path):
#         item_array=[]

#         df = pd.read_csv(csv_file_path)
#         df = df.fillna('') #设置空值为空串
#         json_str = df.to_json(orient='records', force_ascii=False) #force_ascii为False,使用文件本身的字符编码
#         json_data = json.loads(json_str)

#         #print(json_str)
#         if isinstance(json_data, list):
#             for item in json_data:
#                 if isinstance(item, dict):
#                     category = item["category"]
#                     category = item["name"]
#                     pixel_width = item["pixel_width"]
#                     pixel_height = item["pixel_height"]
#                     size_width = item["size_width"]
#                     size_height = item["size_height"]

#                     print("key:", key)
#                     value = item[lan_code]
#                     if len(key) > 0 and len(value) > 0:
#                         item = f"\"{key}\"=\"{value}\";"
#                         item_array.append(item)
#             print(item_array)

#         if len(item_array) > 0:
#             filepath = "./" + json_file_path
#             if os.path.exists(filepath):
#                 with open(filepath, "w") as f:
#                     for item in item_array:
#                         f.write(item + '\n')



_NAME = ''
_CONFIG_FILENAME = ''

if __name__ == '__main__':

    #parser = argparse.ArgumentParser()
    #parser.add_argument("-u", "--update", action='store', help="Update localization file.")
    #parser.add_argument("-mode", type=string, required=True, help="Input ")
    #parser.add_argument("-l", "--log", default=False, action="store_true", help="active log info.")
 
    arguments = sys.argv
    need_update_localization_file = False
    sheet_name = 'Sheet1'

    #判断参数是否包含-u或-update
    if len(arguments) > 1: 
        for arg in arguments:
            if len(str(arg)) > 0:
                if arg == '-u' or arg == '-update':
                    need_update_localization_file = True
                    break

    #print("need_update_localization_file: ", need_update_localization_file)


    # 打印命令行参数
    # for arg in arguments:
    #     print(arg)
    #     if len(str(arg)) > 0:
    #         print('参数：',arg)

    # args, unknown_args = parser.parse_known_args()
    # need_update_localization_file = args.update
    # print("need_update_localization_file: ", need_update_localization_file)


    #print("Step 1. ####################### AppConfig Updating #######################")

    language_codes = ["en","zh-Hans","fr","es"]
    all_item_array = []
    # Example usage
    csv_to_json('photo_size.csv', 'photo_size.json')
