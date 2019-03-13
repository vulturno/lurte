# Lurte

> Un lurte (palabra que puede estar masculina u femenina) u lit (plural litz) ye o esplazamiento d'una important cantidat de nieu enta o cobaixo d'una ladera d'una montanya, que puede encorporar parti d'o sustrato y d'o cubrimiento vechetal d'a montanya. Pueden estar naturals u prevocatos por l'hombre.


## Indice

<p align="center">
  <a href="#motivacion">Motivación</a> •
  <a href="#lo-que-necesitas">Lo que necesitas</a> •
  <a href="#uso">Uso</a> •
  <a href="#contribuye">Contribuye</a> •
  <a href="#licencia">Licencia</a>
</p>

## Motivación

La limitación de la API y el terrible funcionamiento en cuanto a diseño y UX me ha llevado automatizar el proceso para conseguir más datos para [FORNO](https://forno.es). ¿Porque en Bash? Como loco de la automatización es lo que uso.

## Lo que necesitas

* Una apikey del open data de la [AEMET](https://opendata.aemet.es/centrodedescargas/inicio). Es gratuita. Y la tienes que agregar en la línea 4 del script.
* El número de la estación. [Aquí tienes un listado con todas las estaciones y su número](https://github.com/jorgeatgu/lurte/blob/master/estaciones.json)
* Y los años que quieres descargar. Hay que tener en cuenta que a partir de ciertos años la cantidad de datos que se recoge es mayor, en el caso de la estación del Aeropuerto de Zaragoza a partir de 1951 se recogen muchos más datos.

Los usuarios de macOS necesitan instalar SED de GNU a través de Homebrew

Desde enero de 2019 homebrew ha eliminado el flag --default-names, así que para no usar el prefijo g hay que seguir estos pasos: https://apple.stackexchange.com/questions/69223/how-to-replace-mac-os-x-utilities-with-gnu-core-utilities/88812#88812

```
brew install gnu-sed
```

## Uso

### Descargar datos diarios de un rango de años

Con este script te puedes descargar todos los datos diarios de una estación de la AEMET.

Descarga el script ```lurte.sh```. Una vez descargado haz lo siguiente:

```
bash lurte.sh [desde el año] [hasta el año] [número de estación]

 Ejemplo:

bash lurte.sh 1980 1990 9434
```

El script es un poco lento si el rango de años es grande, esta hecho así para que la API no te tire por exceso de peticiones. El tiempo de descarga estimado para un rango de años desde 1951 hasta 2018(804 ficheros) es de unos 30 minutos. El resultado final son todos los días de todos los años en un archivo con el nombre de la estación, ejemplo: ```9434-total-diario.json```.

### Descargar un mes

Para descargar solamente un mes hay que usar el script ```lurte-mes.sh```. Una vez descargado haz lo siguiente:

```
bash lurte-mes.sh [nombre del mes en minúsculas] [año] [número de estación]

Ejemplo:

bash lurte-mes.sh septiembre 2018 9434
```

### Descargar datos anuales

Con este script te descargas los resumenes mensuales de cada año.

Descarga el script ```lurte-anual.sh```. Una vez descargado haz lo siguiente:

```
bash lurte-anual.sh [desde el año] [hasta el año] [número de estación]

 Ejemplo:

bash lurte-anual.sh 1980 1990 9434
```

## Contribuye

[Abre una issue](https://github.com/RichardLitt/standard-readme/issues/new) o haz un PRs.

### Contributors

[Ekaitz Zarraga](https://github.com/ekaitz-zarraga) | [Jorge Aznar](https://github.com/jorgeatgu) 

## Licencia

[MIT](LICENSE) © Jorge Aznar
