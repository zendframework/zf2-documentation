.. EN-Revision: none
.. _zend.config.theory_of_operation:

Aspectos Teóricos
=================

Los datos de configuración se hacen accesibles al constructor ``Zend_Config`` a través de un array asociativo,
que puede ser multidimensional, para permitir organizar los datos desde lo general a lo específico. Las clases de
adaptador concretas permiten construir una tabla asociativa para el constructor de ``Zend_Config`` a partir de un
sistema de almacenamiento de datos de configuración. Algunos scripts de usuario pueden proveer esos arrays
directamente al constructor Zend_Config, sin usar una clase adaptador, lo cual puede ser apropiado en ciertas
ocasiones.

Cada valor del array de datos de configuración se convierte en una propiedad del objeto ``Zend_Config``. La clave
es usada como el nombre de la propiedad. Si un valor es un array por sí solo, entonces la propiedad de objeto
resultante es creada como un nuevo objeto ``Zend_Config``, cargado con los datos del array. Esto ocurre
recursivamente, de forma que una jerarquía de datos de configuración puede ser creada con cualquier número de
niveles.

``Zend_Config`` implementa las interfaces **Countable** e **Iterator** para facilitar el aceso sencillo a los datos
de configuración. Así, uno puede usar la función `count()`_ y constructores *PHP* como `foreach`_ sobre objetos
``Zend_Config``.

Por defecto, los datos de configuración permitidos a través de ``Zend_Config`` son de sólo lectura, y una
asignación (e.g., ``$config->database->host = 'example.com'``) provoca que se lance una excepción. Este
comportamiento por defecto puede ser sobrescrito a través del constructor, sin embargo, para permitir la
modificación de valores de datos. Además, cuando las modificaciones están permitidas, ``Zend_Config`` soporta el
borrado de elementos (unset) (i.e. ``unset($config->database->host);``). El método ``readOnly()`` puede ser usado
para determinar si las modificaciones a un objeto ``Zend_Config`` están permitidas y el método ``setReadOnly()``
puede ser usado para evitar cualquier modificación posterior a un objeto ``Zend_Config`` que fue creado con
permiso de modificaciones.

.. note::

   Es importante no confundir tales modificaciones en memoria con guardar los datos de configuración a un medio de
   almacenamiento específico. Las herramientas para crear y modificar datos de configuración para distintos
   medios de almacenamiento están fuera del alcance de ``Zend_Config``. Existen soluciones third-party de código
   abierto con el propósito de crear y modificar datos de configuración de distintos medios de almacenamiento.

Las clases del adaptador heredan de la clase ``Zend_Config`` debido a que utilizan su funcionalidad.

La familia de clases ``Zend_Config`` permite organizar en secciones los datos de configuración. Los objetos de
adaptador ``Zend_Config`` pueden ser cargados con una sola sección especificada, múltiples secciones
especificadas, o todas las secciones (si no se especifica ninguna).

Las clases del adaptador ``Zend_Config`` soportan un modelo de herencia única que permite que los datos de
configuración hereden de una sección de datos de configuración a otra. Esto es provisto con el fin de reducir o
eliminar la necesidad de duplicar datos de configuración por distintos motivos. Una sección heredada puede
también sobrescribir los valores que hereda de su sección padre. Al igual que la herencia de clases *PHP*, una
sección puede heredar de una sección padre, la cual puede heredar de una sección abuela, etc..., pero la
herencia múltiple (i.e., la sección C heredando directamente de las secciones padre A y B) no está permitida.

Si tiene dos objetos ``Zend_Config``, puede combinarlos en un único objeto usando la función ``merge()``. Por
ejemplo, dados ``$config`` y ``$localConfig``, puede fusionar datos de ``$localConfig`` a ``$config`` usando
``$config->merge($localConfig);``. Los ítemes en ``$localConfig`` sobrescribirán cualquier item con el mismo
nombre en ``$config``.

.. note::

   El objeto ``Zend_Config`` que está ejecutando el merge debe haber sido construido para permitir modificaciones,
   pasando ``TRUE`` como el segundo parámetro del constructor. El método ``setReadOnly()`` puede entonces ser
   usado para evitar cualquier modificación posterior después de que el merge se haya completado.



.. _`count()`: http://php.net/count
.. _`foreach`: http://php.net/foreach
