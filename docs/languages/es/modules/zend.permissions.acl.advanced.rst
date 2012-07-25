.. _zend.permissions.acl.advanced:

Uso Avanzado
============

.. _zend.permissions.acl.advanced.storing:

Almacenamiento Permanente de los Datos ACL
------------------------------------------

``Zend\Permissions\Acl`` fue diseñado de tal manera que no requiere ninguna tecnología particular como bases de datos o un
servidor de cache para el almacenamiento de datos *ACL*. Al poseer una implementación completamente construida en
*PHP*, es posible construir herramientas de administración personalizadas sobre ``Zend\Permissions\Acl`` con relativa
facilidad y flexibilidad. En muchas situaciones se requiere alguna forma de mantenimiento interactivo de una *ACL*,
y ``Zend\Permissions\Acl`` provee métodos para configurar, y consultar, los controles de acceso de una aplicación.

El almacenamiento de los datos *ACL* es una tarea que se delega al desarrollador, puesto que la utilización
variará extensamente en distintas situaciones. Dado que ``Zend\Permissions\Acl`` es serializable, los objetos *ACL* pueden
serializarse con la función `serialize()`_ de *PHP*, y los resultados pueden ser almacenados donde sea que el
desarrollador lo desee, en un archivo, base de datos, o mecanismo de cache

.. _zend.permissions.acl.advanced.assertions:

Escribiendo reglas condicionales ACL con aserciones
---------------------------------------------------

A veces, una regla para permitir o negar una función de acceso a un recurso no debería ser absoluta sino que
depende de varios criterios. Por ejemplo, supóngase que debe permitirse cierto acceso, pero únicamente entre las
8:00am y 5:00pm. Otro ejemplo sería negar el acceso debido a una petición que proviene de una dirección IP que
se ha marcado como una fuente de abusos. ``Zend\Permissions\Acl``\ tiene soporte para la aplicación de normas basadas en
cualquier condición que el desarrollador necesite.

``Zend\Permissions\Acl`` provee soporte para reglas condicionales con ``Zend\Permissions\Acl\Assert\AssertInterface``. Con el fin de utilizar la
regla de aserción de la interfaz, un desarrollador escribe una clase que implemente el método ``assert()`` de la
interfaz:

.. code-block:: php
   :linenos:

   class CleanIPAssertion implements Zend\Permissions\Acl\Assert\AssertInterface
   {
       public function assert(Zend\Permissions\Acl $acl,
                              Zend\Permissions\Acl\Role\RoleInterface $role = null,
                              Zend\Permissions\Acl\Resource\ResourceInterface $resource = null,
                              $privilege = null)
       {
           return $this->_isCleanIP($_SERVER['REMOTE_ADDR']);
       }

       protected function _isCleanIP($ip)
       {
           // ...
       }
   }

Una vez la clase de aserción esta disponible, el desarrollador puede suministrar una instancia de la clase de
aserción cuando asigna reglas condicionales. Una regla que es creada con una aserción sólo se aplica cuando el
método de la aserción devuelve ``TRUE``.

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();
   $acl->allow(null, null, null, new CleanIPAssertion());

El código anterior crea una regla condicional que permite el acceso a todos los privilegios sobre todo, por todo
el mundo, excepto cuando la IP de quien hace la petición está en la "lista negra". Si una petición viene desde
una IP que no está considerada "limpia", entonces la regla no se aplica. Dado que la regla se aplica a todos los
roles, todos los recursos, y todos los privilegios, una IP "no limpia" daría lugar a una negación de acceso.
Éste es un caso especial, sin embargo, y debería ser entendido que en todos los otros casos (por ejemplo, cuando
un rol específico, recurso, o privilegio está especificado por la regla), una aserción fallida provoca que la
regla no se aplique, y otras reglas deberían ser usadas para determinar si el acceso está permitido o denegado.

El método ``assert()`` de un objeto aserción es pasado a la *ACL*, regla, recurso, y privilegio para el cual una
consulta de autorización (por ejemplo, ``isAllowed()``) se aplica, con el fin de proporcionar un contexto para que
la clase de aserción determine sus condiciones cuando fuera necesario.



.. _`serialize()`: http://php.net/serialize
