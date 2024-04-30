#!/bin/env python3
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import bisect
import os
import sys
import multiprocessing as mp

input_filename = sys.argv[1]
filename = input_filename.split("/")[-1]
data_path = "data/" + filename + "_run.formated"
output_fig_name = "data_write_count_fig/" + filename + "_run.formated" + ".png"
output_fig_95_name = "data_write_count_fig/" + filename + "_run.formated" + "_95.png"
print("data_path:", data_path)
print("output_fig_name:", output_fig_name)
print("output_fig_95_name:", output_fig_95_name)
# exit(0)

os.makedirs("data_write_count_fig/", exist_ok=True)

df = pd.read_csv(data_path, delimiter=' ', header=None, names=['op', 'key'])
df_count_update = df.groupby('op').get_group('UPDATE')
df_count = df_count_update.groupby('key').size().reset_index(name='counts')
df_count_sort = df_count.sort_values(by=['counts'], ascending=True)
count_row, count_col = df_count_sort.shape

cdf_x = np.array(df_count_sort['counts'])
cdf_y = 1. * np.arange(len(cdf_x)) / (len(cdf_x) - 1)

plt.plot(cdf_x, cdf_y, label='overall write:{}, key:{}'.format(len(df_count_update), len(df_count)))
plt.xlabel('write count')
plt.ylabel('cdf')
plt.legend()
plt.savefig(output_fig_name)
plt.close()
plt.figure()
sum_of_all_write = df_count_sort['counts'].sum()

# first 95% of rows
df_count_sort_95 = df_count_sort.iloc[:int(count_row * 0.95)]
sum_of_first_95_write = df_count_sort_95['counts'].sum()
print('95% write count:', sum_of_first_95_write)
delta = sum_of_all_write - sum_of_first_95_write
print('top 5% write count:', delta)

cdf_x = np.array(df_count_sort_95['counts'])
cdf_y = 1. * np.arange(len(cdf_x)) / (len(cdf_x) - 1)

plt.plot(cdf_x, cdf_y, label='overall write:{}, key:{}'.format(len(df), len(df_count)))
plt.xlabel('write count')
plt.ylabel('cdf')
plt.legend()
plt.savefig(output_fig_95_name)
plt.close()
