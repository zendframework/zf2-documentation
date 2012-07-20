.. _zend.http.client.adapters:

Zend_Http_Client - 接続アダプタ
=========================

.. _zend.http.client.adapters.overview:

概要
--

``Zend_Http_Client`` は、接続アダプタとして設計されています。
接続アダプタは実際にサーバへの接続を行うオブジェクトで、
リクエストの書き込みやレスポンスの読み込みも行います。
この接続アダプタは置き換えることができます。
つまり、デフォルトの接続アダプタを継承して自分の好みにあうように変更できます。
*HTTP* クライアントクラス全体を書き換える必要はありません。
同じインターフェイスを実装しているだけでいいのです。

現在、 ``Zend_Http_Client`` クラスは四つの組み込み接続アダプタを提供しています。

   - ``Zend_Http_Client_Adapter_Socket`` (デフォルト)

   - ``Zend_Http_Client_Adapter_Proxy``

   - ``Zend_Http_Client_Adapter_Curl``

   - ``Zend_Http_Client_Adapter_Test``



``Zend_Http_Client`` オブジェクトの接続アダプタを指定するには、 設定オプション
'adapter' を使用します。
クライアントオブジェクトのインスタンスを作成する際に、オプション 'adapter'
にアダプタの名前 (たとえば 'Zend_Http_Client_Adapter_Socket' など)
を指定できます。あるいは、アダプタオブジェクトの変数 (たとえば *new
Zend_Http_Client_Adapter_Test* など) を指定することもできます。 ``Zend_Http_Client->setConfig()``
メソッドを使用し、 アダプタを後で設定することも可能です。

.. _zend.http.client.adapters.socket:

ソケットアダプタ
--------

デフォルトの接続アダプタは ``Zend_Http_Client_Adapter_Socket``
です。明示的に接続アダプタを指定しない場合は、これが使用されます。 Socket
アダプタは *PHP* の組み込み関数 fsockopen()
を使用しており、特別な拡張モジュールやコンパイルオプションは必要ありません。

ソケットアダプタには、追加の設定オプションを指定できます。これは
``Zend_Http_Client->setConfig()`` で指定するか、
あるいはクライアントのコンストラクタに渡します。



      .. _zend.http.client.adapter.socket.configuration.table:

      .. table:: Zend_Http_Client_Adapter_Socket の設定パラメータ

         +---------------+------------------------------------------------------------------------------------+---------------+------------------+
         |パラメータ          |説明                                                                                  |予期する型          |デフォルト値            |
         +===============+====================================================================================+===============+==================+
         |persistent     |持続的な TCP 接続を使用するかどうか                                                                |boolean        |FALSE             |
         +---------------+------------------------------------------------------------------------------------+---------------+------------------+
         |ssltransport   |SSL トランスポート層 (たとえば 'sslv2'、'tls')                                                   |文字列            |ssl               |
         +---------------+------------------------------------------------------------------------------------+---------------+------------------+
         |sslcert        |PEM でエンコードした、SSL 証明書ファイルへのパス                                                        |文字列            |NULL              |
         +---------------+------------------------------------------------------------------------------------+---------------+------------------+
         |sslpassphrase  |SSL 証明書ファイルのパスフレーズ                                                                  |文字列            |NULL              |
         +---------------+------------------------------------------------------------------------------------+---------------+------------------+
         |sslusecontext  |Enables proxied connections to use SSL even if the proxy connection itself does not.|boolean        |FALSE             |
         +---------------+------------------------------------------------------------------------------------+---------------+------------------+



   .. note::

      **持続的な TCP 接続**

      持続的な *TCP* 接続を使用すると、 *HTTP*
      リクエストの処理速度が向上する可能性があります。
      しかし、たいていの場合はその効果はごくわずかで、 接続先の *HTTP*
      サーバにかかる負荷が大きくなります。

      持続的な *TCP* 接続を使用するのは、 同じサーバに頻繁に接続する場合で
      そのサーバが同時に多数の接続を処理できることがわかっている場合のみにすることを推奨します。
      いずれにせよ、このオプションを使用する前には
      クライアント側の速度だけでなくサーバ側の負荷についてもベンチマークをとるようにしましょう。

      さらに、持続的な接続を使用するときには :ref:` <zend.http.client.configuration>`
      で説明した Keep-Alive *HTTP* リクエストも有効にしておくことを推奨します。
      そうしないと、持続的な接続の効果はほとんどといっていいほどなくなってしまいます。



   .. note::

      **HTTPS SSL ストリームパラメータ**

      *ssltransport, sslcert* および *sslpassphrase* は、 *HTTPS* 接続で使用する *SSL*
      レイヤーにのみ関連するものです。

      たいていの場合はデフォルトの *SSL* 設定でうまく動作するでしょうが、
      接続先のサーバが特別なクライアント設定を要求している場合は
      それにあわせた設定をする必要があるかもしれません。 その場合は、 `ここ`_ で
      *SSL* トランスポート層やオプションについての説明を参照ください。



