.. EN-Revision: none
.. _zend.db.adapter:

Zend_Db_Adapter
===============

Zend_Db와 관련 클래스들은 Zend Frmework에 기본 데이터 베이스 인터페이스를 제공합니다.
Zend_DB_Adapter는 Zend Framework로 만들어진 PHP 어플리케이션이 관계형 데이터베이스에
접속하기 위한 기본 클라스들을 제공합니다. 각 RDBMS의 종류에 따라 각기 다른
아답터가 제공됩니다.

Zend_Db의 어댑터는 벤더별 PHP 모듈과 범용 모듈사이에 다리역활을 수행하여, 하나의
완성된 PHP 어플리케이션이 최소한의 절차를 거쳐 다른 여러 RDBMS에 적용될수 있게
해줍니다 .

어댑터 클래스의 인터페이스는 `PHP Data Objects`_ 확장 모듈과 매우 유사합니다. Zend_Db는
다음의 RDBMS의 PDO 드라이버를에 대해서 아댑테 클라스를 제공합니다:

- MySQL

- Microsoft SQL Server

- Oracle

- PostgreSQL

- SQLite

또한 Zend_DB는 다음 RDBMS에 대하여 사용이 용이한 PHP database의 확장 모듈도 제공하고
있습니다:

- MySQL, using the `mysqli`_ PHP extension

- Oracle, using the `oci8`_ PHP extension

- IBM DB2, using the `ibm_db2`_ PHP extension

.. note::

   각각의 Zend_Db 아댑터들은 PHP extension을 이용하고 있습니다. Zend_DB Adapter를 이용하기
   위해서는 PHP 환경 설정을 해당 extension에 맞게 설정해주셔야 합니다. 예를 들어, PDO
   Zend_DB 아댑터를 이용하시려면, PDE extension과 PDO 드라이버를 해당 RDBMS에 맞게 enable
   해주셔야 합니다.

.. _zend.db.adapter.connecting:

어댑터를 사용한 데이타베이스 접속
------------------

본 단락에서는 데이타베이스 어댑터의 인스턴스를 생성에대해 다룹니다. 이는 PHP
어플리케이션으로 부터 해당 RDBMS서버로의 연결을 생성하는 것을 의미합니다.

.. _zend.db.adapter.connecting.constructor:

어댑터 constructor 이용
^^^^^^^^^^^^^^^^^^

Constructor를 이용하여 아답터의 인스탄트를 생성할수 있습니다. 아답터의 Constructor는
인수 하나를 요구하며 그 인수는 커넥션을 생성하기 위한 파라메터의 배열형식입니다.

.. _zend.db.adapter.connecting.constructor.example:

.. rubric:: 아답터의 constructor 사용

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Db/Adapter/Pdo/Mysql.php';

   $db = new Zend_Db_Adapter_Pdo_Mysql(array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

.. _zend.db.adapter.connecting.factory:

Zend_Db Factory의 사용
^^^^^^^^^^^^^^^^^^^

직접적인 아답터의 Constructor를 이용하는 방법으로, 정적 메소드 *Zend_Db::factory()*\ 를
이용한 아답터의 인스턴스 생성이 있습니다. 이 메소드는 :ref:`Zend_Loader::loadClass()
<zend.loader.load.class>`\ 를 이용하여 요청에 따라 동적으로 아답터 클라스를 로드 합니다.

첫번째 인수는 아답터 클라스의 베이스명을 문자열로 지정합니다. 예를 들어 문자열
'Pdo_Mysql'은 Zend_DB_Adapter_Pdo_Mysql 클라스에 상응하게 됩니다. 두번째 인수는 아답터의
constructor에 넘겨주는 인수의 배열과 같은 형식의 배열이 됩니다.

.. _zend.db.adapter.connecting.factory.example:

.. rubric:: Adapter factory 메소드의 사용

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Db.php';

   // 자동으로 Zend_Db_Adapter_Pdo_Mysql 클래스를 읽어, 그 인스턴스를 작성합니다.
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'     => '127.0.0.1',
       'username' => 'webuser',
       'password' => 'xxxxxxxx',
       'dbname'   => 'test'
   ));

Zend_Db_Adapter_Abstract 클라스를 상속한 독자적인 클라스를 구성하면서, 그 이름에
"Zend_Db_Adapter"라는 접두어를 붙이지 않으실경우, 파라메터 배열을 "adapternamespace"
키값으로 시작하셨다면 *factory()* 메소드를 이용하신 만드신 아답터를 로드하실수
있습니다.

.. _zend.db.adapter.connecting.factory.example2:

.. rubric:: 커스텀 아답터 클래스를 위한 Adapter factory 메소드 이용하기

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Db.php';

   // Automatically load class MyProject_Db_Adapter_Pdo_Mysql and create an instance of it.
   $db = Zend_Db::factory('Pdo_Mysql', array(
       'host'             => '127.0.0.1',
       'username'         => 'webuser',
       'password'         => 'xxxxxxxx',
       'dbname'           => 'test',
       'adapterNamespace' => 'MyProject_Db_Adapter'
   ));

.. _zend.db.adapter.connecting.factory-config:

Zend_Db_Factory와 Zend_Config 이용하기
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*factory()* 메소드의 인수로 :ref:`Zend_Config <zend.config>`\ 의 오브젝트를 건내줄수도
있습니다.

If the first argument is a config object, it is expected to contain a property named *adapter*, containing the
string naming the adapter class name base. Optionally, the object may contain a property named *params*, with
subproperties corresponding to adapter parameter names. This is used only if the second argument of the *factory()*
method is absent.

.. _zend.db.adapter.connecting.factory.example1:

.. rubric:: Zend_Config 오브젝트와 함께 아댑터 factory 메소드 이용하기

