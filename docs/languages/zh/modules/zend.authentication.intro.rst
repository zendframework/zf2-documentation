.. EN-Revision: none
.. _zend.authentication.introduction:

简介
==

Zend_Auth 为认证（authentication）和一些通用用例情景的具体认证适配器提供了一个API。

Zend_Auth 只涉及 **认证**\ 而不是 **授权**\
。认证被宽松地定义为基于一些证书（credential）来确定一个实体（例如，身份）是否确实是它所声称的。授权是一个过程，它决定是否允许一个实体对其他实体进行访问、执行操作，它超出了Zend_Auth的范围。更多关于Zend
Framework 授权和访问控制的信息，参见 :ref:`Zend\Permissions\Acl <zend.permissions.acl>`.

.. note::

   *Zend_Auth* 类通过它的 *getInstance()*\ 方法实现 Singleton 模式 -
   只有一个实例可用。这意味着使用 *new*\ 操作符和 *clone* 关键字将不能在 *Zend_Auth*
   类中工作，而要使用 *Zend_Auth::getInstance()*\ 来代替。

.. _zend.authentication.introduction.adapters:

适配器
---

Zend_Auth适配器被用来依靠特定的认证服务（例如LDAP、RDBMS或基于文件的存储）来认证。不同的适配器可能有不同的选项和行为，但有些基本的事情在认证适配器中是通用的。例如，接受认证证书（包括声称身份）、依靠认证服务执行查询、返回结果在Zend_Auth适配器中是通用的。

每个Zend_Auth适配器类都实现 *Zend_Auth_Adapter_Interface*\ 。这个接口定义了一个方法
*authenticate()*\ ，适配器必须为执行认证查询而实现它。在调用 *authenticate()*\
之前，每个适配器必需准备就绪。这样适配器准备包括设置证书（例如，用户名和密码）并为适配器专用的配置选项定义一些值，例如为数据库表适配器做的连接设置。

下面是一个认证适配器的例子，它要求为认证设置用户名和密码。为简明扼要，其它的细节（如查询认证服务）被省略了。


   .. code-block:: php
      :linenos:

      class MyAuthAdapter implements Zend_Auth_Adapter_Interface
      {
          /**
           * Sets username and password for authentication
           *
           * @return void
           */
          public function __construct($username, $password)
          {
              // ...
          }

          /**
           * Performs an authentication attempt
           *
           * @throws Zend_Auth_Adapter_Exception If authentication cannot
           *                                     be performed
           * @return Zend_Auth_Result
           */
          public function authenticate()
          {
              // ...
          }
      }


如上面所示， *authenticate()*\ 必需返回一个 *Zend_Auth_Result*\ 的实例（或从 *Zend_Auth_Result*\
派生的一个类的实例）。如果因为某些原因认证查询不能执行， *authenticate()*\
应该抛出一个由 *Zend_Auth_Adapter_Exception*\ 产生的异常。

.. _zend.authentication.introduction.results:

结果
--

为了表示一个认证尝试的结果，Zend_Auth适配器返回一个带有 *authenticate()*\ 的
*Zend_Auth_Result*\ 的实例。适配器基于结构组成 *Zend_Auth_Result*\
对象，下面四个方法提供了一组基本的用户面临的通用Zend_Auth适配器结果的操作：

   - *isValid()*- 返回 true 当且仅当结果表示一个成功的认证尝试

   - *getCode()*- 返回一个 *Zend_Auth_Result*
     常量标识符用来决定认证失败的类型或者是否认证成功。这个可以用于开发者希望区别若干认证结果类型的情形，例如，这允许开发者维护详细的认证结果统计。尽管开发这被鼓励去考虑提供这样详细的原因给用户的风险，替而代之使用一般的认证失败信息，这个功能的其它用法是由于可用性的原因提供专用的，定制的信息给用户。更多的信息，参见下面的注释。

   - *getIdentity()*- 返回认证尝试的身份

   - *getMessages()*- 返回关于认证尝试失败的数组