.. _zend.http.client.adapters.socket.example-1:

.. rubric:: HTTPS トランスポート層の変更

.. code-block:: php
   :linenos:

   // 設定パラメータを指定します
   $config = array(
       'adapter'      => 'Zend_Http_Client_Adapter_Socket',
       'ssltransport' => 'tls'
   );

   // クライアントオブジェクトのインスタンスを作成します
   $client = new Zend_Http_Client('https://www.example.com', $config);

   // これ以降のリクエストは、TLS セキュア接続上で行われます
   $response = $client->request();

上の例の結果は、次の *PHP* コマンドで *TCP*
接続をオープンした場合と同じになります。

``fsockopen('tls://www.example.com', 443)``

.. _zend.http.client.adapters.socket.streamcontext:

ソケットアダプタのストリームコンテキストへのアクセスとカスタマイズ
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zend Framework 1.9 以降、 ``Zend_Http_Client_Adapter_Socket``
は、リモートサーバへの接続に使用している `ストリームコンテキスト`_
に直接アクセスできるようになります。これを使用すると、 *TCP* ストリーム (*HTTPS*
接続の場合は *SSL* ラッパー)
固有のオプションやパラメータを渡せるようになります。

ストリームコンテキストにアクセスするには、 ``Zend_Http_Client_Adapter_Socket``
のこれらのメソッドを使用します。



   - **setStreamContext($context)**
     アダプタが使用するストリームコンテキストを設定します。 *PHP* の
     `stream_context_create()`_ 関数で作成したストリームコンテキストリソースか、
     この関数に渡すのと同じ形式のストリームコンテキストオプションの配列のいずれかを指定できます。
     配列を渡すと、そのオプションを用いて新たなストリームコンテキストを作成し、
     それを設定します。

   - **getStreamContext()** アダプタのストリームコンテキストを取得します。
     ストリームコンテキストが設定されていない場合は、
     デフォルトのストリームコンテキストを作成してそれを返します。
     あとは、さまざまなコンテキストオプションの設定や取得を通常の *PHP*
     ストリームコンテキスト関数で行うことができます。



.. _zend.http.client.adapters.socket.streamcontext.example-1:

.. rubric:: ソケットアダプタのストリームコンテキストオプションの設定

.. code-block:: php
   :linenos:

   // オプションの配列
   $options = array(
       'socket' => array(
           // ソケットのローカル側を特定のインターフェイスにバインドします
           'bindto' => '10.1.2.3:50505'
       ),
       'ssl' => array(
           // サーバ側の証明書を検証します
           // 無効な証明書や自己署名の SSL 証明書は拒否します
           'verify_peer' => true,
           'allow_self_signed' => false,

           // ピア証明書を捕捉します
           'capture_peer_cert' => true
       )
   );

   // アダプタオブジェクトを作成し、HTTP クライアントにバインドします
   $adapter = new Zend_Http_Client_Adapter_Socket();
   $client = new Zend_Http_Client();
   $client->setAdapter($adapter);

   // 方法 1: オプションの配列を setStreamContext() に渡します
   $adapter->setStreamContext($options);

   // 方法 2: ストリームコンテキストを作成して setStreamContext() に渡します
   $context = stream_context_create($options);
   $adapter->setStreamContext($context);

   // 方法 3: デフォルトのストリームコンテキストを取得してオプションを設定します
   $context = $adapter->getStreamContext();
   stream_context_set_option($context, $options);

   // リクエストを処理します
   $response = $client->request();

   // すべてがうまくいけば、これでまたコンテキストにアクセスできます
   $opts = stream_context_get_options($adapter->getStreamContext());
   echo $opts['ssl']['peer_certificate'];

