HELP="> Usage:  `basename $0` [input.list] [output]
> ---------------------------------------
>	<input> :	file_path
>	<output> :	\$path
>	<example> :	`basename $0` input .
> ---------------------------------------
> author :Jc"

. /home/jiangchen/00_software/My_script/module/getopts.sh c:i:o:h $@





binpath=`dirname $(readlink -f $0)`
echo $binpath





> ---------------------------------------
>	<input> : \tfile_path
>	<output> :\tpath
>	<example> :\t`basename $0` input .
> ---------------------------------------
