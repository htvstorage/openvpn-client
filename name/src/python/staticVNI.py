import pandas as pd
import numpy as np
import argparse
from tabulate import tabulate
import glob
import re

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--input_symbol', type=str, help='input file path')

args = parser.parse_args()

# if args.input_file:
#     df = pd.read_csv(args.input_file)
#     df.fillna(0, inplace=True)
#     print(df)
# else:
#     print("Input file path is required")

if args.input_symbol:
    symbol = args.input_symbol
else:
    print("Input symbol path is required")

# Đường dẫn đến thư mục chứa các file CSV cần đọc
path = '/workspace/openvpn-client/name/vnindex/'


files_to_ignore = ".*20221207.*|.*20221208.*|.*20221209.*"   # pattern to ignore

# Lấy danh sách các file CSV trong thư mục đó
csv_files = glob.glob(f'{path}*/{symbol}*.csv')
temp = []
for file in csv_files:
    match = re.search(files_to_ignore,file)
    if not match:
        temp.append(file)
csv_files = temp

# Tạo một list rỗng để chứa các DataFrame
dfs = []

# Đọc từng file CSV và gộp chúng lại thành một DataFrame lớn
for file in csv_files:
    df = pd.read_csv(file)
    dfs.append(df)

merged_df = pd.concat(dfs, ignore_index=True)
df = merged_df
# df.loc[df['h'] > 1000,['o','h','l','c']] = df.loc[df['h'] > 1000,['o','h','l','c']] / 1000
# df.fillna(0, inplace=True)
df.replace([np.inf, -np.inf], np.nan, inplace=True)
df.fillna(df.mean(), inplace=True)
# df['h-l'] = df['h'] - df['l']
# df['h-o'] = df['h'] - df['o']
# Đọc file csv
# df = pd.read_csv('path/to/file.csv')

# Tính toán các thống kê
num_values = df.count()
max_value = df.max()
min_value = df.min()
mean = df.mean()
median = df.median()
variance = df.var()
std_dev = df.std()
mad = df.mad()
skewness = df.skew()

# Tính toán z-score
z_score = np.abs((df - mean) / std_dev)
# print(z_score)
# Đánh dấu các giá trị bất thường
outlier_threshold = 3.0
df_is_outlier = z_score.apply(lambda x: x > outlier_threshold)


# In các thống kê và số lượng giá trị bất thường
print(f"Number of values:\n {num_values}")
print(f"Max value:\n {max_value}")
print(f"Min value:\n {min_value}")
print(f"Mean:\n {mean}")
print(f"Median:\n {median}")
print(f"Variance:\n {variance}")
print(f"Standard deviation:\n {std_dev}")
print(f"Mean absolute deviation:\n {mad}")
print(f"Skewness:\n {skewness}")
# print(f"Number of outliers: {df['is_outlier'].sum()}")
cols_to_keep = ['abu', 'acum_busd', 'acum_busd_val', 'acum_val_bu', 'acum_val_sd', 'acum_val', 'avg_val_bu',
                'avg_val_sd', 'rbusd', 'asd', 'auk', 'bs', 'bu', 'bu-sd', 'bu-sd_val', 'c', 'date', 'datetime']
# df_filtered = df[cols_to_keep]
# print(tabulate(df_filtered, headers='keys', tablefmt='psql'))
# print(df.columns.values)
# print(type(num_values))

dfs = pd.DataFrame({'values': num_values, 'Max': max_value, 'Min': min_value, 'Mean': mean,
                   'Median': median, 'Variance': variance, 'Std': std_dev, 'MAD': mad, 'Skewness': skewness})

print(tabulate(dfs, headers='keys', tablefmt='psql'))   
# print(df_is_outlier)   
# print(tabulate(z_score, headers='keys', tablefmt='psql'))   
# df_filtered = df[df['pbu'] == 100.0]
# df.loc[df['h'] > 1000,['o','h','l','c']] = df.loc[df['h'] > 1000,['o','h','l','c']] / 1000
# print(tabulate(df_filtered, headers='keys', tablefmt='psql'))   
# print(df_filtered.T)
# print(df_filtered.shape,df.shape)
