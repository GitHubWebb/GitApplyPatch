#!/bin/bash
# author wangweixu
# data 2021年04月08日17:05:38

# 为所有 .sh 脚本添加执行权限
# chmod u+x *.sh

# 查找diff文件
function findDiffFile() {
  #  find $(pwd) | grep diff$
  #  ls -a $(pwd)/diff | grep 'diff$'

  diffArrStr=$(ls -a | grep 'diff$')
  #  echo diffArrStr $diffArrStr

  isFileDiff=false
  # 此处调用需要获取函数返回值,所以要在当前线程执行  要使用source 不能使用 sh
  source $BASE_PATH/verifyFileType.sh ${diffArrStr}
  #  echo $isFileDiff

  if ! ($isFileDiff); then
    #    echo "is directory"
    #    当前是目录的情况下 cd进目录重新执行查找
    cd $diffArrStr

    findDiffFile $BASE_PATH
    exit
  else
    #    echo "is file"
    #    当前是diff所在目录情况下,执行后续选择逻辑
    optionReadLine
  fi

}

# 选项逻辑
function optionReadLine() {

  diffArrStrIndex=0
  diffArrIndex=0
  createNewDiff="基于昌平补丁文件生成新补丁"

  for file in $diffArrStr; do
    diffArr[$diffArrStrIndex]="$file" # (为了准确起见，此处要加上双引号“”）
    ((diffArrStrIndex++))

    #  iffArr[$c]=$file
    #    echo iffArr[$diffArrStrIndex]
    #  diffArrStrIndex=`expr $diffArrStrIndex + 1`
  done

  diffArr[${#diffArr[*]}]=${createNewDiff}
  ((diffArrStrIndex++))

  echo "在屏幕上输出diffArr数组长度："
  echo ${#diffArr[*]}
  echo '注：用${#数组名[@或*]} 可以得到数组长度'

  echo "把diffArr数组内容输出到屏幕上："

  clear
  echo "
Please Select:"
  while [ $diffArrIndex -lt $diffArrStrIndex ]; do
    #  echo $diffArrIndex ${diffArr[$diffArrIndex]}
    echo -e "\t $(expr $diffArrIndex + 1). ${diffArr[$diffArrIndex]}"
    ((diffArrIndex++))

  done

  echo -e "\t 0. Quit
"

  currentPkgName="com.xinyi.edu.college.stu"
  newPkgName="com\/senyint\/prod\/edu\/sector"
  fileName='changping-patch.diff'
  generateFileName='empty-live-patch.diff'

  read -p "Enter selection [0-${#diffArr[*]}] > "
  if [[ $REPLY =~ ^[0-${#diffArr[*]}]$ ]]; then
    if [[ $REPLY == 0 ]]; then
      echo "Program terminated."
      exit
    fi

    inputValueDiff=${diffArr[$(expr $REPLY - 1)]}
    echo inputValueDiff ${inputValueDiff}

    if [[ $inputValueDiff == changping-patch.diff || $inputValueDiff == $createNewDiff ]]; then
      read -p "enter newPkgName:" newPkgName
      read -p "enter generateFileName:" generateFileName
      echo you have entered $newPkgName, $generateFileName

      currentPkgName="com.xinyi.edu.college.stu"

      sedPkgName $currentPkgName\t$newPkgName\t$fileName\t$generateFileName

    fi

    if [[ $inputValueDiff == prod-live-patch.diff ]]; then
      currentPkgName="com.xinyi.edu.college.stu"
      newPkgName="com.xinyi.prodedugateway.edu.college.stu"
      generateFileName="prod-live-patch.diff"

      sedPkgName $currentPkgName\t$newPkgName\t$fileName\t$generateFileName

    fi
    if [[ $inputValueDiff == shannxi-live-patch.diff ]]; then
      currentPkgName="com.xinyi.edu.college.stu"
      newPkgName="com.senyint.prod.edu.shaanxi"
      generateFileName="shannxi-live-patch.diff"

      sedPkgName $currentPkgName\t$newPkgName\t$fileName\t$generateFileName

    fi
    if [[ $inputValueDiff == empty-live-patch.diff ]]; then
      currentPkgName="com.xinyi.edu.college.stu"
      newPkgName="com.senyint.prod.edu.sector"
      generateFileName="empty-live-patch.diff"

      sedPkgName $currentPkgName\t$newPkgName\t$fileName\t$generateFileName

    fi

  else

    echo "Invalid entry." >&2
    exit 1
  fi

  # 如果将 /shell & /diff 两个目录放到项目根目录运行则调用 cd ../
  # 否则需要指定项目地址  cd /usr/home/project/xxx/
  projectParentPath="/Users/wangweixu/senyint/project/xinyixy-android-git-androidx"
  # projectParentPath="../"

  read -r -p "$generateFileName 已生成完毕 是否应用补丁? [Y/n] " input
  case $input in
  [yY][eE][sS] | [yY])
    echo "Yes"
    source $BASE_PATH/applyGitPatch.sh $projectParentPath $generateFileName

    ;;

  [nN][oO] | [nN])
    echo "No"
    ;;

  *)
    echo "Invalid input..."
    exit 1
    ;;
  esac

}

# 编写函数 调用修改包名的脚本
# @param currentPkgName     当前包名 com.xxx.xxx
# @param newPkgName         修改后的包名 org.xxx.xxx
# @param fileName           要修改的文件名称
# @param generateFileName   修改后生成新的文件名称
function sedPkgName() {
  inputParamsSed=$(echo -e "$currentPkgName\t$newPkgName\t$fileName\t$generateFileName")
  echo $inputParamsSed
  echo "$inputParamsSed" | $BASE_PATH/sedPkgNameDiff.sh
}

echo "选择补丁模式,用于对现有补丁替换包名操作"
# read-multiple: read multiple values from keyboard
#echo "$(pwd)"
echo -e "读取该项目地址中的diff补丁文件\n$(pwd)"

# Shell获取正在执行脚本的绝对路径
BASE_PATH=$(
  cd $(dirname $0)
  pwd
)
echo "base_path is $BASE_PATH"

findDiffFile $BASE_PATH
