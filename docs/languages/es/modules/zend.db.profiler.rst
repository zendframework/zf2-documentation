.. _zend.db.profiler:

Zend_Db_Profiler
================

.. _zend.db.profiler.introduction:

Introducción
------------

``Zend_Db_Profiler`` puede ser habilitado para Perfilar las consultas. Los Perfiles incluyen la consulta procesada
por el adaptador como el tiempo as transcurrido en la ejecución de las consultas, permitiendo inspeccionar las
consultas realizadas win necesidad de agregar información de depuración extra en el código de las clases. El uso
avanzado también permite que el desarrollador filtre las consultas que desea perfilar.

Habilite el perfilador pasando una directiva al al constructor del adaptador, o pidiendole al adaptador permitirlo
más adelante.

.. code-block:: php
   :linenos:

   $params = array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
       'profiler' => true  // enciende el perfilador
                           // establezca false para deshabilitar (está deshabilitado por defecto)
   );

   $db = Zend_Db::factory('PDO_MYSQL', $params);

   // apagar el perfilador:
   $db->getProfiler()->setEnabled(false);

   // encender el perfilador:
   $db->getProfiler()->setEnabled(true);

El valor de la opción '``profiler``' es flexible. Es interpretada de distintas formas dependiendo del tipo.
Normalmente, debería usar un valor booleano simple, pero otros tipos le permiten personalizar el comportamiento
del perfilador.

Un argumento booleano establece el perfilador como habilitado si el valor es ``TRUE``, o deshabilitado si es
``FALSE``. La clase del perfilador es el la clase de perfilador por defecto del adaptador, ``Zend_Db_Profiler``.

.. code-block:: php
   :linenos:

   $params['profiler'] = true;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

Una instancia del objeto perfilador hace que el adaptador use ese objeto. El tipo del objeto debe ser
``Zend_Db_Profiler`` o una subclase de este. Habilitar el perfilador se hace por separado.

.. code-block:: php
   :linenos:

   $profiler = MyProject_Db_Profiler();
   $profiler->setEnabled(true);
   $params['profiler'] = $profiler;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

El argumento puede ser un array asociativo conteniendo algunas o todas las claves '``enabled``', '``instance``', y
'``class``'. Las claves '``enabled``' e '``instance``' corresponden a los tipos booleano y la instancia documentada
previamente. La clave '``class``' es usada para nombrar la clase que usará el perfilador personalizado. La clase
debe ser ``Zend_Db_Profiler`` o una subclase. La clase es instanciada sin argumentos de constructor. La opción
'``class``' es ignorada cuando la opción '``instance``' está dada.

.. code-block:: php
   :linenos:

   $params['profiler'] = array(
       'enabled' => true,
       'class'   => 'MyProject_Db_Profiler'
   );
   $db = Zend_Db::factory('PDO_MYSQL', $params);

Finalmente, el argumento puede ser un objeto de tipo ``Zend_Config`` conteniendo las propiedades, que son tratadas
como las claves de array descritas recién. Por ejemplo, un archivo "``config.ini``" puede contener los siguientes
datos:

.. code-block:: ini
   :linenos:

   [main]
   db.profiler.class   = "MyProject_Db_Profiler"
   db.profiler.enabled = true

Esta configuración puede ser aplicada con el siguiente código *PHP*:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('config.ini', 'main');
   $params['profiler'] = $config->db->profiler;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

La propiedad '``instance``' debe ser usada como el siguiente ejemplo:

.. code-block:: php
   :linenos:

   $profiler = new MyProject_Db_Profiler();
   $profiler->setEnabled(true);
   $configData = array(
       'instance' => $profiler
       );
   $config = new Zend_Config($configData);
   $params['profiler'] = $config;
   $db = Zend_Db::factory('PDO_MYSQL', $params);

.. _zend.db.profiler.using:

Usando el Perfilador
--------------------

En este punto, obtenemos el perfilador usando el método ``getProfiler()`` del adaptador:

.. code-block:: php
   :linenos:

   $profiler = $db->getProfiler();

Este retorna una instancia del objeto ``Zend_Db_Profiler``. Con esta instancia, el desarrollador puede examinar las
consultar usando una variedad de métodos:

- ``getTotalNumQueries()`` retorna el número total de consultas que han sido perfiladas.

- ``getTotalElapsedSecs()`` retorna el número total de segundos transcurridos en todas las consultas perfiladas.

- ``getQueryProfiles()`` retorna un array con todos los perfiles de consultas.

- ``getLastQueryProfile()`` retorna el último perfil (más reciente) de consulta, independientemente de si la
  consulta ha terminado o no (si no lo ha hecho, la hora de finalización será ``NULL``).

- ``clear()`` limpia los perfiles de consulta de la pila.

El valor de retorno de ``getLastQueryProfile()`` y elementos individuales de ``getQueryProfiles()`` son
``Zend_Db_Profiler_Query`` objetos, que proporcionan la capacidad para inspeccionar cada una de las consultas:

- ``getQuery()`` retorna el texto SQL de la consulta. El texto *SQL* de una declaración preparada con parámetros
  es el texto al tiempo en que la consulta fué preparada, por lo que contiene marcadores de posición, no los
  valores utilizados cuando la declaración se ejecuta.

- ``getQueryParams()`` retorna un array de los valores de los parámetros usados cuando se ejecuta una consulta
  preparada. Este incluye ambos parámetros y argumentos vinculados al método ``execute()`` de la declaración.
  Las claves del array son las posiciones (basado en 1) o indices de parámetros nombrados (string).

- ``getElapsedSecs()`` returna el número de segundos que tuvo la consulta al correr.

