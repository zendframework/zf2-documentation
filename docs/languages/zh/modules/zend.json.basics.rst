.. EN-Revision: none
.. _zend.json.basics:

基本用法
====

*Zend_Json*\ 的使用包括使用现有的两个公共的static方法 : *Zend\Json\Json::encode()* 和
*Zend\Json\Json::decode()*.

   .. code-block:: php
      :linenos:

      // 获得一个value:
      $phpNative = Zend\Json\Json::decode($encodedValue);

      // 编码并返回给客户端:
      $json = Zend\Json\Json::encode($phpNative);





