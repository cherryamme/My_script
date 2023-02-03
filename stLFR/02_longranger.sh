binpath=`dirname $(readlink -f $0)`
. $binpath/config.ini

HELP="> Usage:  `basename $0` [inputdir] [outdir]
> ---------------------------------------
>	<input> :	sample_dir
>	<output> :	\$outdir/\$longranger/sample
>	<example> :	`basename $0` sample_1.fq1.gz \$outdir
> ---------------------------------------
> author :Jc	date :2023-2-3"

. $getopts i:o:h $@


sample=`basename $input`

################################# run longranger ################################
mkdir -p $outdir/$longranger && cd $outdir/$longranger

if [ -e $outdir/$longranger/$sample ];then
echo $input 'already longranger in '$output
else
echo "[`date "+%Y-%m-%d %H:%M:%S"`] longranger ' $input ' >>>>"  $outdir/$longranger/$i
time $longranger wgs --id=$sample --fastqs=$input --reference=$ref --vcmode=gatk:$gatk
fi
done
