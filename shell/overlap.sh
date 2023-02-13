HELP="> Usage:  `basename $0` -i input.bcd21.gz -u cross_chrom_test.bed -s -o mapq_file
> ---------------------------------------
>	<input> :	ConvLFR_sorted.bcd21.gz
>	<output> :	mapq.overlap
>	<config> :	config_file[optional]
>	<example> :	`basename $0` -i ConvLFR_sorted.bcd21.gz -o mapq_file
> ---------------------------------------
> author :Jc	date :2023-2-6"

# binpath=`dirname $(readlink -f $0)`
# . $binpath/config.ini
# binpath=`dirname ${BASH_SOURCE[0]}`

. /home/jiangchen/00_software/My_script/shell/config.ini

. $getopts i:u:o:h $@


$cal_2d_overlapping_barcodes \
	$i \
	$u \
	$o \
	$genome \
	$bin \
	0
