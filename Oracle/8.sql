--刪除系統碎片文件
rm -rf {} \;
find $i -mtime +1 -name "*2020*"  -exec rm -rf {} \;
find $i -mtime +1 -name "*2021*"  -exec rm -rf {} \;
find $i -mtime +1 -name "*2022*"  -exec rm -rf {} \;
done
