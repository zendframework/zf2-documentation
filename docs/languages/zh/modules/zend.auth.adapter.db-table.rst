.. _zend.auth.adapter.dbtable:

数据库表认证
==================

.. _zend.auth.adapter.dbtable.introduction:

简介
------

*Zend_Auth_Adapter_DbTable*\ 提供依靠存储在数据库表中的证书来认证的能力。因为
*Zend_Auth_Adapter_DbTable*\ 需要 *Zend_Db_Adapter_Abstract*\
的实例来传递给它的构造器，所以每个实例要和特定的数据库连接绑定。其它配置选项可以通过构造器和实例方法设置，每个选项有一个配置。

可用的配置选项包括：

   - *tableName*: 包含认证证书的数据库表名，执行数据库认证查询需要依靠这个证书。

   - *identityColumn*:
     数据库表的列的名称，用来表示身份。身份列必须包含唯一的值，例如用户名或者e-mail地址。

   - *credentialColumn*:
     数据库表的列的名称，用来表示证书。在一个简单的身份和密码认证scheme下，证书的值对应为密码。参见
     *credentialTreatment* 选项。

   - *credentialTreatment*: 在许多情况下，密码和其他敏感数据是加密的（encrypted, hashed,
     encoded, obscured,salted
     或者通过以下函数或算法来加工）。通过指定参数化的字串来使用这个方法，例如
     *'MD5(?)'* 或者 *'PASSWORD(?)'*\
     ，开发者可以在输入证书数据时使用任意的SQL。因为这些函数对其下面的RDBMS是专用的，
     请查看数据库手册来确保你所用的数据库的函数的可用性。



.. _zend.auth.adapter.dbtable.introduction.example.basic_usage:

.. rubric:: 基本用法

正如在简介中所解释的， *Zend_Auth_Adapter_DbTable*\ 构造器需要一个 *Zend_Db_Adapter_Abstract*\
的实例，这个实例用做数据库连结，并且认证适配器实例绑定到这个数据库连接。首先，应该创建数据库连接。

下面的代码为in-memory数据库创建一个适配器，创建一个简单的表schema，并插入我们将来可以执行认证查询的一行（数据）。这个例子需要PDO
SQLite extension可用：

.. code-block::
   :linenos:

   // 创建一个 in-memory SQLite 数据库连接
   $dbAdapter = new Zend_Db_Adapter_Pdo_Sqlite(array('dbname' =>
                                                     ':memory:'));

   // 构造一个简单表的创建语句
   $sqlCreate = 'CREATE TABLE [users] ('
              . '[id] INTEGER  NOT NULL PRIMARY KEY, '
              . '[username] VARCHAR(50) UNIQUE NOT NULL, '
              . '[password] VARCHAR(32) NULL, '
              . '[real_name] VARCHAR(150) NULL)';

   // 创建认证证书表
   $dbAdapter->query($sqlCreate);

   // 构造用来插入一行可以成功认证的数据的语句
   $sqlInsert = "INSERT INTO users (username, password, real_name) "
              . "VALUES ('my_username', 'my_password', 'My Real Name')";

   // 插入数据
   $dbAdapter->query($sqlInsert);


随着数据库连接和表数据已经可用， *Zend_Auth_Adapter_DbTable*\
可以被创建。配置选项的值可以传递给构造器或者延后在实例化以后用做setter方法的参数:

.. code-block::
   :linenos:

   // 用构造器参数来配置实例...
   $authAdapter = new Zend_Auth_Adapter_DbTable(
       $dbAdapter,
       'users',
       'username',
       'password'
   );

   // 用构造器参数来配置实例...
   $authAdapter = new Zend_Auth_Adapter_DbTable($dbAdapter);

   $authAdapter
       ->setTableName('users')
       ->setIdentityColumn('username')
       ->setCredentialColumn('password')
   ;


在这点上，认证适配器实例已经可以接受认证查询。为了合成一个认证查询，在调用
*authenticate()*\ 方法之前，输入的证书的值要传递给适配器：

