.. EN-Revision: none
.. _zend.authentication.adapter.http:

HTTP 认证适配器
==========

.. _zend.authentication.adapter.http.introduction:

简介
--

*Zend\Auth_Adapter\Http*\ 提供一个大部分符合 `RFC-2617`_\ 的 `基本`_ 和 `摘要`_ HTTP
认证。摘要认证是一个认证的方法，它在基本认证的基础上做了改进，不需要在网络上传输明文密码。

**主要特性：**

   - 支持基本和摘要认证。

   - 对所有支持的 schemes 发出请求，所以客户端可以响应任何它所支持的 scheme。

   - 支持代理认证。

   - 包括支持文本文件认证和提供一个接口来支持其它资源认证，例如数据库。



还有一些显著的 RFC-2617 特性没有实现：

   - Nonce 跟踪，它将考虑 "stale" 支持，和增强的重放供给保护。

   - 带完整性检查的认证，或 "auth-int"。

   - HTTP 认证信息头。



.. _zend.authentication.adapter.design_overview:

设计回顾
----

这个适配器包括两个子组件，HTTP authentication类本身和所谓的 "Resolvers"。HTTP
authentication类封装了实现基本和摘要认证的逻辑。它使用Resolver在数据存储（缺省是文本文件）中查找客户的身份并取出证书。"resolved"
的证书和客户的输入相比较来决定认证是否成功。

.. _zend.authentication.adapter.configuration_options:

配置选项
----

*Zend\Auth_Adapter\Http*
类需要一个配置数组传递给它的构造器。有若干个配置选项有效，其中一些是必需的：



      .. _zend.authentication.adapter.configuration_options.table:

      .. table:: 配置选项

         +--------------+-------------------------------+---------------------------------------------------------+
         |选项名称          |是否必须                           |描述                                                       |
         +==============+===============================+=========================================================+
         |accept_schemes|是                              |决定适配器从客户端接受哪个认证schemes。必须是包括'basic' 和/或 'digest'的空格分隔的列表。|
         +--------------+-------------------------------+---------------------------------------------------------+
         |realm         |是                              |设置认证领域；在给定的领域里用户名必须是唯一的。                                 |
         +--------------+-------------------------------+---------------------------------------------------------+
         |digest_domains|是，当'accept_schemes' 包含 'digest'|相同认证信息是有效的空格分隔的URIs列表。 URIs不需要都只想同一个服务器。                 |
         +--------------+-------------------------------+---------------------------------------------------------+
         |nonce_timeout |是，当'accept_schemes' 包含 'digest'|设置nonce有效的秒数。参见下面的注解。                                    |
         +--------------+-------------------------------+---------------------------------------------------------+
         |proxy_auth    |否                              |缺省是 Disabled 。Enable 后执行代理认证而不是正常的源服务器认证。                |
         +--------------+-------------------------------+---------------------------------------------------------+



.. note::

   当前的 *nonce_timeout*\
   实现有一些有趣的副作用。这个设置用来决定给定的nonce的有效寿命，或者客户端的认证信息多长时间被有效地接受。目前，如果它被设置为3600（例如），它将导致适配器准点地每个小时提示客户端提供新的证书。一旦nonce跟踪和stale支持实现，这在将来的版本中被解决。

.. _zend.authentication.adapter.http.resolvers:

Resolvers
---------

Resolver的作用是接受用户名和领域，并返回证书值。基本认证期望接收用户密码的Base64编码版本。摘要认证期望接收用户的用户名，领域和密码（用冒号分隔）的hash。当前，唯一支持的hash算法是MD5。

*Zend\Auth_Adapter\Http* 依靠对象实现 *Zend\Auth\Adapter\Http\Resolver\Interface*\
。适配器中包含一个文本文件resolver类，但任何其它种类的resolver可以通过实现resolver接口来创建。

.. _zend.authentication.adapter.http.resolvers.file:

文件 Resolver
^^^^^^^^^^^

文件resolver是一个非常简单的类。它有一个单个的属性指定一个文件名，它也可以被传递给构造器。它的
*resolve()*\ 方法遍历文本文件，用匹配用户名和领域来搜索一行。文本文件的格式和Apache
htpasswd文件类似：

   .. code-block:: php
      :linenos:

      <username>:<realm>:<credentials>\n


每行包含三个字段 - 用户名，领域 和 证书 -
用冒号分隔。证书字段对文件resolver不透明；它被简单地不做修改地返回给调用者。所以，这同样的文件格式对基本和摘要认证都适合。对基本认证，证书字段应该是Base64编码的用户的密码。对摘要认证，它应该是上述的MD5
hash。

有两个同等简单的方法创建文件 Resolver:

   .. code-block:: php
      :linenos:

      $path     = 'files/passwd.txt';
      $resolver = new Zend\Auth\Adapter\Http\Resolver\File($path);


或者

   .. code-block:: php
      :linenos:

      $path     = 'files/passwd.txt';
      $resolver = new Zend\Auth\Adapter\Http\Resolver\File();
      $resolver->setFile($path);


如果给定的路径是空的或不可读，将抛出一个异常。

.. _zend.authentication.adapter.http.basic_usage:

基本用法
----

首先，建立一个带有必需的配置值得数组：

   .. code-block:: php
      :linenos:

      $config = array(
          'accept_schemes' => 'basic digest',
          'realm'          => 'My Web Site',
          'digest_domains' => '/members_only /my_account',
          'nonce_timeout'  => 3600,
      );


这个数组将使适配器接收基本或者摘要认证，并将请求对所有在 */members_only* 和
*/my_account*\ 之下的区域认证访问。领域值通常在浏览器中密码对话框中显示。
*nonce_timeout*\ ，当然，会有上述的行为。

下一步, 创建 Zend\Auth_Adapter\Http 对象：

   .. code-block:: php
      :linenos:

      $adapter = new Zend\Auth_Adapter\Http($config);




因为我们对基本和摘要认证都支持，所以我们需要两个不同的resolver对象。注意这仅仅简单地是两个不同的类：


   .. code-block:: php
      :linenos:

      $basicResolver = new Zend\Auth\Adapter\Http\Resolver\File();
      $basicResolver->setFile('files/basicPasswd.txt');

      $digestResolver = new Zend\Auth\Adapter\Http\Resolver\File();
      $digestResolver->setFile('files/digestPasswd.txt');

      $adapter->setBasicResolver($basicResolver);
      $adapter->setDigestResolver($digestResolver);




最后，我们执行认证。为了完成认证，适配器对请求（Request）和响应（Response）都需要一个reference：


   .. code-block:: php
      :linenos:

      assert($request instanceof Zend\Controller_Request\Http);
      assert($response instanceof Zend\Controller_Response\Http);

      $adapter->setRequest($request);
      $adapter->setResponse($response);

      $result = $adapter->authenticate();
      if (!$result->isValid()) {
          // 错误的 userame/password，或者取消了密码提示
      }






.. _`RFC-2617`: http://tools.ietf.org/html/rfc2617
.. _`基本`: http://en.wikipedia.org/wiki/Basic_authentication_scheme
.. _`摘要`: http://en.wikipedia.org/wiki/Digest_access_authentication