La información que ``Zend_Db_Profiler`` provee es útil para perfilar cuellos de botella en aplicaciones, y para
depurar consultas que han sido ejecutadas. Por instancia, para ver la consulta exacta que tuvo la última
ejecución:

.. code-block:: php
   :linenos:

   $query = $profiler->getLastQueryProfile();

   echo $query->getQuery();

Tal vez una página se genera lentamente; use el perfilador para determinar primero el número total de segundos de
todas las consultas, y luego recorrer paso a paso a través de las consultas para encontrar la más lenta:

.. code-block:: php
   :linenos:

   $totalTime    = $profiler->getTotalElapsedSecs();
   $queryCount   = $profiler->getTotalNumQueries();
   $longestTime  = 0;
   $longestQuery = null;

   foreach ($profiler->getQueryProfiles() as $query) {
       if ($query->getElapsedSecs() > $longestTime) {
           $longestTime  = $query->getElapsedSecs();
           $longestQuery = $query->getQuery();
       }
   }

   echo 'Ejecutadas ' . $queryCount . ' consultas en ' . $totalTime .
        ' segundos' . "\n";
   echo 'Promedio de tiempo de consulta: ' . $totalTime / $queryCount .
        ' segundos' . "\n";
   echo 'Consultas por segundo: ' . $queryCount / $totalTime . "\n";
   echo 'Tardanza de la consulta más lenta: ' . $longestTime . "\n";
   echo "Consulta más lenta: \n" . $longestQuery . "\n";

.. _zend.db.profiler.advanced:

Uso avanzado del Perfilador
---------------------------

Además de la inspección de consultas, el perfilador también le permite al desarrollador filtrar que consultas
serán perfiladas. El siguiente método opera en una instancia de ``Zend_Db_Profiler``:

.. _zend.db.profiler.advanced.filtertime:

Filtrar por tiempo transcurrido en consulta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``setFilterElapsedSecs()`` le permite al desarrolador establecer un tiempo mínimo antes de que una consulta se
perfile. Para remover el filtro, pase un valor ``NULL`` al método.

.. code-block:: php
   :linenos:

   // Solo perfilar consultas que tardan más de 5 segundos:
   $profiler->setFilterElapsedSecs(5);

   // Perfilar todas las consultas sin importar el tiempo:
   $profiler->setFilterElapsedSecs(null);

.. _zend.db.profiler.advanced.filtertype:

Filtrar por tipo de consulta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``setFilterQueryType()`` le permite al desarrollador establecer que tipo de consulta serán perfiladas; para
perfilar multiples tipos, use un "OR" lógico. Los tipos de consulta se definen como las siguientes constantes de
``Zend_Db_Profiler``:

- ``Zend_Db_Profiler::CONNECT``: operaciones de conexión o selección de base de datos.

- ``Zend_Db_Profiler::QUERY``: consultas generales a la base de datos que no calzan con otros tipos.

- ``Zend_Db_Profiler::INSERT``: cualquier consulta que agrega filas a la base de datos, generalmente un *SQL*
  INSERT.

- ``Zend_Db_Profiler::UPDATE``: cualquier consulta que actualice registros existentes, usualmente un *SQL* UPDATE.

- ``Zend_Db_Profiler::DELETE``: cualquier consulta que elimine datos existentes, usualmente un *SQL* DELETE.

- ``Zend_Db_Profiler::SELECT``: cualquier consulta que retorne datos existentes, usualmente un *SQL* SELECT.

- ``Zend_Db_Profiler::TRANSACTION``: cualquier operación transaccional, tal como iniciar una transacción,
  confirmar, o revertir.

Asi como con ``setFilterElapsedSecs()``, puedes remover cualquier filtro existente pasando un ``NULL`` como único
argumento.

.. code-block:: php
   :linenos:

   // Perfilar solo consultas SELECT
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT);

   // Perfila consultas SELECT, INSERT, y UPDATE
   $profiler->setFilterQueryType(Zend_Db_Profiler::SELECT |
                                 Zend_Db_Profiler::INSERT |
                                 Zend_Db_Profiler::UPDATE);

   // Perfilar consultas DELETE
   $profiler->setFilterQueryType(Zend_Db_Profiler::DELETE);

   // Remover todos los filtros
   $profiler->setFilterQueryType(null);

.. _zend.db.profiler.advanced.getbytype:

Obtener perfiles por tipo de consulta
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Usando ``setFilterQueryType()`` puedes reducir los perfiles generados. Sin embargo, a veces puede ser más útil
mantener todos los perfiles, pero ver sólo los que necesita en un determinado momento. Otra característica de
``getQueryProfiles()`` es que puede este filtrado al-vuelo, pasando un tipo de consulta(o una combinación lógica
de tipos de consulta) en el primer; vea :ref:` <zend.db.profiler.advanced.filtertype>` para una lista las
constantes de tipo de consulta.

.. code-block:: php
   :linenos:

   // Obtiene solo perfiles de consultas SELECT
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT);

   // Obtiene los perfiles de consultas SELECT, INSERT, y UPDATE
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::SELECT |
                                           Zend_Db_Profiler::INSERT |
                                           Zend_Db_Profiler::UPDATE);

   // Obtiene solo perfiles de consultas DELETE
   $profiles = $profiler->getQueryProfiles(Zend_Db_Profiler::DELETE);

.. _zend.db.profiler.profilers:

Perfiladores Especializados
---------------------------

Un Perfilador Especializado es un objeto que hereda de ``Zend_Db_Profiler``. Los Perfiladores Especializados tratan
la información de perfilado de maneras más especificas.

.. include:: zend.db.profiler.firebug.rst

