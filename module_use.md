## module

### getopts module使用
插入参数处理功能：
	一般使用 i:o:h 即可，指示input output

```shell
. /home/jiangchen/00_software/My_script/module/getopts.sh c:i:o:h $@
```

### bash_func引用
引用功能较多：
	mkdircd:创建并进入文件夹
	zle：less + gzip
	lc: ls + wc
	lp: pwd + ls
	check_arrfile: 检查arr内文件是否存在
	mklink_arrfile：arr内文件链接至目录
	explain：解释arr内变量
	stepon：任务开始
	stepoff：任务结束
	stepall：任务看板
	transpose：行列转换
	extract：解压文件
	pbf：运行file内每一行，显示进度
	pb：进度条运行任务

```shell
. /home/jiangchen/00_software/My_script/module/bash_func.sh
```


###
