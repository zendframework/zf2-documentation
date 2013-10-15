.. EN-Revision: none
.. _zend.authentication.introduction:

Introducción
============

``Zend_Auth`` provee una *API* para autenticación e incluye adaptadores concretos de autenticación para
escenarios de casos de uso común.

``Zend_Auth`` es concerniente sólo con **autenticación** y no con **autorización**. Autenticación es vagamente
definido como: determinar si una entidad realmente es lo que pretende ser (o sea, identificación), basandose en un
grupo de credenciales. Autorización, el proceso de decidir si se permite a una entidad: acceso a, o el realizar
operaciones en, otras entidades esta fuera del alcance de ``Zend_Auth``. Para más información sobre autorización
y control de acceso con Zend Framework, por favor vea :ref:`Zend\Permissions\Acl <zend.permissions.acl>`.

.. note::

   La clase ``Zend_Auth`` implementa el patrón Singleton - sólo una instancia de la clase está disponible - a
   través de su método estático ``getInstance()``. Esto significa que usar el operador **new** y la keyword
   **clone** no va a funcionar con la clase ``Zend_Auth``: use ``Zend\Auth\Auth::getInstance()`` en su lugar.

.. _zend.authentication.introduction.adapters:

Adaptadores
-----------

Un adaptador ``Zend_Auth`` es usado para autenticar en contra de un tipo particular de servicio de autenticación,
como *LDAP*, *RDBMS*, o almacenamiento basado en ficheros. Diferentes adaptadores pueden tener opciones y
comportamientos muy diferentes, pero algunas cosas básicas son comunes entre los adaptadores de autenticación. Por
ejemplo, aceptar credenciales de autenticación (incluyendo una identidad supuesta), realizar consultas ante el
servicio de autenticación, y regresar resultados, son comunes para los adaptadores ``Zend_Auth``.

Cada clase adaptadora ``Zend_Auth`` implementa ``Zend\Auth\Adapter\Interface``. Esta interface define un metodo,
``authenticate()``, que la clase adaptadora debe implementar para realizar una peticion de autenticación. Cada
clase adaptadora debe ser preparada antes de llamar a ``authenticate()``. Esta preparación del adaptador incluye
la creación de credenciales (p.ej. nombre de usuario y contraseña) y la definición de valores para opciones de
configuración especificos del adaptador, como valores de coneccion a base de datos para un adaptador de tabla de
base de datos.

El siguente ejemplo es un adaptador de autenticación que requiere que un nombre de usuario y contraseña sean
especificados para la autenticación. Otros detalles, como la forma de realizar peticiones al servicio de
autenticación, han sido omitídos por brevedad:

.. code-block:: php
   :linenos:

   class MyAuthAdapter implements Zend\Auth\Adapter\Interface
   {
       /**
        * Establece nombre de usuario y contraseña para autenticación
        *
        * @return void
        */
       public function __construct($username, $password)
       {
           // ...
       }

       /**
        * Realiza un intento de autenticación
        *
        * @throws Zend\Auth\Adapter\Exception Si la autenticación no puede
        *                                     ser realizada
        * @return Zend\Auth\Result
        */
       public function authenticate()
       {
           // ...
       }
   }

Como se ha indicado en su docblock, ``authenticate()`` debe regresar una instancia de ``Zend\Auth\Result`` (o de
una clase derivada de ``Zend\Auth\Result``). Si por alguna razón es imposible realizar una petición de
autenticación, ``authenticate()`` debería arrojar una excepción que se derive de
``Zend\Auth\Adapter\Exception``.

.. _zend.authentication.introduction.results:

Resultados
----------

Los adaptadores ``Zend_Auth`` regresan una instancia de ``Zend\Auth\Result`` con ``authenticate()`` para
representar el resultado de un intento de autenticación. Los adaptadores llenan el objeto ``Zend\Auth\Result`` en
cuanto se construye, así que los siguientes cuatro métodos proveen un grupo básico de operaciones "frente al
usuario" que son comunes a los resultados de adaptadores Zend\Auth\Auth:

- ``isValid()``- regresa true si y solo si el resultado representa un intento de autenticación exitoso

- ``getCode()``- regresa una constante identificadora ``Zend\Auth\Result`` para determinar el tipo de fallo en la
  autenticación o si ha sido exitosa. Este puede ser usado en situaciones cuando el desarrollador desea distinguir
  entre varios tipos de resultados de autenticación. Esto permite a los desarrolladores, por ejemplo, mantener
  estadísticas detalladas de los resultados de autenticación. Otro uso de esta característica es: proporcionar
  al usuario mensajes específicos detallados por razones de usabilidad, aunque los desarrolladores son exhortados
  a considerar el riesgo de proporcionar tales detalles a los usuarios, en vez de un mensaje general de fallo en la
  autenticación. Para más información, vea las siguientes notas:

- ``getIdentity()``- regresa la identidad del intento de autenticación

- ``getMessages()``- regresa un arreglo de mensajes pertinentes a un fallido intento de autenticación