.. note::

   ストリームコンテキストのオプションは、
   アダプタが実際にリクエストを処理しだす前に設定しなければならないことに注意しましょう。
   コンテキストを設定せずにソケットアダプタで *HTTP* リクエストを処理すると、
   デフォルトのストリームコンテキストが作成されます。
   リクエストを処理した後にこのコンテキストリソースにアクセスするには
   ``getStreamContext()`` メソッドを使用します。

.. _zend.http.client.adapters.proxy:

プロキシアダプタ
--------

``Zend_Http_Client_Adapter_Proxy``
アダプタはデフォルトのソケットアダプタとほぼ同じです。
ただし、対象となるサーバに直接接続するのではなく *HTTP*
プロキシサーバを経由して接続するという点が異なります。 これにより、
``Zend_Http_Client`` をプロキシサーバの中から使用できるようになります。
セキュリティやパフォーマンス上の理由により、これが必要となる場合もあるでしょう。

プロキシアダプタを使用するには、 デフォルトの 'adapter' オプション以外に
いくつか追加のパラメータを設定する必要があります。



      .. _zend.http.client.adapters.proxy.table:

      .. table:: Zend_Http_Client の設定パラメータ

         +---------------+---------------------------------------------------+---------------------+------------------------------------------------------------------+
         |パラメータ          |説明                                                 |想定している型              |値の例                                                               |
         +===============+===================================================+=====================+==================================================================+
         |proxy_host     |プロキシサーバのアドレス                                       |string               |'proxy.myhost.com' あるいは '10.1.2.3'                                |
         +---------------+---------------------------------------------------+---------------------+------------------------------------------------------------------+
         |proxy_port     |プロキシサーバの TCP ポート                                   |integer              |8080 (デフォルト) あるいは 81                                              |
         +---------------+---------------------------------------------------+---------------------+------------------------------------------------------------------+
         |proxy_user     |必要に応じて、プロキシのユーザ名                                   |string               |'shahar' あるいは指定しない場合は '' (デフォルト)                                  |
         +---------------+---------------------------------------------------+---------------------+------------------------------------------------------------------+
         |proxy_pass     |必要に応じて、プロキシのパスワード                                  |string               |'secret' あるいは指定しない場合は '' (デフォルト)                                  |
         +---------------+---------------------------------------------------+---------------------+------------------------------------------------------------------+
         |proxy_auth     |プロキシの HTTP 認証形式                                    |string               |Zend_Http_Client::AUTH_BASIC (デフォルト)                              |
         +---------------+---------------------------------------------------+---------------------+------------------------------------------------------------------+



proxy_host は常に設定しなければなりません。指定しなかった場合は、 自動的に
``Zend_Http_Client_Adapter_Socket`` による直接接続に切り替わります。 proxy_port
のデフォルトは '8080' です。もし別のポートをプロキシで使用している場合は、
適切に設定する必要があります。

proxy_user および proxy_pass は、
プロキシサーバが認証を必要とする場合にのみ設定します。
これらを指定すると、'Proxy-Authentication'
ヘッダがリクエストに追加されます。プロキシで認証を必要としない場合は、
このふたつのオプションはそのままにしておきます。

proxy_auth は、プロキシが認証を必要としている場合に、
その認証形式を指定します。設定できる値は Zend_Http_Client::setAuth()
メソッドと同じです。現在はベーシック認証 (Zend_Http_Client::AUTH_BASIC)
のみをサポートしています。

.. _zend.http.client.adapters.proxy.example-1:

.. rubric:: プロキシサーバを使用した Zend_Http_Client の使用法

