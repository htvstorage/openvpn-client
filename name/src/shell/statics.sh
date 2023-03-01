#!/bin/bash


# Kiểm tra xem có đủ đối số đầu vào không
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <csv_file>"
    exit 1
fi

# Lấy đường dẫn tới file CSV từ đối số đầu vào
file_path="$1"

# Đường dẫn tới file CSV
# file_path="./data.csv"

# Đọc header của file CSV
header=$(head -n 1 $file_path)

# Tạo một mảng để lưu các tên cột
IFS=',' read -ra col_names <<< "$header"

# Tính số lượng cột
num_cols=${#col_names[@]}

# In ra các tên cột
echo "Column names:"
for col_name in "${col_names[@]}"
do
    echo $col_name
done
echo ""

# Lấy dữ liệu từ file CSV
data=$(tail -n +2 $file_path)

# Tạo một mảng 2 chiều để lưu dữ liệu
declare -A data_array

# Duyệt qua từng dòng dữ liệu
while IFS= read -r line
do
    # Tách dữ liệu trong dòng thành các trường dữ liệu
    IFS=',' read -ra row <<< "$line"
    
    # Duyệt qua từng trường dữ liệu trong dòng
    for i in "${!row[@]}"
    do
        # Thêm dữ liệu vào mảng 2 chiều
        data_array[$i]+=${row[$i]}
    done
done <<< "$data"

# Tính các thông số thống kê cho từng cột
for i in "${!col_names[@]}"
do
    col_name=${col_names[$i]}
    col_data=${data_array[$i]}

    # Chuyển đổi chuỗi dữ liệu thành mảng số
    IFS=' ' read -ra nums <<< "$col_data"

    # Tính các thông số thống kê
    num_count=${#nums[@]}
    sum=0
    sum_sq=0
    abs_dev_sum=0
    max=${nums[0]}
    min=${nums[0]}

    for num in "${nums[@]}"
    do
        if [[ $num =~ ^[0-9]+$ ]]; then
            sum=$((sum + num))
            # ...
        else
            num=0
        fi    
        sum=$((sum + num))
        sum_sq=$((sum_sq + num * num))
        abs_dev_sum=$((abs_dev_sum + ${num#-} ))
        
        if (( $(echo "$num > $max" | bc -l) )); then
            max=$num
        fi

        if (( $(echo "$num < $min" | bc -l) )); then
            min=$num
        fi
    done

    mean=$(echo "scale=2;$sum / $num_count" | bc -l)
    variance=$(echo "scale=2;($sum_sq - $sum * $mean) / $num_count" | bc -l)
    std_dev=$(echo "scale=2;sqrt($variance)" | bc -l)
    median=$(echo "${nums[@]}" | tr ' ' '\n' | sort -n | awk '{a[NR]=$1} END{print (NR%2==0)?(a[NR/2]+a[NR/2+1])/2:a[(NR+1)/2]}')
    mean_abs_dev=$(echo "scale=2;$abs_dev_sum / $num_count" | bc -l)
    mean_dev=$(echo "scale=2;($max + $min) / 2" | bc -l)

    # Tính skewness 
    skewness=0
    if (( $(echo "$std_dev > 0" | bc -l) )); then
        skewness=$(echo "${nums[@]}" | tr ' ' '\n' | awk '{sum+=($1-'$mean')^3} END{print (sum/NR)/('$std_dev')^3}')
    fi

    # Tìm các giá trị bất thường (abnormal) nếu có
    abnormal=""
    for num in "${nums[@]}"
    do
        if (( $(echo "$num > ($max + 1.5 * $std_dev)" | bc -l) )) || (( $(echo "$num < ($min - 1.5 * $std_dev)" | bc -l) )); then
            abnormal+=" $num"
        fi
    done

    # In ra các thông số thống kê
    echo "Statistics for column $col_name:"
    echo "-----------------------------------"
    echo "Number of values: $num_count"
    echo "Max value: $max"
    echo "Min value: $min"
    echo "Mean: $mean"
    echo "Median: $median"
    echo "Variance: $variance"
    echo "Standard deviation: $std_dev"
    echo "Mean absolute deviation: $mean_abs_dev"
    echo "Mean deviation: $mean_dev"
    echo "Skewness: $skewness"
    if [[ $abnormal ]]; then
        echo "Abnormal values:$abnormal"
    fi
    echo ""
done        