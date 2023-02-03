# my search function

# find file content
function ff() {
if (( $# == 0 ))
then
        cat >&2 <<'EOF'
Usage: ff [content]

EOF
else
  rg  --files-with-matches --no-messages "$1" | fzf --preview-window=up:50% --preview "bat  --style=numbers --color=always {} | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
fi
}
function fff(){
if (( $# == 0 ))
then
        cat >&2 <<'EOF'
Usage: fff [content]

EOF
else
rg --hidden --line-number --with-filename . --field-match-separator ' '\
  | fzf -m --preview "bat --color=always {1} --highlight-line {2}" \
  --preview-window ~8,+{2}-5
fi
}
function mkdircd {
if (( $# == 0 ))
then
        cat >&2 <<'EOF'
Usage: mkdircd [dir]
EOF
else
    mkdir -p "$@" && eval cd "\"\$$#\"";
fi
}

function zle {
  if (( $# == 0 ))
then
        cat >&2 <<'EOF'
Usage: zle [file]
EOF
else
    zcat $@|le
    fi
    }


function lc {
    ls "$@"
    echo -e "\n\033[31m file number：\t $(ls "$@" | eval wc -l)\033[0m"
    }


# function lp {
#     if (( $# == 0 ))
# then
# ls --color=auto $PWD/*
# echo -e "\n\033[31m file number：\t $(ls | eval wc -l)\033[0m"

# else
#     ls --color=auto "$(readlink -f $@/*)"
#     echo -e "\n\033[31m file number：\t $(ls "$@" | eval wc -l)\033[0m"
# fi
# }

function lp {
    if (( $# == 0 ))
then
ls --color=auto $(pwd -P)/*
echo -e "\n\033[31m file number：\t $(ls | eval wc -l)\033[0m"

else
    ls --color=auto "$(readlink -f $@/*)"
    echo -e "\n\033[31m file number：\t $(ls "$@" | eval wc -l)\033[0m"
fi
}




# check if file in array exist
check_arrfile() {
# setopt localoptions noautopushd
if (( $# == 0 ))
then
        cat >&2 <<'EOF'
Usage: check_arrfile [array] ...

EOF
else
while (( $# > 0 ))
do
eval a=\${$1[*]}
                for i in ${a[*]}
                do
                        if [[ ! -s $i ]]
                        then
                        echo "ERROR:Detect there is no $i ! Please check $1"
                        return 1
                        else
                        echo -e "file exist:\t $i"
                        fi
                done
                shift
done
fi
}

# make soft link file from array to target dir
mklink_arrfile() {
if (( $# != 2 ))
then
        cat >&2 <<'EOF'
Usage: mklink_arrfile [file_array] [link_dir]
        file_link in array must be absolute path
EOF
else
        eval a=(\${$1[*]})
        if [[ "a${a}" == "a" ]]
        then
        echo "ERROR:Detect there is no content in \$$1 ! Please check $1"
        fi
        for i in ${a[*]}
        do
                echo -e "file exist:\t $i"
                if [[ ! -s $i ]]
                then
                echo "ERROR:Detect there is no $i ! Please check $1"
                return 1
                fi
        done
        mkdir -p $2
        for i in ${a[*]}
        do
        ln -s $i $2
        done
fi
}







# explain a data array
explain() {
    # setopt localoptions noautopushd
        if (( $# == 0 ))
        then
                cat >&2 <<'EOF'
Usage: explain [array ...]

EOF
else
while (( $# > 0 ))
        do
                if [[ ! -z "$1" ]]
                then
                        eval echo -e "variable: '$1' Length is \${#$1[*]}\\\n\\\t \(\${$1[*]}\)"
                        shift
                        continue
                else
                    echo -e "$1 is not a valid variable"
                fi
                shift
        done
fi
}






# calculate step cost time
unset cost_time start_time
stepon(){
    if (( $# == 0 ))
    then
        cat >&2 <<'EOF'
     Usage: Sstart [name]
EOF
else
        declare -Axg start_time
        start_time["$1"]=$(date +%s)
        echo "##################### $1 ##############################"
        echo -e "Step $1 ——START TIME :`date +"%Y-%m-%d %H:%M.%S"`"
fi
}

stepoff(){
        if (( $# == 0 ))
        then
                cat >&2 <<'EOF'
Usage: Stend [name]
EOF
else
                declare -Axg cost_time
                diff_time=$(( ( $(date +%s) - ${start_time[$1]} ) ))
                diff_h=$[diff_time/3600]
                diff_m=$[diff_time%3600/60]
                cost_time[$1]="$diff_h h $diff_m min"
        echo -e "Step $1 ——END TIME :`date +"%Y-%m-%d %H:%M.%S"` \t cost_time :${cost_time[$1]}"
        echo "##################### $1 ##############################"
fi
}


stepall(){
        echo "#######################################################"
    echo -e All Step length: ${#start_time[*]} "\t("${!start_time[*]} ")"
    for i in ${!start_time[*]}
    do
        echo -e "Step "$i"\t\tcost_time: " ${cost_time[$i]}"\tSTART: "`date -d @${start_time[$i]} +"%Y-%m-%d %H:%M.%S"`
    done
        echo "#######################################################"
}


# transpose a file    row tocol
transpose(){
        if (( $# == 0 ))
        then
                cat >&2 <<'EOF'
Usage: transpose [file]
      transpose a file from row to col(default by space).
EOF
else
  awk '{
    for (i=1;i<=NF;i++){
        if (NR==1){
            res[i]=$i
        }
        else{
            res[i]=res[i]"\t"$i
        }
    }
}END{
    for(j=1;j<=NF;j++){
        print res[j]
    }
}' $1
fi
}


# pb(){
# if (( $# == 0 ))
# then
#                 cat >&2 <<'EOF'
# Usage: pb index legth

# EOF
# else
# bar=$(seq -s "#" $(( $1*(COLUMNS - 5)/$2 ))|sed -E "s/[0-9]//g")
# blank=$(seq -s "-" $(( COLUMNS - 5 - ${#bar} ))|sed -E "s/[0-9]//g")
# echo -e "[\x1b[38;5;2m$bar\x1b[0m$blank]$(( $1*100/$2 ))%\x1b[1F"
# if (($1 == $2))
# then
# echo -e "[\x1b[38;5;2m${bar:1:$((COLUMNS/2 -8))}  \x1b[48;5;2m complete \x1b[0m  "
# fi
# sleep 0.08
# fi
# }

extract () {
  # setopt localoptions noautopushd
  if (( $# == 0 ))
  then
    cat >&2 <<'EOF'
Usage: extract [-option] [file ...]

Options:
    -r, --remove    Remove archive after unpacking.
EOF
  fi
  local remove_archive=1
  if [[ "$1" == "-r" ]] || [[ "$1" == "--remove" ]]
  then
    remove_archive=0
    shift
  fi
  local pwd="$PWD"
  while (( $# > 0 ))
  do
    if [[ ! -f "$1" ]]
    then
      echo "extract: '$1' is not a valid file" >&2
      shift
      continue
    fi
    local success=0
    local extract_dir="${1:t:r}"
    local file="$1" full_path="${1:A}"
    case "${file:l}" in
      (*.tar.gz|*.tgz) (( $+commands[pigz] )) && {
          pigz -dc "$file" | tar xv
        } || tar zxvf "$file" ;;
      (*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$file" ;;
      (*.tar.xz|*.txz) tar --xz --help &> /dev/null && tar --xz -xvf "$file" || xzcat "$file" | tar xvf - ;;
      (*.tar.zma|*.tlz) tar --lzma --help &> /dev/null && tar --lzma -xvf "$file" || lzcat "$file" | tar xvf - ;;
      (*.tar.zst|*.tzst) tar --zstd --help &> /dev/null && tar --zstd -xvf "$file" || zstdcat "$file" | tar xvf - ;;
      (*.tar) tar xvf "$file" ;;
      (*.tar.lz) (( $+commands[lzip] )) && tar xvf "$file" ;;
      (*.tar.lz4) lz4 -c -d "$file" | tar xvf - ;;
      (*.tar.lrz) (( $+commands[lrzuntar] )) && lrzuntar "$file" ;;
      (*.gz) (( $+commands[pigz] )) && pigz -dk "$file" || gunzip "$file" ;;
      (*.bz2) bunzip2 "$file" ;;
      (*.xz) unxz "$file" ;;
      (*.lrz) (( $+commands[lrunzip] )) && lrunzip "$file" ;;
      (*.lz4) lz4 -d "$file" ;;
      (*.lzma) unlzma "$file" ;;
      (*.z) uncompress "$file" ;;
      (*.zip|*.war|*.jar|*.ear|*.sublime-package|*.ipa|*.ipsw|*.xpi|*.apk|*.aar|*.whl) unzip "$file" -d "$extract_dir" ;;
      (*.rar) unrar x -ad "$file" ;;
      (*.rpm) command mkdir -p "$extract_dir" && builtin cd -q "$extract_dir" && rpm2cpio "$full_path" | cpio --quiet -id ;;
      (*.7z) 7za x "$file" ;;
      (*.deb) command mkdir -p "$extract_dir/control" "$extract_dir/data"
        builtin cd -q "$extract_dir"
        ar vx "$full_path" > /dev/null
        builtin cd -q control
        extract ../control.tar.*
        builtin cd -q ../data
        extract ../data.tar.*
        builtin cd -q ..
        command rm *.tar.* debian-binary ;;
      (*.zst) unzstd "$file" ;;
      (*.cab) cabextract -d "$extract_dir" "$file" ;;
      (*.cpio) cpio -idmvF "$file" ;;
      (*) echo "extract: '$file' cannot be extracted" >&2
        success=1  ;;
    esac
    (( success = success > 0 ? success : $? ))
    (( success == 0 && remove_archive == 0 )) && rm "$full_path"
    shift
    builtin cd  "$pwd"
  done
}



pbf(){
if (( $# == 0 ))
then
                cat >&2 <<'EOF'
Usage: pbf file
EOF
else
unset ar len
readarray -t ar <$1
len=${#ar[*]}
tput sc
for i in `seq 0 $(( ${len} -1 ))`;
do
tput rc
tput ed
echo -e "No:$(($i+1))/${len}\t${ar[i]}"
bar=$(seq -s "#" $(( ($i+1)*(COLUMNS - 5)/${len} ))|sed -E "s/[0-9]//g")
blank=$(seq -s "-" $(( COLUMNS - 5 - ${#bar} ))|sed -E "s/[0-9]//g")
if (($i != $(( ${len} -1 ))))
then
echo -e "[\x1b[38;5;2m$bar\x1b[0m$blank]$(( ($i+1)*100/$(( ${len} )) ))%"
tput ed
else
echo -e "[\x1b[38;5;2m$bar\x1b[0m$blank]$(( ($i+1)*100/$(( ${len} )) ))%\x1b[1F"
echo -e "[\x1b[38;5;2m${bar:1:$((COLUMNS/2 -8))}  \x1b[48;5;2m complete \x1b[0m  "
fi
eval ${ar[i]}
if [ $? != 0 ]; then
   echo -e "\x1b[48;5;9mERROR:\x1b[0m \x1b[38;5;9m${ar[i]} failed\x1b[0m"
   break
fi
sleep 0.5
done
fi

}



pb(){
if (( $# == 0 ))
then
                cat >&2 <<'EOF'
Usage: pb command array|files [args ...]
example: pb cat test2/\* \|grep 'sd'
        pb mv test2/\* .
a=$i
b=$2
EOF
else
unset ar1 ar2 len
ar1=$1
eval ar2=($2)
shift
shift
len=${#ar2[*]}
tput sc
for i in `seq 0 $(( ${#ar2[*]} -1 ))`;
do
tput rc
tput ed
script="$ar1 ${ar2[i]} $@"
echo -e "No$(($i+1))/${len}:\t\t$script "
bar=$(seq -s "#" $(( ($i+1)*(COLUMNS - 5)/${#ar2[*]} ))|sed -E "s/[0-9]//g")
blank=$(seq -s "-" $(( COLUMNS - 5 - ${#bar} ))|sed -E "s/[0-9]//g")
echo -e "[\x1b[38;5;2m$bar\x1b[0m$blank]$(( ($i+1)*100/$(( ${#ar2[*]} )) ))%"
tput ed
if (($i == $(( ${#ar2[*]} -1 ))))
then
echo -e "\x1b[1F[\x1b[38;5;2m${bar:1:$((COLUMNS/2 -8))}  \x1b[48;5;2m complete \x1b[0m  "
fi
eval $script
if [ $? != 0 ]; then
   echo -e "\x1b[48;5;9mERROR:\x1b[0m \x1b[38;5;9m$script failed\x1b[0m"
   break
fi
sleep 0.5
done
fi
}
