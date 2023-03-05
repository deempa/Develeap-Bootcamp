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

    current_time=$(date +%s)
    file_modified_time=$(stat -c %Y "$file_name")

    if [[ ${file_type} =~ [Zz][Ii][Pp] ]]; then
        if [[ "$file_name" == fc-* && current_time - file_modified_time > 172800]]; then
            rm "$file_name"
        fi
        return 0
    else
        return 1
    fi
}

function zip_directory_without_recursive ()
{
    
}

function zip_directory_with_recursive ()
{
    for f in $1/*
        do
            if [[ $file_type == "directory" ]]; then
                zip_directory_with_recursive $f
            else
                zip_file $f
            fi
        done
}

function zip_file ()
{
    is_file_zipped $1
    boolean_is_file_zipped=$?
    echo $boolean_is_file_zipped
    if [[ $boolean_is_file_zipped -eq 1 ]]; then # if file is not compressed
        zip "fc-${file_name}" ${file_name}
    else
        mv ${file_name} "fc-${file_name}"
        touch "fc-${file_name}"
    fi
}

function start_zipping()
{
    file_name=$1
    file_type=$(file $1 | cut -d' ' -f 2)
    if [[ $recursive == true ]]; then
        if [[ $file_type == "directory" ]]; then
            zip_directory_with_recursive ${file_name}
        else #is not directory
            zip_file ${file_name}
        fi
    else # recursive is false
        if [[ $file_type == "directory" ]]; then
            zip_directory_without_recursive $f
        else
            zip_file ${file_name}
        fi
    fi
}

for file_name in "$*"
do
    start_zipping $file_name
done

