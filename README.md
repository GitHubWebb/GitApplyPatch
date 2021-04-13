# GitApplyPatch

#### 介绍

Use shell scripts to select existing patches in the project to modify the package name to generate new files and patches(使用shell脚本可选择在项目中现有的补丁进行修改包名生成新文件并应有补丁)

#### 应用场景

最近的项目都是基于标板开发修改包名后起的分支, 在各个分支编写新的代码逻辑, 标板同步维护, 因为包名(文件夹根目录结构)不一致进行同步拉取的时候就会文件夹和类冲突, git会基于标板目录结构在新分支创建新的文件夹和类, 当类修改的比较细碎的时候就失去git文件比对能力。于是使用git补丁同时因为出错的底层原因是包名不一致所以修改补丁文件不一致的包名, 应用补丁之后可以完美使用git进行比对文件差异, 注: git补丁对二进制文件需要做特殊处理!

#### 使用说明 (脚本模式同样可以用于其他用途, 必须find name xxx.txt 循环想要替换的文本)

暂定目录结构分为 /shell (脚本文件) & /diff (补丁文件) 

1.  使用./shell/selectPatchMode.sh 进行diff文件的扫描,如果提示没有权限可以考虑在目录中使用 chmod u+x *.sh
2.  在selectPatchMode.sh中会调用sedPkgName.sh对指定文件要替换的文字进行替换并生成新文件(也可以不生成新文件设置备份名,将老文件备份)
3.  上述操作结束后会调用applyGitPatch.sh 进行git应用补丁逻辑,要注意应用补丁需要cd 到 项目的根目录,脚本调用样例中提供两种方式选择

    a. 将/shell & /diff 整体复制到项目根目录 在应用补丁时候 cd ../   到根目录即可
    b. /shell & /diff 目录与项目目录毫无关联,则需要使用 cd 到项目根目录
4. 注意使用git应用补丁需要使用git apply --reject强制应用根据生成后的.rej文件进行修改后调用applyGitPatch.sh中后续注释的代码
5. 第四条主要看大家需求不想像我一样强制执行后根据rej修改也阔以

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request

#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