为了执行更多的操作，开发者可能希望基于认证结果的类型来分支化。一些开发者可能发信有用的操作是：在太多的不成功的密码尝试之后锁住帐号，在太多不存在的身份尝试后标记IP地址，并提供专用的，定制的认证结果信息给用户。下面的结果代码是可用的：


   .. code-block:: php
      :linenos:

      Zend_Auth_Result::SUCCESS
      Zend_Auth_Result::FAILURE
      Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND
      Zend_Auth_Result::FAILURE_IDENTITY_AMBIGUOUS
      Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID
      Zend_Auth_Result::FAILURE_UNCATEGORIZED




下面的例子举例说明开发者如何分支化结果代码：

   .. code-block:: php
      :linenos:

      // inside of AuthController / loginAction
      $result = $this->_auth->authenticate($adapter);

      switch ($result->getCode()) {

          case Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND:
              /** do stuff for nonexistent identity **/
              break;

          case Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID:
              /** do stuff for invalid credential **/
              break;

          case Zend_Auth_Result::SUCCESS:
              /** do stuff for successful authentication **/
              break;

          default:
              /** do stuff for other failure **/
              break;
      }




.. _zend.authentication.introduction.persistence:

身份的持久（Persistence）
------------------

实质上，认证一个包含认证证书的请求很有用，但是维护已认证的身份并在每次请求时不需要出示认证证书也同样很重要。

HTTP是一个无连接的协议，然而，象cookie和session这样的技术已经被开发出来使在服务器端的web应用维护多请求状态变得容易。

.. _zend.authentication.introduction.persistence.default:

在PHP Session 中的缺省持久（Persistence）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

缺省地， *Zend_Auth*\ 从使用PHP
session成功的认证尝试中提供身份的持久存储。基于一个成功的认证尝试，
*Zend_Auth::authenticate()*\ 通过把认证结果放入持久存储中来保存身份。除非另有配置，
*Zend_Auth* 使用名称为 *Zend_Auth_Storage_Session* 的存储类，这个类使用 :ref:`Zend_Session
<zend.session>`\ 。通过实现 *Zend_Auth_Storage_Interface*\ 给 *Zend_Auth::setStorage()*\
提供一个对象，一个定制的类可以被替代使用。

.. note::

   对于特定的用例，如果身份的持久存储不合适，开发者可以放弃使用 *Zend_Auth*\
   类，替代地，而直接使用适配器类。

.. _zend.authentication.introduction.persistence.default.example:

.. rubric:: 修改 Session 名字空间

*Zend_Auth_Storage_Session*\ 使用 *'Zend_Auth'*\ 的seesion名字空间。通过给 *Zend_Auth_Storage_Session*\
的构造器传递不同的值，这个名字空间可以被替换，并且这个值被从内部传递给
*Zend_Session_Namespace*\ 的构造器。这应该发生在认证尝试之前，因为 *Zend_Auth::authenticate()*\
执行身份的自动存储。

   .. code-block:: php
      :linenos:

      // Save a reference to the Singleton instance of Zend_Auth
      $auth = Zend_Auth::getInstance();

      // Use 'someNamespace' instead of 'Zend_Auth'
      $auth->setStorage(new Zend_Auth_Storage_Session('someNamespace'));

      /**
       * @todo Set up the auth adapter, $authAdapter
       */

      // Authenticate, saving the result, and persisting the identity on
      // success
      $result = $auth->authenticate($authAdapter);




.. _zend.authentication.introduction.persistence.custom:

实现订制存储
^^^^^^

有时候开发者需要使用不同的身份持久行为，而不是 *Zend_Auth_Storage_Session*\
提供的。对于这样的案例开发者可以简单地实现 *Zend_Auth_Storage_Interface*\ 并给
*Zend_Auth::setStorage()*\ 提供一个类的实例。

.. _zend.authentication.introduction.persistence.custom.example:

.. rubric:: 使用定制存储类