.. code-block:: php
   :linenos:

   // 接続パラメータを設定します
   $config = array(
       'adapter'    => 'Zend_Http_Client_Adapter_Proxy',
       'proxy_host' => 'proxy.int.zend.com',
       'proxy_port' => 8000,
       'proxy_user' => 'shahar.e',
       'proxy_pass' => 'bananashaped'
   );

   // クライアントオブジェクトのインスタンスを作成します
   $client = new Zend_Http_Client('http://www.example.com', $config);

   // 作業を続けます...

説明したとおり、もし proxy_host を省略したり空文字列を設定したりすると、
自動的に直接接続に切り替わります。これにより、設定パラメータによって
オプションでプロキシを使用できるようなアプリケーションを書くことが可能となります。

.. note::

   プロキシアダプタは ``Zend_Http_Client_Adapter_Socket``
   を継承しているので、ストリームコンテキストへのアクセスメソッド (:ref:`
   <zend.http.client.adapters.socket.streamcontext>` を参照ください)
   を使用してプロキシ接続におけるストリームコンテキストオプションを設定できます。
   その方法については上で説明しました。

.. _zend.http.client.adapters.curl:

cURL アダプタ
---------

cURL は標準的な *HTTP* クライアントライブラリで、 多くの OS に含まれています。また
*PHP* からは cURL 拡張モジュールで使用できます。 *HTTP*
クライアントで起こりうる多くの特別な例にも対応することができるので、 *HTTP*
アダプタとしては完璧な選択肢といえるでしょう。
セキュアな接続やプロキシ、そしてあらゆる種類の認証にも対応しており、
大きなファイルをサーバ間で移動させるときなどにも使用できます。

.. _zend.http.client.adapters.curl.example-1:

.. rubric:: cURL オプションの設定

.. code-block:: php
   :linenos:

   $config = array(
       'adapter'   => 'Zend_Http_Client_Adapter_Curl',
       'curloptions' => array(CURLOPT_FOLLOWLOCATION => true),
   );
   $client = new Zend_Http_Client($uri, $config);

デフォルトでは、cURL アダプタは Socket
アダプタとまったく同じ挙動となるように設定されています。 また、Socket
アダプタおよび Proxy アダプタと同じ設定パラメータを使えます。 cURL
のオプションを変更するには、アダプタのコンストラクタでキー 'curloptions'
を指定するか、あるいは ``setCurlOption($name, $value)`` をコールします。 *$name* は、cURL
拡張モジュールの CURL_* 定数に対応します。Curl ハンドルにアクセスするには
*$adapter->getHandle();* をコールします。

.. _zend.http.client.adapters.curl.example-2:

.. rubric:: ハンドルによるファイル転送

cURL を使用して、巨大なファイルを *HTTP* 越しに転送できます。

.. code-block:: php
   :linenos:

   $putFileSize   = filesize("filepath");
   $putFileHandle = fopen("filepath", "r");

   $adapter = new Zend_Http_Client_Adapter_Curl();
   $client = new Zend_Http_Client();
   $client->setAdapter($adapter);
   $adapter->setConfig(array(
       'curloptions' => array(
           CURLOPT_INFILE => $putFileHandle,
           CURLOPT_INFILESIZE => $putFileSize
       )
   ));
   $client->request("PUT");

.. _zend.http.client.adapters.test:

テストアダプタ
-------

*HTTP* 接続に依存するテストコードを書くのは非常に難しいものです。
たとえば、リモートサーバから *RSS* を取得するアプリケーションをテストするには、
ネットワークにつながっている必要があります。常にネットワークが使用できるとは限りません。

このようなときのためにあるのが ``Zend_Http_Client_Adapter_Test`` アダプタです。
``Zend_Http_Client``
を使用するアプリケーションを作成し、それをテストしたい場合には、
デフォルトのアダプタを Test アダプタ (モックオブジェクト) に変更します。
これで、サーバに接続せずにテストを行えるようになります。

``Zend_Http_Client_Adapter_Test`` には setResponse() というメソッドがあります。
このメソッドのパラメータには、 *HTTP* レスポンスをテキストか ``Zend_Http_Response``
オブジェクトで指定できます。 レスポンスを設定すると、Test
アダプタは常にこのレスポンスを返すようになります。 実際の *HTTP*
リクエストは行いません。

