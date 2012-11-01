.. EN-Revision: none
.. _zend.service.strikeiron:

Zend\Service\StrikeIron
=======================

``Zend\Service\StrikeIron`` は、StrikeIron ウェブサービス用の *PHP* 5
クライアントです。以下のセクションを参照ください。



   - :ref:` <zend.service.strikeiron>`



   - :ref:` <zend.service.strikeiron.bundled-services>`



   - :ref:` <zend.service.strikeiron.advanced-uses>`



.. _zend.service.strikeiron.overview:

概要
--

`StrikeIron`_ は、さまざまな商用データサービス ("Data as a Service")
を提供しています。たとえば Online Sales Tax, Currency Rates, Stock Quotes, Geocodes, Global Address
Verification, Yellow/White Pages, MapQuest Driving Directions, Dun & Bradstreet Business Credit Checks
などのサービスがあります。

StrikeIron ウェブサービスの各サービスは、標準の *SOAP* (および REST) *API*
を共有しています。これにより、複数のサービスを統合して管理するのが簡単になります。
StrikeIron はまた、すべてのサービスの支払いを単一のアカウントで管理しています。
ソリューションプロバイダにとって完璧な環境といえます。 `http://www.strikeiron.com/sdp`_
で、フリーなウェブサービスを試してみましょう。

StrikeIron のサービスは、 `PHP 5 の SOAP 拡張モジュール`_
のみでも使用することができるでしょう。 しかし、StrikeIron
をこの方法で使用すると、 真の *PHP*
風インターフェイスを活用することができません。 ``Zend\Service\StrikeIron``
コンポーネントは、 *SOAP*
拡張モジュールの上にもう一枚薄い皮をかぶせることによって、 StrikeIron
のサービスをより便利かつ *PHP* らしく使えるようにしています。

.. note::

   ``Zend\Service\StrikeIron`` を使うには、 *PHP* 5 の *SOAP*
   拡張モジュールがインストールされて有効になっている必要があります。

``Zend\Service\StrikeIron`` コンポーネントが提供する機能を以下にまとめます。



   - StrikeIron の認証情報の一元管理により、 さまざまな StrikeIron
     サービスで使用可能。

   - StrikeIron のさまざまな登録情報 (ライセンスの状態や残りの使用回数など)
     の標準的な方法での取得。

   - *PHP* のラッパークラスを作成しなくても、WSDL だけで StrikeIcon
     サービスが使用可能。 また、ラッパーを作成することで、
     より便利なインターフェイスを使用することも可能。

   - StrikeIron のサービスのうち、人気のある 3 つについてのラッパー。



.. _zend.service.strikeiron.registering:

StrikeIron への登録
---------------

``Zend\Service\StrikeIron`` を使用するには、まず StrikeIron
開発者アカウントを取得するために `登録`_ する必要があります。

登録したら、StrikeIron のユーザ名とパスワードを受け取ります。 ``Zend\Service\StrikeIron``
で StrikeIron に接続する際には、 このユーザ名とパスワードを使用します。

また、StrikeIron の Super Data Pack Web Service にも `登録`_ する必要があります。

どちらの登録処理も無料です。 StrikeIron
のウェブサイト上で比較的速やかに行えます。

.. _zend.service.strikeiron.getting-started:

では、はじめましょう
----------

StrikeIron のアカウントを `取得`_ して `Super Data Pack`_ にも参加したら、
``Zend\Service\StrikeIron`` を使うための準備は完了です。

StrikeIron には何百ものさまざまなウェブサービスが存在します。 Zend\Service\StrikeIron
はこれらのサービスの多くで利用可能ですが、 特に以下の 3
つについてはラッパークラスを用意しています。

- :ref:`ZIP Code Information <zend.service.strikeiron.bundled-services.zip-code-information>`

- :ref:`US Address Verification <zend.service.strikeiron.bundled-services.us-address-verification>`

- :ref:`Sales & Use Tax Basic <zend.service.strikeiron.bundled-services.sales-use-tax-basic>`

``Zend\Service\StrikeIron`` クラスには、 そのコンストラクタで StrikeIron
アカウント情報やその他のオプションを設定できます。 また、StrikeIron
の各種サービス用のクライアントを帰すファクトリメソッドも用意しています。

   .. code-block:: php
      :linenos:

      $strikeIron = new Zend\Service\StrikeIron(array('username' => 'あなたのユーザ名',
                                                      'password' => 'あなたのパスワード'));

      $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));



