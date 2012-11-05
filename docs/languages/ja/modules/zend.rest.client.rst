.. EN-Revision: none
.. _zend.rest.client:

Zend\Rest\Client
================

.. _zend.rest.client.introduction:

導入
--

``Zend\Rest\Client`` の使用法は、 *SoapClient* オブジェクト (`SOAP
ウェブサービス拡張モジュール`_) の使用法と非常によく似ています。REST
サービスのプロシージャは、簡単に ``Zend\Rest\Client``
のメソッドとしてコールできます。 まず、そのサービスのアドレスを ``Zend\Rest\Client``
のコンストラクタに指定します。

.. _zend.rest.client.introduction.example-1:

.. rubric:: 基本的な REST リクエスト

.. code-block:: php
   :linenos:

   /**
    * framework.zend.com サーバに接続し、挨拶を受け取ります
    */
   $client = new Zend\Rest\Client('http://framework.zend.com/rest');

   echo $client->sayHello('Davey', 'Day')->get(); // "Hello Davey, Good Day"

.. note::

   **コール方法の違い**

   ``Zend\Rest\Client`` は、
   リモートメソッドのコールをできるだけネイティブなメソッドと同様に行おうとします。
   唯一の違いは、続けて ``get()`` か ``post()``\ 、 ``put()`` あるいは ``delete()``
   のいずれかのメソッドをコールしなければならないということです。
   これは、メソッドの連結で行ってもかまいませんし、
   独立したメソッドコールにしてもかまいません。

   .. code-block:: php
      :linenos:

      $client->sayHello('Davey', 'Day');
      echo $client->get();

.. _zend.rest.client.return:

レスポンス
-----

``Zend\Rest\Client`` を使用して行ったリクエストは、すべて ``Zend\Rest_Client\Response``
オブジェクトを返します。
このオブジェクトには多くのプロパティがあり、結果に簡単にアクセスできます。

``Zend\Rest\Server`` に基づくサービスにアクセスした場合には、 ``Zend\Rest\Client``
は結果についていくつかの前提条件を想定しています。
たとえばレスポンスステータス (成功あるいは失敗) や返り値の型などです。

.. _zend.rest.client.return.example-1:

.. rubric:: レスポンスステータス

.. code-block:: php
   :linenos:

   $result = $client->sayHello('Davey', 'Day')->get();

   if ($result->isSuccess()) {
       echo $result; // "Hello Davey, Good Day"
   }

上の例で、リクエストの結果をオブジェクトとして扱い、 ``isSuccess()``
をコールしていることがごらんいただけるでしょう。 また、 ``__toString()``
をサポートしているため、 単に *echo*
とするだけでオブジェクトの結果を取得できます。 ``Zend\Rest_Client\Response``
は、任意のスカラー値を echo することが可能です。複雑な形式の場合は、
配列記法あるいはオブジェクト記法が使用できます。

しかし、 ``Zend\Rest\Server``
を使用していないサービスに問い合わせたいこともあるでしょう。このような場合、
``Zend\Rest_Client\Response`` オブジェクトは *SimpleXMLElement* と同様の振る舞いをします。
しかし、より簡単に処理するため、プロパティがルート要素の直下にない場合には
自動的に XPath で *XML* を探すようにしています。さらに、
プロパティに対してメソッドとしてアクセスすると、 *PHP*
の値あるいは値の配列としてそのオブジェクトを取得できます。

.. _zend.rest.client.return.example-2:

.. rubric:: Technorati の Rest サービスの使用

.. code-block:: php
   :linenos:

   $technorati = new Zend\Rest\Client('http://api.technorati.com/bloginfo');
   $technorati->key($key);
   $technorati->url('http://pixelated-dreams.com');
   $result = $technorati->get();
   echo $result->firstname() .' '. $result->lastname();

.. _zend.rest.client.return.example-3:

.. rubric:: Technorati からのレスポンスの例

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>
   <!-- generator="Technorati API version 1.0 /bloginfo" -->
   <!DOCTYPE tapi PUBLIC "-//Technorati, Inc.//DTD TAPI 0.02//EN"
                         "http://api.technorati.com/dtd/tapi-002.xml">
   <tapi version="1.0">
       <document>
           <result>
               <url>http://pixelated-dreams.com</url>
               <weblog>
                   <name>Pixelated Dreams</name>
                   <url>http://pixelated-dreams.com</url>
                   <author>
                       <username>DShafik</username>
                       <firstname>Davey</firstname>
                       <lastname>Shafik</lastname>
                   </author>
                   <rssurl>
                       http://pixelated-dreams.com/feeds/index.rss2
                   </rssurl>
                   <atomurl>
                       http://pixelated-dreams.com/feeds/atom.xml
                   </atomurl>
                   <inboundblogs>44</inboundblogs>
                   <inboundlinks>218</inboundlinks>
                   <lastupdate>2006-04-26 04:36:36 GMT</lastupdate>
                   <rank>60635</rank>
               </weblog>
               <inboundblogs>44</inboundblogs>
               <inboundlinks>218</inboundlinks>
           </result>
       </document>
   </tapi>

ここで、 *firstname* や *lastname* といったプロパティにアクセスできます。
これらはトップレベル要素ではありませんが、
名前を指定するだけで自動的に取得できます。

.. note::

   **複数の要素**

   名前でアクセスしているときにもし複数の項目が見つかったら、 SimpleXMLElements
   の配列を返します。メソッド記法でアクセスすると、 *PHP* の値の配列を返します。

.. _zend.rest.client.args:

リクエストの引数
--------

``Zend\Rest\Server`` ベースのサービスにリクエストを送るのではない場合は、
リクエストの際に複数の引数を指定する必要があります。
これを行うには、引数名と同じ名前のメソッドをコールし、 その最初の
(そして唯一の) 引数として値を指定します。
これらのメソッドコールはそのオブジェクト自身を返すので、 メソッドを連結する
"流れるような" 形式で使用できます。 最初のコール
(あるいは複数の引数を指定した場合の最初の引数) は常に、 ``Zend\Rest\Server``
サービスをコールする際のメソッドとみなされます。

.. _zend.rest.client.args.example-1:

.. rubric:: リクエストの引数の設定

.. code-block:: php
   :linenos:

   $client = new Zend\Rest\Client('http://example.org/rest');

   $client->arg('value1');
   $client->arg2('value2');
   $client->get();

   // あるいは

   $client->arg('value1')->arg2('value2')->get();

上の例の二通りの方法はいずれも、次のような get 引数となります。
*?method=arg&arg1=value1&arg=value1&arg2=value2*

最初の *$client->arg('value1');* のコールが *method=arg&arg1=value1* および *arg=value1*
の二通りの結果となることにお気づきでしょう。これによって、 ``Zend\Rest\Server``
がリクエストを適切に理解できるようになるのです。
そのサービスを使用するにあたっての前提知識を必要としなくなります。

.. warning::

   **Zend\Rest\Client の厳格性**

   受け取る引数について厳格な REST サービスでは、 ``Zend\Rest\Client``
   の使用に失敗することがあります。 これは上で説明した挙動のせいです。
   これはそう頻繁に起こることではないので、特に問題とはならないでしょう。



.. _`SOAP ウェブサービス拡張モジュール`: http://www.php.net/soap
