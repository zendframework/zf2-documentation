.. _zend.permissions.acl.introduction:

Introducción
============

``Zend\Permissions\Acl`` provee la implementación de un sistema simple y flexible de Listas de Control de Acceso (*ACL*, por
sus siglas en inglés) para la administración de privilegios. En general, una aplicación puede utilizar las *ACL*
para controlar el acceso a ciertos objetos protegidos, que son requeridos por otros objetos.

Para los propósitos de esta documentación:

- Un **recurso** es un objeto al cual el acceso esta controlado.

- Un **rol** es un objeto que puede solicitar acceso a un recurso.

En términos generales, **Los roles solicitan acceso a los recursos**. Por ejemplo, si una persona solicita acceso
a un automóvil, entonces la persona se convierte en el rol solicitante, y el automóvil en el recurso, puesto que
el acceso al automóvil puede no estar disponible a cualquiera.

A través de la especificación y uso de Listas de Control de Acceso (*ACL*), una aplicación puede controlar cómo
los objetos solicitantes (roles) han obtenido acceso a objetos protegidos (recursos).

.. _zend.permissions.acl.introduction.resources:

Acerca de los Recursos
----------------------

En ``Zend\Permissions\Acl``, crear un recurso es muy sencillo. ``Zend\Permissions\Acl`` proporciona el ``Zend\Permissions\Acl\Resource\ResourceInterface`` para
facilitar a los desarrolladores la creación de recursos. Una clase solo necesita implementar su interfaz, la cual
consiste en un método único, ``getResourceId()``, para que ``Zend\Permissions\Acl`` considere el objeto como un recurso.
Adicionalmente, ``Zend\Permissions\Acl\Resource`` es proporcionado por ``Zend\Permissions\Acl`` como un recurso básico de aplicación para
que los desarrolladores puedan extenderla hasta donde lo deseen.

``Zend\Permissions\Acl`` provee un estructura de árbol a la cual pueden ser agregados múltiples recursos (o "Áreas con
Controles de Acceso").Ya que los recursos son almacenados en esta estructura de árbol, estos pueden ser
organizados desde lo general (hacia la raíz del árbol) a lo específico (hacia las ramas del árbol). Consultas
sobre un recurso específico buscarán automáticamente, en la jerarquía del recurso, reglas asignadas a recursos
anteriores a los que el recurso actual haga referencia, permitiendo la herencia simple de reglas. Por ejemplo, si
una regla por defecto se aplica a cada edificio en una ciudad, uno simplemente podría asignar la regla a la
ciudad, en lugar de asignar la misma regla a cada edificio. Algunos edificios pueden necesitar excepciones a la
regla, sin embargo, y esto es fácil de hacer en ``Zend\Permissions\Acl`` asignando esta excepción a cada edificio que
necesite una excepción a la regla. Un recurso sólo puede heredar de un recurso padre, aunque este recurso padre
puede tener a la vez su propio recurso padre, y así; sucesivamente.

``Zend\Permissions\Acl`` también soporta privilegios sobre recursos (ejemplo. "crear","leer","actualizar", "borrar"), y el
desarrollador puede asignar reglas que afecten o a todos los privilegios o a privilegios específicos sobre un
recurso.

.. _zend.permissions.acl.introduction.roles:

Acerca de las Reglas
--------------------

Al igual que los recursos, la creación de un rol también es muy simple. ``Zend\Permissions\Acl`` proporciona
``Zend\Permissions\Acl\Role\RoleInterface`` para facilitar a los desarrolladores la creación de roles. Una clase solo necesita la
implementación de su interfaz, la cual consiste en un método único, ``getRoleId()``, para que ``Zend\Permissions\Acl``
considere que el objeto es un Rol. Adicionalmente, ``Zend\Permissions\Acl\Role`` está incluido con ``Zend\Permissions\Acl`` como una
implementación principal del rol para que los desarrolladores la extiendan hasta donde lo deseen.

En ``Zend\Permissions\Acl``, un Rol puede heredar de otro o más roles. Esto es para soportar herencia de reglas entre roles.
Por ejemplo, un Rol de usuario, como "sally", puede estar bajo uno o más roles padre, como "editor" y
"administrador". El desarrollador puede asignar reglas a "editor" y "administrador" por separado, y "sally" puede
heredar tales reglas de ambos, sin tener que asignar reglas directamente a "sally".

Dado que la habilidad de herencia desde múltiples roles es muy útil, múltiples herencias también introduce
cierto grado de complejidad. El siguiente ejemplo ilustra la condición de ambiguedad y como ``Zend\Permissions\Acl`` soluciona
esto.

.. _zend.permissions.acl.introduction.roles.example.multiple_inheritance:

.. rubric:: Herencia Múlltiple entre Roles

El siguiente código define tres roles principales - "invitado", "miembro", y "admin" - de los cuales otros roles
pueden heredar. Entonces, un rol identificado como "unUsuario" es colocado y hereda de los otros tres roles. El
orden en el cual estos roles aparecen en el array ``$parents`` es importante. Cuando es necesario, ``Zend\Permissions\Acl``
busca por reglas de acceso definidas no solo para el rol solicitado (aquí, "unUsuario"), sino también sobre los
roles heredados (aquí, "invitado", "miembro", y "admin"):

.. code-block:: php
   :linenos:

   $acl = new Zend\Permissions\Acl\Acl();

   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('invitado'))
       ->addRole(new Zend\Permissions\Acl\Role\GenericRole('miembro'))
       ->addRole(new Zend\Permissions\Acl\Role\GenericRole('admin'));

   $parents = array('invitado', 'miembro', 'admin');
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('unUsuario'), $parents);

   $acl->add(new Zend\Permissions\Acl\Resource\GenericResource('unRecurso'));

   $acl->deny('invitado', 'unRecurso');
   $acl->allow('miembro', 'unRecurso');

   echo $acl->isAllowed('unUsuario', 'unRecurso') ? 'permitido' : 'denegado';

