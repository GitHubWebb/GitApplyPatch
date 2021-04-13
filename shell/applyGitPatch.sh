#!/bin/bash
# author wangweixu
# data 2021年04月08日17:05:38
# params [0] 项目根目录  [1] 补丁文件路径

projectParentPath=$1
patchFilePath=$(pwd)/$2

echo "应用生成后的git补丁$patchFileName"
# read-multiple: read multiple values from keyboard
echo "$(pwd)"

# 如果将 /shell & /diff 两个目录放到项目根目录运行则调用 cd ../
# 否则需要指定项目地址  cd /usr/home/project/xxx/
cd $projectParentPath
echo "$(pwd)"

#exit

# 先进行应用补丁恢复,
# 避免"fatal: previous rebase directory .git/rebase-apply still exists but mbox given."
# 一般来说之前执行git am失败过，需要执行git am --abort
# 注意 调用该命令 如果没有应用过补丁 会失败 忽略即可
# fatal: Resolve operation not in progress, we are not resuming.
git am --abort


# 先检查patch文件：
git apply --stat $patchFilePath
# 检查能否应用成功：
git apply --check $patchFilePath
# 打补丁：
#(使用-s或--signoff选项，可以commit信息中加入Signed-off-by信息)
git am --signoff < $patchFilePath

# 自动合入 patch 中不冲突的代码改动，同时保留冲突的部分。
# 这些存在冲突的改动内容会被单独存储到目标源文件的相应目录下，
# 以后缀为 .rej 的文件进行保存。
# 比如对 ./test/someDeviceDriver.c 文件中的某些行合入代码改动失败，
# 则会将这些发生冲突的行数及内容都保存在 ./test/someDeviceDriver.c.rej 文件中。
# 我们可以在执行 git am 命令的目录下执行 find  -name  *.rej 命令以查看所有存在冲突的源文件位置。
git apply --reject $patchFilePath

# 修复后调用下面两个注释命令进行提交
# 将所有改动都添加到暂存区（注意，关键字add后有一个小数点 . 作为参数，表示当前路径）
# git add .

## 如果还想保留原作者，那么就要使用git am --resolved命令
## 继续 因为报错 被中断的 patch 合入操作。合入完成后，会有提示信息输出。
# git am --resolved
git log
