.. EN-Revision: none
.. _zend.authentication.adapter.http:

Adaptador de Autenticación HTTP
===============================

.. _zend.authentication.adapter.http.introduction:

Introducción
------------

``Zend\Auth\Adapter\Http`` proporciona una implementación compatible con `RFC-2617`_, `Basic`_ y `Digest`_
Autenticación *HTTP*. La autenticación "Digest" es un método de autenticación *HTTP* que mejora la
autenticación básica proporcionando una manera de autenticar sin tener que transmitir la contraseña de manera
clara en un texto a través de la red.

**Características Principales:**

- Soporta tanto Autenticación "Digest" como Básica.

- Establece retos en todos los proyectos soportados, por lo que el cliente puede responder con cualquier proyecto
  que soporte.

- Soporta autenticación proxy.

- Incluye soporte para la autenticación contra archivos de texto y proporciona una interfaz para autenticar contra
  otras fuentes, tales como bases de datos.

Hay algunas características notables del *RFC-2617* no implementadas todavía:

- Seguimiento "nonce", que permitiría un gran apoyo, y un aumento de la protección de repetidos ataques.

- Autenticación con comprobación de integridad, o "auth-int".

- Cabecera de información de la autenticación *HTTP*.

.. _zend.authentication.adapter.design_overview:

Descripción del diseño
----------------------

Este adaptador consiste en dos sub-componentes, la propia clase autenticación *HTTP*, y el llamado "Resolvers". La
clase autenticación *HTTP* encapsula la lógica para llevar a cabo tanto la autenticación basica y la "Digest".
Utiliza un Resolver para buscar la identidad de un cliente en los datos almacenados (por defecto, archivos de
texto), y recuperar las credenciales de los datos almacenados. Las credenciales del "Resolved" se comparan con los
valores presentados por el cliente para determinar si la autenticación es satisfactoria.

.. _zend.authentication.adapter.configuration_options:

Opciones de Configuración
-------------------------

La clase ``Zend\Auth\Adapter\Http`` requiere un array configurado que pasará a su constructor. Hay varias opciones
de configuración disponibles, y algunas son obligatorias:

.. _zend.authentication.adapter.configuration_options.table:

.. table:: Opciones de Configuración

   +----------------+-------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Nombre de Opción|Obligatoria                                |Descripción                                                                                                                                                           |
   +================+===========================================+======================================================================================================================================================================+
   |accept_schemes  |Si                                         |Determina que tareas de autenticación acepta el adaptador del cliente. Debe ser una lista separada por espacios que contengo 'basic' y/o 'digest' .                   |
   +----------------+-------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |realm           |Si                                         |Establece el realm de autenticación; usernames debe ser único dentro de un determinado realm.                                                                         |
   +----------------+-------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |digest_domains  |Si, cuando accept_schemes contiene 'digest'|Lista de URI s separadas por espacios para las cuales la misma información de autenticación es válida. No es necesario que todas las URI s apunten al mismo servidor. |
   +----------------+-------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |nonce_timeout   |Si, cuando accept_schemes contiene 'digest'|Establece el número de segundos para los cuales el "nonce" es válido. Ver notas de abajo.                                                                             |
   +----------------+-------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |proxy_auth      |No                                         |Deshabilitado por defecto. Permite llevar a cabo la autenticación del Proxy, en lugar de la autenticación normal del servidor.                                        |
   +----------------+-------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. note::

   La implementación actual del ``nonce_timeout`` tiene algunos efectos colaterales interesantes. Este ajuste es
   supuesto para determinar la vida util válida para un determinado "nonce", o de manera efectiva el tiempo que
   una información de autenticación del cliente es aceptada. Actualmente, si se establece en 3600 (por ejemplo),
   hará que el adaptador indique al cliente las nuevas credenciales cada hora, a la hora en punto.

.. _zend.authentication.adapter.http.resolvers:

Resolvers
---------

El trabajo del "Resolver" es tener un username y un realm, y devolver algún valor de tipo credencial. La
autenticación básica espera recibir la versión codificada en Base64 de la contraseña del usuario. La
autenticación "Digest" espera recibir un hash del username del usuario, un realm, y su contraseña (separados por
coma). Actualmente, sólo se admite el algoritmo de hash *MD5*.