Ya que no hay reglas específicamente definidas para el rol "unUsuario" y "unRecurso", ``Zend\Permissions\Acl`` debe buscar por
reglas que puedan estar definidas para roles "unUsuario" hereda. Primero, el rol "admin" es visitado, y no hay
regla de acceso definida para éste. Luego, el rol "miembro" es visitado, y ``Zend\Permissions\Acl`` encuentra que aquí hay
una regla especificando que "miembro" tiene permiso para acceder a "unRecurso".

Así, ``Zend\Permissions\Acl`` va a seguir examinando las reglas definidas para otros roles padre, sin embargo, encontraría
que "invitado" tiene el acceso denegado a "unRecurso". Este hecho introduce una ambigüedad debido a que ahora
"unUsuario" está tanto denegado como permitido para acceder a "unRecurso", por la razón de tener un conflicto de
reglas heredadas de diferentes roles padre.

``Zend\Permissions\Acl`` resuelve esta ambigüedad completando la consulta cuando encuentra la primera regla que es
directamente aplicable a la consulta. En este caso, dado que el rol "miembro" es examinado antes que el rol
"invitado", el código de ejemplo mostraría "permitido".

.. note::

   Cuando se especifican múltiples padres para un Rol, se debe tener en cuenta que el último padre listado es el
   primero en ser buscado por reglas aplicables para una solicitud de autorización.

.. _zend.permissions.acl.introduction.creating:

Creando las Listas de Control de Acceso (ACL)
---------------------------------------------

Una *ACL* puede representar cualquier grupo de objetos físicos o virtuales que desee. Para propósitos de
demostración, sin embargo, crearemos un *ACL* básico para un Sistema de Administración de Contenido (*CMS*) que
mantendrá varias escalas de grupos sobre una amplia variedad de áreas. Para crear un nuevo objeto *ACL*,
iniciamos la *ACL* sin parámetros:

.. code-block:: php
   :linenos:


   $acl = new Zend\Permissions\Acl\Acl();

.. note::

   Hasta que un desarrollador especifique una regla"permitido", ``Zend\Permissions\Acl`` deniega el acceso a cada privilegio
   sobre cada recurso para cada rol.

.. _zend.permissions.acl.introduction.role_registry:

Registrando Roles
-----------------

El Sistema de Administración de Contenido (*CMS*) casi siempre necesita una jerarquía de permisos para determinar
la capacidad de identificación de sus usuarios. Puede haber un grupo de 'Invitados' para permitir acceso limitado
para demostraciones, un grupo de 'Personal' para la mayoría de usuarios del *CMS* quienes realizan la mayor parte
de operaciones del día a día, un grupo 'Editores' para las responsabilidades de publicación, revisión, archivo
y eliminación de contenido, y finalmente un grupo 'Administradores' cuyas tareas pueden incluir todas las de los
otros grupos y también el mantenimiento de la información delicada, manejo de usuarios, configuración de los
datos básicos y su respaldo/exportación. Este grupo de permisos pueden ser representados en un registro de roles,
permitiendo a cada grupo heredar los privilegios de los grupos 'padre', al igual que proporcionando distintos
privilegios solo para su grupo individual. Los permisos pueden ser expresados como:

.. _zend.permissions.acl.introduction.role_registry.table.example_cms_access_controls:

.. table:: Controles de Acceso para un CMS de ejemplo

   +-------------+------------------------------+------------------+
   |Nombre       |Permisos Individuales         |Hereda permisos de|
   +=============+==============================+==================+
   |Invitado     |View                          |N/A               |
   +-------------+------------------------------+------------------+
   |Personal     |Editar, Enviar, Revisar       |Invitado          |
   +-------------+------------------------------+------------------+
   |Editor       |Publicar, Archivar, Eliminar  |Personal          |
   +-------------+------------------------------+------------------+
   |Administrador|(Todos los accesos permitidos)|N/A               |
   +-------------+------------------------------+------------------+

