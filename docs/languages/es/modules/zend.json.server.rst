.. EN-Revision: none
.. _zend.json.server:

Zend\Json\Server - servidor JSON-RPC
====================================

``Zend\Json\Server`` es una implementación del servidor `JSON-RPC`_ Soporta tanto la versión 1 de la
especificación `JSON-RPC`_ así como la especificación de la `versión 2`_; además, provee una implementación
de *PHP* de la especificación del `Service Mapping Description (SMD)`_ para prestar un servicio de metadatos a
consumidores del servicio.

JSON-RPC es un protocolo liviano de Remote Procedure Call que utiliza JSON para envolver sus mensajes. Esta
implementación JSON-RPC sigue la *API* *PHP* de `SoapServer`_. Esto significa que, en una situación típica,
simplemente:

- Instancia el objeto servidor

- Agrega una o más funciones y/o clases/objetos al objeto servidor para

- handle() -- maneja -- el requerimiento

``Zend\Json\Server`` utiliza :ref:` <zend.server.reflection>` para realizar reflexión sobre cualquiera de las
clases o funciones agregadas, y utiliza esa información para construir tanto la SMD y hacer cumplir el método de
llamado de firmas. Como tal, es imperativo que cualquier de las funciones agregadas y/o los métodos de clase
tengan mínimamente una plena documentación de *PHP* docblocks:

- Todos los parámetros y sus tipos de variables esperados

- El tipo de variable del valor de retorno

``Zend\Json\Server`` escucha por solicitudes POST únicamente en este momento; afortunadamente, la mayoría de las
implementaciones del cliente JSON-RPC en los medios en el momento de escribir esto, sólo requieren a POST como es.
Esto hace que sea fácil de utilizar el mismo punto final del servidor para manejar a ambas peticiones así como
para entregar el servicio SMD, como se muestra en el siguiente ejemplo.

.. _zend.json.server.usage:

.. rubric:: Uso de Zend\Json\Server

Primero, definir una clase que queramos exponer vía servidor JSON-RPC. Vamos a la clase 'Calculator', y definir
los métodos para 'add', 'subtract', 'multiply', y 'divide':

.. code-block:: php
   :linenos:

   /**
    * Calculator - clase de ejemplo para exponer via JSON-RPC
    */
   class Calculator
   {
       /**
        * Devuelve la suma de dos variables
        *
        * @param  int $x
        * @param  int $y
        * @return int
        */
       public function add($x, $y)
       {
           return $x + $y;
       }

       /**
        * Devuelve la diferencia de dos variables
        *
        * @param  int $x
        * @param  int $y
        * @return int
        */
       public function subtract($x, $y)
       {
           return $x - $y;
       }

       /**
        * Devuelve el producto de dos variables
        *
        * @param  int $x
        * @param  int $y
        * @return int
        */
       public function multiply($x, $y)
       {
           return $x * $y;
       }

       /**
        * Devuelve la división de dos variables
        *
        * @param  int $x
        * @param  int $y
        * @return float
        */
       public function divide($x, $y)
       {
           return $x / $y;
       }
   }

Nótese que cada método tiene un docblock con entradas indicando cada parámetro y su tipo, así como una entrada
para el valor de retorno. Esto es **absolutamente crítico** cuando se usa ``Zend\Json\Server``-- o cualquier otro
componente del servidor en Zend Framework, por esa cuestión.

Ahora, crearemos un script para manejar las peticiones:

.. code-block:: php
   :linenos:

   $server = new Zend\Json\Server();

   // Indicar que funcionalidad está disponible:
   $server->setClass('Calculator');

   // Manejar el requerimiento:
   $server->handle();

Sin embargo, esto no soluciona el problema de devolución de un SMD para que el cliente JSON-RPC pueda
autodescubrir los métodos. Esto puede lograrse determinando el método del requerimiento *HTTP*, y luego
especificando algún servidor de metadatos:

.. code-block:: php
   :linenos:

   $server = new Zend\Json\Server();
   $server->setClass('Calculator');

   if ('GET' == $_SERVER['REQUEST_METHOD']) {
       // Indica el punto final de la URL, y la versión en uso de JSON-RPC:
       $server->setTarget('/json-rpc.php')
              ->setEnvelope(Zend\Json_Server\Smd::ENV_JSONRPC_2);

       // Capturar el SMD
       $smd = $server->getServiceMap();

       // Devolver el SMD al cliente
       header('Content-Type: application/json');
       echo $smd;
       return;
   }

   $server->handle();

