#!/bin/bash

declare -A extensions

# 读取 .gitignore 文件中的忽略模式
readarray -t ignore_patterns < <(git ls-files -o --exclude-standard --others | grep -o '\.[^.]*$' | sort -u)

# 排除 .git 文件夹并查找文件
find . -type f -not -path "./.git/*" -print0 | while IFS= read -r -d $'\0' file; do
    if [[ "$file" == "." ]]; then
        continue
    fi
    filename=$(basename "$file")
    ext="${filename##*.}"
    if [[ "$ext" == "$filename" ]]; then
        ext=""
    fi

    ignored=false
    for pattern in "${ignore_patterns[@]}"; do
        # 使用通配符匹配
        if [[ ".$ext" == "$pattern" ]]; then #注意此处需要加上一个.
            ignored=true
            break
        fi
    done

    if ! $ignored; then
        if [[ -z "${extensions[$ext]}" ]]; then
            extensions[$ext]=1
            echo "$ext"
        fi
    fi
done