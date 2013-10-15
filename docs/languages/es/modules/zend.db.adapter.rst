.. EN-Revision: none
.. _zend.db.adapter:

Zend\Db\Adapter
===============

``Zend_Db`` y sus clases relacionadas proporcionan una interfaz simple de base de datos *SQL* para Zend Framework.
El ``Zend\Db\Adapter`` es la clase base que se utiliza para conectar su aplicación *PHP* A una base de datos
(*RDBMS*). Existen diferentes clases Adapters(Adaptador) para cada tipo de base de datos (*RDBMS*).

Las clases Adapters de ``Zend_Db`` crean un puente entre las extensiones de base de datos de *PHP* hacia una
interfaz común, para ayudarle a escribir aplicaciones *PHP* una sola vez y poder desplegar múltiples tipos de
base de datos (*RDBMS*) con muy poco esfuerzo.

La Interfaz de la clase adaptador (adapter) es similar a la interfaz de la extensión `PHP Data Objects`_.
``Zend_Db`` proporciona clases Adaptadoras para los drivers *PDO* de los siguientes tipos de *RDBMS*:

- IBM DB2 e Informix Dynamic Server (IDS), usando la extensión *PHP* `pdo_ibm`_

- MySQL, usando la extensión *PHP* `pdo_mysql`_

- Microsoft SQL Server, usando la extensión *PHP* `pdo_mssql`_

- Oracle, usando la extensión *PHP* `pdo_oci`_

- PostgreSQL, usando la extensión *PHP* `pdo_pgsql`_

- SQLite, usando la extensión *PHP* `pdo_sqlite`_

Ademas, ``Zend_Db`` proporciona clases Adaptadoras que utilizan las extensiones de base de datos de *PHP* de los
siguientes tipos:

- MySQL, usando la extensión *PHP* `mysqli`_

- Oracle, usando la extensión *PHP* `oci8`_

- IBM DB2, usando la extensión *PHP* `ibm_db2`_

- Firebird/Interbase, usando la extensión *PHP* `php_interbase`_

.. note::

   Cada Zend\Db\Adaptador utiliza una extensión *PHP*. Se debe de tener habilitada la respectiva extensión en su
   entorno *PHP* para utilizar un ``Zend\Db\Adapter``. Por ejemplo, si se utiliza una clase ``Zend\Db\Adapter``
   basada en *PDO*, tiene que habilitar tanto la extensión *PDO* como el driver *PDO* del tipo de base de datos
   que se utiliza.

.. _zend.db.adapter.connecting:

Conexión a una Base de Datos utilizando un Adaptador
----------------------------------------------------

Esta sección describe cómo crear una instancia de un Adaptador de base de datos. Esto corresponde a establecer
una conexión a un servidor de Base de Datos (*RDBMS*) desde su aplicación *PHP*.

.. _zend.db.adapter.connecting.constructor:

Usando un Constructor de Zend_Db Adapter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Se puede crear una instancia de un Adaptador utilizando su constructor. Un constructor de adaptador toma un
argumento, que es un conjunto de parámetros utilizados para declarar la conexión.

.. _zend.db.adapter.connecting.constructor.example:

.. rubric:: Usando el Constructor de un Adaptador

