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


function is_file_zipped ()
{
    file_name=$1
    file_type=$(file $1 | cut -d' ' -f 2)
    echo $file_type
    #timeout_in_seconds=$(($timeout_in_hours * 60))

    if [[ ${file_type} =~ [Zz][Ii][Pp] ]]; then
        if [ "$file_name" == fc-* ] && [ $(find "$file_name" -mtime +2 -print) ]; then
            rm "$file_name"
        fi
        return 0
    else
        return 1
    fi
}

function zip_directory_without_recursive ()
{
    for f in $1/*
    do
        echo $f
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
    is_file_zipped $1
    boolean_is_file_zipped=$?
    if [[ $boolean_is_file_zipped -eq 1 ]]; then # if file is not compressed
        base_name=$(basename ${1})
        base_name_with_fc="fc-${base_name}"
        zip -d "fc-${base_name}" ${1}
    else
        text_after_fc=$(echo $1 | cut -d'-' -f2-)
        mv ${1} "fc-${text_after_fc}"
        touch "fc-${text_after_fc}"
    fi
}

function start_zipping()
{
    file_name=$1
    echo $file_name
    #file_full_path=$(realpath $file_name)
    file_type=$(file $file_name | cut -d' ' -f 2)
    if [[ $recursive == true ]]; then
        if [[ $file_type == "directory" ]]; then
            zip_directory_with_recursive $file_name
        else #is not directory
            zip_file $file_name
        fi
    else # recursive is false
        if [[ $file_type == "directory" ]]; then
            echo $file_name
            zip_directory_without_recursive $file_name
        else
            zip_file $file_name
        fi
    fi
}

for file_name in "$*"
do
    echo $file_name
    start_zipping $file_name
done

