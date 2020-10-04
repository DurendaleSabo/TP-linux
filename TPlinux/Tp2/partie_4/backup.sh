#!/bin/bash

# Buton Killian
# 01/10/2020
#script pour vagrant

# On créer les ficjier backup pour commencé
backup_time="$(date +%Y%m%d_%H%M)"

saved_folder_path="${1}"

saved_folder="${saved_folder_path##*/}"

backup_name="${saved_folder}_${backup_time}"

backup_dir="/opt/backup"

backup_path="${backup_dir}/${saved_folder}/${backup_name}.tar.gz"

backup_useruid="1003"
max_backup_number=7

# On vérifie que le user qui execute le script soit le bon 
if [[ $UID -ne ${backup_useruid} ]]
then
    echo "Ce script doit être éxecuté avec l'utilisateur backup" >&2
    exit 1
fi

# On vérifie que le dossier a backup existe
if [[ ! -d "${saved_folder_path}" ]]
then
    echo "Ce dossier n'existe pas !" >&2
    exit 1
fi

# Fonction qui crée la backup
backup_folder ()
{
    if [[ ! -d "${backup_dir}/${saved_folder_path}" ]]
    then
        mkdir "${backup_dir}/${saved_folder_path}"
    fi
    
    tar -czvf \
    ${backup_path} \
    ${target_dir} \
    1> /dev/null \
    2> /dev/null
    
    if [[ $(echo $?) -ne 0 ]]
    then
        echo "Une erreur est survenue lors de la compréssion" >&2
        exit 1
    else
        echo "La compréssion à réussi dans ${backup_dir}/${saved_folder_path}" >&1
    fi
}

# Fonction qui vérifie si il y en a 7 et qui supprime la plus ancienne 
delete_outdated_backup ()
{
    if [[ $(ls "${backup_dir}/${saved_folder_path}" | wc -l) -gt max_backup_number ]]
    then
        oldest_file=$(ls -t "${backup_dir}/${saved_folder_path}" | tail -1)
        rm -rf "${backup_dir}/${saved_folder_path}/${oldest_file}"
    fi
}

backup_folder
delete_outdated_backup