Para este ejemplo, se usa ``Zend\Permissions\Acl\Role``, pero cualquier objeto que implemente ``Zend\Permissions\Acl\Role\RoleInterface`` es
admisible. Estos grupos pueden ser agregados al registro de roles de la siguiente manera:

.. code-block:: php
   :linenos:


   $acl = new Zend\Permissions\Acl\Acl();

   // Agregar grupos al registro de roles usando Zend\Permissions\Acl\Role

   // Invitado no hereda controles de acceso
   $rolInvitado = new Zend\Permissions\Acl\Role\GenericRole('invitado');
   $acl->addRole($rolInvitado);

   // Personal hereda de Invitado
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('personal'), $rolInvitado);

   /* alternativamente, lo de arriba puede ser escrito así:
   $rolInvitado = $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('personal'), 'invitado');
   //*/

   // Editor hereda desde personal
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('editor'), 'personal');

   // Administrador no hereda controles de acceso
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('administrador'));

.. _zend.permissions.acl.introduction.defining:

Definiendo Controles de Acceso
------------------------------

Ahora que la *ACL* contiene los roles relevantes, se pueden establecer reglas que definan cómo los roles pueden
acceder a los recursos. Tenga en cuenta que no definiremos ningún recurso en particular para este ejemplo, el cual
está simplificado para ilustrar que las reglas se aplican a todos los recursos. ``Zend\Permissions\Acl`` proporciona una forma
práctica por la cual las reglas solo necesitan ser asignadas de lo general a lo especifico, minimizando el número
de reglas necesarias, porque los recursos y roles heredan reglas que están definidas en sus padres.

.. note::

   In general, ``Zend\Permissions\Acl`` obeys a given rule if and only if a more specific rule does not apply.

Consecuentemente, podemos definir un grupo razonablemente complejo de reglas con un mínimo de código. Para
aplicar estos permisos básicos como están definidos arriba:

.. code-block:: php
   :linenos:


   $acl = new Zend\Permissions\Acl\Acl();


   $rolInvitado = new Zend\Permissions\Acl\Role\GenericRole('invitado');
   $acl->addRole($rolInvitado);
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('personal'), $rolInvitado);
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('editor'), 'personal');
   $acl->addRole(new Zend\Permissions\Acl\Role\GenericRole('administrador'));

   // Invitado solo puede ver el contenido
   $acl->allow($rolInvitado, null, 'ver');

   /* Lo de arriba puede ser escrito de la siguiente forma alternativa:
   $acl->allow('invitado', null, 'ver');
   //*/

   // Personal hereda el privilegio de ver de invitado,
   // pero también necesita privilegios adicionales
   $acl->allow('personal', null, array('editar', 'enviar', 'revisar'));

   // Editor hereda los privilegios de ver, editar, enviar, y revisar de personal,
   // pero también necesita privilegios adicionales
   $acl->allow('editor', null, array('publicar', 'archivar', 'eliminar'));

   // Administrador no hereda nada, pero tiene todos los privilegios permitidos
   $acl->allow('administrador');

El valor ``NULL`` en las llamadas de ``allow()`` es usado para indicar que las reglas de permiso se aplican a todos
los recursos.

.. _zend.permissions.acl.introduction.querying:

Consultando la ACL
------------------

Ahora tenemos una *ACL* flexible que puede ser usada para determinar qué solicitantes tienen permisos para
realizar funciones a través de la aplicación web. Ejecutar consultas es la forma más simple de usar el método
``isAllowed()``:

.. code-block:: php
   :linenos:

   echo $acl->isAllowed('invitado', null, 'ver') ?
        "permitido" : "denegado"; // permitido

   echo $acl->isAllowed('personal', null, 'publicar') ?
        "permitido" : "denegado"; // denegado

   echo $acl->isAllowed('personal', null, 'revisar') ?
        "permitido" : "denegado"; // permitido

   echo $acl->isAllowed('editor', null, 'ver') ?
        "permitido" : "denegado";
   // permitido debido a la herencia de invitado

   echo $acl->isAllowed('editor', null, 'actualizar') ?
        "permitido" : "denegado";
   // denegado debido a que no hay regla de permiso para 'actualizar'

   echo $acl->isAllowed('administrador', null, 'ver') ?
        "permitido" : "denegado";
   // permitido porque administrador tiene permitidos todos los privilegios

   echo $acl->isAllowed('administrador') ?
        "permitido" : "denegado";
   // permitido porque administrador tiene permitidos todos los privilegios

   echo $acl->isAllowed('administrador', null, 'actualizar') ?
        "permitido" : "denegado";
   // permitido porque administrador tiene permitidos todos los privilegios


