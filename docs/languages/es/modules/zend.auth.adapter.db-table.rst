.. _zend.auth.adapter.dbtable:

Tabla de base de datos de autenticación
=======================================

.. _zend.auth.adapter.dbtable.introduction:

Introducción
------------

``Zend_Auth_Adapter_DbTable`` proporciona la capacidad de autenticar contra credenciales almacenadas en una tabla
de la base de datos. Como ``Zend_Auth_Adapter_DbTable`` requiere una instancia de ``Zend_Db_Adapter_Abstract`` que
será pasada a su constructor, cada instancia está vinculada a una conexión concreta de la base de datos. Se
pueden establecer otras opciones de configuración a través del constructor y de métodos de instancia:

Las opciones de configuración disponibles incluyen:

- **tableName**: Nombre de tabla de la base de datos que contiene las credenciales de autenticación, y contra la
  cual se realiza la búsqueda de autenticación en la base de datos.

- **identityColumn**: Nombre de la columna de la tabla de la base de datos utilizada para representar la identidad.
  La columna identidad debe contar con valores únicos, tales como un apellido ó una dirección de e-mail.

- **credentialColumn**: Nombre de la columna de la tabla de la base de datos utilizada para representar la
  credencial. Conforme a un sistema de identidad simple y autenticación de contraseña, el valor de la credencial
  corresponde con la contraseña. Véase también la opción ``credentialTreatment``.

- **credentialTreatment**: En muchos casos, contraseñas y otros datos son encriptados, mezclados, codificados,
  ocultados, desplazados o tratados de otra manera a través de alguna función o algoritmo. Al especificar una
  cadena de tratamiento parametrizada con este método, tal como ``'MD5(?)'`` o ``'PASSWORD(?)'``, un desarrollador
  podría aplicar sentencias arbitrarias *SQL* sobre los datos credenciales de entrada. Ya que estas funciones son
  específicas de los *RDBMS*, debemos consultar el manual de la base de datos para comprobar la disponibilidad de
  tales funciones para su sistema de base de datos.

.. _zend.auth.adapter.dbtable.introduction.example.basic_usage:

.. rubric:: Uso Básico

Como se explicó en la introducción, el constructor ``Zend_Auth_Adapter_DbTable`` requiere una instancia de
``Zend_Db_Adapter_Abstract`` que sirve como conexión a la base de datos a la cual la instancia de autenticación
está obligada a adaptarse. En primer lugar, la conexión de la base de datos debe ser creada.

El siguiente código crea un adaptador para una base de datos en memoria , un esquema simple de la tabla, e inserta
una fila contra la que se pueda realizar una consulta de autenticación posterior. Este ejemplo requiere que la
extensión *PDO* SQLite esté disponible.

.. code-block:: php
   :linenos:

   // Crear una conexión en memoria de la bade de datos SQLite
   $dbAdapter = new Zend_Db_Adapter_Pdo_Sqlite(array('dbname' =>
                                                     ':memory:'));

   // Construir mediante una consulta una simple tabla
   $sqlCreate = 'CREATE TABLE [users] ('
              . '[id] INTEGER  NOT NULL PRIMARY KEY, '
              . '[username] VARCHAR(50) UNIQUE NOT NULL, '
              . '[password] VARCHAR(32) NULL, '
              . '[real_name] VARCHAR(150) NULL)';

   // Crear las credenciales de autenticación de la tabla
   $dbAdapter->query($sqlCreate);

   // Construir una consulta para insertar una fila para que se pueda realizar la autenticación
   $sqlInsert = "INSERT INTO users (username, password, real_name) "
              . "VALUES ('my_username', 'my_password', 'My Real Name')";

   // Insertar los datos
   $dbAdapter->query($sqlInsert);

Con la conexión de la base de datos y los datos de la tabla disponibles, podemos crear un instancia de
``Zend_Auth_Adapter_DbTable``. Los valores de las opciones de configuración pueden ser pasados al constructor o
pasados como parámetros a los métodos setter después de ser instanciados.

.. code-block:: php
   :linenos:

   // Configurar la instancia con los parámetros del constructor...
   $authAdapter = new Zend_Auth_Adapter_DbTable(
       $dbAdapter,
       'users',
       'username',
       'password'
   );

   // ...o configurar la instancia con los métodos setter.
   $authAdapter = new Zend_Auth_Adapter_DbTable($dbAdapter);

   $authAdapter
       ->setTableName('users')
       ->setIdentityColumn('username')
       ->setCredentialColumn('password')
   ;

En este punto, el adaptador de la instancia de autenticación está listo para aceptar consultas de autenticación.
Con el fin de elaborar una consulta de autenticación, los valores de entrada de la credencial son pasados por el
adaptador ates de llamar al método ``authenticate()``:

.. code-block:: php
   :linenos:

   // Seleccionamos los valores de entrada de la credencial (e.g., de un formulario de acceso)
   $authAdapter
       ->setIdentity('my_username')
       ->setCredential('my_password')
   ;

   // Ejecutamos la consulta de autenticación, salvando los resultados

Además de la disponibilidad del método ``getIdentity()`` sobre el objeto resultante de la autenticación,
``Zend_Auth_Adapter_DbTable`` también ayuda a recuperar la fila de al tabla sobre la autenticación realizada.