.. code-block::
   :linenos:

   // 设置输入的证书的值（例如，从登陆的表单）
   $authAdapter
       ->setIdentity('my_username')
       ->setCredential('my_password')
   ;

   // 执行认证查询，并保存结果
   $result = $authAdapter->authenticate();


除了基于认证结果对象的 *getIdentity()* 方法的可用性之外， *Zend_Auth_Adapter_DbTable*\
也支持从认证成功的表中读取一行数据：

.. code-block::
   :linenos:

   // 输出身份
   echo $result->getIdentity() . "\n\n";

   // 输出结果行
   print_r($authAdapter->getResultRowObject());

   /* Output:
   my_username

   Array
   (
       [id] => 1
       [username] => my_username
       [password] => my_password
       [real_name] => My Real Name
   )
   */


因为表行里包含证书值，通过防止无意识地访问来安全化这个值很重要。

.. _zend.auth.adapter.dbtable.advanced.storing_result_row:

高级使用：持久一个 DbTable 结果对象
------------------------------------------------

缺省地，基于成功的认证 *Zend_Auth_Adapter_DbTable*
返回提供给auth对象的身份。对于其他用例情景，如开发者想给 *Zend_Auth*
的持久存储机制存储一个包括其他有用信息的身份对象，已经通过使用
*getResultRowObject()* 方法返回一个 *stdClass*\
对象解决了。下面的代码片段举例说明它的用法：

.. code-block::
   :linenos:

   // authenticate with Zend_Auth_Adapter_DbTable
   $result = $this->_auth->authenticate($adapter);

   if ($result->isValid()) {
       // store the identity as an object where only the username and
       //real_name have been returned
       $storage = $this->_auth->getStorage();
       $storage->write($adapter->getResultRowObject(array(
           'username',
           'real_name',
       )));

       // store the identity as an object where the password column has
       // been omitted
       $storage->write($adapter->getResultRowObject(
           null,
           'password'
       ));

       /* ... */

   } else {

       /* ... */

   }


.. _zend.auth.adapter.dbtable.advanced.advanced_usage:

高级用法范例
------------------

虽然 Zend_Auth （和它的继承者 Zend_Auth_Adapter_DbTable ）主要用来 **认证** 而不是 **授权**
，但是基于它们用在哪个域名下，还是有一些实例和问题。根据如何解释你的问题，有时候通过在认证适配器里检查授权问题也许能解决问题。

用一点不恰当的免责声明，Zend_Auth_Adapter_DbTable
有内建的机制可以用来利用添加另外的认证时的检查来解决一些普通的用户问题。

.. code-block::
   :linenos:

   // The status field value of an account is not equal to "compromised"
   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND status != "compromised"'
   );

   // The active field value of an account is equal to "TRUE"
   $adapter = new Zend_Auth_Adapter_DbTable(
       $db,
       'users',
       'username',
       'password',
       'MD5(?) AND active = "TRUE"'
   );


另外一个场景是免疫机制的实现。免疫是指大幅提高程序安全的技术术语。
它的想法是基于连接随机字符串到每个密码来使从字典里预先计算好的哈希值来完成强力攻击数据库成为可能。

因此我们需要修改表来存储免疫的字符串：

.. code-block::
   :linenos:

   $sqlAlter = "ALTER TABLE [users] "
             . "ADD COLUMN [password_salt] "
             . "AFTER [password]";

   $dbAdapter->query($sqlAlter);


这里是在注册时给每个用户生成免疫字符串的简单的方法：

.. code-block::
   :linenos:

   for ($i = 0; $i < 50; $i++)
   {
       $dynamicSalt .= chr(rand(33, 126));
   }


构造适配器：

.. code-block::
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

   你可以通过使用静态免疫值硬编码到程序里来更好地改善安全问题。
   万一你的数据库有安全隐患（例如 SQL 注入攻击），但你的 web 服务器
   依然完整，攻击者仍得不到你的数据。