``getService()`` メソッドは、StrikeIron のサービス用のクライアントを帰します。引数には
*PHP* のラッパークラスの名前を指定します。 この場合の *SalesUseTaxBasic*
は、ラッパークラス ``Zend\Service_StrikeIron\SalesUseTaxBasic``
を指しています。標準で組み込まれている 3 つのラッパーについては
:ref:`バンドルされているサービス <zend.service.strikeiron.bundled-services>` で説明します。

``getService()`` は、対応する *PHP* ラッパーを持たない StrikeIron
サービス用のクライアントも返すことができます。 この機能については :ref:`WSDL
によるサービスの使用 <zend.service.strikeiron.advanced-uses.services-by-wsdl>` で説明します。

.. _zend.service.strikeiron.making-first-query:

はじめてのクエリ
--------

``getService()`` で StrikeIron サービス用のクライアントを取得したら、 あとは普通の *PHP*
オブジェクトと同様にそのメソッドをコールできます。

   .. code-block:: php
      :linenos:

      $strikeIron = new Zend\Service\StrikeIron(array('username' => 'あなたのユーザ名',
                                                      'password' => 'あなたのパスワード'));

      // Sales & Use Tax Basic サービス用のクライアントを取得します
      $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

      // カナダのオンタリオ州の税率を取得します
      $rateInfo = $taxBasic->getTaxRateCanada(array('province' => 'ontario'));
      echo $rateInfo->province;
      echo $rateInfo->abbreviation;
      echo $rateInfo->GST;

上の例では、 ``getService()`` メソッドを使用して :ref:`Sales & Use Tax Basic
<zend.service.strikeiron.bundled-services.sales-use-tax-basic>`
サービス用のクライアントを取得しています。 取得したオブジェクトは *$taxBasic*
に保存します。

次に、そのサービスの ``getTaxRateCanada()``
メソッドをコールします。メソッドに対してキーワードパラメータを渡すには
連想配列を使用します。これは、すべての StrikeIron のメソッドで共通の方法です。

``getTaxRateCanada()`` の返り値を *$rateInfo* に取得し、そのプロパティ *province* や ``GST``
を参照しています。

StrikeIron のサービスの多くは、この例と同じくらい簡単に使用できます。 3 つの
StrikeIron サービスについての詳細は :ref:`バンドルされているサービス
<zend.service.strikeiron.bundled-services>` を参照ください。

.. _zend.service.strikeiron.examining-results:

結果の吟味
-----

StrikeIron サービスについて学習したりデバッグしたりする際には、
メソッドから返された内容を出力できると便利です。 メソッドの返り値は常に
``Zend\Service_StrikeIron\Decorator`` のインスタンスとなります。 これはちょっとした
`デコレータ`_ オブジェクトであり、メソッドのコール結果をラップしています。

サービスが返した結果を調べる最も単純な方法は、 `print_r()`_ のような *PHP*
の組み込み関数を使うことです。

   .. code-block:: php
      :linenos:

      <?php
      $strikeIron = new Zend\Service\StrikeIron(array('username' => 'あなたのユーザ名',
                                                      'password' => 'あなたのパスワード'));

      $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

      $rateInfo = $taxBasic->getTaxRateCanada(array('province' => 'ontario'));
      print_r($rateInfo);
      ?>

      Zend\Service_StrikeIron\Decorator Object
      (
          [_name:protected] => GetTaxRateCanadaResult
          [_object:protected] => stdClass Object
              (
                  [abbreviation] => ON
                  [province] => ONTARIO
                  [GST] => 0.06
                  [PST] => 0.08
                  [total] => 0.14
                  [HST] => Y
              )
      )



上の例でわかるように、デコレータ (*$rateInfo*) が *GetTaxRateCanadaResult*
というオブジェクトをラップしています。 これが ``getTaxRateCanada()`` の返り値です。

この結果から、 *$rateInfo* には *abbreviation* や *province*\ 、 ``GST``
といった公開プロパティがあることがわかります。これらは *$rateInfo->province*
のようにしてアクセスできます。

.. tip::

   StrikeIron
   の結果のプロパティは、場合によっては大文字で始まっていることもあります (*Foo*
   や *Bar* など)。一方、たいていの *PHP*
   オブジェクトのプロパティは、普通は小文字で始まる形式 (*foo* や *bar* など)
   です。このあたりはデコレータがうまく処理するので、 プロパティが *Foo*
   であっても *foo* として取得できるようになります。

