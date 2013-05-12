#!/bin/bash
#version 1.0
#@author Christian Ariza
#Universidad de los Andes, Colombia
[[ -r "$HOME/.config/nginx-utils" ]] && . "$HOME/.config/nginx-utils"
sites_enabled="${NGX_CONF_DIR:-/etc/nginx}/${NGX_SITES_ENABLED:-sites-enabled}"
sites_available="${NGX_CONF_DIR:-/etc/nginx}/${NGX_SITES_AVAILABLE:-sites-available}"
SOURCE="$0"

		
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it rela$
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
echo $DIR
template="$DIR/templates/templateProxy"

show_help(){
	cat <<HELP
Este script permite crear un nuevo sitio disponible como un proxy a una url dada. Los parámetros son: 

	-n nombre del sitio (obligatorio, no debe existir un sitio con el mismo nombre)
	-l listen puerto o url por lo que escuchará este bloque de servidor. (opcional, si no se especifica escuchará por el puerto por defecto)
	-s serverName dominio por el que se resolverá (es obligatorio si no se especifica el parametro -l)
	-u URL a la que resolverá el proxy
	-t timeout opcional para el proxy
	-f carpeta a la que se redirigirá la raiz de este server. (opcional)
HELP

}

while getopts "n:l:s:u:t:f:" opt; do 
	case $opt in
		n) NAME="$OPTARG";;
		l) LISTEN="$OPTARG";;
		s) SERVERNAME="$OPTARG";;
		u) URL="$OPTARG";;
		t) TIMEOUT="$OPTARG";;
		f) FOLDER="$OPTARG";;
		*)show_help && exit 0;;
	esac
done
if [[ (-z "$NAME")|| (-z "$SERVERNAME" && -z "$LISTEN") || (-z "$URL") ]]; then
	echo "falta alguno de los parámetros obligatorios"
	show_help
	exit 0
fi
if [ -f  "$sites_available/$NAME" ]; then
	echo "Ya existe un sitio con ese nombre en $sites_available"
	exit 0
fi
cp "$template" "$sites_available/$NAME";
sed -i "s¬##url¬$URL¬g" "$sites_available/$NAME"
if [[ -n "$SERVERNAME" ]]; then 
	sed -i "s¬##server_name  ##serverName¬server_name  $SERVERNAME¬g" "$sites_available/$NAME"
fi
if [[ -n "$LISTEN" ]]; then 
	sed -i "s¬##listen¬listen  $LISTEN¬g" "$sites_available/$NAME"
fi
if [[ -n "$TIMEOUT" ]]; then 
	sed -i "s¬##timeout¬timeout¬g" "$sites_available/$NAME"
	sed -i "s¬##tm¬$TIMEOUT¬g" "$sites_available/$NAME"
fi

if [[ -n "$FOLDER" ]]; then 
	sed -i "s¬##rewrite¬rewrite¬g" "$sites_available/$NAME"
	sed -i "s¬##folder¬$FOLDER¬g" "$sites_available/$NAME"
fi
echo "CREADO $sites_available/$NAME :"
cat "$sites_available/$NAME"