``Zend\Auth\Adapter\Http`` se basa en la implementación de objetos ``Zend\Auth\Adapter\Http\Resolver\Interface``.
Un archivo de texto de la clase "Resolve" se incluye con este adaptador, pero cualquier otro tipo de "resolver"
puede ser creado simplemente implementando la interfaz del "resolver".

.. _zend.authentication.adapter.http.resolvers.file:

Archivo Resolver
^^^^^^^^^^^^^^^^

El archivo "resolver" es una clase muy simple. Tiene una única propiedad que especifique un nombre de archivo, que
también puede ser pasado al constructor. Su método ``resolve()`` recorre el archivo de texto, buscando una linea
con el correspondiente username y realm. El formato del archivo de texto es similar a los archivos htpasswd de
Apache:

.. code-block:: text
   :linenos:

   <username>:<realm>:<credentials>\n

Cada linea consta de tres campos -username, realm, y credenciales - cada uno separados por dos puntos. El campo
credenciales es opaco al archivo "resolver"; simplemente devuelve el valor tal como és al llamador. Por lo tanto,
este formato de archivo sirve tanto de autenticación básica como "Digest". En la autenticación básica, el campo
credenciales debe ser escrito en texto claro. En la autenticación "Digest", debería ser en hash *MD5* descrito
anteriormente.

Hay dos formas igualmente fácil de crear un archivo de "resolver":

.. code-block:: php
   :linenos:

   $path     = 'files/passwd.txt';
   $resolver = new Zend\Auth\Adapter\Http\Resolver\File($path);

o

.. code-block:: php
   :linenos:

   $path     = 'files/passwd.txt';
   $resolver = new Zend\Auth\Adapter\Http\Resolver\File();
   $resolver->setFile($path);

Si la ruta está vacía o no se puede leer, se lanza una excepción.

.. _zend.authentication.adapter.http.basic_usage:

Uso Básico
----------

En primer lugar, establecemos un array con los valores de configuración obligatorios:

.. code-block:: php
   :linenos:

   $config = array(
       'accept_schemes' => 'basic digest',
       'realm'          => 'My Web Site',
       'digest_domains' => '/members_only /my_account',
       'nonce_timeout'  => 3600,
   );

Este array hará que el adaptador acepte la autenticación básica o "Digest", y requerirá un acceso autenticado a
todas las áreas del sitio en ``/members_only`` y ``/my_account``. El valor realm es normalmente mostrado por el
navegador en el cuadro de dialogo contraseña. El ``nonce_timeout``, por supuesto, se comporta como se ha descrito
anteriormente.

A continuación, creamos el objeto Zend\Auth\Adapter\Http:

.. code-block:: php
   :linenos:

   $adapter = new Zend\Auth\Adapter\Http($config);

Ya que estamos soportando tanto la autenticación básica como la "Digest", necesitamos dos objetos diferentes
resolver. Tenga en cuenta que esto podría ser facilmente dos clases diferentes:

.. code-block:: php
   :linenos:

   $basicResolver = new Zend\Auth\Adapter\Http\Resolver\File();
   $basicResolver->setFile('files/basicPasswd.txt');

   $digestResolver = new Zend\Auth\Adapter\Http\Resolver\File();
   $digestResolver->setFile('files/digestPasswd.txt');

   $adapter->setBasicResolver($basicResolver);
   $adapter->setDigestResolver($digestResolver);

Por último, realizamos la autenticación. El adaptador necesita una referencia a ambos objetos solicitud y
respuesta para hacer su trabajo:

.. code-block:: php
   :linenos:

   assert($request instanceof Zend\Controller\Request\Http);
   assert($response instanceof Zend\Controller\Response\Http);

   $adapter->setRequest($request);
   $adapter->setResponse($response);

   $result = $adapter->authenticate();
   if (!$result->isValid()) {
       // Bad userame/password, or canceled password prompt
   }



.. _`RFC-2617`: http://tools.ietf.org/html/rfc2617
.. _`Basic`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
.. _`Digest`: http://en.wikipedia.org/wiki/Digest_access_authentication
