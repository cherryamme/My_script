binpath=`dirname $(readlink -f $0)`
. $binpath/config.ini

HELP="> Usage:  `basename $0` [input] [outdir]
> ---------------------------------------
>	<input> :	sample_1.fq1.gz
>	<output> :	\$outdir/\$split_dir/sample
>	<example> :	`basename $0` sample_1.fq1.gz \$outdir
> ---------------------------------------
> author :Jc	date :2023-2-3"

. $getopts i:o:h $@

fq1_path=$input
fq2_path=${input/_1$suffix/_2$suffix}
sample=`basename $input`
sample=${sample%_*}
prefix=$output/$split_dir/$sample/$sample

################################# run split10X ################################
if [ -s $output ];then
echo $input 'already split10x in '$output
else
echo "[`date "+%Y-%m-%d %H:%M:%S"`] split10x ' $input ' >>>>"  $output
time $split10x -fq1 $fq1_path -fq2 $fq2_path -prefix $prefix
fi
