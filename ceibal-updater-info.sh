#!/bin/bash

PKG_NAME="ceibal-update"

help(){
    echo ""
    echo "Usage:"
    echo "$0 <--pkg=package_name> --fecha_ult_act | --installed_udpate" 
    echo
    echo DESCRIPCION
    echo ""
    echo "  --pkg=NOMBRE_DEL_PAQUETE"
    echo "         Opcional, si no se especifica se toma el nombre de paquete por defecto "ceibal-update""
    echo ""
    echo "  --fecha_ult_act"
    echo "         Fecha en la que se genero y publico la actualizaion"
    echo ""
    echo "  --installed_update"
    echo "         Fecha en la que la actualizacion se instalo en la maquina."
    echo ""
}

die(){
    echo "¡¡¡¡¡ ERROR !!!!!"
    exit 1
}

fecha_ult_act(){
    TMP_FILE=`mktemp`
    gunzip -c /usr/share/doc/${PKG_NAME}/changelog.Debian.gz > $TMP_FILE || die
    DATE=`dpkg-parsechangelog --count 1 --show-field Date -l$TMP_FILE` || die    
    echo `date -d "$DATE" +%Y%m%d`
}


installed_update(){
    for i in `ls -t /var/log/dpkg.log*`;do
        if ( `echo $i | grep -q gz` );then
            CMD=zcat
        else
            CMD=cat
        fi
        DATE=`$CMD $i | grep "install.${PKG_NAME}" | cut -f1 -d" " | sed s/-//g`
        if [[ "$DATE" ]] ;then
            echo $DATE
        fi
    done
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