.. _zend.http.client.adapters.test.example-1:

.. rubric:: HTTP レスポンススタブを使用したテスト

.. code-block:: php
   :linenos:

   // 新しいアダプタとクライアントのインスタンスを作成します
   $adapter = new Zend_Http_Client_Adapter_Test();
   $client = new Zend_Http_Client('http://www.example.com', array(
       'adapter' => $adapter
   ));

   // 想定するレスポンスを設定します
   $adapter->setResponse(
       "HTTP/1.1 200 OK"        . "\r\n" .
       "Content-type: text/xml" . "\r\n" .
                                  "\r\n" .
       '<?xml version="1.0" encoding="UTF-8"?>' .
       '<rss version="2.0" ' .
       '     xmlns:content="http://purl.org/rss/1.0/modules/content/"' .
       '     xmlns:wfw="http://wellformedweb.org/CommentAPI/"' .
       '     xmlns:dc="http://purl.org/dc/elements/1.1/">' .
       '  <channel>' .
       '    <title>Premature Optimization</title>' .
       // などなど...
       '</rss>');

   $response = $client->request('GET');
   // .. $response の処理を続けます...

上の例のようにすると、 *HTTP*
クライアントにお望みのレスポンスを返させることができます。
その際にネットワーク接続は使用しません。また、実際のサーバからのレスポンスも使用しません。
この場合、このテストでテストするのは、 レスポンス本文の *XML*
をアプリケーションが正しくパースできるかどうかということです。

時には、オブジェクトに対するひとつのメソッド呼び出しの中で複数の *HTTP*
トランザクションを行うこともあるでしょう。そのような場合は setResponse()
を単独で使うことはできません。なぜなら、
結果が呼び出し元に返ってくるまで次のレスポンスを設定できないからです。

.. _zend.http.client.adapters.test.example-2:

.. rubric:: 複数の HTTP レスポンススタブを使用したテスト

.. code-block:: php
   :linenos:

   // 新しいアダプタおよびクライアントのインスタンスを作成します
   $adapter = new Zend_Http_Client_Adapter_Test();
   $client = new Zend_Http_Client('http://www.example.com', array(
       'adapter' => $adapter
   ));

   // 最初の応答として期待する値を設定します
   $adapter->setResponse(
       "HTTP/1.1 302 Found"      . "\r\n" .
       "Location: /"             . "\r\n" .
       "Content-Type: text/html" . "\r\n" .
                                   "\r\n" .
       '<html>' .
       '  <head><title>Moved</title></head>' .
       '  <body><p>This page has moved.</p></body>' .
       '</html>');

   // それに続くレスポンスを設定します
   $adapter->addResponse(
       "HTTP/1.1 200 OK"         . "\r\n" .
       "Content-Type: text/html" . "\r\n" .
                                   "\r\n" .
       '<html>' .
       '  <head><title>My Pet Store Home Page</title></head>' .
       '  <body><p>...</p></body>' .
       '</html>');

   // HTTP クライアントオブジェクト ($client) をテスト対象の
   // オブジェクトに注入し、オブジェクトの動きを以下でテストします

setResponse() メソッドは、 ``Zend_Http_Client_Adapter_Test``
のバッファにあるレスポンスをすべて削除し、
最初に返されるレスポンスを設定します。addResponse()
メソッドは、それに続くレスポンスを追加します。

レスポンスは、それを追加した順に再生されます。
登録したよりも多くのリクエストが発生した場合は、
返されるレスポンスは最初のものに戻り、そこからまた順に返されるようになります。

上の例で、このアダプタがテストするように設定されているのは、 302
リダイレクトが発生した場合のオブジェクトの挙動です。
アプリケーションの内容によって、リダイレクトさせるべきなのかそうでないのかは異なるでしょう。
この例ではリダイレクトさせることを想定しているので、
テストアダプタもそれにあわせて設定しています。 最初の 302 レスポンスを
setResponse() メソッドで設定し、 次に返される 200 レスポンスを addResponse()
メソッドで設定します。 テストアダプタを設定し終えたら、そのアダプタを含む
*HTTP* クライアントをテスト対象オブジェクトに注入し、その挙動をテストします。