Si utiliza el servidor JSON-RPC con Dojo toolkit, también necesitará establecer un flag de compatibilidad
especial para garantizar que los dos interoperen correctamente:

.. code-block:: php
   :linenos:

   $server = new Zend\Json\Server();
   $server->setClass('Calculator');

   if ('GET' == $_SERVER['REQUEST_METHOD']) {
       $server->setTarget('/json-rpc.php')
              ->setEnvelope(Zend\Json_Server\Smd::ENV_JSONRPC_2);
       $smd = $server->getServiceMap();

       // Establecer la compatibilidad con Dojo:
       $smd->setDojoCompatible(true);

       header('Content-Type: application/json');
       echo $smd;
       return;
   }

   $server->handle();

.. _zend.json.server.details:

Detalles Avanzados
------------------

Aunque la mayor funcionalidad de ``Zend\Json\Server`` se puntualiza en :ref:` <zend.json.server.usage>`, hay más
funcionalidad avanzada disponible.

.. _zend.json.server.details.zendjsonserver:

Zend\Json\Server
^^^^^^^^^^^^^^^^

``Zend\Json\Server`` es la clase núcleo en la propuesta JSON-RPC; que maneja todas las peticiones y como respuesta
devuelve un conjunto de datos. Tiene los siguientes métodos:

- ``addFunction($function)``: Especifica la función de espacio del usuario para agregar al servidor.

- ``setClass($class)``: Especifica una clase u objeto para agregar al servidor; todos los métodos públicos de ese
  item serán expuestos como métodos JSON-RPC.

- ``fault($fault = null, $code = 404, $data = null)``: Crea y devuelve un objeto ``Zend\Json_Server\Error``.

- ``handle($request = false)``: Maneja una solicitud JSON-RPC; opcionalmente, pasa un objeto
  ``Zend\Json_Server\Request`` a utlizar (crea uno por defecto).

- ``getFunctions()``: Devuelve una lista de todos los métodos agregados.

- ``setRequest(Zend\Json_Server\Request $request)``: Especifica un objeto solicitud para el servidor a utilizar.

- ``getRequest()``: Recupera el objeto solicitud usado por el servidor.

- ``setResponse(Zend\Json_Server\Response $response)``: Establece el objeto respuesta para el servidor a utilizar.

- ``getResponse()``: Recupera el objeto respuesta usado por el servidor.

- ``setAutoEmitResponse($flag)``: Indica si el servidor debería emitir automáticamente la respuesta y todas las
  cabeceras; por defecto, esto es ``TRUE``.

- ``autoEmitResponse()``: Determina si la auto-emisión de la respuesta está habilitada.

- ``getServiceMap()``: Recupera la descripción del mapa de servicio en el form de un objeto
  ``Zend\Json_Server\Smd``.

.. _zend.json.server.details.zendjsonserverrequest:

Zend\Json_Server\Request
^^^^^^^^^^^^^^^^^^^^^^^^

El medio ambiente de una solicitud JSON-RPC está encapsulado en el objeto ``Zend\Json_Server\Request``. Este
objeto le permite establecer porciones necesarias de la solicitud JSON-RPC, incluida el ID de la solicitud,
parámetros y especificaciones de la versión JSON-RPC. Tiene la capacidad de cargarse a sí mismo via JSON o un
conjunto de opciones, y puede mostrase a si mismo como JSON vía el método ``toJson()``.

El objeto solicitud tiene los siguientes métodos disponibles:

- ``setOptions(array $options)``: Especifica la configuración del objeto. ``$options`` puede contener claves que
  concuerden con cualuier método 'set': ``setParams()``, ``setMethod()``, ``setId()``, y ``setVersion()``.

- ``addParam($value, $key = null)``: Agrega un parámetro para usar con el método de llamada. Los parámetros
  pueden ser sólo los valores, o pueden incluir opcionalmente el nombre del parámetro.

- ``addParams(array $params)``: Agrega múltiples parámetros a la vez; proxies a ``addParam()``