El desarrollador podría desear ramificar basado en el tipo de resultado de la autenticación a fin de realizar
operaciones mas específicas. Algunas operaciones que los desarrolladores podrían encontrar útiles son: bloquear
cuentas despues de varios intentos fallidos de ingresar una contraseña, marcar una dirección IP despues de que ha
intentado muchas identidades no existentes, y proporcionar al usuario mensajes especificos resultados de la
autenticación. Los siguientes codigos de resultado están disponibles:

.. code-block:: php
   :linenos:

   Zend\Auth\Result::SUCCESS
   Zend\Auth\Result::FAILURE
   Zend\Auth\Result::FAILURE_IDENTITY_NOT_FOUND
   Zend\Auth\Result::FAILURE_IDENTITY_AMBIGUOUS
   Zend\Auth\Result::FAILURE_CREDENTIAL_INVALID
   Zend\Auth\Result::FAILURE_UNCATEGORIZED

El siguiente ejemplo ilustra como un desarrollador podría ramificar basado en el código resultado:

.. code-block:: php
   :linenos:

   // debtri de AuthController / loginAction
   $result = $this->_auth->authenticate($adapter);

   switch ($result->getCode()) {

       case Zend\Auth\Result::FAILURE_IDENTITY_NOT_FOUND:
           /** realiza algo para identidad inexistente **/
           break;

       case Zend\Auth\Result::FAILURE_CREDENTIAL_INVALID:
           /** realiza algo para credencial invalida **/
           break;

       case Zend\Auth\Result::SUCCESS:
           /** realiza algo para autenticación exitosa **/
           break;

       default:
           /** realiza algo para otras fallas **/
           break;
   }

.. _zend.authentication.introduction.persistence:

Persistencia de Identidad
-------------------------

Autenticar una petición que incluye credenciales de autenticación es util por sí mismo, pero también es
importante el soportar mantener la identidad autenticada sin tener que presentar las credenciales de autenticación
con cada petición.

*HTTP* es un protocolo sin estado, sin embargo, se han desarrollado técnicas como las cookies y sesiones a fin de
facilitar mantener el estado a través de multiples peticiones en aplicaciones web del lado del servidor.

.. _zend.authentication.introduction.persistence.default:

Persistencia por Defecto en la Sesión PHP
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Por defecto, ``Zend_Auth`` provee almacenamiento persistente de la identidad desde un intento de autenticación
exitoso usando la sesión *PHP*. En un intento de autenticación exitoso, ``end_Auth::authenticate()`` almacena la
identidad del resultado de autenticación en almacenamiento persistente. A menos que se configure diferente,
``Zend_Auth`` usa una clase de almacenamiento llamada ``Zend\Auth\Storage\Session``, la cual, a su vez usa
:ref:`Zend_Session <zend.session>`. Una clase diferente podría ser utilizada mediante proveer un objeto que
implemente ``Zend\Auth\Storage\Interface`` a ``Zend\Auth\Auth::setStorage()``

.. note::

   Si el automático almacenamiento persistente de la identidad no es apropiado para un caso en particular,
   entonces los desarrolladores podrían dejar de usar la clase ``Zend_Auth`` al mismo tiempo, utilizando en su
   lugar una clase adaptadora directamente.

.. _zend.authentication.introduction.persistence.default.example:

.. rubric:: Modifying the Session Namespace

``Zend\Auth\Storage\Session`` usa un espacionombre (namespace) de sesión 'Zend_Auth'. Este espacio-nombre podría
ser OVERRIDDEN al pasar un valor diferente al contructor de ``Zend\Auth\Storage\Session``, y este valor es pasado
internamente al constructor de ``Zend\Session\Namespace``. Esto debería ocurrir antes de que se intente la
autenticación, ya que ``Zend\Auth\Auth::authenticate()`` realiza el almacenamiento automático de la identidad.

.. code-block:: php
   :linenos:

   // Almacena una referencia a la instancia Singleton de Zend_Auth
   $auth = Zend\Auth\Auth::getInstance();

   // Usa 'unEspacionombre' en lugar de 'Zend_Auth'
   $auth->setStorage(new Zend\Auth\Storage\Session('unEspacionombre'));

   /**
    * @todo Set up the auth adapter, $authAdapter
    */

   // Autenticar, almacenando el resultado, y persistiendo la identidad en
   // suceso
   $result = $auth->authenticate($authAdapter);

.. _zend.authentication.introduction.persistence.custom:

Implementando Almacenamiento Personalizado
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

En ocaciones los desarrolladores podrían necesitar usar un diferente comportamiento de persistencia de identidad
que el provisto por ``Zend\Auth\Storage\Session``. Para esos casos los desarrolladores podrían simplemente
implementar ``Zend\Auth\Storage\Interface`` y suplir una instancia de la clase a ``Zend\Auth\Auth::setStorage()``.

.. _zend.authentication.introduction.persistence.custom.example:

.. rubric:: Usando una Clase de Almacenamiento Personalizada

