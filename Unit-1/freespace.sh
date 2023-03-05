#!/bin/bash

timeout_in_hours=48 # default timeout 
recursive=false

# Flags recognize and save variables.
while getopts 'rt:' flag; do
  case "${flag}" in
    r) recursive=true ;;
    t) timeout_in_hours=${OPTARG} ;;
    *)
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND-1))

function usage()
{
    echo "freespace [-r] [-t ###] file [file...]"
}


function is_file_zipped ()
{
    local file_name=$1
    local file_type=$(file $1 | cut -d' ' -f 2)

    if [[ ${file_type} =~ [Zz][Ii][Pp] ]]; then
        # if [ "$file_name" == fc-* ] && [ $(find "$file_name" -mtime +2 -print) ]; then
        #     rm "$file_name"
        # fi
        return 0
    else
        # if [ "$file_name" == fc-* ] && [ $(find "$file_name" -mtime +2 -print) ]; then
        #     rm "$file_name"
        # fi
        return 1
    fi
}

function zip_directory_without_recursive ()
{
    for f in $1/*
    do
        local file_type=$(file $f | cut -d' ' -f 2)
        if [[ $file_type == "directory" ]]; then
            continue
        fi
        zip_file $f
    done
}

function zip_directory_with_recursive ()
{
    for f in $1/*
    do
        if [[ $file_type == "directory" ]]; then
            zip_directory_with_recursive ${f}
        else
            zip_file ${f}
        fi
    done
}

function zip_file ()
{
    local file_name="$1"
    is_file_zipped "${file_name}"
    boolean_is_file_zipped=$?
    dir_name=$(dirname $file_name)
    new_file_name="fc-$(basename "$1")"
    new_file_path="${dir_name}/${new_file_name}"
    # echo ${file_name}
    # echo $new_file_path
    #echo dirname- $dir_name/fc-$basename
    # echo basename- $basename
    if [[ $boolean_is_file_zipped -eq 1 ]]; then
        zip "${new_file_path}" "${file_name}"
    else
        exit
    fi
    # is_file_zipped $1
    # boolean_is_file_zipped=$?
    # dir_name=$(dirname $1)
    # if [[ $boolean_is_file_zipped -eq 1 ]]; then # if file is not compressed
    #     zip "fc-${1}" ${1}
    # else

    #     mv "${1}" "fc-${text_after_fc}"
    #     touch "fc-${text_after_fc}"
    # fi
}

function start_zipping()
{
    local file_name="$1"
    local file_type=$(file "$file_name" | cut -d' ' -f 2)

    if [[ $recursive == true ]]; then
        if [[ $file_type == "directory" ]]; then
            zip_directory_with_recursive $file_name
        else 
            zip_file $file_name
        fi
    else 
        if [[ $file_type == "directory" ]]; then
            zip_directory_without_recursive $file_name
        else
            zip_file "${file_name}"
        fi
    fi
}

for f_name in "$@"
do
    if [[ -e $f_name ]]; then
        start_zipping $f_name
    else
        echo "${f_name} is not exists!" 
    fi
done

