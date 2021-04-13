#!/bin/bash
# author  wangweixu
# data    2021年04月08日17:05:38
# note    修改指定包名并新建文件

# read-multiple: read multiple values from keyboard
#echo "$(pwd)"

echo -e "修改指定diff补丁文件,替换包名,params \n{0} : currentPkgName \t {1} : currentPointPkgName \t {2} : newPkgName \t {3} : fileName \t {4} : backName \t "
echo "Enter one or more values > "
read currentPkgName newPkgName fileName generateFileName var5

# 避免输入的包名被sed关键字替换 将 '.' 转换成'\.'  '/' 转换成 '\/'
currentPointPkgName=$currentPkgName
currentPkgName=${currentPkgName//./\\/}
currentPointPkgName=${currentPointPkgName//./\\.}

newPointPkgName=$newPkgName
newPkgName=${newPkgName//./\\/}
newPointPkgName=${newPointPkgName//./\\.}

echo "currentPkgName = '$currentPkgName'"
echo "currentPointPkgName = '$currentPointPkgName'"
echo "newPkgName = '$newPkgName'"
echo "newPointPkgName = '$newPointPkgName'"
echo "fileName = '$fileName'"
echo "generateFileName = '$generateFileName'"
echo "var5 = '$var5'"

#sed -i "$backName" 's|$currentPkgName|$newPkgName#g' $fileName

#currentPkgName="com\/senyint\/prod\/edu\/shaanxi"
#currentPkgName="com.senyint.prod.edu.shaanxi"
#currentPointPkgName="com\.senyint\.prod\.edu\.shaanxi"
#newPkgName="com\/senyint\/prod\/edu\/sector"
#newPointPkgName="com.senyint.prod.edu.sector"
#fileName='shannxi-patch.diff'
#generateFileName='empty-live-patch.diff'

#echo ${currentPkgName//./\\/}
#echo ${currentPointPkgName//./\\.}

sed -e "s|$currentPkgName|$newPkgName|g;s|$currentPointPkgName|$newPointPkgName|g;" $fileName > $generateFileName

#sed -i "$backName" "s|$currentPkgName|$newPkgName|g;s|$currentPointPkgName|$newPointPkgName|g;" $fileName
# sed -i "$backName" "s|'"$currentPkgName"'|'"$newPkgName"'|g;s|'"$currentPointPkgName"'|'"$newPkgName"'|g" $fileName
