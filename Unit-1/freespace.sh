#!/bin/bash

# Set default timeout
TIMEOUT=48

# Set default recursive flag to false

RECURSIVE=false

function usage()
{
    echo "freespace [-r] [-t ###] file [file...]"
}

while getopts 'rt:' flag; do
  case "${flag}" in
    r) RECURSIVE=true ;;
    t) TIMEOUT=${OPTARG} ;;
    *)
        usage
        exit 1
      ;;
  esac
done
shift $((OPTIND-1))

function is_file_zipped ()
{
    local file_name=$1
    local file_type=$(file "$1" | cut -d' ' -f 2)
    local basename=$(basename "${file_name}")
    ((timeout_in_minutes = TIMEOUT * 60))

    if [[ "${file_type}" =~ [Zz][Ii][Pp] || "${file_type}" == "compress'd" ]]; then
        if [[ "${basename}" == fc-* && $(find ${file_name} -mmin +${timeout_in_minutes} -print) ]]; then
                rm "${file_name}"
        fi
        return 0
    else
        return 1
    fi
}

function zip_directory_without_recursive ()
{
    local folder_path="$1"
    local folder_contents=$(find "${folder_path}" -mindepth 1 -maxdepth 1)

    if [[ -z "${folder_contents}" ]]; then
        return
    fi
    
    for f in $1/*
    do
        local file_type=$(file $f | cut -d' ' -f 2)
        if [[ $file_type == "directory" ]]; then
            continue
        fi
        zip_file "${f}"
    done
}

function zip_directory_with_recursive ()
{   
    local folder_path="$1"
    local folder_contents=$(find "${folder_path}" -mindepth 1 -maxdepth 1)

    if [[ -z "${folder_contents}" ]]; then
        return
    fi

    for f in $1/*
    do
        local file_type=$(file "${f}" | cut -d' ' -f 2)
        if [[ "${file_type}" == "directory" && "$(ls -A $1)" ]]; then
            zip_directory_with_recursive "${f}"
        else
            zip_file "${f}"
        fi
    done
}

function zip_file ()
{
    local file_name="$1"
    is_file_zipped "${file_name}"
    boolean_is_file_zipped=$?
    dir_name=$(dirname $file_name)
    basename=$(basename $file_name)
    new_file_name="fc-$(basename "$1")"
    new_file_path="${dir_name}/${new_file_name}"

    if [[ $boolean_is_file_zipped -eq 1 ]]; then
        zip -qm "${new_file_path}" "${file_name}" 
    elif [[ $boolean_is_file_zipped -eq 0 ]]; then
        if [[ "${basename}" == fc-* ]]; then
            true
        else
            mv "${file_name}" "${new_file_path}"
            touch "${new_file_path}"
        fi
    fi
}

function start_zipping()
{
    local file_name="$1"
    local file_type=$(file "${file_name}" | cut -d' ' -f 2)

    if [[ "${RECURSIVE}" == true ]]; then
        if [[ "${file_type}" == "directory" ]]; then
                zip_directory_with_recursive "${file_name}"            
        else 
            zip_file "${file_name}"
        fi
    else 
        if [[ "${file_type}" == "directory" ]]; then
            zip_directory_without_recursive "${file_name}"
        else
            zip_file "${file_name}"
        fi
    fi
}

if [[ $# -eq 0 ]]; then
  usage
fi

for f_name in "$@"
do
    if [[ -e "${f_name}" ]]; then
        start_zipping "${f_name}"
    else
        echo "${f_name} is not exists!" 
    fi
done

