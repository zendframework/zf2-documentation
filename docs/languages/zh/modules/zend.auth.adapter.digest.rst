.. _zend.auth.adapter.digest:

摘要式认证
=====

.. _zend.auth.adapter.digest.introduction:

简介
--

`摘要式认证`_\ 是一个HTTP认证的方法，它通过不需要通过网络传递明文密码的方法对
`基本认证`_\ 加以改进。

这个适配器允许依靠文本文件认证，该文本包括数行摘要式认证的基本元素：

   - 用户名，例如 "*joe.user*"

   - 领域，例如 "*Administrative Area*"

   - 用户名，领域和密码的MD5 hash用冒号隔开

在下面的例子中，上面的元素用冒号隔开（密码是"*somePassword*"）：

.. code-block:: php
   :linenos:

   someUser:Some Realm:fde17b91c3a510ecbaf7dbd37f59d4f8


.. _zend.auth.adapter.digest.specifics:

规范（Specifics）
-------------

摘要式认证适配器 *Zend_Auth_Adapter_Digest*\ 需要若干输入参数：

   - 文件名 － 认证查询被执行是所需的文件名

   - 领域 － 摘要式认证领域

   - 用户名 － 摘要式认证用户

   - 密码 － 该领域用户的密码

在调用 *authenticate()*\ 之前必需要设定这些参数。

.. _zend.auth.adapter.digest.identity:

身份（Identity）
------------

摘要式认证返回一个 *Zend_Auth_Result* 对象，它由包含 *realm*\ 和 *username*\
健值的数组的身份形成。在 *authenticate()*\
被调用之前，分别设置和这些健值关联的数组值为相符的值。

.. code-block::
   :linenos:

   <
   $adapter = new Zend_Auth_Adapter_Digest($filename,
                                           $realm,
                                           $username,
                                           $password);

   $result = $adapter->authenticate();

   $identity = $result->getIdentity();

   print_r($identity);

   /*
   Array
   (
       [realm] => Some Realm
       [username] => someUser
   )
   */




.. _`摘要式认证`: http://en.wikipedia.org/wiki/Digest_access_authentication
.. _`基本认证`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
