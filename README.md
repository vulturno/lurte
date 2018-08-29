# Lurte

> Un lurte (palabra que puede estar masculina u femenina) u lit (plural litz) ye o esplazamiento d'una important cantidat de nieu enta o cobaixo d'una ladera d'una montanya, que puede encorporar parti d'o sustrato y d'o cubrimiento vechetal d'a montanya. Pueden estar naturals u prevocatos por l'hombre.

¿Que necesitas?

* Una apikey del open data de la [AEMET](https://opendata.aemet.es/centrodedescargas/inicio). Es gratuita.
* El número de la estación. [Aquí tienes un listado con todas las estaciones y su número](https://github.com/jorgeatgu/lurte/blob/master/estaciones.json)
* Y los años que quieres descargar. Hay que tener en cuenta que a partir de ciertos años la cantidad de datos que se recoge es mayor, en el caso de la estación del Aeropuerto de Zaragoza a partir de 1951 se recogen muchos más datos.

Los usuarios de macOS necesitan instalar SED de GNU a través de Homebrew

```
brew install gnu-sed --default-names
```

Una vez descargado el script para ejecutarlo solo tienes que hacer lo siguiente

```
./lurte.sh
```


El script es un poco lento si el rango de años es grande, esta hecho así para que la API no te tire por exceso de peticiones. Unos 30 minutos para descargarte desde 1951 hasta 2018, en total son 804 ficheros. Al final te lo concatena todo en el mismo(esto es configurable) con el nombre de la estación ```9434-total-diario.json```.