아래의 예는, 배열로 부터 생성된 Zend_Config 오브젝트입니다. :ref:`Zend_Config_Ini
<zend.config.adapters.ini>` 또는 :ref:`Zend_Config_Xml <zend.config.adapters.xml>`\ 을 이용하여 외부
파일로부터도 데이터를 로드 할수 있습니다.

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Config.php';
   require_once 'Zend/Db.php';

   $config = new Zend_Config(
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

   $db = Zend_Db::factory($config->database);
   ));

*factory()* 메소드의 두번째 인자는 Zend_Config의 다른 오브젝트 혹은 배열의 형태입니다.
It should contain entries corresponding to adapter parameters. This argument is optional, but if it is present, it
takes priority over any parameters supplied in the first argument.

.. _zend.db.adapter.connecting.parameters:

아답터 파라메터
^^^^^^^^

아래의 리스트는 Zend_Db Adapter 클래스에서 인식하는 일반적인 파라메터들입니다.

- **host**: 데이터 베이스 서벙의 아이피나 호스트네임의 문자열입니다. 만약 데이터
  베이스와 PHP 어플리케이션이 같은 호스트 상에서 운영되고 있으면 'localhost' 혹은
  '127.0.0.1'을 이용하시면 됩니다.

- **username**: 관계형 데이터베이스 서버에 접속하기 위한 어카운트의 ID입니다.

- **password**: 관계형 데이터베이스 서버에 인증을 위한 패스워드입니다.

- **dbname**: 관계형 데이터베이스 서버의 인스탄스 이름입니다.

- **port**: 관계형 데이터베이스에 따라서는 관리자가 지정한 특수한 포트로만 커녁션을
  지원하기도 합니다. 포트 파라메터는 관계형 데이터베이스 서버로의 접속히 해당
  포트로의 설정을 지원합니다.

- **options**: 이 파라메트는 모든 Zend_Db_Adapter 클라스들의 옵션들을 배열의 형태로
  지정하게 되어있습니다.

- **driver_options**: 이 파라메터는 해당 데이터베이스에서 요구하는 추가 옵션을 배열의
  형태로 입력반습니다. 일반적으로 이 파라메터는 PDO driver의 attributes를 설정하는데
  쓰입니다.

- **adapterNamespace**: 어댑터 클래스의 접두어가 'Zend_Db_Adapter' 이외인 경우에 어댑터
  클래스의 이름을 지정하기 위해 쓰입니다. 젠드 아답터 클라스 이외의 클라스를 로드
  하기 위해서 *factory()*\ 를 이용하셨을 경우 adapterNamespace를 이용하시기 바랍니다.

.. _zend.db.adapter.connecting.parameters.example1:

.. rubric:: Factory에 대소문자 변환 옵션 지정하기

*Zend_Db::CASE_FOLDING*\ 를 이용하여 대소문자 변환 옵션을 지정할수 있습니다. PDO나 IBM DB2
데이터베이스 드라이버의 *ATTR_CASE*\ 속성에 상응하는 것으로, 쿼리 리절트 셋의 문자
키 값을 변환합니다. 옵션 값으로는 *Zend_Db::CASE_NATURAL* (기본값), *Zend_Db::CASE_UPPER*,
그리고 *Zend_Db::CASE_LOWER* 가 있습니다.