もしデコレータではなく中身のオブジェクトそのものやその名前がほしい場合は、
それぞれ ``getDecoratedObject()`` および ``getDecoratedObjectName()`` を使用します。

.. _zend.service.strikeiron.handling-errors:

エラー処理
-----

先ほどの例はあまりにも無邪気すぎるところがありました。
エラー処理を一切していなかったのです。 メソッドをコールした際に、StrikeIron
がエラーを返す可能性だってあります。
認証情報が間違っていたり、アカウントが有効期限切れになっていた場合などに
StrikeIron はエラーを発します。

このような場合は例外がスローされます。 例外が発生することを想定して、
サービスのメソッドをコールする際には例外処理を書く必要があります。

   .. code-block:: php
      :linenos:

      $strikeIron = new Zend\Service\StrikeIron(array('username' => 'あなたのユーザ名',
                                                      'password' => 'あなたのパスワード'));

      $taxBasic = $strikeIron->getService(array('class' => 'SalesUseTaxBasic'));

      try {

        $taxBasic->getTaxRateCanada(array('province' => 'ontario'));

      } catch (Zend\Service_StrikeIron\Exception $e) {

        // 接続時のエラーなどの場合の
        // エラー処理をここで行います

      }

スローされる例外は、常に ``Zend\Service_StrikeIron\Exception`` となります。

メソッドコール時の通常の失敗と例外の違いはしっかり把握しておきましょう。
例外が発生するのは、 **例外的な**
状態です。たとえばネットワークの障害が発生したとか
アカウントが有効期限切れになっていたとかいった状況がそれにあたります。
通常の失敗とは、もっと頻繁に起こりえるものです。 たとえば ``getTaxRateCanada()``
で指定した *province* が見つけられないときなどは例外とはなりません。

.. note::

   StrikeIron サービスのメソッドをコールする際には
   常に返り値をチェックするようにしましょう。 もちろん例外処理も必要です。



.. _zend.service.strikeiron.checking-subscription:

購入内容の確認
-------

StrikeIron にはさまざまなサービスがあります。
その中には無料で使えるものもあればお試し版のものもあります。
また、有料サービスのみのものもあります。 StrikeIron を使用するにあたっては、
そのサービスの購入状況を常に確認することが必要です。

*getService* メソッドが返す StrikeIron クライアントにはすべて、
そのサービスの購入状況を調べる ``getSubscriptionInfo()`` メソッドが存在します。

   .. code-block:: php
      :linenos:

      // Sales & Use Tax Basic サービス用のクライアントを取得します
      $strikeIron = new Zend\Service\StrikeIron(array('username' => 'あなたのユーザ名',
                                                      'password' => 'あなたのパスワード'));

      $taxBasic = $strikeIron->getService(array('class => 'SalesUseTaxBasic'));

      // Sales & Use Tax Basic サービスをあと何回使用できるかを調べます
      $subscription = $taxBasic->getSubscriptionInfo();
      echo $subscription->remainingHits;



``getSubscriptionInfo()`` メソッドが返すオブジェクトの多くには、 *remainingHits*
プロパティが含まれます。
これを調べて、使用しているサービスの状態を確認します。
残りの使用回数を超える数のメソッドコールを行うと、 StrikeIron
は例外をスローします。

サービスの購入状況を調べる問い合わせを送っても、
残りの使用可能回数は減りません。
サービスのメソッドをコールする際にはいつも残りの回数を自動的に取得します。
この値は、サービスに接続しなくても ``getSubscriptionInfo()`` で取得できます。
キャッシュを使用せずにもう一度情報を問い合わせるよう ``getSubscriptionInfo()``
に指示するには、 ``getSubscriptionInfo(true)`` とします。



.. _`StrikeIron`: http://www.strikeiron.com
.. _`http://www.strikeiron.com/sdp`: http://www.strikeiron.com/sdp
.. _`PHP 5 の SOAP 拡張モジュール`: http://jp.php.net/soap
.. _`登録`: http://www.strikeiron.com/ProductDetail.aspx?p=257
.. _`取得`: http://strikeiron.com/Register.aspx
.. _`Super Data Pack`: http://www.strikeiron.com/ProductDetail.aspx?p=257
.. _`デコレータ`: http://ja.wikipedia.org/wiki/Decorator_%E3%83%91%E3%82%BF%E3%83%BC%E3%83%B3
.. _`print_r()`: http://www.php.net/print_r
