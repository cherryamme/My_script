#!/bin/sh

pattern="$1"
shift 1

check_file(){
	for i in ${@}; do
		if [ ! -e ${i} ]; then
			echo -e "ERROR: ${i} not exist.\n"
			usage
			exit 1
		fi
	done
}

## usage function
usage() {
	# Function: Print a help message.
	echo -e ">>>>>>>>>>>>>    HELP    >>>>>>>>>>>>>>>>>"
	echo -e "$HELP"
	echo -e ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" 1>&2
}


echo "<Command>: `basename $0` $@"
while getopts "$pattern" opt; do
  case $opt in
    c)
	  config="$OPTARG"
	  check_file $config
	  echo "<config>: $config"
	  ;;
    i)
      input="$OPTARG"
	  check_file $input
	  echo "<input>: $input"
      ;;
    s)
      sample="$OPTARG"
	  echo "<sample>: $sample"
      ;;
    o)
      output="$OPTARG"
	  echo "<output>: $output"
      ;;
	h)
	  usage
	  exit 0
	  ;;
    \?)
	  usage
      exit 1
      ;;
  esac
done


## 输出剩余参数
shift $((OPTIND-1))
if [ $# -gt 0 ]; then
	echo -e "<Remaining arguments>: $@"
fi

## 检查必需参数是否为空
if [[ -z "$input" || -z "$output" ]]; then
	echo -e "ERROR: -i/-o need arguments. \n" 1>&2
	usage
	exit 1
fi


# file=($input $config)
# check_arrfile file

#检查文件是否存在



# ##判断是否数字
# TIMES=${OPTARG}
# re_isanum='^[0-9]+$'                # Regex: match whole numbers only
# if ! [[ $TIMES =~ $re_isanum ]]; then   # if $TIMES not whole:
# echo "Error: TIMES must be a positive, whole number."
# elif [ $TIMES -eq "0" ]; then
# echo "Error: TIMES must be greater than zero."
# fi
