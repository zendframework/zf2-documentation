.. _zend.http.client:

Zend_Http_Client - 介绍
=====================

.. _zend.http.client.introduction:

介绍
--

Zend_Http_Client 提供了一个简单的界面来执行HTTP请求。Zend_Http_Client 支持 作为一个 HTTP
客户端应有的大多数简单功能，也包括象HTTP认证和文件上传等更加
复杂的功能。成功的请求和大多数失败的请求将返回一个 Zend_Http_Response 对象，
该对象提供了对响应的头部信息和主体信息的访问。 （见 :ref:` <zend.http.response>`\ ）

构造器类可选的第一个参数可以是一个URL（字符串或者 Zend_Uri_Http 对象），
第二个可选参数是一个包含配置参数的数组。这两个参数也可以全空，之后由
setUri()和setConfig()方法提供。



      .. _zend.http.client.introduction.example-1:

      .. rubric:: 初始化一个 Zend_Http_Client 对象

      .. code-block:: php
         :linenos:

         $client = new Zend_Http_Client('http://example.org', array(
             'maxredirects' => 0,
             'timeout'      => 30));

         // 上述代码和下面的代码是两种不同的写法
         $client = new Zend_Http_Client();
         $client->setUri('http://example.org');
         $client->setConfig(array(
             'maxredirects' => 0,
             'timeout'      => 30));




.. _zend.http.client.configuration:

配置参数
----

构造器和 setConfig() 方法接受一个复合的配置参数数组，因为这些配置参数
有一个缺省值，所以是否配置这些参数都是可选的。



      .. _zend.http.client.configuration.table:

      .. table:: Zend_Http_Client 配置参数

         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+
         |参数             |描述                                                                           |值的类型|缺省值                              |
         +===============+=============================================================================+====+=================================+
         |maxredirects   |随后的重定向的最大值 (0 = none)                                                        |整数  |5                                |
         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+
         |strict         |是否执行头部名称的确认，当设置为 False 时，将忽略确认，通常情况下不应改变这个参数的值。                              |布尔值 |true                             |
         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+
         |strictredirects|重定向时是否严格遵守 RFC (见 )                                                          |布尔值 |false                            |
         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+
         |useragent      |用户代理的识别字符串（含在请求的头部信息内）                                                       |字符串 |'Zend_Http_Client'               |
         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+
         |timeout        |连接超时 (单位是秒)                                                                  |整数  |10                               |
         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+
         |httpversion    |HTTP 协议版本 (通常是 '1.1' 或 '1.0')                                                |字符串 |'1.1'                            |
         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+
         |adapter        |连接适配器类时使用（见 ）                                                                |多种类型|'Zend_Http_Client_Adapter_Socket'|
         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+
         |keepalive      |是否允许与服务器之间的 keep-alive 连接。如果在同一台服务器上 执行几个互相关联的请求时，keep-alive 连接是有用的而且有可能提高性能。|布尔值 |false                            |
         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+
         |storeresponse  |是否保存上次的响应结果，以备今后使用getLastResponse()重新获取。如果设置为 false，getLastResponse() 将返回空。  |布尔值 |true                             |
         +---------------+-----------------------------------------------------------------------------+----+---------------------------------+



.. _zend.http.client.basic-requests:

执行基本 HTTP 请求
------------

使用 request() 方法执行简单 HTTP 请求是件非常容易的事情，3行代码即可搞定：



      .. _zend.http.client.basic-requests.example-1:

      .. rubric:: 执行一个简单的 GET 请求

      .. code-block:: php
         :linenos:

         $client = new Zend_Http_Client('http://example.org');
         $response = $client->request();


request() 带一个可选的参数 - 请求方法，它可以是 GET, POST, PUT, HEAD, DELETE, TRACE, OPTIONS 或
CONNECT 等由 HTTP 协议定义的方法。 [#]_. 为了方便起见，这些都被定义为类的常量：即
Zend_Http_Request::GET, Zend_Http_Request::POST 等等。

如果没有指定请求方法，则使用最后一次 setMethod() 设定的请求方法。 如果从未使用
setMethod()，那么缺省的请求方法是 GET（见上述的例子）。



      .. _zend.http.client.basic-requests.example-2:

      .. rubric:: 使用 GET 以外的请求方法

      .. code-block:: php
         :linenos:

         // 执行一个 POST 请求
         $response = $client->request('POST');

         // 另外一种执行 POST 请求的方式
         $client->setMethod(Zend_Http_Client::POST);
         $response = $client->request();




.. _zend.http.client.parameters:

添加 GET 和 POST 参数
----------------

在一个HTTP请求中添加GET参数是非常简单的，既可以通过把参数指定为
URL的一部分，也可以通过使用 setParameterGet() 方法来添加。这个方
法把把GET参数的名称作为它的第一个参数，把GET参数的值作为它的第二
个参数。为了方便起见，setParameterGet() 方法也能接受单个复合数组 （名称 => 值）的 GET
参数，这种方式对于需要设置几个 GET 参数时更 加方便。



      .. _zend.http.client.parameters.example-1:

      .. rubric:: 设置 GET 参数

      .. code-block:: php
         :linenos:

         // 使用 setParameterGet 方法设置一个 GET 参数
         $client->setParameterGet('knight', 'lancelot');

         // 设置 URL 的等效方法
         $client->setUri('http://example.com/index.php?knight=lancelot');

         // 一次添加几个参数
         $client->setParameterGet(array(
             'first_name'  => 'Bender',
             'middle_name' => 'Bending'
             'made_in'     => 'Mexico',
         ));




虽然 GET 参数可以和任何请求方法一起发送，但 POST 参数只能在 POST
请求内发送。给一个请求添加 POST 参数与添加 GET 参数非常类似，是由 setParameterPost()
方法完成的，该方法在结构上与 setParameterGet() 方法很相似。



      .. _zend.http.client.parameters.example-2:

      .. rubric:: 设置 POST 参数

      .. code-block:: php
         :linenos:

         // 设置一个 POST 参数
         $client->setParameterPost('language', 'fr');

         // 设置几个 POST 参数，其中的一个参数有几个值
         $client->setParameterPost(array(
             'language'  => 'es',
             'country'   => 'ar',
             'selection' => array(45, 32, 80)
         ));


需要注意的是，当发送 POST 请求时，即可设置GET参数，也可设置POST参数。
另一方面，如果针对一个非 POST 请求设置 POST 参数，将不会被触发或给出
报错，因为它是没有用的。除非请求是一个 POST 请求，POST 参数都会被简 单地忽略掉。

.. _zend.http.client.accessing_last:

访问最后一次的请求和响应
------------

Zend_Http_Client 提供了访问客户端最后一次发送的请求和访问客户端最后
一次接收到的响应的方法。 *Zend_Http_Client->getLastRequest()* 不需要设置参数，同时
返回最后一次客户端发送的HTTP请求字符串。同样， *Zend_Http_Client->getLastResponse()*
返回客户端接收到的 最后一次 :ref:`Zend_Http_Response <zend.http.response>` 对象。



.. _`http://www.w3.org/Protocols/rfc2616/rfc2616.html`: http://www.w3.org/Protocols/rfc2616/rfc2616.html

.. [#] 见 RFC 2616 -`http://www.w3.org/Protocols/rfc2616/rfc2616.html`_.