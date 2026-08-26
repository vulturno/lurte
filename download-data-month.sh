#!/bin/bash

: '
Descarga un mes completo de todas las estaciones que usamos en vulturno.

Uso: bash download-data-month.sh [mes en minúsculas] [año]
Ejemplo: bash download-data-month.sh julio 2026

Los archivos se generan en el directorio desde el que se lanza el script.
'

mes=$1
year=$2

if [ -z "$mes" ] || [ -z "$year" ]; then
    printf "%b\n" "\e[31mUso: bash download-data-month.sh [mes en minúsculas] [año]"
    printf "%b\n" "\e[31mEjemplo: bash download-data-month.sh julio 2026"
    exit 1
fi

# La ruta de lurte-mes.sh, así podemos lanzar el script desde cualquier directorio
directorio=$(cd "$(dirname "$0")" && pwd)

# El listado de estaciones de la AEMET que descargamos cada mes
# Pamplona (9262) volvió a servir datos en 2026 y se reincorporó al listado
# 1249I (Oviedo) y 1690B siguen sin servir datos: fallan siempre, no es un error
estaciones=(
    8175 8025 1387 2444 4452 0076 1082 2331 3469A 8500A
    4121 5402 8096 1024E 0367 5514 C649I 4642E 9898 5960
    2661 9771C 9170 3195 6155A B278 6000A 7031 1690A 1690B
    1249I 1484C 0016A 2867 1109 1428 2465 5783 2030 C447A
    3260B 8416 2539 9091O 2400E 6325O 9434 9262
)

total=${#estaciones[@]}
fallidas=()

for ((i = 0; i < total; i++)); do
    estacion=${estaciones[$i]}

    echo "[$((i + 1))/$total] Descargando $estacion - $mes $year"

    if ! bash "$directorio"/lurte-mes.sh "$mes" "$year" "$estacion"; then
        fallidas+=("$estacion")
    fi

    # La AEMET limita el número de peticiones, esperamos entre estación y estación
    if [ "$i" -lt $((total - 1)) ]; then
        sleep 10
    fi
done

if [ ${#fallidas[@]} -eq 0 ]; then
    printf "%b\n" "\e[35mDescargadas las $total estaciones de $mes de $year"
else
    printf "%b\n" "\e[31mHan fallado ${#fallidas[@]} estaciones de $mes de $year: ${fallidas[*]}"
    printf "%b\n" "\e[31mPuedes repetirlas una a una con: bash lurte-mes.sh $mes $year [estación]"
    exit 1
fi
