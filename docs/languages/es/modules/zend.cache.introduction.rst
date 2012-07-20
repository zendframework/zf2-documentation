.. _zend.cache.introduction:

Introducción
============

``Zend_Cache`` provee una forma genérica para cualquier caché de datos.

El almacenamiento en caché en Zend Framework se opera por interfaces, mientras que los registros de caché son
almacenados a través de adapatadores del backend (**Archivo**, **Sqlite**, **Memcache**...) mediante un sistema
flexible de documentos de identidad y etiquetas. Utilizando éstas, es fácil en el futuro eliminar determinados
tipos de registro.(Ejemplo: "eliminar todos los registros caché de determinada etiqueta").

El módulo principal (``Zend_Cache_Core``) es genérico, flexible y configurable. Aun para sus necesidades
específicas existen frontends de caché que extienden ``Zend_Cache_Core`` a conveniencia: **Output**, **File**,
**Function** y **Class**.

.. _zend.cache.introduction.example-1:

.. rubric:: Obtener un frontend con Zend_Cache::factory()

``Zend_Cache::factory()`` ejemplifica objetos correctos y los une. En este primer ejemplo, usaremos el frontend
**Core** junto con el backend **File**.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 7200, // tiempo de vida de caché de 2 horas
      'automatic_serialization' => true
   );

   $backendOptions = array(
       'cache_dir' => './tmp/' // Carpeta donde alojar los archivos de caché
   );

   // getting a Zend_Cache_Core object
   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

.. note::

   **Frontends y Backends Compuestos de Múltiples Palabras**

   Algunos frontends y backends se nombran usando varias palabras, tal como 'ZenPlatform'. Al fabricarlas las
   especificamos, las separamos usando un separador de palabras, como un espacio (' '), guión ('-'), o punto
   ('.').

.. _zend.cache.introduction.example-2:

.. rubric:: Almacenando en caché un resultado de consulta a una base de datos

Ahora que tenemos un frontend, podemos almacenar en caché cualquier tipo de dato (hemos activado la
serialización). Por ejemplo, podemos almacenar en caché un resultado de una consulta de base de datos muy
costosa. Después de ser almacenada en caché, no es necesario ni conectar la base de datos; los registros se
obtienen del caché de forma no serializada.

.. code-block:: php
   :linenos:

   // $cache initializada en el ejemplo anterior

   // Verificar si la cahce existe:
   if(!$result = $cache->load('myresult')) {

       // no existe cache; conectar a la base de datos

       $db = Zend_Db::factory( [...] );

       $result = $db->fetchAll('SELECT * FROM huge_table');

       $cache->save($result, 'myresult');

   } else {

       // cache existosa!, darlo a conocer
       echo "Éste es de caché!\n\n";

   }

   print_r($result);

.. _zend.cache.introduction.example-3:

.. rubric:: El almacenamiento en caché de salida con la interfaz de salida Zend_Cache

'Resaltamos' las secciones en las que deseamos almacenar en caché la salida, mediante la adición de algunas
condiciones lógicas, encapsulamos la sección dentro de los métodos ``start()`` y ``end()`` (esto se parece al
primer ejemplo y es la estrategia fundamental para el almacenamiento en caché).

Dentro, los datos de salida, como siempre – todas las salidas serán almacenadas en caché cuando se ordene la
ejecución del método ``end()``. En la siguiente ejecución, toda la sección se saltará a favor de la búsqueda
de datos del caché (tanto tiempo como el registro del caché sea válido).

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 30,                   // tiempo de vida de caché de 30 segundos
      'automatic_serialization' => false  // éste es el valor por defecto
   );

   $backendOptions = array('cache_dir' => './tmp/');

   $cache = Zend_Cache::factory('Output',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // Pasamos un identificador único al método start()
   if(!$cache->start('mypage')) {
       // salida como de costumbre:

       echo 'Hola mundo! ';
       echo 'Esto está en caché ('.time().') ';

       $cache->end(); // la salida es guardada y enviada al navegador
   }

   echo 'Esto no estará en caché nunca ('.time().').';

Note que delineamos el resultado de ``time()`` dos veces; esto es algo dinámico para los propósitos de la
demostración. Trate de ejecutarlo y entonces regenérelo muchas veces; notará que el primer número no cambia
mientras que el segundo cambia a medida que pasa el tiempo. Esto es porque el primer número esta delineado en la
sección caché y esta guardado en medio de otras salidas. Después de medio minuto (habremos establecido el tiempo
de vida de 30 segundos) los números deben acoplarse nuevamente porque el registro caché ha expirado -- sólo para
ser almacenado en caché nuevamente. Deberá probarlo en su visualizador o consola.

.. note::

   Cuando usamos ``Zend_Cache``, ponemos atención a la importación del identificador caché (pasado a ``save()``
   y ``start()``). Éste deberá ser único para cada recurso que se almacene en caché, de otra manera los
   registros almacenados en caché que no se vinculan podrían borrarse unos a otros, o peor aún, mostrarse uno en
   lugar del otro.


