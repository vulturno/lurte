#!/bin/bash
# Loader from http://codingdiscovery.blogspot.com/2014/03/show-loading-dots-in-bash-script.html

function lurte() {

    function openAemet() {
        #Aquí el año desde el que queremos descargar
        from=1951
        #Aquí el año hasta el que queremos descargar
        to=2018
        #Aquí nuestro apikey del open data de la AEMET
        apikey=''

        # Los años que queremos descargar
        for i in {$from..$to}
        do
                               # Le pasamos un nombre al archivo que generaremos con todo el año
                               entero="${i}-entero"

                               # Los doce meses del año
                               curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-01-01T00:00:00UTC/fechafin/'${i}'-01-31T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-02-01T00:00:00UTC/fechafin/'${i}'-02-29T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-03-01T00:00:00UTC/fechafin/'${i}'-03-31T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-04-01T00:00:00UTC/fechafin/'${i}'-04-30T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-05-01T00:00:00UTC/fechafin/'${i}'-05-31T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-06-01T00:00:00UTC/fechafin/'${i}'-06-30T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-07-01T00:00:00UTC/fechafin/'${i}'-07-31T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-08-01T00:00:00UTC/fechafin/'${i}'-08-31T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-09-01T00:00:00UTC/fechafin/'${i}'-09-30T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-10-01T00:00:00UTC/fechafin/'${i}'-10-31T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-11-01T00:00:00UTC/fechafin/'${i}'-11-30T23:59:59UTC/estacion/9434/?api_key='${apikey}''  >> $i.json && curl --silent --request GET --insecure \
                               --url 'https://opendata.aemet.es/opendata/api/valores/climatologicos/diarios/datos/fechaini/'${i}'-12-01T00:00:00UTC/fechafin/'${i}'-12-31T23:59:59UTC/estacion/9434/?api_key='${apikey}'' >> $i.json &&
                                 # El archivo que descargamos contiene demasiadas cosas que no sirven
                                 # Vamos a quedarnos solo con la url de datos
                                 sed -i '' '/descripcion/d' $i.json &&
                                 sed -i '' '/estado/d' $i.json &&
                                 sed -i '' '/metadatos/d' $i.json &&
                                 sed -i '' 's/{//' $i.json &&
                                 sed -i '' 's/}//' $i.json &&
                                 sed -i '' 's/"//' $i.json &&
                                 sed -i '' 's/ : //' $i.json &&
                                 sed -i '' 's/datos//' $i.json &&
                                 sed -i '' 's/",//' $i.json &&
                                 sed -i '' 's/""//' $i.json &&
                                 sed -i '' 's/  //' $i.json &&
                                 # Ahora ejecutamos todas las url y descargamos su contenido en el mismo archivo
                                 while read line; do
                                   rm -rf $i.json
                                   curl --silent --request GET --insecure "$line" >> $entero.json &&
                                       # Le damos un respiro a la API
                                   done < $i.json &&
                                 # Eliminamos los archivos de los años ya que no nos sirven para nada
                                 sleep 30
                             done
                # Al concatenar meses el objeto JSON no esta bien construido
                # Vamos a cambiar [] por ,
                sed -i '' 's/]//' *.json &&
                sed -i '' 's/\[/,/' *.json

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
