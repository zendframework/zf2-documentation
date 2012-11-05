.. EN-Revision: none
.. _zend.http.response:

Zend\Http\Response
==================

.. _zend.http.response.introduction:

简介
--

对于由 :ref:` <zend.http.client>`\ 返回的应答(Response)信息， *Zend\Http\Response*
可以提供简单的访问方式。 它提供一组友好的方法来获得从请求返回的应答信息:

   - *isError()*: 如果收到HTTP出错状态的代码,返回TRUE, 否则返回FALSE.

   - *isSuccessful()*: 如果得到HTTP请求成功的状态代码,返回TRUE, 否则返回FALSE.

   - *isRedirect()*: 如果得到HTTP重定向的状态代码,返回TRUE, 否则返回FALSE.

   - *getStatus()*: 返回HTTP请求的状态代码.

   - *getHeaders()*: 以数组的形式返回HTTP请求头部信息的字符串.

   - *getBody()*: 返回HTTP正文内容(字符串).



.. rubric:: 处理HTTP应答

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Http/Client.php';
   try {
       $http = new Zend\Http\Client('http://example.org');
       $response = $http->get();
       if ($response->isSuccessful()) {
           echo $response->getBody();
       } else {
           echo "<p>发生错误</p>\n";
           echo "HTTP Status: " . $response->getStatus() . "\n";
           echo "HTTP Headers:\n";
           $responseHeaders = $response->getHeaders();
           foreach ($responseHeaders as $responseHeaderName => $responseHeaderValue) {
               echo "$responseHeaderName: $responseHeaderValue\n";
           }
       }
   } catch (Zend\Http_Client\Exception $e) {
       echo '<p>An error occurred (' .$e->getMessage(). ')</p>';
   }
   ?>