- ``setParams(array $params)``: Establece todos los parámetros a la vez; sobrescribe cualquiera de los parámetros
  existentes.

- ``getParam($index)``: Recupera un parámetro por posición o por el nombre.

- ``getParams()``: Recupera todos los parámetros a la vez.

- ``setMethod($name)``: Establece el método para llamar.

- ``getMethod()``: Recupera el método que será llamado.

- ``isMethodError()``: Determinar si la solicitud está malformada o no y si daría como resultado un error.

- ``setId($name)``: Establecer el identificador de solicitud(utilizado por el cliente para igualar las solicitudes
  de respuestas).

- ``getId()``: Recuperar el identificador de solicitudes.

- ``setVersion($version)``: Establecer la versión de la especificación JSON-RPC que conforma la solicitud. Puede
  ser '1.0' o '2.0'.

- ``getVersion()``: Recuperar la versión de la especificación JSON-RPC utilizados por la solicitud.

- ``loadJson($json)``: Cargar el objeto solicitud de una cadena JSON.

- ``toJson()``: Mostrar la solicitud como un string JSON.

Una versión específica de *HTTP* está disponible a través de ``Zend\Json\Server\Request\Http``. Esta clase
podrá recuperar la solicitud via ``php://input``, y permite el acceso JSON sin procesar vía el método
``getRawJson()``.

.. _zend.json.server.details.zendjsonserverresponse:

Zend\Json_Server\Response
^^^^^^^^^^^^^^^^^^^^^^^^^

La respuesta del conjunto de datos JSON-RPC es encapsulada en el objeto ``Zend\Json_Server\Response``. Este objeto
le permite ajustar el valor de retorno de la solicitud, siendo la respuesta un error o no, el identificador de
solicitud, con que versión de especificación esta conformada la respuesta de JSON-RPC, y, opcionalmente el mapa
de servicio.

El objeto respuesta tiene los siguientes métodos disponibles:

- ``setResult($value)``: Establecer el resultado de la respuesta.

- ``getResult()``: Recuperar el resultado de la respuesta.

- ``setError(Zend\Json_Server\Error $error)``: Establecer un objeto error. Si ya está, este será utilizado como
  la respuesta cuando se serialize a JSON.

- ``getError()``: Recuperar el objeto error, si lo hubiera.

- ``isError()``: Si la respuesta es una respuesta de error o no.

- ``setId($name)``: Establecer el identificador de solicitud (de manera que la respuesta del cliente pueda
  coincidir con la solicitud original).

- ``getId()``: Recuperar el identificador de solicitud.

- ``setVersion($version)``: Establecer la versión JSON-RPC con la que deba estar conformada la respuesta.

- ``getVersion()``: Recuperar la versión JSON-RPC con la cumple la respuesta.

- ``toJson()``: Serializar la respuesta a JSON. Si la respuesta es una respuesta de error, serializar el objeto
  error.

- ``setServiceMap($serviceMap)``: Establecer el objeto mapa de servicio para la respuesta.

- ``getServiceMap()``: Recuperar el objeto mapa de servicio, si hubiera alguno.

Una versión específica de *HTTP* está disponible a través de ``Zend\Json\Server\Response\Http``. Esta clase
enviará las cabeceras *HTTP* apropiadas así como serializará la respuesta como *JSON*.

.. _zend.json.server.details.zendjsonservererror:

Zend\Json_Server\Error
^^^^^^^^^^^^^^^^^^^^^^

JSON-RPC tiene un formato especial para informar condiciones de error. Todos los errores necesitan proporcionar,
mínimamente, un mensaje de error y un código de error; opcionalmente, pueden proporcionar datos adicionales,
tales como un backtrace.

Los códigos de error derivan de los recomendados por `el proyecto XML-RPC EPI`_. ``Zend\Json\Server``
apropiadamente asigna el código sobre la base de la condición de error. Para las excepciones de la aplicación,
se utiliza el código '-32000'.

``Zend\Json_Server\Error`` expone los siguientes métodos:

- ``setCode($code)``: Establece el código de error; si el código de error no está en el rango de aceptación de
  XML-RPC, -32000 será asignado.

- ``getCode()``: Recuperar el actual código de error.

