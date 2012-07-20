.. _zend.json.basics:

基本用法
============

*Zend_Json*\ 的使用包括使用现有的两个公共的static方法 : *Zend_Json::encode()* 和
*Zend_Json::decode()*.

   .. code-block::
      :linenos:

      // 获得一个value:
      $phpNative = Zend_Json::decode($encodedValue);

      // 编码并返回给客户端:
      $json = Zend_Json::encode($phpNative);





