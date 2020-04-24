### Tools

#### git
* [git document](https://git-scm.com/book/zh/v2)

ERROR:
* `error:src refspec master does not match any`
原因: 引起该错误的原因是，目录中没有文件，空目录是不能提交上去的

* `error: failed to push some refs to 'https://github.com/fengzhihao123/test.git'`
原因: github中的README.md文件不在本地代码目录中 pull=fetch+merge
执行: `git pull --rebase origin master`

* 显示本地分支和远程分支的对应关系
`git branch -vv`

* error:`refusing to merge unrelated histories`
解决:`git pull --allow-unrelated-histories`  [so](http://stackoverflow.com/questions/37937984/git-refusing-to-merge-unrelated-histories)

## Git

### 将本地的项目关联到远程仓库

#### 创建的远程仓库有文件
1. `git init` : 初始化git仓库
2. `git add .` : 将文件添加到缓存区
3. `git commit -m"add project"` : 提交文件
4. `git remote add origin xxxx` : 给本地仓库指定远程仓库地址， origin 为远程仓库的名字，xxxx 为远程仓库的地址
5. `git pull --allow-unrelated-histories` : 拉取远程仓库分支的代码，参数 `--allow-unrelated-histories` 的含义[Stackoverflow](http://stackoverflow.com/questions/37937984/git-refusing-to-merge-unrelated-histories)，如果不添加该参数会报错 : `fatal: refusing to merge unrelated histories`
6. `git branch --set-upstream-to=origin/master master` : 将远程的master分支设置为本地master分支的上行
7. `git push` : 将本地代码提交到远程仓库

#### 创建的远程仓库无文件
1. git init 
2. git add .
3. git commit -m"add project"
4. git remote add origin xxxx
5. git push -u origin master : 将本地内容添加到origin仓库

#### 相关命令
* git branch : 显示本地分支 
* git branch -vv : 显示本地分支和对应的远程分支
* git remote -v : 显示远程仓库地址
* git remote rm xxx : 移除远程仓库地址
* git checkout -b xxx : 新建并切换分支
* git checkout : 切换分支
* git merge : 合并分支
* git status : 显示仓库文件的状态



#### Iterm
* [shortcut key](https://cnbin.github.io/blog/2015/06/20/iterm2-kuai-jie-jian-da-quan/)

#### autojump

### Cocoapods
* [Cocoapods install](http://www.jianshu.com/p/00107eb5449b)
* [pod install vs pod update](https://guides.cocoapods.org/using/pod-install-vs-update.html)
* [忽略特殊文件.gitignore](http://www.liaoxuefeng.com/wiki/0013739516305929606dd18361248578c67b8067c8c017b000/0013758404317281e54b6f5375640abbb11e67be4cd49e0000)

#### Install error 
* pod setup :error `RPC failed; curl 56 SSLRead() return error -36| 17.00 KiB/s`

解决:

```
cd ~/.cocoapods/repos
git clone https://github.com/CocoaPods/Specs.git master
```
参考 : [CocoaPods安装和使用图解](http://www.jianshu.com/p/06e6b7670a91)

### VSCode
修改快捷键
command + k + s 调出此窗口
```
[
  { "key": "cmd+1",                "command": "workbench.action.openEditorAtIndex1" },
  { "key": "cmd+2",                "command": "workbench.action.openEditorAtIndex2" },
  { "key": "cmd+3",                "command": "workbench.action.openEditorAtIndex3" },
  { "key": "cmd+4",                "command": "workbench.action.openEditorAtIndex4" },
  { "key": "cmd+5",                "command": "workbench.action.openEditorAtIndex5" },
  { "key": "cmd+6",                "command": "workbench.action.openEditorAtIndex6" },
  { "key": "cmd+7",                "command": "workbench.action.openEditorAtIndex7" },
  { "key": "cmd+8",                "command": "workbench.action.openEditorAtIndex8" },
  { "key": "cmd+9",                "command": "workbench.action.openEditorAtIndex9" }  
]
```

#### 插件
* 在插件安装的框中输入`shell`，即可在终端使用`code .`打开文件
* command k + command r :显示vscode官方快捷键