Para poder utilizar una clase de almacenamiento persistente de identidad diferente a ``Zend\Auth\Storage\Session``,
el desarrollador implementa ``Zend\Auth\Storage\Interface``:

.. code-block:: php
   :linenos:

   class MyStorage implements Zend\Auth\Storage\Interface
   {
       /**
        * Regresa true si y solo si el almacenamiento esta vacio
        *
        * @arroja Zend\Auth\Storage\Exception Si es imposible
        *                                     determinar si el almacenamiento
        *                                     esta vacio
        * @regresa boleano
        */
       public function isEmpty()
       {
           /**
            * @por hacer implementación
            */
       }

       /**
        * Regresa el contenido del almacenamiento
        *
        * El comportamiento es indefinido cuando el almacenamiento esta vacio
        *
        * @arroja Zend\Auth\Storage\Exception Si leer contenido de
        *                                     almacenamiento es imposible
        * @regresa mixto
        */
       public function read()
       {
           /**
            * @por hacer implementación
            */
       }

       /**
        * Escribe $contents al almacenamiento
        *
        * @parametros mezclado $contents
        * @arroja Zend\Auth\Storage\Exception Si escribir $contents al
        *                                     almacenamiento es imposible
        * @regresa boleano
        */
       public function write($contents)
       {
           /**
            * @por hacer implementación
            */
       }

       /**
        * limpia contenidos del almacenamiento
        *
        * @arroja Zend\Auth\Storage\Exception Si limpiar contenidos del
        *                                     almacenamiento es imposible
        * @regresa void
        */
       public function clear()
       {
           /**
            * @por hacer implementación
            */
       }
   }

A fin de poder usar esta clase de almacenamiento personalizada, ``Zend\Auth\Auth::setStorage()`` es invocada antes de
intentar una petición de autenticación:

.. code-block:: php
   :linenos:

   // Instruye Zend_Auth para usar la clase de almacenamiento personalizada
   Zend\Auth\Auth::getInstance()->setStorage(new MyStorage());

   /**
    * @por hacer Configurar el adaptador de autenticación, $authAdapter
    */

   // Autenticar, almacenando el resultado, y persistiendo la identidad
   // si hay exito
   $result = Zend\Auth\Auth::getInstance()->authenticate($authAdapter);

.. _zend.authentication.introduction.using:

Uso
---

Hay dos formas provistas de usar adaptadores ``Zend_Auth``:

. indirectamente, a través de ``Zend\Auth\Auth::authenticate()``

. directamente, a través del metodo ``authenticate()`` del adaptador

El siguiente ejemplo ilustra como usar el adaptador ``:Zend_Auth``: indirectamente, a través del uso de la clase
``Zend_Auth``:

.. code-block:: php
   :linenos:

   // Recibe una referencia a la instancia singleton de Zend_Auth
   $auth = Zend\Auth\Auth::getInstance();

   // Configura el adaptador de autenticación
   $authAdapter = new MyAuthAdapter($username, $password);

   // Intenta la autenticación, almacenando el resultado
   $result = $auth->authenticate($authAdapter);

   if (!$result->isValid()) {
       // Autenticación fallida: imprime el por que
       foreach ($result->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // Autenticación exitosa, la identidad ($username) es almacenada
       // en la sesión
       // $result->getIdentity() === $auth->getIdentity()
       // $result->getIdentity() === $username
   }

Una vez que la autenticación ha sido intentada en una petición, como en el ejemplo anterior, es fácil verificar
si existe una identidad autenticada exitosamente:

.. code-block:: php
   :linenos:

   $auth = Zend\Auth\Auth::getInstance();
   if ($auth->hasIdentity()) {
       // Existe la identidad; obtenla
       $identity = $auth->getIdentity();
   }

Para remover una identidad del almacenamiento persistente, simplemente usa el metodo ``clearIdentity()`` method.
Comunmente esto sería usado para implementar una operación "cerrar sesión" en la aplicación:

.. code-block:: php
   :linenos:

   Zend\Auth\Auth::getInstance()->clearIdentity();

Cuando el uso automático de almacenamiento persistente es inapropiado para un caso en particular, el desarrollador
podría simplemente omitir el uso de la clase ``Zend_Auth``, usando una clase adaptadora directamente. El uso
directo de una clase adaptadora implica configurar y preparar un objeto adaptador y despues llamar a su metodo
``authenticate()``. Los detalles específicos del adaptador son discutidos en la documentación de cada adaptador.
El siguiente ejemplo utiliza directamente ``MyAuthAdapter``:

.. code-block:: php
   :linenos:

   // Configura el adaptador de autenticación
   $authAdapter = new MyAuthAdapter($username, $password);

   // Intenta la autenticación, almacenando el resultado
   $result = $authAdapter->authenticate();

   if (!$result->isValid()) {
       // Autenticación fallida, imprime el porque
       foreach ($result->getMessages() as $message) {
           echo "$message\n";
       }
   } else {
       // Autenticación exitosa
       // $result->getIdentity() === $username
   }