.. code-block:: php
   :linenos:

   // Imprimir la identidad
   echo $result->getIdentity() . "\n\n";

   // Imprimir la fila resultado
   print_r($authAdapter->getResultRowObject());

   /* Salida:
   my_username

   Array
   (
       [id] => 1
       [username] => my_username
       [password] => my_password
       [real_name] => My Real Name
   )

Ya que la fila de la tabla contiene el valor de la credencial, es importante proteger los valores contra accesos no
deseados.

.. _zend.auth.adapter.dbtable.advanced.storing_result_row:

Advanced Usage: Manteniendo el resultado del Objeto DbTable
-----------------------------------------------------------

Por defecto, ``Zend_Auth_Adapter_DbTable`` devuelve la identidad proporcionada al objeto Auth en la autenticación
realizada. Otro de los casos de uso, donde los desarrolladores desean guardar para mantener el mecanismo de
almacenamiento de un objeto identidad ``Zend_Auth`` que contiene información útil, se resuelve usando el método
``getResultRowObject()`` para devolver un objeto **stdClass**. El siguiente fragmento de código muestra su uso:

.. code-block:: php
   :linenos:

   // Autenticar con Zend_Auth_Adapter_DbTable
   $result = $this->_auth->authenticate($adapter);

   if ($result->isValid()) {
       // Almacena la identidad como un objedo dónde solo username y
       // real_name han sido devueltos
       $storage = $this->_auth->getStorage();
       $storage->write($adapter->getResultRowObject(array(
           'username',
           'real_name',
       )));

       // Almacena la identidad como un objeto dónde la columna contraseña ha
       // sido omitida
       $storage->write($adapter->getResultRowObject(
           null,
           'password'
       ));

       /* ... */

   } else {

       /* ... */

   }

.. _zend.auth.adapter.dbtable.advanced.advanced_usage:

Ejemplo de Uso Avanzado
-----------------------

Si bien el objetivo primordial de ``Zend_Auth`` (y, por consiguiente, ``Zend_Auth_Adapter_DbTable``) es
principalmente la **autenticación** y no la **autorización**, hay unos pocos casos y problemas que se encuentran
al límite entre cuales encajan dentro del dominio. Dependiendo de cómo haya decidido explicar su problema, a
veces tiene sentido resolver lo que podría parecer un problema de autorización dentro de un adaptador de
autenticación.

Con esa excepción fuera de lo común, ``Zend_Auth_Adapter_DbTable`` ha construido mecanismos que pueden ser
aprovechados para realizar controles adicionales en la autenticación a la vez que se resuelven algunos problemas
comunes de los usuarios.

.. code-block:: php
   :linenos:

   // El valor del campo status de una cuenta no es igual a "compromised"
   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND status != "compromised"'
   );

   // El valor del campo active de una cuenta es igual a "TRUE"
   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND active = "TRUE"'

Otra idea puede ser la aplicación de un mecanismo de "salting". "Salting" es un término que se refiere a una
técnica que puede mejorar altamente la seguridad de su aplicación. Se basa en la idea de concatenar una cadena
aleatoria a cada contraseña para evitar un ataque de fuerza bruta sobre la base de datos usando los valores hash
de un diccionario pre-calculado.

Por lo tanto, tenemos que modificar nuestra tabla para almacenar nuestra cadena mezclada:

.. code-block:: php
   :linenos:

   $sqlAlter = "ALTER TABLE [users] "
             . "ADD COLUMN [password_salt] "
             . "AFTER [password]";

Aquí hay una forma sencilla de generar una cadena mezclada por cada usuario en el momento del registro:

.. code-block:: php
   :linenos:

   for ($i = 0; $i < 50; $i++) {
       $dynamicSalt .= chr(rand(33, 126));

Y ahora vamos a construir el adaptador:

.. code-block:: php
   :linenos:

   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       "MD5(CONCAT('"
       . Zend_Registry::get('staticSalt')
       . "', ?, password_salt))"
   );

.. note::

   Puede mejorar aún más la seguridad mediante el uso de un valor 'salt' estático fuertemente codificado en su
   aplicación. En el caso de que su base de datos se vea comprometida (por ejemplo, por un ataque de inyección
   *SQL*), su servidor web está intacto y sus datos son inutilizable para el atacante.

Otra alternativa es utilizar el método ``getDbSelect()`` de ``Zend_Auth_Adapter_DbTable`` después de que el
adaptador se ha construido. Este método devolverá la instancia del objeto ``Zend_Db_Select`` que se va a utilizar
para completar la rutina de authenticate(). Es importante señalar que este método siempre devuelve el mismo
objeto, independientemente de si ``authenticate()`` ha sido llamado o no. Este objeto **no tendrá** ninguna de las
credenciales de identidad o información de como estos valores son colocados dentro del objeto seleccionado en
``authenticate()``.

Un ejemplo de una situación en la que uno podría querer utilizar el método ``getDbSelect()`` sería comprobar el
estado de un usuario, en otras palabras, ver si la cuenta del usuario está habilitada.

.. code-block:: php
   :linenos:

   // Continuando con el ejemplo de arriba
   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?)'
   );

   // obtener el objeto select (por referencia)
   $select = $adapter->getDbSelect();
   $select->where('active = "TRUE"');

   // authenticate, esto asegura que users.active = TRUE
   $adapter->authenticate();


