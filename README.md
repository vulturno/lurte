# Lurte

> Un lurte (palabra que puede estar masculina u femenina) u lit (plural litz) ye o esplazamiento d'una important cantidat de nieu enta o cobaixo d'una ladera d'una montanya, que puede encorporar parti d'o sustrato y d'o cubrimiento vechetal d'a montanya. Pueden estar naturals u prevocatos por l'hombre.

Usuarios de macOS, debéis de instalar SED para GNU. Es mejor para tu vida, ya que la amplía mayoría de ejemplos de SED están para GNU no para BSD.

```
brew install gnu-sed --default-names
```

Un script de andar por casa para descargarte del open data de la AEMET todos los datos diarios de los años que quieras. El resultado será un JSON con todos los años. Se puede modificar para descargar datos anuales.

El script es un poco lento para que la API no te tire por exceso de peticiones. Unos 20 minutos para descargarte 67 años, que multiplicados por 12 son 804 ficheros. Al final te lo concatena todo en el mismo(esto es configurable). Si lo haces a mano puedes morir por como esta hecho el proceso en la AEMET.

¿Que necesitas?

* Una apikey del open data de la [AEMET](https://opendata.aemet.es/centrodedescargas/inicio). Es gratuita.
* El número de la estación. [Aquí tienes un listado con todas las estaciones y su número](https://github.com/jorgeatgu/lurte/blob/master/estaciones.json)
* Y los años que quieres descargar. Hay que tener en cuenta que a partir de ciertos años la cantidad de datos que se recoge es mayor, en el caso de la estación del Aeropuerto de Zaragoza a partir de 1951 se recogen muchos más datos.
