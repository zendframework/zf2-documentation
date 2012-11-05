.. EN-Revision: none
.. _zend.service.strikeiron.advanced-uses:

Zend\Service\StrikeIron: 応用編
============================

このセクションでは、 ``Zend\Service\StrikeIron`` のより進んだ使用法を説明します。

.. _zend.service.strikeiron.advanced-uses.services-by-wsdl:

WSDL によるサービスの使用
---------------

StrikeIron のサービスの中には *PHP* のラッパークラスが存在するものもあります。
これらについては :ref:`バンドルされているサービス <zend.service.strikeiron.bundled-services>`
を参照ください。しかし、StrikeIron には何百ものサービスがあり、
中には便利なものも多くあります。
これらについても、ラッパークラスを作成せずに利用できます。

ラッパークラスが存在しない StrikeIron サービスを使用するには、 ``getService()``
のオプションに *class* ではなく *wsdl* を指定します。

   .. code-block:: php
      :linenos:

      $strikeIron = new Zend\Service\StrikeIron(array('username' => 'あなたのユーザ名',
                                                      'password' => 'あなたのパスワード'));

      // Reverse Phone Lookup サービス用の汎用クライアントを取得します
      $phone = $strikeIron->getService(
          array('wsdl' => 'http://ws.strikeiron.com/ReversePhoneLookup?WSDL')
      );

      $result = $phone->lookup(array('Number' => '(408) 253-8800'));
      echo $result->listingName;

      // Zend Technologies USA Inc



StrikeIron サービスを WSDL から使用するには、 WSDL
ファイルについての基礎知識が必要です。 StrikeIron
のサイトには、そのためのリソースも豊富に用意されています。 また、 `Horde
プロジェクト`_ の `Jan Schneider`_ が、 WSDL ファイルを読みやすく HTML
形式に変換するための `ちょっとした PHP のルーチン`_ を公開しています。

公式にサポートしているのは、 :ref:`バンドルされているサービス
<zend.service.strikeiron.bundled-services>`
に挙げられているものだけであることに注意しましょう。

.. _zend.service.strikeiron.viewing-soap-transactions:

SOAP トランザクションの表示
----------------

StrikeIron との通信は、すべて *SOAP* 拡張モジュールを用いて行います。 StrikeIron
との間でやり取りする *XML* の内容を確認できると、 デバッグ時に便利です。

すべての StrikeIron クライアント (``Zend\Service_StrikeIron\Base`` のサブクラス) には
``getSoapClient()`` メソッドが存在します。 これは、StrikeIron との通信に使用している
*SOAPClient* のインスタンスを返します。

*PHP* の `SOAPClient`_ には *trace*
オプションがあり、これを使用すると直前のトランザクションで交換された *XML*
を取得できます。 ``Zend\Service\StrikeIron`` は、デフォルトでは *trace*
を有効にしません。しかし、 *SOAPClient*
に渡すオプションを指定することで、この挙動は簡単に変更できます。

*SOAP* のトランザクションを見るには、 ``getSoapClient()`` メソッドをコールして
*SOAPClient* のインスタンスを取得し、 `\__getLastRequest()`_ や `\__getLastRequest()`_
のような適切なメソッドをコールします。

   .. code-block:: php
      :linenos:

      $strikeIron =
          new Zend\Service\StrikeIron(array('username' => 'あなたのユーザ名',
                                            'password' => 'あなたのパスワード',
                                            'options'  => array('trace' => true)));

      // Sales & Use Tax Basic サービス用のクライアントを取得します
      $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

      // メソッドをコールします
      $taxBasic->getTaxRateCanada(array('province' => 'ontario'));

      // SOAPClient のインスタンスを取得し、XML を表示します
      $soapClient = $taxBasic->getSoapClient();
      echo $soapClient->__getLastRequest();
      echo $soapClient->__getLastResponse();





.. _`Horde プロジェクト`: http://horde.org
.. _`Jan Schneider`: http://janschneider.de
.. _`ちょっとした PHP のルーチン`: http://janschneider.de/news/25/268
.. _`SOAPClient`: http://www.php.net/manual/ja/function.soap-soapclient-construct.php
.. _`\__getLastRequest()`: http://www.php.net/manual/ja/function.soap-soapclient-getlastresponse.php
