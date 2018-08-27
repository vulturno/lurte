

  function lurte() {
    function openAemet() {
        # El año desde el que queremos descargar
        from=1951
        # El año hasta el que queremos descargar
        to=1952
        # El número de estación de la AEMET
        station=9434
        # El nombre del archivo con todos los años
        total="${station}-total-diario"
        # La apikey del open data de la AEMET
        apikey=''
                # Los años que queremos descargar
               for i in {$from..$to}
               do
               # Le pasamos un nombre al archivo que generaremos con todo el año
               entero="${i}-entero"

                       # Los doce meses del año
                       curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-01-01T00:00:00UTC/fechafin/'${i}'-01-31T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-02-01T00:00:00UTC/fechafin/'${i}'-02-29T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-03-01T00:00:00UTC/fechafin/'${i}'-03-31T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-04-01T00:00:00UTC/fechafin/'${i}'-04-30T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-05-01T00:00:00UTC/fechafin/'${i}'-05-31T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-06-01T00:00:00UTC/fechafin/'${i}'-06-30T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-07-01T00:00:00UTC/fechafin/'${i}'-07-31T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-08-01T00:00:00UTC/fechafin/'${i}'-08-31T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-09-01T00:00:00UTC/fechafin/'${i}'-09-30T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-10-01T00:00:00UTC/fechafin/'${i}'-10-31T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-11-01T00:00:00UTC/fechafin/'${i}'-11-30T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                         --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-12-01T00:00:00UTC/fechafin/'${i}'-12-31T23:59:59UTC/estacion/'${station}'/?api_key='${apikey}'' >> $i.json &&
                         # El archivo que descargamos contiene demasiadas cosas que no sirven
                         # Vamos a quedarnos solo con la url de datos
                         sed -i '/descripcion/d;/estado/d;/metadatos/d' $i.json &&
                         sed -i 's/{//;s/}//;s/"//;s/ : //;s/datos//;s/",//;s/""//;s/  //' $i.json &&
                         # Ahora ejecutamos todas las url de datos de todo el año y descargamos su contenido en el mismo archivo
                         while read line; do
                            # Eliminamos los archivos de los años ya que no nos sirven para nada
                            rm -rf $i.json
                            curl --silent --request GET --insecure "$line" >> $entero.json &&
                            # Añadimos una coma al final de todos los archivos anuales para luego concatenar todos en el mismo archivo
                            echo "," >> $entero.json
                         done < $i.json &&
                        # Le damos un respiro a la API, ya que nos baneara si hacemos demasiadas peticiones en poco tiempo
                        sleep 30
               done

        # Al concatenar todos los meses el objeto JSON no esta bien construido
        # Primero eliminamos ], excepto el último que sirve para concatenar todos los archivos en el mismo
        sed -i 's/],/,/' *.json &&
        # Eliminamos todos los [ excepto el primero que sirve para concatenar todos los archivos en el mismo
        sed -i '1 ! s/\[//' *.json &&
        # Concatenamos todos los JSON en el mismo archivo
        cat *.json > $total.json &&
        sed -i '$ s/,/,]/' $total.json &&
        # Eliminamos todos los JSON con los años enteros
        find . -name '*-entero*' -delete &&
        # Cambiamos el separador de coma por punto
        sed -i 's/\([0-9]\),/\1\./g' $total.json

    }

    showLoading() {
      mypid=$!
      loadingText=$1

      echo -ne "$loadingText\r"

      while kill -0 $mypid 2>/dev/null; do
        echo -ne "$loadingText.\r"
        sleep 0.5
        echo -ne "$loadingText..\r"
        sleep 0.5
        echo -ne "$loadingText...\r"
        sleep 0.5
        echo -ne "\r\033[K"
        echo -ne "$loadingText\r"
        sleep 0.5
      done

      echo "$loadingText...Descarga completada!"
    }

    openAemet & showLoading "Descargando todos los datos de la AEMET"
}
