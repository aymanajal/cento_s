#!/bin/bash

# 获取两天前的日期，格式为 YYYY-MM-DD
two_days_ago=$(date -d "2 days ago" +%Y-%m-%d)
# 定义日志文件夹的父目录
log_parent_dir="/data/nclogbackup"

# 删除两天前的日志文件夹
rm -rf "$log_parent_dir/$two_days_ago"
