.. _zend.rest.server:

Zend_Rest_Server
================

.. _zend.rest.server.introduction:

導入
--

``Zend_Rest_Server`` は、完全に機能する REST サーバを作成するためのものです。

.. _zend.rest.server.usage:

REST サーバの使用法
------------

.. _zend.rest.server.usage.example-1:

.. rubric:: 基本的な Zend_Rest_Server の使用法 - クラス

.. code-block:: php
   :linenos:

   $server = new Zend_Rest_Server();
   $server->setClass('My_Service_Class');
   $server->handle();

.. _zend.rest.server.usage.example-2:

.. rubric:: 基本的な Zend_Rest_Server の使用法 - 関数

.. code-block:: php
   :linenos:

   /**
    * Say Hello
    *
    * @param string $who
    * @param string $when
    * @return string
    */
   function sayHello($who, $when)
   {
       return "Hello $who, Good $when";
   }

   $server = new Zend_Rest_Server();
   $server->addFunction('sayHello');
   $server->handle();

.. _zend.rest.server.args:

Zend_Rest_Server サービスのコール
-------------------------

``Zend_Rest_Server`` サービスをコールするには、 GET/POST 時の引数 *method*
にそのメソッド名を指定しなければなりません。
その後に、任意の数の引数を続けることができます。これは、引数の名前 (たとえば
"who") を指定するか、あるいは引数の位置を表す数値 (たとえば "arg1") を指定します。

.. note::

   **数値インデックス**

   数値で指定する引数のインデックスは、1 から始まります。

上の例の *sayHello* をコールするには、次のようにします。

*?method=sayHello&who=Davey&when=Day*

あるいは、このようにもできます。

*?method=sayHello&arg1=Davey&arg2=Day*

.. _zend.rest.server.customstatus:

独自のステータスの送信
-----------

値を返す際に独自のステータスを返すには、 キー *status* を含む配列を返します。

.. _zend.rest.server.customstatus.example-1:

.. rubric:: 独自のステータスを返す

.. code-block:: php
   :linenos:

   /**
    * Say Hello
    *
    * @param string $who
    * @param string $when
    * @return array
    */
   function sayHello($who, $when)
   {
       return array('msg' => "An Error Occurred", 'status' => false);
   }

   $server = new Zend_Rest_Server();
   $server->addFunction('sayHello');
   $server->handle();

.. _zend.rest.server.customxml:

独自の XML レスポンスを返す
----------------

独自の *XML* を返したい場合は、 *DOMDocument*\ 、 *DOMElement* あるいは *SimpleXMLElement*
オブジェクトを返します。

.. _zend.rest.server.customxml.example-1:

.. rubric:: 独自の XML を返す

.. code-block:: php
   :linenos:

   /**
    * Say Hello
    *
    * @param string $who
    * @param string $when
    * @return SimpleXMLElement
    */
   function sayHello($who, $when)
   {
       $xml ='<?xml version="1.0" encoding="ISO-8859-1"?>
   <mysite>
       <value>Hey $who! Hope you\'re having a good $when</value>
       <code>200</code>
   </mysite>';

       $xml = simplexml_load_string($xml);
       return $xml;
   }

   $server = new Zend_Rest_Server();
   $server->addFunction('sayHello');

   $server->handle();

サービスからのレスポンスは、変更なしにクライアントに返されます。