为了使用不同于 *Zend_Auth_Storage_Session*\ 的身份之久存储类，开发者可实现
*Zend_Auth_Storage_Interface*\ ：

   .. code-block:: php
      :linenos:

      class MyStorage implements Zend_Auth_Storage_Interface
      {
          /**
           * Returns true if and only if storage is empty
           *
           * @throws Zend_Auth_Storage_Exception If it is impossible to
           *                                     determine whether storage
           *                                     is empty
           * @return boolean
           */
          public function isEmpty()
          {
              /**
               * @todo implementation
               */
          }

          /**
           * Returns the contents of storage
           *
           * Behavior is undefined when storage is empty.
           *
           * @throws Zend_Auth_Storage_Exception If reading contents from
           *                                     storage is impossible
           * @return mixed
           */
          public function read()
          {
              /**
               * @todo implementation
               */
          }

          /**
           * Writes $contents to storage
           *
           * @param  mixed $contents
           * @throws Zend_Auth_Storage_Exception If writing $contents to
           *                                     storage is impossible
           * @return void
           */
          public function write($contents)
          {
              /**
               * @todo implementation
               */
          }

          /**
           * Clears contents from storage
           *
           * @throws Zend_Auth_Storage_Exception If clearing contents from
           *                                     storage is impossible
           * @return void
           */
          public function clear()
          {
              /**
               * @todo implementation
               */
          }
      }




为了使用这个定制的存储类，在认证查询被尝试前， *Zend_Auth::setStorage()*\ 被调用：

   .. code-block:: php
      :linenos:

      // Instruct Zend_Auth to use the custom storage class
      Zend_Auth::getInstance()->setStorage(new MyStorage());

      /**
       * @todo Set up the auth adapter, $authAdapter
       */

      // Authenticate, saving the result, and persisting the identity on
      // success
      $result = Zend_Auth::getInstance()->authenticate($authAdapter);




.. _zend.authentication.introduction.using:

使用Zend_Auth
-----------

这里提供了两种方法使用Zend_Auth适配器：

   . 非直接地，通过 *Zend_Auth::authenticate()*

   . 直接地，通过适配器的 *authenticate()* 方法



下面的例子通过 *Zend_Auth*\ 类来示例如何非直接地使用Zend_Auth适配器：

   .. code-block:: php
      :linenos:

      // Get a reference to the singleton instance of Zend_Auth
      require_once 'Zend/Auth.php';
      $auth = Zend_Auth::getInstance();

      // Set up the authentication adapter
      $authAdapter = new MyAuthAdapter($username, $password);

      // Attempt authentication, saving the result
      $result = $auth->authenticate($authAdapter);

      if (!$result->isValid()) {
          // Authentication failed; print the reasons why
          foreach ($result->getMessages() as $message) {
              echo "$message\n";
          }
      } else {
          // Authentication succeeded; the identity ($username) is stored
          // in the session
          // $result->getIdentity() === $auth->getIdentity()
          // $result->getIdentity() === $username
      }




一旦在一个请求里的认证被尝试，如上面的例子，检查一个成功的被认证的身份是否存在就是一个简单的匹配：


   .. code-block:: php
      :linenos:

      $auth = Zend_Auth::getInstance();
      if ($auth->hasIdentity()) {
          // Identity exists; get it
          $identity = $auth->getIdentity();
      }




从持久存储空间出去一个身份，可简单地使用 *clearIdentity()*\
方法。这将被典型地用作“logout”操作。

   .. code-block:: php
      :linenos:

      Zend_Auth::getInstance()->clearIdentity();




当自动使用持久存储空间对特定的用例不合适，开发者可简单地忽略 *Zend_Auth*\
类，直接使用适配器类。直接使用适配器类需要配置和准备适配器对象和调用它的
*authenticate()*\
方法。适配器规范细节将在每个适配器的文档中讨论。下面的例子直接使用
*MyAuthAdapter*\ ：

   .. code-block:: php
      :linenos:

      // Set up the authentication adapter
      $authAdapter = new MyAuthAdapter($username, $password);

      // Attempt authentication, saving the result
      $result = $authAdapter->authenticate();

      if (!$result->isValid()) {
          // Authentication failed; print the reasons why
          foreach ($result->getMessages() as $message) {
              echo "$message\n";
          }
      } else {
          // Authentication succeeded
          // $result->getIdentity() === $username
      }