アダプタをわざと失敗させたい場合は ``setNextRequestWillFail($flag)`` を使用します。
このメソッドは、次に ``connect()`` をコールしたときに ``Zend_Http_Client_Adapter_Exception``
を発生させます。これは、外部のサイトのコンテンツをキャッシュするアプリケーションで、
(外部サイトがダウンしていたときの) 挙動をテストする際に有用です。

.. _zend.http.client.adapters.test.example-3:

.. rubric:: アダプタを失敗させる

.. code-block:: php
   :linenos:

   // 新たなアダプタとクライアントを作成します
   $adapter = new Zend_Http_Client_Adapter_Test();
   $client = new Zend_Http_Client('http://www.example.com', array(
       'adapter' => $adapter
   ));

   // 次のリクエストでわざと例外を発生させます
   $adapter->setNextRequestWillFail(true);

   try {
       // これは Zend_Http_Client_Adapter_Exception となります
       $client->request();
   } catch (Zend_Http_Client_Adapter_Exception $e) {
       // ...
   }

   // これ以降の処理は、 setNextRequestWillFail(true) を次に呼び出すまで
   //通常通りに行います

.. _zend.http.client.adapters.extending:

独自の接続アダプタの作成
------------

独自の接続アダプタを作成し、それを使用することもできます。
たとえば持続的なソケットを使用するアダプタを作成したり、
キャッシュ機能を追加したアダプタを作成したりなど、
作成するアプリケーションの要件にあわせたものを作成することが可能です。

そのためには、 ``Zend_Http_Client_Adapter_Interface``
を実装したクラスを作成する必要があります。
以下の例は、ユーザ定義のアダプタクラスの雛形となります。
この例で定義されているすべてのパブリック関数を、
アダプタで定義する必要があります。

.. _zend.http.client.adapters.extending.example-1:

.. rubric:: 独自の接続アダプタの作成

.. code-block:: php
   :linenos:

   class MyApp_Http_Client_Adapter_BananaProtocol
       implements Zend_Http_Client_Adapter_Interface
   {
       /**
        * アダプタの設定配列を設定する
        *
        * @param array $config
        */
       public function setConfig($config = array())
       {
           // ここはほとんど変更することはありません -
           // 通常は Zend_Http_Client_Adapter_Socket の実装をコピーします
       }

       /**
        * リモートサーバに接続する
        *
        * @param string  $host
        * @param int     $port
        * @param boolean $secure
        */
       public function connect($host, $port = 80, $secure = false)
       {
           // リモートサーバとの接続を確立します
       }

       /**
        * リクエストをリモートサーバに送信する
        *
        * @param string        $method
        * @param Zend_Uri_Http $url
        * @param string        $http_ver
        * @param array         $headers
        * @param string        $body
        * @return string Request as text
        */
       public function write($method,
                             $url,
                             $http_ver = '1.1',
                             $headers = array(),
                             $body = '')
       {
           // リクエストをリモートサーバに送信します。
           // この関数は、リクエスト全体 (ヘッダおよび本文)
           // を文字列で返します。
       }

       /**
        * サーバからのレスポンスを読み込む
        *
        * @return string
        */
       public function read()
       {
           // リモートサーバからのレスポンスを読み込み、それを文字列で返します。
       }

       /**
        * サーバとの接続を閉じる
        *
        */
       public function close()
       {
           // リモートサーバとの接続を閉じます。最後にコールされます。
       }
   }

   // そして、このアダプタを使用します
   $client = new Zend_Http_Client(array(
       'adapter' => 'MyApp_Http_Client_Adapter_BananaProtocol'
   ));



.. _`ここ`: http://www.php.net/manual/ja/transports.php#transports.inet
.. _`ストリームコンテキスト`: http://www.php.net/manual/ja/stream.contexts.php
.. _`stream_context_create()`: http://php.net/manual/ja/function.stream-context-create.php
