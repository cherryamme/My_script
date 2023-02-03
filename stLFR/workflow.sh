set -e


HELP="> Usage:  `basename $0` -i input -o outdir
> ---------------------------------------
>	<input> :	sample_1.fq1.gz
>	<output> :	\$outdir
>	<config> :	config_file[optional]
>	<example> :	`basename $0` -i sample_1.fq1.gz -o \$outdir
> ---------------------------------------
> author :Jc	date :2023-2-3"

######################### argument ################################
binpath=`dirname $(readlink -f $0)`
. $binpath/config.ini
. $bash_func
. $getopts c:i:o:h $@


input=`readlink -f $input`

if [[ -z "$sample" ]]; then
	sample=`basename $input`
	sample=${sample%_*}
fi

if [[ $config ]]; then
	echo "loading config "$config
	. $config
fi

mkdir -p $outdir

software=($split10x $gatk $ref $longranger)
check_arrfile software




######################### workflow ################################

# copy file
mkdir -p $outdir/$datadir/${sample}
if [ ! -e $outdir/$datadir/${sample}/${sample}_1$suffix ];then ln -s ${fq1_path[i]} $outdir/$datadir/${sample}/${sample}_1$suffix;fi
if [ ! -e $outdir/$datadir/${sample}/${sample}_2$suffix ];then ln -s ${fq2_path[i]} $outdir/$datadir/${sample}/${sample}_2$suffix;fi


# run split10X
stepon split10x
$binpath/01_split10X.sh -i $outdir/$datadir/${sample}/${sample}_1$suffix -o $outdir
stepoff split10x



# run longranger
stepon longranger
$binpath/02_longranger.sh -i $outdir/$datadir/${sample} -o $outdir
stepoff longranger

stepall
