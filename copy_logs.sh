#!/bin/bash

# 获取当前日期，格式为 YYYY-MM-DD
current_date=$(date +%Y-%m-%d)
# 定义日志文件夹路径
log_dir="/data/nclogbackup/logs/$current_date"
# 定义备份文件存放的目标目录
target_dir="/data/nclogbackup/$current_date"

# 创建日志文件夹
mkdir -p "$log_dir"
# 重定向标准输出和标准错误输出到日志文件
exec > "$log_dir/copy_logs.log" 2>&1

# 源目录
source_dir="/data/yonyou/home/nclogs"

# 查找所有符合条件的文件并复制
find "$source_dir" -type d -name "default*" -print0 | while IFS= read -r -d '' default_dir; do
    echo "Processing directory: $default_dir"
    find "$default_dir" -type f -name "nc-log*" -print0 | while IFS= read -r -d '' log_file; do
        echo "Processing file: $log_file"
        # 计算目标文件路径
        relative_path="${log_file#$source_dir/}"
        target_file="$target_dir/$relative_path"
        # 创建目标文件的上级目录
        mkdir -p "$(dirname "$target_file")"
        # 复制文件
        cp "$log_file" "$target_file"
        if [ $? -ne 0 ]; then
            echo "Failed to copy $log_file to $target_file"
        fi
    done
done