- ``setMessage($message)``: Establecer el mensaje de error.

- ``getMessage()``: Recuperar el mensaje de error actual.

- ``setData($data)``: Establecer el conjunto de datos auxiliares para calificar más adelante el error, tal como un
  backtrace.

- ``getData()``: Recuperar cualquier auxiliar actual de errores de datos.

- ``toArray()``: Mandar el error a un array. El array contendrá las claves 'code', 'message', y 'data'.

- ``toJson()``: Mandar el error a una representación de error JSON-RPC.

.. _zend.json.server.details.zendjsonserversmd:

Zend\Json_Server\Smd
^^^^^^^^^^^^^^^^^^^^

SMD quiere decir Service Mapping Description, un esquema JSON que define cómo un cliente puede interactuar con un
servicio web en particular. En el momento de escribir esto, la `especificación`_ todavía no ha sido ratificada
oficialmente, pero ya está en uso en Dojo toolkit así como en otros clientes consumidores de JSON-RPC.

En su aspecto más básico, un SMD indica el método de transporte (POST, GET, TCP/IP, etc), el tipo de envoltura
de la solicitud (generalmente se basa en el protocolo del servidor), el objetivo *URL* del proveedor del servicio,
y un mapa de los servicios disponibles. En el caso de JSON-RPC, el servicio de mapa es una lista de los métodos
disponibles, en el que cada método documenta los parámetros disponibles y sus tipos, así como los tipos de
valores esperados a devolver.

``Zend\Json_Server\Smd`` Proporciona un objeto orientado para construir servicios de mapas. Básicamente, pasa los
metadatos describiendo el servicio usando mutators, y especifica los servicios (métodos y funciones).

Las descripciones de los servicios son típicamente instancias de ``Zend\Json\Server\Smd\Service``; también puede
pasar toda la información como un array a los diversos mutators de servicios en ``Zend\Json_Server\Smd``, y que
instanciará on objeto de servicio por usted. Los objetos de servicio contienen información como el nombre del
servicio (típicamente, la función o el nombre del método), los parámetros (nombres, tipos y posición), y el
tipo del valor de retorno. Opcionalmente, cada servicio puede tener su propio objetivo y envoltura, aunque esta
funcionalidad rara vez es utilizada.

``Zend\Json\Server`` Realmente todo esto sucede entre bambalinas para usted, utilizando reflexión sobre las clases
y funciones agregadas; debe crear su propio servicio de mapas sólo si necesita brindar funcionalidad personalizada
que la introspección de clase y función no puede ofrecer.

Los métodos disponibles en ``Zend\Json_Server\Smd`` incluyen:

- ``setOptions(array $options)``: Establecer un objeto SMD desde un array de opciones. Todos los mutators (métodos
  comenzando con 'set') se pueden usar como claves.

- ``setTransport($transport)``: Establecer el transporte usado para acceder al servicio; únicamente POST es
  actualmente soportado.

- ``getTransport()``: Obtener el servicio de transporte actual.

- ``setEnvelope($envelopeType)``: Establecer la envoltura de la solicitud que debería ser utilizada para acceder
  al servicio. Actualmente las constantes soportadas son ``Zend\Json_Server\Smd::ENV_JSONRPC_1`` y
  ``Zend\Json_Server\Smd::ENV_JSONRPC_1``.

- ``getEnvelope()``: Obtener la envoltura de la petición actual.

