#!/bin/bash

PKG_NAME="ceibal-update"

help(){
    echo ""
    echo "Usage:"
    echo "$0 <--pkg=package_name> --fecha_ult_act | --installed_udpate" 
}

die(){
    echo "¡¡¡¡¡ ERROR !!!!!"
    exit 1
}

fecha_ult_act(){
    exit 0        
}


installed_update(){
    TMP_FILE=`mktemp`
    gunzip -c /usr/share/doc/${PKG_NAME}/changelog.Debian.gz > $TMP_FILE || die
    DATE=`dpkg-parsechangelog --count 1 --show-field Date -l$TMP_FILE` || die    
    echo `date -d "$DATE" +%Y%m%d`
}




if [[ $# < 1 ]];then
    help
fi

for i in "$@"
do
case $i in
    -p=* |--pkg=*)
        PKG_NAME="${i#*=}"
    ;;

    -f |--fecha_ult_act*)
        fecha_ult_act
    ;;

    -i |--installed_update*)
        installed_update
    ;;

    -h* |--help*)
        help
    ;;

    *)
        help
    ;;
esac
done