.. code-block:: php
   :linenos:

   <?php
   $options = array(
       Zend_Db::CASE_FOLDING => Zend_Db::CASE_UPPER
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Db2', $params);

.. _zend.db.adapter.connecting.parameters.example2:

.. rubric:: 팩토리에 자동 쿼팅(auto-quoting) 옵션 지정하기

*Zend_Db::AUTO_QUOTE_IDENTIFIERS*\ 를 이용하여 오토 쿼팅 옵션을 지정할수 있습니다. 해당
값이 *true*\ (기본값)일 경우 데이블 이름, 컬럼 이름, 그리고 알리아스등의 Adapter
오브젝트에 의해 생성되는 모든 인자들이 모두 쿼팅 됩니다. 이는 SQL 키워드나
특수문자를 포함한 식별자 사용시 유리합니다. 만약 해당 값이 *false*\ 일 경우
식별자의 자동쿼팅은 적용 되지않습니다. 만약 쿼트를 이용해야 할경우 *quoteIdentifier()*
메소드를 이용하여 쿼팅할수 있습니다.

.. code-block:: php
   :linenos:

   <?php
   $options = array(
       Zend_Db::AUTO_QUOTE_IDENTIFIERS => false
   );

   $params = array(
       'host'           => '127.0.0.1',
       'username'       => 'webuser',
       'password'       => 'xxxxxxxx',
       'dbname'         => 'test',
       'options'        => $options
   );

   $db = Zend_Db::factory('Pdo_Mysql', $params);

.. _zend.db.adapter.connecting.parameters.example3:

.. rubric:: 팩토리에 PDP 드라이버 옵션 지정하기

.. code-block:: php
   :linenos:

   <?php
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

   $db = Zend_Db::factory('Pdo_Mysql', $params);

   echo $db->getConnection()->getAttribute(PDO::MYSQL_ATTR_USE_BUFFERED_QUERY);

.. _zend.db.adapter.connecting.getconnection:

접속 지연 관리하기
^^^^^^^^^^

Creating an instance of an Adapter class does not immediately connect to the RDBMS server. The Adapter saves the
connection parameters, and makes the actual connection on demand, the first time you need to execute a query. This
ensures that creating an Adapter object is quick and inexpensive. You can create an instance of an Adapter even if
you are not certain that you need to run any database queries during the current request your application is
serving.

If you need to force the Adapter to connect to the RDBMS, use the *getConnection()* method. This method returns an
object for the connection as represented by the respective PHP database extension. For example, if you use any of
the Adapter classes for PDO drivers, then *getConnection()* returns the PDO object, after initiating it as a live
connection to the specific database.

It can be useful to force the connection if you want to catch any exceptions it throws as a result of invalid
account credentials, or other failure to connect to the RDBMS server. These exceptions are not thrown until the
connection is made, so it can help simplify your application code if you handle the exceptions in one place,
instead of at the time of the first query against the database.

.. _zend.db.adapter.connecting.getconnection.example:

.. rubric:: 접속 예외 처리

.. code-block:: php
   :linenos:

   <?php
   try {
       $db = Zend_Db::factory('Pdo_Mysql', $parameters);
       $db->getConnection();
   } catch (Zend_Db_Adapter_Exception $e) {
       // perhaps a failed login credential, or perhaps the RDBMS is not running
   } catch (Zend_Exception $e) {
       // perhaps factory() failed to load the specified Adapter class
   }

.. _zend.db.adapter.example-database:

The example database
--------------------

In the documentation for Zend_Db classes, we use a set of simple tables to illustrate usage of the classes and
methods. These example tables could store information for tracking bugs in a software development project. The
database contains four tables:

- **accounts** stores information about each user of the bug-tracking database.

- **products** stores information about each product for which a bug can be logged.

- **bugs** stores information about bugs, including that current state of the bug, the person who reported the bug,
  the person who is assigned to fix the bug, and the person who is assigned to verify the fix.

- **bugs_products** stores a relationship between bugs and products. This implements a many-to-many relationship,
  because a given bug may be relevant to multiple products, and of course a given product can have multiple bugs.

The following SQL data definition language pseudocode describes the tables in this example database. These example
tables are used extensively by the automated unit tests for Zend_Db.

.. code-block:: php
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

You can run a SQL SELECT query and retrieve its results in one step using the *fetchAll()* method.

The first argument to this method is a string containing a SELECT statement. Alternatively, the first argument can
be an object of class :ref:`Zend_Db_Select <zend.db.select>`. The Adapter automatically converts this object to a
string representation of the SELECT statement.

The second argument to *fetchAll()* is an array of values to substitute for parameter placeholders in the SQL
statement.

.. _zend.db.adapter.select.fetchall.example:

.. rubric:: Using fetchAll()

.. code-block:: php
   :linenos:

   <?php
   $sql = 'SELECT * FROM bugs WHERE bug_id = ?';

   $result = $db->fetchAll($sql, 2);

.. _zend.db.adapter.select.fetch-mode:

Changing the Fetch Mode
^^^^^^^^^^^^^^^^^^^^^^^

By default, *fetchAll()* returns an array of rows, each of which is an associative array. The keys of the
associative array are the columns or column aliases named in the select query.

You can specify a different style of fetching results using the *setFetchMode()* method. The modes supported are
identified by constants:

- **Zend_Db::FETCH_ASSOC**: return data in an array of associative arrays. The array keys are column names, as
  strings. This is the default fetch mode for Zend_Db_Adapter classes.

  Note that if your select-list contains more than one column with the same name, for example if they are from two
  different tables in a JOIN, there can be only one entry in the associative array for a given name. If you use the
  FETCH_ASSOC mode, you should specify column aliases in your SELECT query to ensure that the names result in
  unique array keys.

  By default, these strings are returned as they are returned by the database driver. This is typically the
  spelling of the column in the RDBMS server. You can specify the case for these strings, using the
  *Zend_Db::CASE_FOLDING* option. Specify this when instantiating the Adapter. See :ref:`
  <zend.db.adapter.connecting.parameters.example1>`.

- **Zend_Db::FETCH_NUM**: return data in an array of arrays. The arrays are indexed by integers, corresponding to
  the position of the respective field in the select-list of the query.

- **Zend_Db::FETCH_BOTH**: return data in an array of arrays. The array keys are both strings as used in the
  FETCH_ASSOC mode, and integers as used in the FETCH_NUM mode. Note that the number of elements in the array is
  double that which would be in the array if you used iether FETCH_ASSOC or FETCH_NUM.

- **Zend_Db::FETCH_COLUMN**: return data in an array of values. The value in each array is the value returned by
  one column of the result set. By default, this is the first column, indexed by 0.

- **Zend_Db::FETCH_OBJ**: return data in an array of objects. The default class is the PHP built-in class stdClass.
  Columns of the result set are available as public properties of the object.

.. _zend.db.adapter.select.fetch-mode.example:

.. rubric:: Using setFetchMode()

.. code-block:: php
   :linenos:

   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAll('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result is an array of objects
   echo $result[0]->bug_description;

.. _zend.db.adapter.select.fetchassoc:

Fetching a Result Set as an Associative Array
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The *fetchAssoc()* method returns data in an array of associative arrays, regardless of what value you have set for
the fetch mode.

.. _zend.db.adapter.select.fetchassoc.example:

.. rubric:: Using fetchAssoc()

.. code-block:: php
   :linenos:

   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchAssoc('SELECT * FROM bugs WHERE bug_id = ?', 2);

   // $result is an array of associative arrays, in spite of the fetch mode
   echo $result[0]['bug_description'];

.. _zend.db.adapter.select.fetchcol:

Fetching a Single Column from a Result Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The *fetchCol()* method returns data in an array of values, regardless of the value you have set for the fetch
mode. This only returns the first column returned by the query. Any other columns returned by the query are
discarded. If you need to return a column other than the first, see :ref:`
<zend.db.statement.fetching.fetchcolumn>`.

.. _zend.db.adapter.select.fetchcol.example:

.. rubric:: Using fetchCol()

.. code-block:: php
   :linenos:

   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchCol('SELECT bug_description, bug_id FROM bugs WHERE bug_id = ?', 2);

   // contains bug_description; bug_id is not returned
   echo $result[0];

.. _zend.db.adapter.select.fetchpairs:

Fetching Key-Value Pairs from a Result Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The *fetchPairs()* method returns data in an array of key-value pairs, as an associative array with a single entry
per row. The key of this associative array is taken from the first column returned by the SELECT query. The value
is taken from the second column returned by the SELECT query. Any other columns returned by the query are
discarded.

You should design the SELECT query so that the first column returned has unique values. If there are duplicates
values in the first column, entries in the associative array will be overwritten.

.. _zend.db.adapter.select.fetchpairs.example:

.. rubric:: Using fetchPairs()

.. code-block:: php
   :linenos:

   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchPairs('SELECT bug_id, bug_status FROM bugs');

   echo $result[2];

.. _zend.db.adapter.select.fetchrow:

Fetching a Single Row from a Result Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The *fetchRow()* method returns data using the current fetch mode, but it returns only the first row fetched from
the result set.

.. _zend.db.adapter.select.fetchrow.example:

.. rubric:: Using fetchRow()

.. code-block:: php
   :linenos:

   <?php
   $db->setFetchMode(Zend_Db::FETCH_OBJ);

   $result = $db->fetchRow('SELECT * FROM bugs WHERE bug_id = 2');

   // note that $result is a single object, not an array of objects
   echo $result->bug_description;

.. _zend.db.adapter.select.fetchone:

Fetching a Single Scalar from a Result Set
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The *fetchOne()* method is like a combination of *fetchRow()* with *fetchCol()*, in that it returns data only for
the first row fetched from the result set, and it returns only the value of the first column in that row. Therefore
it returns only a single scalar value, not an array or an object.

.. _zend.db.adapter.select.fetchone.example:

.. rubric:: Using fetchOne()

.. code-block:: php
   :linenos:

   <?php
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

You can add new rows to a table in your database using the *insert()* method. The first argument is a string that
names the table, and the second argument is an associative array, mapping column names to data values.

.. _zend.db.adapter.write.insert.example:

.. rubric:: Inserting to a table

.. code-block:: php
   :linenos:

   <?php
   $data = array(
       'created_on'      => '2007-03-22',
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

Columns you exclude from the array of data are not specified to the database. Therefore, they follow the same rules
that an SQL INSERT statement follows: if the column has a DEFAULT clause, the column takes that value in the row
created, otherwise the column is left in a NULL state.

By default, the values in your data array are inserted using parameters. This reduces risk of some types of
security issues. You don't need to apply escaping or quoting to values in the data array.

You might need values in the data array to be treated as SQL expressions, in which case they should not be quoted.
By default, all data values passed as strings are treated as string literals. To specify that the value is an SQL
expression and therefore should not be quoted, pass the value in the data array as an object of type Zend_Db_Expr
instead of a plain string.

.. _zend.db.adapter.write.insert.example2:

.. rubric:: Inserting expressions to a table

.. code-block:: php
   :linenos:

   <?php
   $data = array(
       'created_on'      => new Zend_Db_Expr('CURDATE()'),
       'bug_description' => 'Something wrong',
       'bug_status'      => 'NEW'
   );

   $db->insert('bugs', $data);

.. _zend.db.adapter.write.lastinsertid:

Retrieving a Generated Value
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Some RDBMS brands support auto-incrementing primary keys. A table defined this way generates a primary key value
automatically during an INSERT of a new row. The return value of the *insert()* method is **not** the last inserted
ID, because the table might not have an auto-incremented column. Instead, the return value is the number of rows
affected (usually 1).

If your table is defined with an auto-incrementing primary key, you can call the *lastInsertId()* method after the
insert. This method returns the last value generated in the scope of the current database connection.

.. _zend.db.adapter.write.lastinsertid.example-1:

.. rubric:: Using lastInsertId() for an auto-increment key

.. code-block:: php
   :linenos:

   <?php
   $db->insert('bugs', $data);

   // return the last value generated by an auto-increment column
   $id = $db->lastInsertId();

Some RDBMS brands support a sequence object, which generates unique values to serve as primary key values. To
support sequences, the *lastInsertId()* method accepts two optional string arguments. These arguments name the
table and the column, assuming you have followed the convention that a sequence is named using the table and column
names for which the sequence generates values, and a suffix "\_seq". This is based on the convention used by
PostgreSQL when naming sequences for SERIAL columns. For example, a table "bugs" with primary key column "bug_id"
would use a sequence named "bugs_bug_id_seq".

.. _zend.db.adapter.write.lastinsertid.example-2:

.. rubric:: Using lastInsertId() for a sequence

.. code-block:: php
   :linenos:

   <?php
   $db->insert('bugs', $data);

   // return the last value generated by sequence 'bugs_bug_id_seq'.
   $id = $db->lastInsertId('bugs', 'bug_id');

   // alternatively, return the last value generated by sequence 'bugs_seq'.
   $id = $db->lastInsertId('bugs');

If the name of your sequence object does not follow this naming convention, use the *lastSequenceId()* method
instead. This method takes a single string argument, naming the sequence literally.

.. _zend.db.adapter.write.lastinsertid.example-3:

.. rubric:: Using lastSequenceId()

.. code-block:: php
   :linenos:

   <?php
   $db->insert('bugs', $data);

   // return the last value generated by sequence 'bugs_id_gen'.
   $id = $db->lastSequenceId('bugs_id_gen');

For RDBMS brands that don't support sequences, including MySQL, Microsoft SQL Server, and SQLite, the arguments to
the lastInsertId() method are ignored, and the value returned is the most recent value generated for any table by
INSERT operations during the current connection. For these RDBMS brands, the lastSequenceId() method always returns
*null*.

.. note::

   **Why not use "SELECT MAX(id) FROM table"?**

   Sometimes this query returns the most recent primary key value inserted into the table. However, this technique
   is not safe to use in an environment where multiple clients are inserting records to the database. It is
   possible, and therefore is bound to happen eventually, that another client inserts another row in the instant
   between the insert performed by your client application and your query for the MAX(id) value. Thus the value
   returned does not identify the row you inserted, it identifies the row inserted by some other client. There is
   no way to know when this has happened.

   Using a strong transaction isolation mode such as "repeatable read" can mitigate this risk, but some RDBMS
   brands don't support the transaction isolation required for this, or else your application may use a lower
   transaction isolation mode by design.

   Furthermore, using an expression like "MAX(id)+1" to generate a new value for a primary key is not safe, because
   two clients could do this query simultaneously, and then both use the same calculated value for their next
   INSERT operation.

   All RDBMS brands provide mechanisms to generate unique values, and to return the last value generated. These
   mechanisms necessarily work outside of the scope of transaction isolation, so there is no chance of two clients
   generating the same value, and there is no chance that the value generated by another client could be reported
   to your client's connection as the last value generated.

.. _zend.db.adapter.write.update:

Updating Data
^^^^^^^^^^^^^

You can update rows in a database table using the *update()* method of an Adapter. This method takes three
arguments: the first is the name of the table; the second is an associative array mapping columns to change to new
values to assign to these columns.

The values in the data array are treated as string literals. See :ref:` <zend.db.adapter.write.insert>` for
information on using SQL expressions in the data array.

The third argument is a string containing an SQL expression that is used as criteria for the rows to change. The
values and identifiers in this argument are not quoted or escaped. You are responsible for ensuring that any
dynamic content is interpolated into this string safely. See :ref:` <zend.db.adapter.quoting>` for methods to help
you do this.

The return value is the number of rows affected by the update operation.

.. _zend.db.adapter.write.update.example:

.. rubric:: Updating rows

.. code-block:: php
   :linenos:

   <?php
   $data = array(
       'updated_on'      => '2007-03-23',
       'bug_status'      => 'FIXED'
   );

   $n = $db->update('bugs', $data, 'bug_id = 2');

If you omit the third argument, then all rows in the database table are updated with the values specified in the
data array.

If you provide an array of strings as the third argument, these strings are joined together as terms in an
expression separated by *AND* operators.

.. _zend.db.adapter.write.update.example-array:

.. rubric:: Updating rows using an array of expressions

.. code-block:: php
   :linenos:

   <?php
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

You can delete rows from a database table using the *delete()* method. This method takes two arguments: the first
is a string naming the table.

The second argument is a string containing an SQL expression that is used as criteria for the rows to delete. The
values and identifiers in this argument are not quoted or escaped. You are responsible for ensuring that any
dynamic content is interpolated into this string safely. See :ref:` <zend.db.adapter.quoting>` for methods to help
you do this.

The return value is the number of rows affected by the delete operation.

.. _zend.db.adapter.write.delete.example:

.. rubric:: Deleting rows

.. code-block:: php
   :linenos:

   <?php
   $n = $db->delete('bugs', 'bug_id = 3');

If you omit the second argument, the result is that all rows in the database table are deleted.

If you provide an array of strings as the second argument, these strings are joined together as terms in an
expression separated by *AND* operators.

.. _zend.db.adapter.quoting:

Quoting Values and Identifiers
------------------------------

When you form SQL queries, often it is the case that you need to include the values of PHP variables in SQL
expressions. This is risky, because if the value in a PHP string contains certain symbols, such as the quote
symbol, it could result in invalid SQL. For example, notice the imbalanced quote characters in the following query:


   .. code-block:: php
      :linenos:

      $name = "O'Reilly";
      $sql = "SELECT * FROM bugs WHERE reported_by = '$name'";

      echo $sql;
      // SELECT * FROM bugs WHERE reported_by = 'O'Reilly'



Even worse is the risk that such code mistakes might be exploited deliberately by a person who is trying to
manipulate the function of your web application. If they can specify the value of a PHP variable through the use of
an HTTP parameter or other mechanism, they might be able to make your SQL queries do things that you didn't intend
them to do, such as return data to which the person should not have privilege to read. This is a serious and
widespread technique for violating application security, known as "SQL Injection" (see
`http://en.wikipedia.org/wiki/SQL_Injection`_).

The Zend_Db Adapter class provides convenient functions to help you reduce vulnerabilities to SQL Injection attacks
in your PHP code. The solution is to escape special characters such as quotes in PHP values before they are
interpolated into your SQL strings. This protects against both accidental and deliberate manipulation of SQL
strings by PHP variables that contain special characters.

.. _zend.db.adapter.quoting.quote:

Using quote()
^^^^^^^^^^^^^

The *quote()* method accepts a single argument, a scalar string value. It returns the value with special characters
escaped in a manner appropriate for the RDBMS you are using, and surrounded by string value delimiters. The
standard SQL string value delimiter is the single-quote (*'*).

.. _zend.db.adapter.quoting.quote.example:

.. rubric:: Using quote()

.. code-block:: php
   :linenos:

   <?php
   $name = $db->quote("O'Reilly");
   echo $name;
   // 'O\'Reilly'

   $sql = "SELECT * FROM bugs WHERE reported_by = $name";

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

Note that the return value of *quote()* includes the quote delimiters around the string. This is different from
some functions that escape special characters but do not add the quote delimiters, for example
`mysql_real_escape_string()`_.

Values may need to be quoted or not quoted according to the SQL datatype context in which they are used. For
instance, in some RDBMS brands, an integer value must not be quoted as a string if it is compared to an
integer-type column or expression. In other words, the following is an error in some SQL implementations, assuming
*intColumn* has a SQL datatype of *INTEGER*

   .. code-block:: php
      :linenos:

      SELECT * FROM atable WHERE intColumn = '123'



You can use the optional second argument to the *quote()* method to apply quoting selectively for the SQL datatype
you specify.

.. _zend.db.adapter.quoting.quote.example-2:

.. rubric:: Using quote() with a SQL type

.. code-block:: php
   :linenos:

   <?php
   $value = '1234';
   $sql = 'SELECT * FROM atable WHERE intColumn = '
        . $db->quoteType($value, 'INTEGER');


Each Zend_Db_Adapter class has encoded the names of numeric SQL datatypes for the respective brand of RDBMS. You
can also use the constants *Zend_Db::INT_TYPE*, *Zend_Db::BIGINT_TYPE*, and *Zend_Db::FLOAT_TYPE* to write code in
a more RDBMS-independent way.

Zend_Db_Table specifies SQL types to *quote()* automatically when generating SQL queries that reference a table's
key columns.

.. _zend.db.adapter.quoting.quote-into:

Using quoteInto()
^^^^^^^^^^^^^^^^^

The most typical usage of quoting is to interpolate a PHP variable into a SQL expression or statement. You can use
the *quoteInto()* method to do this in one step. This method takes two arguments: the first argument is a string
containing a placeholder symbol (*?*), and the second argument is a value or PHP variable that should be
substituted for that placeholder.

The placeholder symbol is the same symbol used by many RDBMS brands for positional parameters, but the
*quoteInto()* method only emulates query parameters. The method simply interpolates the value into the string,
escapes special characters, and applies quotes around it. True query parameters maintain the separation between the
SQL string and the parameters as the statement is parsed in the RDBMS server.

.. _zend.db.adapter.quoting.quote-into.example:

.. rubric:: Using quoteInto()

.. code-block:: php
   :linenos:

   <?php
   $sql = $db->quoteInto("SELECT * FROM bugs WHERE reported_by = ?", "O'Reilly");

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 'O\'Reilly'

You can use the optional third parameter of *quoteInto()* to specify the SQL datatype. Numeric datatypes are not
quoted, and other types are quoted.

.. _zend.db.adapter.quoting.quote-into.example-2:

.. rubric:: Using quoteInto() with a SQL type

.. code-block:: php
   :linenos:

   <?php
   $sql = $db->quoteInto("SELECT * FROM bugs WHERE bug_id = ?", '1234', 'INTEGER');

   echo $sql;
   // SELECT * FROM bugs WHERE reported_by = 1234

.. _zend.db.adapter.quoting.quote-identifier:

Using quoteIdentifier()
^^^^^^^^^^^^^^^^^^^^^^^

Values are not the only part of SQL syntax that might need to be variable. If you use PHP variables to name tables,
columns, or other identifiers in your SQL statements, you might need to quote these strings too. By default, SQL
identifiers have syntax rules like PHP and most other programming languages. For example, identifiers should not
contain spaces, certain punctuation or special characters, or international characters. Also certain words are
reserved for SQL syntax, and should not be used as identifiers.

However, SQL has a feature called **delimited identifiers**, which allows broader choices for the spelling of
identifiers. If you enclose a SQL identifier in the proper types of quotes, you can use identifiers with spellings
that would be invalid without the quotes. Delimited identifiers can contain spaces, punctuation, or international
characters. You can also use SQL reserved words if you enclose them in identifier delimiters.

The *quoteIdentifier()* method works like *quote()*, but it applies the identifier delimiter characters to the
string according to the type of Adapter you use. For example, standard SQL uses double-quotes (*"*) for identifier
delimiters, and most RDBMS brands use that symbol. MySQL uses back-quotes (*`*) by default. The *quoteIdentifier()*
method also escapes special characters within the string argument.

.. _zend.db.adapter.quoting.quote-identifier.example:

.. rubric:: Using quoteIdentifier()

.. code-block:: php
   :linenos:

   <?php
   // we might have a table name that is an SQL reserved word
   $tableName = $db->quoteIdentifier("order");

   $sql = "SELECT * FROM $tableName";

   echo $sql
   // SELECT * FROM "order"

SQL delimited identifiers are case-sensitive, unlike unquoted identifiers. Therefore, if you use delimited
identifiers, you must use the spelling of the identifier exactly as it is stored in your schema, including the case
of the letters.

In most cases where SQL is generated within Zend_Db classes, the default is that all identifiers are delimited
automatically. You can change this behavior with the option *Zend_Db::AUTO_QUOTE_IDENTIFIERS*. Specify this when
instantiating the Adapter. See :ref:` <zend.db.adapter.connecting.parameters.example2>`.

.. _zend.db.adapter.transactions:

Controlling Database Transactions
---------------------------------

Databases define transactions as logical units of work that can be committed or rolled back as a single change,
even if they operate on multiple tables. All queries to a database are executed within the context of a
transaction, even if the database driver manages them implicitly. This is called **auto-commit** mode, in which the
database driver creates a transaction for every statement you execute, and commits that transaction after your SQL
statement has been executed. By default, all Zend_Db Adapter classes operate in auto-commit mode.

Alternatively, you can specify the beginning and resolution of a transaction, and thus control how many SQL queries
are included in a single group that is committed (or rolled back) as a single operation. Use the
*beginTransaction()* method to initiate a transaction. Subsequent SQL statements are executed in the context of the
same transaction until you resolve it explicitly.

To resolve the transaction, use either the *commit()* or *rollBack()* methods. The *commit()* method marks changes
made during your transaction as committed, which means the effects of these changes are shown in queries run in
other transactions.

The *rollBack()* method does the opposite: it discards the changes made during your transaction. The changes are
effectively undone, and the state of the data returns to how it was before you began your transaction. However,
rolling back your transaction has no effect on changes made by other transactions running concurrently.

After you resolve this transaction, *Zend_Db_Adapter* returns to auto-commit mode until you call
*beginTransaction()* again.

.. _zend.db.adapter.transactions.example:

.. rubric:: Managing a transaction to ensure consistency

.. code-block:: php
   :linenos:

   <?php
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

The *listTables()* method returns an array of strings, naming all tables in the current database.

The *describeTable()* method returns an associative array of metadata about a table. Specify the name of the table
as a string in the first argument to this method. The second argument is optional, and names the schema in which
the table exists.

The keys of the associative array returned are the column names of the table. The value corresponding to each
column is also an associative array, with the following keys and values:

.. _zend.db.adapter.list-describe.metadata:

.. table:: Metadata fields returned by describeTable()

   +----------------+---------+------------------------------------------------------------------------------------+
   |Key             |Type     |Description                                                                         |
   +================+=========+====================================================================================+
   |SCHEMA_NAME     |(string) |Name of the database schema in which this table exists.                             |
   +----------------+---------+------------------------------------------------------------------------------------+
   |TABLE_NAME      |(string) |Name of the table to which this column belongs.                                     |
   +----------------+---------+------------------------------------------------------------------------------------+
   |COLUMN_NAME     |(string) |Name of the column.                                                                 |
   +----------------+---------+------------------------------------------------------------------------------------+
   |COLUMN_POSITION |(integer)|Ordinal position of the column in the table.                                        |
   +----------------+---------+------------------------------------------------------------------------------------+
   |DATA_TYPE       |(string) |RDBMS name of the datatype of the column.                                           |
   +----------------+---------+------------------------------------------------------------------------------------+
   |DEFAULT         |(string) |Default value for the column, if any.                                               |
   +----------------+---------+------------------------------------------------------------------------------------+
   |NULLABLE        |(boolean)|True if the column accepts SQL NULLs, false if the column has a NOT NULL constraint.|
   +----------------+---------+------------------------------------------------------------------------------------+
   |LENGTH          |(integer)|Length or size of the column as reported by the RDBMS.                              |
   +----------------+---------+------------------------------------------------------------------------------------+
   |SCALE           |(integer)|Scale of SQL NUMERIC or DECIMAL type.                                               |
   +----------------+---------+------------------------------------------------------------------------------------+
   |PRECISION       |(integer)|Precision of SQL NUMERIC or DECIMAL type.                                           |
   +----------------+---------+------------------------------------------------------------------------------------+
   |UNSIGNED        |(boolean)|True if an integer-based type is reported as UNSIGNED.                              |
   +----------------+---------+------------------------------------------------------------------------------------+
   |PRIMARY         |(boolean)|True if the column is part of the primary key of this table.                        |
   +----------------+---------+------------------------------------------------------------------------------------+
   |PRIMARY_POSITION|(integer)|Ordinal position (1-based) of the column in the primary key.                        |
   +----------------+---------+------------------------------------------------------------------------------------+
   |IDENTITY        |(boolean)|True if the column uses an auto-generated value.                                    |
   +----------------+---------+------------------------------------------------------------------------------------+

If no table exists matching the table name and optional schema name specified, then *describeTable()* returns an
empty array.

.. _zend.db.adapter.closing:

Closing a Connection
--------------------

Normally it is not necessary to close a database connection. PHP automatically cleans up all resources and the end
of a request. Database extensions are designed to close the connection as the reference to the resource object is
cleaned up.

However, if you have a long-duration PHP script that initiates many database connections, you might need to close
the connection, to avoid exhausting the capacity of your RDBMS server. You can use the Adapter's
*closeConnection()* method to explicitly close the underlying database connection.

.. _zend.db.adapter.closing.example:

.. rubric:: Closing a database connection

.. code-block:: php
   :linenos:

   <?php
   $db->closeConnection();

.. note::

   **Does Zend_Db support persistent connections?**

   The usage of persistent connections is not supported or encouraged in Zend_Db.

   Using persistent connections can cause an excess of idle connections on the RDBMS server, which causes more
   problems than any performance gain you might achieve by reducing the overhead of making connections.

   Database connections have state. That is, some objects in the RDBMS server exist in session scope. Examples are
   locks, user variables, temporary tables, and information about the most recently executed query, such as rows
   affected, and last generated id value. If you use persistent connections, your application could access invalid
   or privileged data that were created in a previous PHP request.

.. _zend.db.adapter.other-statements:

Running Other Database Statements
---------------------------------

There might be cases in which you need to access the connection object directly, as provided by the PHP database
extension. Some of these extensions may offer features that are not surfaced by methods of
Zend_Db_Adapter_Abstract.

For example, all SQL statements run by Zend_Db are prepared, then executed. However, some database features are
incompatible with prepared statements. DDL statements like CREATE and ALTER cannot be prepared in MySQL. Also, SQL
statements don't benefit from the `MySQL Query Cache`_, prior to MySQL 5.1.17.

Most PHP database extensions provide a method to execute SQL statements without preparing them. For example, in
PDO, this method is *exec()*. You can access the connection object in the PHP extension directly using
getConnection().

.. _zend.db.adapter.other-statements.example:

.. rubric:: Running a non-prepared statement in a PDO adapter

.. code-block:: php
   :linenos:

   <?php
   $result = $db->getConnection()->exec('DROP TABLE bugs');

Similarly, you can access other methods or properties that are specific to PHP database extensions. Be aware,
though, that by doing this you might constrain your application to the interface provided by the extension for a
specific brand of RDBMS.

In future versions of Zend_Db, there will be opportunities to add method entry points for functionality that is
common to the supported PHP database extensions. This will not affect backward compatibility.

.. _zend.db.adapter.adapter-notes:

Notes on Specific Adapters
--------------------------

This section lists differences between the Adapter classes of which you should be aware.

.. _zend.db.adapter.adapter-notes.ibm-db2:

IBM DB2
^^^^^^^

- Specify this Adapter to the factory() method with the name 'Db2'.

- This Adapter uses the PHP extension ibm_db2.

- IBM DB2 supports both sequences and auto-incrementing keys. Therefore the arguments to *lastInsertId()* are
  optional. If you give no arguments, the Adapter returns the last value generated for an auto-increment key. If
  you give arguments, the Adapter returns the last value generated by the sequence named according to the
  convention '**table**\ _ **column**\ _seq'.

.. _zend.db.adapter.adapter-notes.mysqli:

MySQLi
^^^^^^

- Specify this Adapter to the *factory()* method with the name 'Mysqli'.

- This Adapter utilizes the PHP extension mysqli.

- MySQL does not support sequences, so *lastInsertId()* ignores its arguments and always returns the last value
  generated for an auto-increment key. The *lastSequenceId()* method returns *null*.

.. _zend.db.adapter.adapter-notes.oracle:

Oracle
^^^^^^

- Specify this Adapter to the *factory()* method with the name 'Oracle'.

- This Adapter uses the PHP extension oci8.

- Oracle does not support auto-incrementing keys, so you should specify the name of a sequence to *lastInsertId()*
  or *lastSequenceId()*.

- The Oracle extension does not support positional parameters. You must use named parameters.

- Currently the *Zend_Db::CASE_FOLDING* option is not supported by the Oracle adapter. To use this option with
  Oracle, you must use the PDO OCI adapter.

.. _zend.db.adapter.adapter-notes.pdo-mssql:

PDO Microsoft SQL Server
^^^^^^^^^^^^^^^^^^^^^^^^

- Specify this Adapter to the *factory()* method with the name 'Pdo_Mssql'.

- This Adapter uses the PHP extensions pdo and pdo_mssql.

- Microsoft SQL Server does not support sequences, so *lastInsertId()* ignores its arguments and always returns the
  last value generated for an auto-increment key. The *lastSequenceId()* method returns *null*.

- Zend_Db_Adapter_Pdo_Mssql sets *QUOTED_IDENTIFIER ON* immediately after connecting to a SQL Server database. This
  makes the driver use the standard SQL identifier delimiter symbol (*"*) instead of the proprietary
  square-brackets syntax SQL Server uses for delimiting identifiers.

- You can specify *pdoType* as a key in the options array. The value can be "mssql" (the default), "dblib",
  "freetds", or "sybase". This option affects the DSN prefix the adapter uses when constructing the DSN string.
  Both "freetds" and "sybase" imply a prefix of "sybase:", which is used for the `FreeTDS`_ set of libraries. See
  also `http://www.php.net/manual/en/ref.pdo-dblib.connection.php`_ for more information on the DSN prefixes used
  in this driver.

.. _zend.db.adapter.adapter-notes.pdo-mysql:

PDO MySQL
^^^^^^^^^

- Specify this Adapter to the *factory()* method with the name 'Pdo_Mysql'.

- This Adapter uses the PHP extensions pdo and pdo_mysql.

- MySQL does not support sequences, so *lastInsertId()* ignores its arguments and always returns the last value
  generated for an auto-increment key. The *lastSequenceId()* method returns *null*.

.. _zend.db.adapter.adapter-notes.pdo-oci:

PDO Oracle
^^^^^^^^^^

- Specify this Adapter to the *factory()* method with the name 'Pdo_Oci'.

- This Adapter uses the PHP extensions pdo and pdo_oci.

- Oracle does not support auto-incrementing keys, so you should specify the name of a sequence to *lastInsertId()*
  or *lastSequenceId()*.

.. _zend.db.adapter.adapter-notes.pdo-pgsql:

PDO PostgreSQL
^^^^^^^^^^^^^^

- Specify this Adapter to the *factory()* method with the name 'Pdo_Pgsql'.

- This Adapter uses the PHP extensions pdo and pdo_pgsql.

- PostgreSQL supports both sequences and auto-incrementing keys. Therefore the arguments to *lastInsertId()* are
  optional. If you give no arguments, the Adapter returns the last value generated for an auto-increment key. If
  you give arguments, the Adapter returns the last value generated by the sequence named according to the
  convention '**table**\ _ **column**\ _seq'.

.. _zend.db.adapter.adapter-notes.pdo-sqlite:

PDO SQLite
^^^^^^^^^^

- Specify this Adapter to the *factory()* method with the name 'Pdo_Sqlite'.

- This Adapter uses the PHP extensions pdo and pdo_sqlite.

- SQLite does not support sequences, so *lastInsertId()* ignores its arguments and always returns the last value
  generated for an auto-increment key. The *lastSequenceId()* method returns *null*.

- To connect to an SQLite2 database, specify *'dsnprefix'=>'sqlite2'* in the array of parameters when creating an
  instance of the Pdo_Sqlite Adapter.

- To connect to an in-memory SQLite database, specify *'dbname'=>':memory:'* in the array of parameters when
  creating an instance of the Pdo_Sqlite Adapter.

- Older versions of the SQLite driver for PHP do not seem to support the PRAGMA commands necessary to ensure that
  short column names are used in result sets. If you have problems that your result sets are returned with keys of
  the form "tablename.columnname" when you do a join query, then you should upgrade to the current version of PHP.



.. _`PHP Data Objects`: http://www.php.net/pdo
.. _`mysqli`: http://www.php.net/mysqli
.. _`oci8`: http://www.php.net/oci8
.. _`ibm_db2`: http://www.php.net/ibm_db2
.. _`http://en.wikipedia.org/wiki/SQL_Injection`: http://en.wikipedia.org/wiki/SQL_Injection
.. _`mysql_real_escape_string()`: http://www.php.net/mysqli_real_escape_string
.. _`MySQL Query Cache`: http://dev.mysql.com/doc/refman/5.1/en/query-cache-how.html
.. _`FreeTDS`: http://www.freetds.org/
.. _`http://www.php.net/manual/en/ref.pdo-dblib.connection.php`: http://www.php.net/manual/en/ref.pdo-dblib.connection.php