.. code-block:: php
   :linenos:

   $db = new Zend\Db\Adapter\Pdo\Mysql(array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

.. _zend.db.adapter.connecting.factory:

Usando el Zend_Db Factory
^^^^^^^^^^^^^^^^^^^^^^^^^

Como alternativa a la utilización directa del constructor de un adaptador, se puede crear una instancia del
adaptador que use el método estático ``Zend\Db\Db::factory()``. Este método carga dinámicamente el archivo de
clase Adaptador bajo demanda, usando :ref:`Zend\Loader\Loader::loadClass() <zend.loader.load.class>`.

El primer argumento es una cadena que nombra al nombre base de la clase Adaptador. Por ejemplo, la cadena
'``Pdo_Mysql``' corresponde a la clase ``Zend\Db\Adapter\Pdo\Mysql``. El segundo argumento es el mismo array de
parámetros que hubiera enviado al constructor del adaptador.

.. _zend.db.adapter.connecting.factory.example:

.. rubric:: Usando el Adaptador del método factory

.. code-block:: php
   :linenos:

   // No necesitamos la siguiente declaración, porque
   // el archivo Zend\Db\Adapter\Pdo\Mysql será cargado para nosotros por el método
   // factory de Zend_Db.

   // carga automaticamente la clase Zend\Db\Adapter\Pdo\Mysql
   // y crea una instancia de la misma
   $db = Zend\Db\Db::factory('Pdo_Mysql', array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

Si crea su propia clase que extiende a ``Zend\Db\Adapter\Abstract``, pero no nombra su clase con el prefijo de
paquete "``Zend\Db\Adapter``", se puede utilizar el método ``factory()`` para cargar su adaptador si se especifica
la parte principal de la clase del adaptador con la clave "adapterNamespace" en el conjunto de parámetros

.. _zend.db.adapter.connecting.factory.example2:

.. rubric:: Usando el método factory para una clase Adaptador personalizada

.. code-block:: php
   :linenos:

   // No tenemos que cargar el archivo de clase Adaptador
   // porque será cargado para nosotros por el método factory de Zend_Db.

   // Automáticamente carga la clase MyProject_Db_Adapter_Pdo_Mysql
   // y crea una instancia de ella.

   $db = Zend\Db\Db::factory('Pdo_Mysql', array(
       'host'             => '127.0.0.1',
       'username'         => 'webuser',
       'password'         => 'xxxxxxxx',
       'dbname'           => 'test',
       'adapterNamespace' => 'MyProject_Db_Adapter'
   ));

.. _zend.db.adapter.connecting.factory-config:

Uso de Zend_Config con Zend_Db Factory
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Opcionalmente, se puede especificar cualquier argumento del método ``factory()`` como un objeto de tipo
:ref:`Zend_Config <zend.config>`.

Si el primer argumento es un objeto de configuración, se espera que contenga una propiedad llamada ``adapter``,
conteniendo la cadena que da nombre al nombre base de la clase de adaptador. Opcionalmente, el objeto puede
contener una propiedad llamada ``params``, con subpropiedades correspondientes a nombres de parámetros del
adaptador. Esto es usado sólo si el segundo argumento del método ``factory()`` se ha omitido.

.. _zend.db.adapter.connecting.factory.example1:

.. rubric:: Uso del método factory del Adaptador con un objeto Zend_Config

En el siguiente ejemplo, un objeto ``Zend_Config`` es creado usando un array. También puedes cargar los datos de
un archivo externo, por ejemplo con :ref:`Zend\Config\Ini <zend.config.adapters.ini>` o :ref:`Zend\Config\Xml
<zend.config.adapters.xml>`.

.. code-block:: php
   :linenos:

   $config = new Zend\Config\Config(
       array(
           'database' => array(
               'adapter' => 'Mysqli',
               'params' => array(
                   'dbname' => 'test',
                   'username' => 'webuser',
                   'password' => 'secret',
               )
           )
       )
   );

   $db = Zend\Db\Db::factory($config->database);

El segundo argumento del método ``factory()`` puede ser un array asociativo con entradas correspondientes a los
parámetros del adaptador. Este argumento es opcional. Si el primer argumento es de tipo ``Zend_Config``, se asume
que tiene todos los parametros, y el segundo argumento es ignorado.

.. _zend.db.adapter.connecting.parameters:

Parámetros del Adaptador
^^^^^^^^^^^^^^^^^^^^^^^^

El siguiente listado explica parámetros comunes reconocidos por Adaptador de clases ``Zend_Db``.

- **host**: una string conteniendo un nombre de host o dirección IP del servidor de base de datos. Si la base de
  datos está corriendo sobre el mismo host que la aplicación *PHP*, usted puede utilizar 'localhost' o
  '127.0.0.1'.

- **username**: identificador de cuenta para autenticar una conexión al servidor *RDBMS*.

- **password**: la contraseña de la cuenta para la autenticación de credenciales de conexión con el servidor
  *RDBMS*

- **dbname**: nombre de la base de datos en el servidor *RDBMS*.

- **port**: algunos servidores *RDBMS* pueden aceptar conexiones de red sobre un número de puerto específico. El
  parámetro del puerto le permite especificar el puerto al que su aplicación *PHP* se conecta, para que concuerde
  el puerto configurado en el servidor *RDBMS*.

- **charset**: specify the charset used for the connection.

- **options**: : este parámetro es un array asociativo de opciones que son genéricas a todas las clases
  ``Zend\Db\Adapter``.

- **driver_options**: este parámetro es un array asociativo de opciones adicionales para una extensión de base de
  datos dada. un uso típico de este parámetro es establecer atributos de un driver *PDO*.

- **adapterNamespace**: nombre de la parte inicial del nombre de las clase para el adaptador, en lugar de
  '``Zend\Db\Adapter``'. Utilice esto si usted necesita usar el método ``factory()`` para cargar un adaptador de
  clase de base de datos que no sea de Zend.

.. _zend.db.adapter.connecting.parameters.example1:

.. rubric:: Passing the case-folding option to the factory

Usted puede pasar esta opción específica por la constante ``Zend\Db\Db::CASE_FOLDING``. Este corresponde al atributo
``ATTR_CASE`` en los drivers de base de datos *PDO* e IBM DB2, ajustando la sensibilidad de las claves tipo cadena
en los resultados de consultas. La opción toma los valores ``Zend\Db\Db::CASE_NATURAL`` (el predeterminado),
``Zend\Db\Db::CASE_UPPER``, y ``Zend\Db\Db::CASE_LOWER``.

.. code-block:: php
   :linenos:

   $options = array(
       Zend\Db\Db::CASE_FOLDING => Zend\Db\Db::CASE_UPPER
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend\Db\Db::factory('Db2', $params);

.. _zend.db.adapter.connecting.parameters.example2:

.. rubric:: Passing the auto-quoting option to the factory

Usted puede especificar esta opción por la constante ``Zend\Db\Db::AUTO_QUOTE_IDENTIFIERS``. Si el valor es ``TRUE``
(el predeterminado), los identificadores como nombres de tabla, nombres de columna, e incluso los alias son
delimitados en la sintaxis *SQL* generada por el Adatador del objeto. Esto hace que sea sencillo utilizar
identificadores que contengan palabras reservadas de *SQL*, o caracteres especiales. Si el valor es ``FALSE``, los
identificadores no son delimitados automáticamente. Si usted necesita delimitar identificadores, debe hacer usted
mismo utilizando el método ``quoteIdentifier()``.

.. code-block:: php
   :linenos:

   $options = array(
       Zend\Db\Db::AUTO_QUOTE_IDENTIFIERS => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend\Db\Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.parameters.example3:

.. rubric:: Passing PDO driver options to the factory

.. code-block:: php
   :linenos:

   $pdoParams = array(
       PDO::MYSQL_ATTR_USE_BUFFERED_QUERY => true
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'driver_options' => $pdoParams
   );

   $db = Zend\Db\Db::factory('Pdo_Mysql', $params);

   echo $db->getConnection()
           ->getAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY);

.. _zend.db.adapter.connecting.parameters.example4:

.. rubric:: Passing Serialization Options to the Factory

.. code-block:: php
   :linenos:

   $options = array(
       Zend\Db\Db::ALLOW_SERIALIZATION => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend\Db\Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.getconnection:

Managing Lazy Connections
^^^^^^^^^^^^^^^^^^^^^^^^^

Creating an instance of an Adapter class does not immediately connect to the *RDBMS* server. The Adapter saves the
connection parameters, and makes the actual connection on demand, the first time you need to execute a query. This
ensures that creating an Adapter object is quick and inexpensive. You can create an instance of an Adapter even if
you are not certain that you need to run any database queries during the current request your application is
serving.

If you need to force the Adapter to connect to the *RDBMS*, use the ``getConnection()`` method. This method returns
an object for the connection as represented by the respective *PHP* database extension. For example, if you use any
of the Adapter classes for *PDO* drivers, then ``getConnection()`` returns the *PDO* object, after initiating it as
a live connection to the specific database.

It can be useful to force the connection if you want to catch any exceptions it throws as a result of invalid
account credentials, or other failure to connect to the *RDBMS* server. These exceptions are not thrown until the
connection is made, so it can help simplify your application code if you handle the exceptions in one place,
instead of at the time of the first query against the database.

Additionally, an adapter can get serialized to store it, for example, in a session variable. This can be very
useful not only for the adapter itself, but for other objects that aggregate it, like a ``Zend\Db\Select`` object.
By default, adapters are allowed to be serialized, if you don't want it, you should consider passing the
``Zend\Db\Db::ALLOW_SERIALIZATION`` option with ``FALSE``, see the example above. To respect lazy connections
principle, the adapter won't reconnect itself after being unserialized. You must then call ``getConnection()``
yourself. You can make the adapter auto-reconnect by passing the ``Zend\Db\Db::AUTO_RECONNECT_ON_UNSERIALIZE`` with
``TRUE`` as an adapter option.

.. _zend.db.adapter.connecting.getconnection.example:

.. rubric:: Handling connection exceptions

.. code-block:: php
   :linenos:

   try {
       $db = Zend\Db\Db::factory('Pdo_Mysql', $parameters);
       $db->getConnection();
   } catch (Zend\Db\Adapter\Exception $e) {
       // perhaps a failed login credential, or perhaps the RDBMS is not running
   } catch (Zend_Exception $e) {
       // perhaps factory() failed to load the specified Adapter class
   }

.. _zend.db.adapter.example-database:

La base de datos de ejemplo
---------------------------

En la documentación de las clases ``Zend_Db``, usamos un conjunto sencillo de tablas para ilustrar el uso de las
clases y métodos. Estas tablas de ejemplo permiten almacenar información para localizar bugs en un proyecto de
desarrollo de software. La base de datos contiene cuatro tablas:

- **accounts** almacena información sobre cada usuario que hace el seguimiento de bugs.

- **products** almacena información sobre cada producto para el que pueden registrarse bugs.

- **bugs** almacena información sobre bugs, incluyendo el estado actual del bug, la persona que informó sobre el
  bug, la persona que está asignada para corregir el bug, y la persona que está asignada para verificar la
  corrección.

- **bugs_products** stores a relationship between bugs and products. This implements a many-to-many relationship,
  because a given bug may be relevant to multiple products, and of course a given product can have multiple bugs.

La siguiente definición de datos *SQL* en lenguaje pseudocódigo describe las tablas de esta base de datos de
ejemplo. Estas tablas de ejemplo son usadas ampliamente por los tests unitarios automatizados de ``Zend_Db``.

.. code-block:: sql
   :linenos:

   CREATE TABLE accounts (
     account_name      VARCHAR(100) NOT NULL PRIMARY KEY
   );

   CREATE TABLE products (
     product_id        INTEGER NOT NULL PRIMARY KEY,
     product_name      VARCHAR(100)
   );

   CREATE TABLE bugs (
     bug_id            INTEGER NOT NULL PRIMARY KEY,
     bug_description   VARCHAR(100),
     bug_status        VARCHAR(20),
     reported_by       VARCHAR(100) REFERENCES accounts(account_name),
     assigned_to       VARCHAR(100) REFERENCES accounts(account_name),
     verified_by       VARCHAR(100) REFERENCES accounts(account_name)
   );

   CREATE TABLE bugs_products (
     bug_id            INTEGER NOT NULL REFERENCES bugs,
     product_id        INTEGER NOT NULL REFERENCES products,
     PRIMARY KEY       (bug_id, product_id)
   );

Also notice that the *bugs* table contains multiple foreign key references to the *accounts* table. Each of these
foreign keys may reference a different row in the *accounts* table for a given bug.

The diagram below illustrates the physical data model of the example database.

.. image:: ../images/zend.db.adapter.example-database.png
   :width: 387
   :align: center

.. _zend.db.adapter.select:

Reading Query Results
---------------------

This section describes methods of the Adapter class with which you can run SELECT queries and retrieve the query
results.

.. _zend.db.adapter.select.fetchall:

Fetching a Complete Result Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can run a *SQL* SELECT query and retrieve its results in one step using the ``fetchAll()`` method.

The first argument to this method is a string containing a SELECT statement. Alternatively, the first argument can
be an object of class :ref:`Zend\Db\Select <zend.db.select>`. The Adapter automatically converts this object to a
string representation of the SELECT statement.

The second argument to ``fetchAll()`` is an array of values to substitute for parameter placeholders in the *SQL*
statement.

.. _zend.db.adapter.select.fetchall.example:

.. rubric:: Using fetchAll()

.. code-block:: php
   :linenos:

   $sql = 'SELECT * FROM bugs WHERE bug_id = ?';

   $result = $db->fetchAll($sql, 2);

.. _zend.db.adapter.select.fetch-mode:

Changing the Fetch Mode
^^^^^^^^^^^^^^^^^^^^^^^

By default, ``fetchAll()`` returns an array of rows, each of which is an associative array. The keys of the
associative array are the columns or column aliases named in the select query.

You can specify a different style of fetching results using the ``setFetchMode()`` method. The modes supported are
identified by constants:

- ``Zend\Db\Db::FETCH_ASSOC``: return data in an array of associative arrays. The array keys are column names, as
  strings. This is the default fetch mode for ``Zend\Db\Adapter`` classes.

  Note that if your select-list contains more than one column with the same name, for example if they are from two
  different tables in a JOIN, there can be only one entry in the associative array for a given name. If you use the
  FETCH_ASSOC mode, you should specify column aliases in your SELECT query to ensure that the names result in
  unique array keys.

  By default, these strings are returned as they are returned by the database driver. This is typically the
  spelling of the column in the *RDBMS* server. You can specify the case for these strings, using the
  ``Zend\Db\Db::CASE_FOLDING`` option. Specify this when instantiating the Adapter. See :ref:`
  <zend.db.adapter.connecting.parameters.example1>`.

- ``Zend\Db\Db::FETCH_NUM``: return data in an array of arrays. The arrays are indexed by integers, corresponding to
  the position of the respective field in the select-list of the query.

- ``Zend\Db\Db::FETCH_BOTH``: return data in an array of arrays. The array keys are both strings as used in the
  FETCH_ASSOC mode, and integers as used in the FETCH_NUM mode. Note that the number of elements in the array is
  double that which would be in the array if you used either FETCH_ASSOC or FETCH_NUM.

- ``Zend\Db\Db::FETCH_COLUMN``: return data in an array of values. The value in each array is the value returned by
  one column of the result set. By default, this is the first column, indexed by 0.

- ``Zend\Db\Db::FETCH_OBJ``: return data in an array of objects. The default class is the *PHP* built-in class
  stdClass. Columns of the result set are available as public properties of the object.

.. _zend.db.adapter.select.fetch-mode.example:

.. rubric:: Using setFetchMode()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchAll('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result is an array of objects
   echo $result[0]->bug_description;

.. _zend.db.adapter.select.fetchassoc:

Fetching a Result Set as an Associative Array
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``fetchAssoc()`` method returns data in an array of associative arrays, regardless of what value you have set
for the fetch mode.

.. _zend.db.adapter.select.fetchassoc.example:

.. rubric:: Using fetchAssoc()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchAssoc('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result is an array of associative arrays, in spite of the fetch mode
   echo $result[0]['bug_description'];

.. _zend.db.adapter.select.fetchcol:

Fetching a Single Column from a Result Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``fetchCol()`` method returns data in an array of values, regardless of the value you have set for the fetch
mode. This only returns the first column returned by the query. Any other columns returned by the query are
discarded. If you need to return a column other than the first, see :ref:`
<zend.db.statement.fetching.fetchcolumn>`.

.. _zend.db.adapter.select.fetchcol.example:

.. rubric:: Using fetchCol()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchCol(
       'SELECT bug_description, bug_id FROM bugs WHERE bug_id = ?', 2);

   // contains bug_description; bug_id is not returned
   echo $result[0];

.. _zend.db.adapter.select.fetchpairs:

Fetching Key-Value Pairs from a Result Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``fetchPairs()`` method returns data in an array of key-value pairs, as an associative array with a single
entry per row. The key of this associative array is taken from the first column returned by the SELECT query. The
value is taken from the second column returned by the SELECT query. Any other columns returned by the query are
discarded.

You should design the SELECT query so that the first column returned has unique values. If there are duplicates
values in the first column, entries in the associative array will be overwritten.

.. _zend.db.adapter.select.fetchpairs.example:

.. rubric:: Using fetchPairs()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchPairs('SELECT bug_id, bug_status FROM bugs');

   echo $result[2];

.. _zend.db.adapter.select.fetchrow:

Fetching a Single Row from a Result Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``fetchRow()`` method returns data using the current fetch mode, but it returns only the first row fetched from
the result set.

.. _zend.db.adapter.select.fetchrow.example:

.. rubric:: Using fetchRow()

.. code-block:: php
   :linenos:

   $db->setFetchMode(Zend\Db\Db::FETCH_OBJ);

   $result = $db->fetchRow('SELECT * FROM bugs WHERE bug_id = 2');

   // note that $result is a single object, not an array of objects
   echo $result->bug_description;

.. _zend.db.adapter.select.fetchone:

Fetching a Single Scalar from a Result Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The ``fetchOne()`` method is like a combination of ``fetchRow()`` with ``fetchCol()``, in that it returns data only
for the first row fetched from the result set, and it returns only the value of the first column in that row.
Therefore it returns only a single scalar value, not an array or an object.

.. _zend.db.adapter.select.fetchone.example:

.. rubric:: Using fetchOne()

.. code-block:: php
   :linenos:

   $result = $db->fetchOne('SELECT bug_status FROM bugs WHERE bug_id = 2');

   // this is a single string value
   echo $result;

.. _zend.db.adapter.write:

Writing Changes to the Database
-------------------------------

You can use the Adapter class to write new data or change existing data in your database. This section describes
methods to do these operations.

.. _zend.db.adapter.write.insert:

Inserting Data
^^^^^^^^^^^^^^

You can add new rows to a table in your database using the ``insert()`` method. The first argument is a string that
names the table, and the second argument is an associative array, mapping column names to data values.

.. _zend.db.adapter.write.insert.example:

.. rubric:: Inserting in a Table

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

Columns you exclude from the array of data are not specified to the database. Therefore, they follow the same rules
that an *SQL* INSERT statement follows: if the column has a DEFAULT clause, the column takes that value in the row
created, otherwise the column is left in a *NULL* state.

By default, the values in your data array are inserted using parameters. This reduces risk of some types of
security issues. You don't need to apply escaping or quoting to values in the data array.

You might need values in the data array to be treated as *SQL* expressions, in which case they should not be
quoted. By default, all data values passed as strings are treated as string literals. To specify that the value is
an *SQL* expression and therefore should not be quoted, pass the value in the data array as an object of type
``Zend\Db\Expr`` instead of a plain string.

.. _zend.db.adapter.write.insert.example2:

.. rubric:: Inserting Expressions in a Table

.. code-block:: php
   :linenos:

   $data = array(
       'created_on'      => new Zend\Db\Expr('CURDATE()'),
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

.. _zend.db.adapter.write.lastinsertid:

Retrieving a Generated Value
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Some *RDBMS* brands support auto-incrementing primary keys. A table defined this way generates a primary key value
automatically during an INSERT of a new row. The return value of the ``insert()`` method is **not** the last
inserted ID, because the table might not have an auto-incremented column. Instead, the return value is the number
of rows affected (usually 1).

If your table is defined with an auto-incrementing primary key, you can call the ``lastInsertId()`` method after
the insert. This method returns the last value generated in the scope of the current database connection.

.. _zend.db.adapter.write.lastinsertid.example-1:

.. rubric:: Using lastInsertId() for an Auto-Increment Key

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // return the last value generated by an auto-increment column
   $id = $db->lastInsertId();

Some *RDBMS* brands support a sequence object, which generates unique values to serve as primary key values. To
support sequences, the ``lastInsertId()`` method accepts two optional string arguments. These arguments name the
table and the column, assuming you have followed the convention that a sequence is named using the table and column
names for which the sequence generates values, and a suffix "\_seq". This is based on the convention used by
PostgreSQL when naming sequences for SERIAL columns. For example, a table "bugs" with primary key column "bug_id"
would use a sequence named "bugs_bug_id_seq".

.. _zend.db.adapter.write.lastinsertid.example-2:

.. rubric:: Using lastInsertId() for a Sequence

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // return the last value generated by sequence 'bugs_bug_id_seq'.
   $id = $db->lastInsertId('bugs', 'bug_id');

   // alternatively, return the last value generated by sequence 'bugs_seq'.
   $id = $db->lastInsertId('bugs');

If the name of your sequence object does not follow this naming convention, use the ``lastSequenceId()`` method
instead. This method takes a single string argument, naming the sequence literally.

.. _zend.db.adapter.write.lastinsertid.example-3:

.. rubric:: Using lastSequenceId()

.. code-block:: php
   :linenos:

   $db->insert('bugs', $data);

   // return the last value generated by sequence 'bugs_id_gen'.
   $id = $db->lastSequenceId('bugs_id_gen');

For *RDBMS* brands that don't support sequences, including MySQL, Microsoft *SQL* Server, and SQLite, the arguments
to the lastInsertId() method are ignored, and the value returned is the most recent value generated for any table
by INSERT operations during the current connection. For these *RDBMS* brands, the lastSequenceId() method always
returns ``NULL``.

.. note::

   **Why Not Use "SELECT MAX(id) FROM table"?**

   Sometimes this query returns the most recent primary key value inserted into the table. However, this technique
   is not safe to use in an environment where multiple clients are inserting records to the database. It is
   possible, and therefore is bound to happen eventually, that another client inserts another row in the instant
   between the insert performed by your client application and your query for the MAX(id) value. Thus the value
   returned does not identify the row you inserted, it identifies the row inserted by some other client. There is
   no way to know when this has happened.

   Using a strong transaction isolation mode such as "repeatable read" can mitigate this risk, but some *RDBMS*
   brands don't support the transaction isolation required for this, or else your application may use a lower
   transaction isolation mode by design.

   Furthermore, using an expression like "MAX(id)+1" to generate a new value for a primary key is not safe, because
   two clients could do this query simultaneously, and then both use the same calculated value for their next
   INSERT operation.

   All *RDBMS* brands provide mechanisms to generate unique values, and to return the last value generated. These
   mechanisms necessarily work outside of the scope of transaction isolation, so there is no chance of two clients
   generating the same value, and there is no chance that the value generated by another client could be reported
   to your client's connection as the last value generated.

.. _zend.db.adapter.write.update:

Updating Data
^^^^^^^^^^^^^

You can update rows in a database table using the ``update()`` method of an Adapter. This method takes three
arguments: the first is the name of the table; the second is an associative array mapping columns to change to new
values to assign to these columns.

The values in the data array are treated as string literals. See :ref:` <zend.db.adapter.write.insert>` for
information on using *SQL* expressions in the data array.

The third argument is a string containing an *SQL* expression that is used as criteria for the rows to change. The
values and identifiers in this argument are not quoted or escaped. You are responsible for ensuring that any
dynamic content is interpolated into this string safely. See :ref:` <zend.db.adapter.quoting>` for methods to help
you do this.

The return value is the number of rows affected by the update operation.

.. _zend.db.adapter.write.update.example:

.. rubric:: Updating Rows

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $n = $db->update('bugs', $data, 'bug_id = 2');

If you omit the third argument, then all rows in the database table are updated with the values specified in the
data array.

If you provide an array of strings as the third argument, these strings are joined together as terms in an
expression separated by ``AND`` operators.

.. _zend.db.adapter.write.update.example-array:

.. rubric:: Updating Rows Using an Array of Expressions

.. code-block:: php
   :linenos:

   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $where[] = "reported_by = 'goofy'";
   $where[] = "bug_status = 'OPEN'";

   $n = $db->update('bugs', $data, $where);

   // Resulting SQL is:
   //  UPDATE "bugs" SET "update_on" = '2007-03-23', "bug_status" = 'FIXED'
   //  WHERE ("reported_by" = 'goofy') AND ("bug_status" = 'OPEN')

.. _zend.db.adapter.write.delete:

Deleting Data
^^^^^^^^^^^^^

You can delete rows from a database table using the ``delete()`` method. This method takes two arguments: the first
is a string naming the table.

The second argument is a string containing an *SQL* expression that is used as criteria for the rows to delete. The
values and identifiers in this argument are not quoted or escaped. You are responsible for ensuring that any
dynamic content is interpolated into this string safely. See :ref:` <zend.db.adapter.quoting>` for methods to help
you do this.

The return value is the number of rows affected by the delete operation.

.. _zend.db.adapter.write.delete.example:

.. rubric:: Deleting Rows

.. code-block:: php
   :linenos:

   $n = $db->delete('bugs', 'bug_id = 3');

If you omit the second argument, the result is that all rows in the database table are deleted.

If you provide an array of strings as the second argument, these strings are joined together as terms in an
expression separated by ``AND`` operators.

.. _zend.db.adapter.quoting:

Quoting Values and Identifiers
------------------------------

When you form *SQL* queries, often it is the case that you need to include the values of PHP variables in *SQL*
expressions. This is risky, because if the value in a PHP string contains certain symbols, such as the quote
symbol, it could result in invalid *SQL*. For example, notice the imbalanced quote characters in the following
query:

   .. code-block:: php
      :linenos:

      $name = "O'Reilly";
      $sql = "SELECT * FROM bugs WHERE reported_by = '$name'";

      echo $sql;
      // SELECT * FROM bugs WHERE reported_by = 'O'Reilly'



Even worse is the risk that such code mistakes might be exploited deliberately by a person who is trying to
manipulate the function of your web application. If they can specify the value of a *PHP* variable through the use
of an *HTTP* parameter or other mechanism, they might be able to make your *SQL* queries do things that you didn't
intend them to do, such as return data to which the person should not have privilege to read. This is a serious and
widespread technique for violating application security, known as "SQL Injection" (see
http://en.wikipedia.org/wiki/SQL_Injection).

The ``Zend_Db`` Adapter class provides convenient functions to help you reduce vulnerabilities to *SQL* Injection
attacks in your *PHP* code. The solution is to escape special characters such as quotes in *PHP* values before they
are interpolated into your *SQL* strings. This protects against both accidental and deliberate manipulation of
*SQL* strings by *PHP* variables that contain special characters.

.. _zend.db.adapter.quoting.quote:

Using quote()
^^^^^^^^^^^^^

The ``quote()`` method accepts a single argument, a scalar string value. It returns the value with special
characters escaped in a manner appropriate for the *RDBMS* you are using, and surrounded by string value
delimiters. The standard *SQL* string value delimiter is the single-quote (*'*).

.. _zend.db.adapter.quoting.quote.example:

.. rubric:: Using quote()

.. code-block:: php
   :linenos:

   $name = $db->quote("O'Reilly");
   echo $name;
   // 'O\'Reilly'

   $sql = "SELECT * FROM bugs WHERE reported_by = $name";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Note that the return value of ``quote()`` includes the quote delimiters around the string. This is different from
some functions that escape special characters but do not add the quote delimiters, for example
`mysql_real_escape_string()`_.

Values may need to be quoted or not quoted according to the *SQL* datatype context in which they are used. For
instance, in some RDBMS brands, an integer value must not be quoted as a string if it is compared to an
integer-type column or expression. In other words, the following is an error in some *SQL* implementations,
assuming *intColumn* has a *SQL* datatype of ``INTEGER``

   .. code-block:: php
      :linenos:

      SELECT * FROM atable WHERE intColumn = '123'



You can use the optional second argument to the ``quote()`` method to apply quoting selectively for the *SQL*
datatype you specify.

.. _zend.db.adapter.quoting.quote.example-2:

.. rubric:: Using quote() with a SQL Type

.. code-block:: php
   :linenos:

   $value = '1234';
   $sql = 'SELECT * FROM atable WHERE intColumn = '
        . $db->quote($value, 'INTEGER');

Each ``Zend\Db\Adapter`` class has encoded the names of numeric *SQL* datatypes for the respective brand of
*RDBMS*. You can also use the constants ``Zend\Db\Db::INT_TYPE``, ``Zend\Db\Db::BIGINT_TYPE``, and
``Zend\Db\Db::FLOAT_TYPE`` to write code in a more *RDBMS*-independent way.

``Zend\Db\Table`` specifies *SQL* types to ``quote()`` automatically when generating *SQL* queries that reference a
table's key columns.

.. _zend.db.adapter.quoting.quote-into:

Using quoteInto()
^^^^^^^^^^^^^^^^^

The most typical usage of quoting is to interpolate a *PHP* variable into a *SQL* expression or statement. You can
use the ``quoteInto()`` method to do this in one step. This method takes two arguments: the first argument is a
string containing a placeholder symbol (*?*), and the second argument is a value or *PHP* variable that should be
substituted for that placeholder.

The placeholder symbol is the same symbol used by many *RDBMS* brands for positional parameters, but the
``quoteInto()`` method only emulates query parameters. The method simply interpolates the value into the string,
escapes special characters, and applies quotes around it. True query parameters maintain the separation between the
*SQL* string and the parameters as the statement is parsed in the *RDBMS* server.

.. _zend.db.adapter.quoting.quote-into.example:

.. rubric:: Using quoteInto()

.. code-block:: php
   :linenos:

   $sql = $db->quoteInto("SELECT * FROM bugs WHERE reported_by = ?", "O'Reilly");

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

You can use the optional third parameter of ``quoteInto()`` to specify the *SQL* datatype. Numeric datatypes are
not quoted, and other types are quoted.

.. _zend.db.adapter.quoting.quote-into.example-2:

.. rubric:: Using quoteInto() with a SQL Type

.. code-block:: php
   :linenos:

   $sql = $db
       ->quoteInto("SELECT * FROM bugs WHERE bug_id = ?", '1234', 'INTEGER');

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 1234

.. _zend.db.adapter.quoting.quote-identifier:

Using quoteIdentifier()
^^^^^^^^^^^^^^^^^^^^^^^

Values are not the only part of *SQL* syntax that might need to be variable. If you use *PHP* variables to name
tables, columns, or other identifiers in your *SQL* statements, you might need to quote these strings too. By
default, *SQL* identifiers have syntax rules like *PHP* and most other programming languages. For example,
identifiers should not contain spaces, certain punctuation or special characters, or international characters. Also
certain words are reserved for *SQL* syntax, and should not be used as identifiers.

However, *SQL* has a feature called **delimited identifiers**, which allows broader choices for the spelling of
identifiers. If you enclose a *SQL* identifier in the proper types of quotes, you can use identifiers with
spellings that would be invalid without the quotes. Delimited identifiers can contain spaces, punctuation, or
international characters. You can also use *SQL* reserved words if you enclose them in identifier delimiters.

The ``quoteIdentifier()`` method works like ``quote()``, but it applies the identifier delimiter characters to the
string according to the type of Adapter you use. For example, standard *SQL* uses double-quotes (*"*) for
identifier delimiters, and most *RDBMS* brands use that symbol. MySQL uses back-quotes (*`*) by default. The
``quoteIdentifier()`` method also escapes special characters within the string argument.

.. _zend.db.adapter.quoting.quote-identifier.example:

.. rubric:: Using quoteIdentifier()

.. code-block:: php
   :linenos:

   // we might have a table name that is an SQL reserved word
   $tableName = $db->quoteIdentifier("order");

   $sql = "SELECT * FROM $tableName";

   echo $sql
   // SELECT * FROM "order"

*SQL* delimited identifiers are case-sensitive, unlike unquoted identifiers. Therefore, if you use delimited
identifiers, you must use the spelling of the identifier exactly as it is stored in your schema, including the case
of the letters.

In most cases where *SQL* is generated within ``Zend_Db`` classes, the default is that all identifiers are
delimited automatically. You can change this behavior with the option ``Zend\Db\Db::AUTO_QUOTE_IDENTIFIERS``. Specify
this when instantiating the Adapter. See :ref:` <zend.db.adapter.connecting.parameters.example2>`.

.. _zend.db.adapter.transactions:

Controlling Database Transactions
---------------------------------

Databases define transactions as logical units of work that can be committed or rolled back as a single change,
even if they operate on multiple tables. All queries to a database are executed within the context of a
transaction, even if the database driver manages them implicitly. This is called **auto-commit** mode, in which the
database driver creates a transaction for every statement you execute, and commits that transaction after your
*SQL* statement has been executed. By default, all ``Zend_Db`` Adapter classes operate in auto-commit mode.

Alternatively, you can specify the beginning and resolution of a transaction, and thus control how many *SQL*
queries are included in a single group that is committed (or rolled back) as a single operation. Use the
``beginTransaction()`` method to initiate a transaction. Subsequent *SQL* statements are executed in the context of
the same transaction until you resolve it explicitly.

To resolve the transaction, use either the ``commit()`` or ``rollBack()`` methods. The ``commit()`` method marks
changes made during your transaction as committed, which means the effects of these changes are shown in queries
run in other transactions.

The ``rollBack()`` method does the opposite: it discards the changes made during your transaction. The changes are
effectively undone, and the state of the data returns to how it was before you began your transaction. However,
rolling back your transaction has no effect on changes made by other transactions running concurrently.

After you resolve this transaction, ``Zend\Db\Adapter`` returns to auto-commit mode until you call
``beginTransaction()`` again.

.. _zend.db.adapter.transactions.example:

.. rubric:: Managing a Transaction to Ensure Consistency

.. code-block:: php
   :linenos:

   // Start a transaction explicitly.
   $db->beginTransaction();

   try {
       // Attempt to execute one or more queries:
       $db->query(...);
       $db->query(...);
       $db->query(...);

       // If all succeed, commit the transaction and all changes
       // are committed at once.
       $db->commit();

   } catch (Exception $e) {
       // If any of the queries failed and threw an exception,
       // we want to roll back the whole transaction, reversing
       // changes made in the transaction, even those that succeeded.
       // Thus all changes are committed together, or none are.
       $db->rollBack();
       echo $e->getMessage();
   }

.. _zend.db.adapter.list-describe:

Listing and Describing Tables
-----------------------------

The ``listTables()`` method returns an array of strings, naming all tables in the current database.

The ``describeTable()`` method returns an associative array of metadata about a table. Specify the name of the
table as a string in the first argument to this method. The second argument is optional, and names the schema in
which the table exists.

The keys of the associative array returned are the column names of the table. The value corresponding to each
column is also an associative array, with the following keys and values:

.. _zend.db.adapter.list-describe.metadata:

.. table:: Metadata Fields Returned by describeTable()

   +----------------+---------+----------------------------------------------------------------------------------+
   |Key             |Type     |Description                                                                       |
   +================+=========+==================================================================================+
   |SCHEMA_NAME     |(string) |Name of the database schema in which this table exists.                           |
   +----------------+---------+----------------------------------------------------------------------------------+
   |TABLE_NAME      |(string) |Name of the table to which this column belongs.                                   |
   +----------------+---------+----------------------------------------------------------------------------------+
   |COLUMN_NAME     |(string) |Name of the column.                                                               |
   +----------------+---------+----------------------------------------------------------------------------------+
   |COLUMN_POSITION |(integer)|Ordinal position of the column in the table.                                      |
   +----------------+---------+----------------------------------------------------------------------------------+
   |DATA_TYPE       |(string) |RDBMS name of the datatype of the column.                                         |
   +----------------+---------+----------------------------------------------------------------------------------+
   |DEFAULT         |(string) |Default value for the column, if any.                                             |
   +----------------+---------+----------------------------------------------------------------------------------+
   |NULLABLE        |(boolean)|TRUE if the column accepts SQLNULLs, FALSE if the column has a NOTNULL constraint.|
   +----------------+---------+----------------------------------------------------------------------------------+
   |LENGTH          |(integer)|Length or size of the column as reported by the RDBMS .                           |
   +----------------+---------+----------------------------------------------------------------------------------+
   |SCALE           |(integer)|Scale of SQL NUMERIC or DECIMAL type.                                             |
   +----------------+---------+----------------------------------------------------------------------------------+
   |PRECISION       |(integer)|Precision of SQL NUMERIC or DECIMAL type.                                         |
   +----------------+---------+----------------------------------------------------------------------------------+
   |UNSIGNED        |(boolean)|TRUE if an integer-based type is reported as UNSIGNED .                           |
   +----------------+---------+----------------------------------------------------------------------------------+
   |PRIMARY         |(boolean)|TRUE if the column is part of the primary key of this table.                      |
   +----------------+---------+----------------------------------------------------------------------------------+
   |PRIMARY_POSITION|(integer)|Ordinal position (1-based) of the column in the primary key.                      |
   +----------------+---------+----------------------------------------------------------------------------------+
   |IDENTITY        |(boolean)|TRUE if the column uses an auto-generated value.                                  |
   +----------------+---------+----------------------------------------------------------------------------------+

.. note::

   **How the IDENTITY Metadata Field Relates to Specific RDBMSs**

   The IDENTITY metadata field was chosen as an 'idiomatic' term to represent a relation to surrogate keys. This
   field can be commonly known by the following values:-

   - ``IDENTITY``- DB2, MSSQL

   - ``AUTO_INCREMENT``- MySQL

   - ``SERIAL``- PostgreSQL

   - ``SEQUENCE``- Oracle

If no table exists matching the table name and optional schema name specified, then ``describeTable()`` returns an
empty array.

.. _zend.db.adapter.closing:

Closing a Connection
--------------------

Normally it is not necessary to close a database connection. *PHP* automatically cleans up all resources and the
end of a request. Database extensions are designed to close the connection as the reference to the resource object
is cleaned up.

However, if you have a long-duration *PHP* script that initiates many database connections, you might need to close
the connection, to avoid exhausting the capacity of your *RDBMS* server. You can use the Adapter's
``closeConnection()`` method to explicitly close the underlying database connection.

Since release 1.7.2, you could check you are currently connected to the *RDBMS* server with the method
``isConnected()``. This means that a connection resource has been initiated and wasn't closed. This function is not
currently able to test for example a server side closing of the connection. This is internally use to close the
connection. It allow you to close the connection multiple times without errors. It was already the case before
1.7.2 for *PDO* adapters but not for the others.

.. _zend.db.adapter.closing.example:

.. rubric:: Closing a Database Connection

.. code-block:: php
   :linenos:

   $db->closeConnection();

.. note::

   **Does Zend_Db Support Persistent Connections?**

   Yes, persistence is supported through the addition of the ``persistent`` flag set to true in the configuration
   (not driver_configuration) of an adapter in ``Zend_Db``.

   .. _zend.db.adapter.connecting.persistence.example:

   .. rubric:: Using the Persitence Flag with the Oracle Adapter

   .. code-block:: php
      :linenos:

      $db = Zend\Db\Db::factory('Oracle', array(
          'host'       => '127.0.0.1',
          'username'   => 'webuser',
          'password'   => 'xxxxxxxx',
          'dbname'     => 'test',
          'persistent' => true
      ));

   Please note that using persistent connections can cause an excess of idle connections on the *RDBMS* server,
   which causes more problems than any performance gain you might achieve by reducing the overhead of making
   connections.

   Database connections have state. That is, some objects in the *RDBMS* server exist in session scope. Examples
   are locks, user variables, temporary tables, and information about the most recently executed query, such as
   rows affected, and last generated id value. If you use persistent connections, your application could access
   invalid or privileged data that were created in a previous *PHP* request.

   Currently, only Oracle, DB2, and the *PDO* adapters (where specified by *PHP*) support persistence in
   ``Zend_Db``.

.. _zend.db.adapter.other-statements:

Running Other Database Statements
---------------------------------

There might be cases in which you need to access the connection object directly, as provided by the *PHP* database
extension. Some of these extensions may offer features that are not surfaced by methods of
``Zend\Db\Adapter\Abstract``.

For example, all *SQL* statements run by ``Zend_Db`` are prepared, then executed. However, some database features
are incompatible with prepared statements. DDL statements like CREATE and ALTER cannot be prepared in MySQL. Also,
*SQL* statements don't benefit from the `MySQL Query Cache`_, prior to MySQL 5.1.17.

Most *PHP* database extensions provide a method to execute *SQL* statements without preparing them. For example, in
*PDO*, this method is ``exec()``. You can access the connection object in the *PHP* extension directly using
getConnection().

.. _zend.db.adapter.other-statements.example:

.. rubric:: Running a Non-Prepared Statement in a PDO Adapter

.. code-block:: php
   :linenos:

   $result = $db->getConnection()->exec('DROP TABLE bugs');

Similarly, you can access other methods or properties that are specific to *PHP* database extensions. Be aware,
though, that by doing this you might constrain your application to the interface provided by the extension for a
specific brand of *RDBMS*.

In future versions of ``Zend_Db``, there will be opportunities to add method entry points for functionality that is
common to the supported *PHP* database extensions. This will not affect backward compatibility.

.. _zend.db.adapter.server-version:

Retrieving Server Version
-------------------------

Since release 1.7.2, you could retrieve the server version in *PHP* syntax style to be able to use
``version_compare()``. If the information isn't available, you will receive ``NULL``.

.. _zend.db.adapter.server-version.example:

.. rubric:: Verifying server version before running a query

.. code-block:: php
   :linenos:

   $version = $db->getServerVersion();
   if (!is_null($version)) {
       if (version_compare($version, '5.0.0', '>=')) {
           // do something
       } else {
           // do something else
       }
   } else {
       // impossible to read server version
   }

.. _zend.db.adapter.adapter-notes:

Notes on Specific Adapters
--------------------------

This section lists differences between the Adapter classes of which you should be aware.

.. _zend.db.adapter.adapter-notes.ibm-db2:

IBM DB2
^^^^^^^

- Specify this Adapter to the factory() method with the name 'Db2'.

- This Adapter uses the *PHP* extension ibm_db2.

- IBM DB2 supports both sequences and auto-incrementing keys. Therefore the arguments to ``lastInsertId()`` are
  optional. If you give no arguments, the Adapter returns the last value generated for an auto-increment key. If
  you give arguments, the Adapter returns the last value generated by the sequence named according to the
  convention '**table** _ **column** _seq'.

.. _zend.db.adapter.adapter-notes.mysqli:

MySQLi
^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Mysqli'.

- This Adapter utilizes the *PHP* extension mysqli.

- MySQL does not support sequences, so ``lastInsertId()`` ignores its arguments and always returns the last value
  generated for an auto-increment key. The ``lastSequenceId()`` method returns ``NULL``.

.. _zend.db.adapter.adapter-notes.oracle:

Oracle
^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Oracle'.

- This Adapter uses the *PHP* extension oci8.

- Oracle does not support auto-incrementing keys, so you should specify the name of a sequence to
  ``lastInsertId()`` or ``lastSequenceId()``.

- The Oracle extension does not support positional parameters. You must use named parameters.

- Currently the ``Zend\Db\Db::CASE_FOLDING`` option is not supported by the Oracle adapter. To use this option with
  Oracle, you must use the *PDO* OCI adapter.

- By default, LOB fields are returned as OCI-Lob objects. You could retrieve them as string for all requests by
  using driver options *'lob_as_string'* or for particular request by using ``setLobAsString(boolean)`` on adapter
  or on statement.

.. _zend.db.adapter.adapter-notes.sqlsrv:

Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Sqlsrv'.

- This Adapter uses the *PHP* extension sqlsrv

- Microsoft *SQL* Server does not support sequences, so ``lastInsertId()`` ignores primary key argument and returns
  the last value generated for an auto-increment key if a table name is specified or a last insert query returned
  id. The ``lastSequenceId()`` method returns ``NULL``.

- ``Zend\Db\Adapter\Sqlsrv`` sets ``QUOTED_IDENTIFIER ON`` immediately after connecting to a *SQL* Server database.
  This makes the driver use the standard *SQL* identifier delimiter symbol (**"**) instead of the proprietary
  square-brackets syntax *SQL* Server uses for delimiting identifiers.

- You can specify ``driver_options`` as a key in the options array. The value can be a anything from here
  http://msdn.microsoft.com/en-us/library/cc296161(SQL.90).aspx.

- You can use ``setTransactionIsolationLevel()`` to set isolation level for current connection. The value can be
  ``SQLSRV_TXN_READ_UNCOMMITTED``, ``SQLSRV_TXN_READ_COMMITTED``, ``SQLSRV_TXN_REPEATABLE_READ``,
  ``SQLSRV_TXN_SNAPSHOT`` or ``SQLSRV_TXN_SERIALIZABLE``.

- As of Zend Framework 1.9, the minimal supported build of the *PHP* *SQL* Server extension from Microsoft is
  1.0.1924.0. and the *MSSQL* Server Native Client version 9.00.3042.00.

.. _zend.db.adapter.adapter-notes.pdo-ibm:

PDO for IBM DB2 and Informix Dynamic Server (IDS)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Pdo_Ibm'.

- This Adapter uses the *PHP* extensions pdo and pdo_ibm.

- You must use at least *PDO* _IBM extension version 1.2.2. If you have an earlier version of this extension, you
  must upgrade the *PDO* _IBM extension from *PECL*.

.. _zend.db.adapter.adapter-notes.pdo-mssql:

PDO Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Pdo_Mssql'.

- This Adapter uses the *PHP* extensions pdo and pdo_mssql.

- Microsoft *SQL* Server does not support sequences, so ``lastInsertId()`` ignores its arguments and always returns
  the last value generated for an auto-increment key. The ``lastSequenceId()`` method returns ``NULL``.

- If you are working with unicode strings in an encoding other than UCS-2 (such as UTF-8), you may have to perform
  a conversion in your application code or store the data in a binary column. Please refer to `Microsoft's
  Knowledge Base`_ for more information.

- ``Zend\Db\Adapter\Pdo\Mssql`` sets ``QUOTED_IDENTIFIER ON`` immediately after connecting to a *SQL* Server
  database. This makes the driver use the standard *SQL* identifier delimiter symbol (*"*) instead of the
  proprietary square-brackets syntax *SQL* Server uses for delimiting identifiers.

- You can specify *pdoType* as a key in the options array. The value can be "mssql" (the default), "dblib",
  "freetds", or "sybase". This option affects the DSN prefix the adapter uses when constructing the DSN string.
  Both "freetds" and "sybase" imply a prefix of "sybase:", which is used for the `FreeTDS`_ set of libraries. See
  also http://www.php.net/manual/en/ref.pdo-dblib.connection.php for more information on the DSN prefixes used
  in this driver.

.. _zend.db.adapter.adapter-notes.pdo-mysql:

PDO MySQL
^^^^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Pdo_Mysql'.

- This Adapter uses the *PHP* extensions pdo and pdo_mysql.

- MySQL does not support sequences, so ``lastInsertId()`` ignores its arguments and always returns the last value
  generated for an auto-increment key. The ``lastSequenceId()`` method returns ``NULL``.

.. _zend.db.adapter.adapter-notes.pdo-oci:

PDO Oracle
^^^^^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Pdo_Oci'.

- This Adapter uses the *PHP* extensions pdo and pdo_oci.

- Oracle does not support auto-incrementing keys, so you should specify the name of a sequence to
  ``lastInsertId()`` or ``lastSequenceId()``.

.. _zend.db.adapter.adapter-notes.pdo-pgsql:

PDO PostgreSQL
^^^^^^^^^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Pdo_Pgsql'.

- This Adapter uses the *PHP* extensions pdo and pdo_pgsql.

- PostgreSQL supports both sequences and auto-incrementing keys. Therefore the arguments to ``lastInsertId()`` are
  optional. If you give no arguments, the Adapter returns the last value generated for an auto-increment key. If
  you give arguments, the Adapter returns the last value generated by the sequence named according to the
  convention '**table** _ **column** _seq'.

.. _zend.db.adapter.adapter-notes.pdo-sqlite:

PDO SQLite
^^^^^^^^^^

- Specify this Adapter to the ``factory()`` method with the name 'Pdo_Sqlite'.

- This Adapter uses the *PHP* extensions pdo and pdo_sqlite.

- SQLite does not support sequences, so ``lastInsertId()`` ignores its arguments and always returns the last value
  generated for an auto-increment key. The ``lastSequenceId()`` method returns ``NULL``.

- To connect to an SQLite2 database, specify *'sqlite2'=>true* in the array of parameters when creating an instance
  of the ``Pdo_Sqlite`` Adapter.

- To connect to an in-memory SQLite database, specify *'dbname'=>':memory:'* in the array of parameters when
  creating an instance of the ``Pdo_Sqlite`` Adapter.

- Older versions of the SQLite driver for *PHP* do not seem to support the PRAGMA commands necessary to ensure that
  short column names are used in result sets. If you have problems that your result sets are returned with keys of
  the form "tablename.columnname" when you do a join query, then you should upgrade to the current version of
  *PHP*.

.. _zend.db.adapter.adapter-notes.firebird:

Firebird/Interbase
^^^^^^^^^^^^^^^^^^

- This Adapter uses the *PHP* extension php_interbase.

- Firebird/interbase does not support auto-incrementing keys, so you should specify the name of a sequence to
  ``lastInsertId()`` or ``lastSequenceId()``.

- Currently the ``Zend\Db\Db::CASE_FOLDING`` option is not supported by the Firebird/interbase adapter. Unquoted
  identifiers are automatically returned in upper case.

- Adapter name is ``ZendX_Db_Adapter_Firebird``.

  Remember to use the param adapterNamespace with value ``ZendX_Db_Adapter``.

  We recommend to update the gds32.dll (or linux equivalent) bundled with php, to the same version of the server.
  For Firebird the equivalent gds32.dll is fbclient.dll.

  By default all identifiers (tables names, fields) are returned in upper case.



.. _`PHP Data Objects`: http://www.php.net/pdo
.. _`pdo_ibm`: http://www.php.net/pdo-ibm
.. _`pdo_mysql`: http://www.php.net/pdo-mysql
.. _`pdo_mssql`: http://www.php.net/pdo-mssql
.. _`pdo_oci`: http://www.php.net/pdo-oci
.. _`pdo_pgsql`: http://www.php.net/pdo-pgsql
.. _`pdo_sqlite`: http://www.php.net/pdo-sqlite
.. _`mysqli`: http://www.php.net/mysqli
.. _`oci8`: http://www.php.net/oci8
.. _`ibm_db2`: http://www.php.net/ibm_db2
.. _`php_interbase`: http://www.php.net/ibase
.. _`mysql_real_escape_string()`: http://www.php.net/mysqli_real_escape_string
.. _`MySQL Query Cache`: http://dev.mysql.com/doc/refman/5.1/en/query-cache-how.html
.. _`Microsoft's Knowledge Base`: http://support.microsoft.com/kb/232580
.. _`FreeTDS`: http://www.freetds.org/
