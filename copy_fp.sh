#!/bin/bash

# 获取当前日期，格式为 YYYY-MM-DD
current_date=$(date +%Y-%m-%d)
# 源目录
source_dir="/data/yonyou/home/nclogs"
# 目标目录
target_dir="/data/nclog备份/$current_date"

# 查找所有符合条件的文件并复制
find "$source_dir" -type d -name "default*" -print0 | while IFS= read -r -d '' default_dir; do
    echo "Processing directory: $default_dir"
    find "$default_dir" -type f \( -name "*fapiao*" -o -name "*imag*" \) -mtime 0 -print0 | while IFS= read -r -d '' log_file; do
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

# 在所有文件复制完成后进行压缩
echo "Starting compression..."
# 获取当前日期作为压缩文件名的一部分
current_date=$(date +"%Y%m%d")
# 在目标目录下创建压缩文件
cd "$target_dir" || exit
tar -czf "nclog备份_${current_date}.tar.gz" ./*
if [ $? -eq 0 ]; then
    echo "Compression completed successfully: $target_dir/nclog备份_${current_date}.tar.gz"
    # 删除已压缩的原始文件和文件夹，但保留压缩包
    find "$target_dir" -mindepth 1 ! -name "*.tar.gz" -delete
    echo "Original files and directories have been removed"
else
    echo "Compression failed"
fi