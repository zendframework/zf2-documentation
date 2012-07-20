.. _zend.db.profiler.profilers.firebug:

Perfilando con Firebug
======================

``Zend_Db_Profiler_Firebug`` envía información de perfilado a la `Consola`_ de `Firebug`_.

Todos los datos son enviados a través del componente ``Zend_Wildfire_Channel_HttpHeaders`` que usa cabeceras
*HTTP* para asegurar que el contenido de la página no sea alterado. Depurar peticiones *AJAX* que requieren
respuestas *JSON* y *XML* es perfectamente posible con este enfoque.

Requerimientos:

- Navegador web Firefox idealmente versión 3, pero la versión 2 tambien está soportada.

- Extensión Firebug para Firefox, la cual puede descargarse desde `https://addons. mozilla
  .org/en-US/firefox/addon/1843`_.

- Extensión FirePHP para Firefox, la cual puede descargarse desde
  `https://addons.mozilla.org/en-US/firefox/addon/6149`_.

.. _zend.db.profiler.profilers.firebug.example.with_front_controller:

.. rubric:: Perfilando DB con Zend_Controller_Front

.. code-block:: php
   :linenos:

   // En tu archivo bootstrap

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Anexar el perfilador a tu adaptador de base de datos
   $db->setProfiler($profiler)

   // Despachar el controlador frontal

   // Todas las consultas a la base de datos en tus archivos modelo, vista y controlador
   // ahora serán perfilados y enviados a Firebug

.. _zend.db.profiler.profilers.firebug.example.without_front_controller:

.. rubric:: Perfilar DB sin Zend_Controller_Front

.. code-block:: php
   :linenos:

   $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
   $profiler->setEnabled(true);

   // Anexar el perfilador a tu adaptador de base de datos
   $db->setProfiler($profiler)

   $request  = new Zend_Controller_Request_Http();
   $response = new Zend_Controller_Response_Http();
   $channel  = Zend_Wildfire_Channel_HttpHeaders::getInstance();
   $channel->setRequest($request);
   $channel->setResponse($response);

   // Iniciar un buffer de las salidas
   ob_start();

   // Ahora se pueden ejecutar las consultas a la Base de Datos para ser perfiladas

   // Enviar los datos de perfilado al navegador
   $channel->flush();
   $response->sendHeaders();



.. _`Consola`: http://getfirebug.com/logging.html
.. _`Firebug`: http://www.getfirebug.com/
.. _`https://addons. mozilla .org/en-US/firefox/addon/1843`: https://addons.mozilla.org/en-US/firefox/addon/1843
.. _`https://addons.mozilla.org/en-US/firefox/addon/6149`: https://addons.mozilla.org/en-US/firefox/addon/6149