- ``setContentType($type)``: Establecer el tipo de contenido que deben utilizar las solicitudes (por defecto, es
  'application/json»).

- ``getContentType()``: Conseguir el tipo del contenido actual para las solicitudes al servicio.

- ``setTarget($target)``: Establecer el punto final de la *URL* para el servicio.

- ``getTarget()``: Obtener el punto final de la *URL* para el servicio.

- ``setId($id)``: Normalmente, este es el punto final de la *URL* del servicio (igual que el objetivo).

- ``getId()``: Recuperar el ID del servicio (normalmente el punto final de la *URL* del servicio).

- ``setDescription($description)``: Establecer una descripción del servicio (típicamente información narrativa
  que describe el propósito del servicio).

- ``getDescription()``: Obtener la descripción del servicio.

- ``setDojoCompatible($flag)``: Establecer un flag que indique si el SMD es compatible o no con el toolkit de Dojo.
  Cuando sea verdadero, el *JSON* SMD será formateado para cumplir con el formato que espera el cliente de Dojo
  JSON-RPC.

- ``isDojoCompatible()``: Devuelve el valor del flag de compatibilidad de Dojo (``FALSE``, por defecto).

- ``addService($service)``: Añade un servicio al mapa. Puede ser un array de información a pasar al constructor
  de ``Zend\Json\Server\Smd\Service``, o una instancia de esa clase.

- ``addServices(array $services)``: Agrega múltiples servicios a la vez.

- ``setServices(array $services)``: Agrega múltiples servicios a la vez, sobreescribiendo cualquiera de los
  servicios previamente establecidos.

- ``getService($name)``: Ontiene el servicio por su nombre.

- ``getServices()``: Obtener todos los servicios agregados.

- ``removeService($name)``: Elimina un servicio del mapa.

- ``toArray()``: Mandar el mapa de servicio a un array.

- ``toDojoArray()``: Mandar el mapa de servicio a un array compatible con Dojo Toolkit.

- ``toJson()``: Mandar el mapa de servicio a una representación JSON.

``Zend\Json\Server\Smd\Service`` tiene los siguientes métodos:

- ``setOptions(array $options)``: Establecer el estado del objeto dede un array. Cualquier mutator (métodos
  comenzando con 'set') puede ser utilizado como una clave y establecerlo mediante este método.

- ``setName($name)``: Establecer el nombre del servicio (típicamente, la función o el nombre del método).

- ``getName()``: Recuperar el nombre del servicio.

- ``setTransport($transport)``: Establecer el servicio de transporte (actualmente, sólo transportes apoyados por
  ``Zend\Json_Server\Smd`` son permitidos).

- ``getTransport()``: Recuperar el transporte actual.

- ``setTarget($target)``: Establecer el punto final de la *URL* del servicio (típicamente, este será el mismo que
  el SMD en general, al cual el servicio está agregado).

- ``getTarget()``: Obtener el punto final de la *URL* del servicio.

- ``setEnvelope($envelopeType)``: Establecer la envoltura del servicio (actualmente, sólo se permiten las
  envolturas soportadas por ``Zend\Json_Server\Smd``.

- ``getEnvelope()``: Recuperar el tipo de envoltura del servicio.

- ``addParam($type, array $options = array(), $order = null)``: Añadir un parámetro para el servicio. Por
  defecto, sólo el tipo de parámetro es necesario. Sin embargo, también puede especificar el orden, así como
  opciones tales como:

  - **name**: el nombre del parámetro

  - **optional**: cuándo el parámetro es opcional o no

  - **default**: un valor por defecto para el parámetro

  - **description**: texto describiendo el parámetro

- ``addParams(array $params)``: Agregar varios parámetros a la vez; cada param debería ser un array asociativo
  conteniendo mínimamente la clave 'type' describiendo el tipo de parámetro y, opcionalmente la clave 'order';
  cualquiera de las otras claves serán pasados como ``$options`` a ``addOption()``.

- ``setParams(array $params)``: Establecer muchos parámetros a la vez, sobrescribiendo cualquiera de los
  parámetros existentes.

- ``getParams()``: Recuperar todos los parámetros actualmente establecidos.

- ``setReturn($type)``: Establecer el tipo del valor de retorno del servicio.

- ``getReturn()``: Obtener el tipo del valor de retorno del servicio.

- ``toArray()``: Mandar el servicio a un array.

- ``toJson()``: Mandar el servicio a una representación *JSON*.



.. _`JSON-RPC`: http://json-rpc.org/wiki/specification
.. _`versión 2`: http://groups.google.com/group/json-rpc/web/json-rpc-1-2-proposal
.. _`Service Mapping Description (SMD)`: http://groups.google.com/group/json-schema/web/service-mapping-description-proposal
.. _`SoapServer`: http://us.php.net/manual/en/function.soap-soapserver-construct.php
.. _`el proyecto XML-RPC EPI`: http://xmlrpc-epi.sourceforge.net/specs/rfc.fault_codes.php
.. _`especificación`: http://groups.google.com/group/json-schema/web/service-mapping-description-proposal
