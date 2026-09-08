#!/bin/bash

: '
Descarga los resúmenes anuales de todas las estaciones que usamos en vulturno.

Uso: bash download-data-anual.sh [año desde] [año hasta]
Ejemplo: bash download-data-anual.sh 2025 2026

Los archivos <estación>-total-anual.json se generan en el directorio desde el que
se lanza el script.

IMPORTANTE: lurte-anual.sh hace "sed -i -- *.json" sobre TODO el directorio de
trabajo, así que este script se lanza desde un directorio vacío y va sacando cada
<estación>-total-anual.json a ~/github/lurte según lo termina. Si se lanza desde
~/github/lurte corrompe estaciones.json y los ficheros ya descargados.
'

desde=$1
hasta=$2

if [ -z "$desde" ] || [ -z "$hasta" ]; then
    printf "%b\n" "\e[31mUso: bash download-data-anual.sh [año desde] [año hasta]"
    printf "%b\n" "\e[31mEjemplo: bash download-data-anual.sh 2025 2026"
    exit 1
fi

# La ruta de lurte-anual.sh, así podemos lanzar el script desde cualquier directorio
directorio=$(cd "$(dirname "$0")" && pwd)

if [ "$(pwd)" = "$directorio" ]; then
    printf "%b\n" "\e[31mNo lo lances desde $directorio: lurte-anual.sh hace sed -i sobre *.json"
    printf "%b\n" "\e[31mCrea un directorio vacío, entra en él y vuelve a lanzarlo"
    exit 1
fi

# El listado de estaciones de la AEMET, el mismo que download-data-month.sh
# 1249I (Oviedo) dejó de emitir en 2023 y 1690B no sirve datos: fallan, no es un error
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

    echo "[$((i + 1))/$total] Descargando $estacion - $desde a $hasta"

    bash "$directorio"/lurte-anual.sh "$desde" "$hasta" "$estacion"

    # lurte-anual.sh siempre sale con 0, así que comprobamos el fichero resultante
    if [ -s "$estacion"-total-anual.json ] && jq -e . "$estacion"-total-anual.json > /dev/null 2>&1; then
        # Lo sacamos del directorio de trabajo: si se queda, el sed -i de la
        # siguiente estación lo modificaría
        mv -f "$estacion"-total-anual.json "$directorio"/
    else
        fallidas+=("$estacion")
        rm -f "$estacion"-total-anual.json
    fi

    # Limpiamos cualquier resto para que no contamine la siguiente estación
    rm -f ./*-entero*.json
done

if [ ${#fallidas[@]} -eq 0 ]; then
    printf "%b\n" "\e[35mDescargadas las $total estaciones de $desde a $hasta"
else
    printf "%b\n" "\e[31mHan fallado ${#fallidas[@]} estaciones: ${fallidas[*]}"
    printf "%b\n" "\e[31mPuedes repetirlas una a una con: bash $directorio/lurte-anual.sh $desde $hasta [estación]"
    exit 1
fi
