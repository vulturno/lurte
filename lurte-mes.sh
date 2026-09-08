#!/bin/bash

apikey=$APIKEY_AEMET

error="
La APIKEY esta vacía, sin APIKEY no puedes obtener ningún dato.
Echale un ojo al README: https://github.com/vulturno/lurte#lo-que-necesitas
"

if [ -z "$apikey" ]; then
      printf "%b\n" "\e[31m$error"
      exit 1
fi

# Traducimos el nombre del mes en minúsculas a su número con dos dígitos
function numeroDelMes {
    case $1 in
        enero)      echo "01" ;;
        febrero)    echo "02" ;;
        marzo)      echo "03" ;;
        abril)      echo "04" ;;
        mayo)       echo "05" ;;
        junio)      echo "06" ;;
        julio)      echo "07" ;;
        agosto)     echo "08" ;;
        septiembre) echo "09" ;;
        octubre)    echo "10" ;;
        noviembre)  echo "11" ;;
        diciembre)  echo "12" ;;
        *)          echo "" ;;
    esac
}

# El último día del mes, teniendo en cuenta los años bisiestos
function ultimoDiaDelMes {
    numero=$1
    year=$2

    case $numero in
        01|03|05|07|08|10|12)
            echo "31"
        ;;
        04|06|09|11)
            echo "30"
        ;;
        02)
            if [ $((year % 4)) -eq 0 ] && { [ $((year % 100)) -ne 0 ] || [ $((year % 400)) -eq 0 ]; }; then
                echo "29"
            else
                echo "28"
            fi
        ;;
    esac
}

function openAemet {
    # El mes que queremos descargar
    mes=$1
    # El año que queremos descargar
    year=$2
    # El número de estación de la AEMET
    station=$3

    numero=$(numeroDelMes "$mes")

    if [ -z "$numero" ]; then
        printf "%b\n" "\e[31mNo has introducido ningún mes, vuelve a probar introduciendo el nombre del mes en minúsculas."
        return 1
    fi

    if [ -z "$year" ] || [ -z "$station" ]; then
        printf "%b\n" "\e[31mUso: bash lurte-mes.sh [mes en minúsculas] [año] [número de estación]"
        return 1
    fi

    dia=$(ultimoDiaDelMes "$numero" "$year")

    curl --silent --request GET --insecure \
      --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'"${year}"'-'"${numero}"'-01T00:00:00UTC/fechafin/'"${year}"'-'"${numero}"'-'"${dia}"'T23:59:59UTC/estacion/'"${station}"'/?api_key='"${apikey}"'' > "$mes".json

    # La AEMET responde con un JSON que trae el estado de la petición y la url de los datos
    # Si no comprobamos el estado acabamos generando archivos vacíos de 0 bytes
    estado=$(jq -r '.estado' "$mes".json 2>/dev/null)
    datos=$(jq -r '.datos' "$mes".json 2>/dev/null)

    if [ "$estado" != "200" ] || [ -z "$datos" ] || [ "$datos" = "null" ]; then
        printf "%b\n" "\e[31mLa AEMET no ha devuelto datos de la estación $station para $mes de $year (estado: $estado)"
        rm -f "$mes".json
        return 1
    fi

    # Dejamos la url en la primera línea y descargamos los datos a continuación
    # La primera línea se elimina más abajo, una vez limpiado el JSON
    echo "$datos" > "$mes".json &&
    curl --silent --request GET --insecure "$datos" >> "$mes".json &&

    # Al concatenar todos los meses el objeto JSON no esta bien construido
    # Mierdas varias para que el JSON quede formateado conforme es debido
    sed -i 's/],/,/' "$mes".json &&
    # Mierdas varias para que el JSON final quede formateado conforme es debido
    sed -i '$ s/,/]/' "$mes".json &&
    sed -i '$ s/],/,/' "$mes".json &&
    # Cambiamos el separador de coma por punto
    sed -i 's/\([0-9]\),/\1\./g' "$mes".json &&
    # Cambiamos Ip por 0 ver https://github.com/jorgeatgu/lurte/issues/9
    sed -i 's/Ip/0/' "$mes".json &&
    # Eliminamos las comillas de los números, incluídos los negativos
    sed -i -r 's/"(\-{0,1}[[:digit:]]+(\.[[:digit:]]+){0,1})"/\1/' "$mes".json &&
    # Eliminamos el cero a la izquierda que esta en los resultados de la dirección de viento
    sed -r -i 's/0*([0-9])/\1/' "$mes".json &&
    # Eliminamos la url que dejamos en la primera línea
    sed -i '1d' "$mes".json &&
    cp "$mes.json" "$station"-"$mes".json &&
    rm "$mes".json
}

showLoading() {
    mypid=$!
    loadingText=$1

    printf "%s.\r\e[35m" "$loadingText"

    while kill -0 $mypid 2>/dev/null
    do
        printf "%s.\r\e[35m" "$loadingText"
        sleep 0.5
        printf "%s..\r\e[35m" "$loadingText"
        sleep 0.5
        printf "%s...\r\e[35m" "$loadingText"
        sleep 0.5
        printf "\\n"
        printf "%s\r\e[35m" "$loadingText"
        sleep 0.5
    done
}

openAemet "$1" "$2" "$3" &
pid=$!

showLoading "Descargando todos los datos de la AEMET"

wait "$pid"
estadoDescarga=$?

if [ "$estadoDescarga" -ne 0 ]; then
    printf "%b\n" "\e[31mLa descarga ha fallado, no se ha generado ningún archivo."
    exit "$estadoDescarga"
fi

printf "%b\n" "\e[35m¡Descarga completada!"
