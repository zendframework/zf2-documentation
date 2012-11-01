.. EN-Revision: none
.. _zend.soap.client:

Zend\Soap\Client
================

``Zend\Soap\Client``\ により *PHP*\ プログラマーにとって *SOAP*\
クライアントの開発が簡単になります。

WSDLモードまたは非WSDLモードで使用できるでしょう。

WSDLモードでは、 ``Zend\Soap\Client``\ コンポーネントは
トランスポート層オプションを定めるためにWSDLドキュメントを使います。

WSDL記述は通常、クライアントがアクセスするウェブ・サービスによって提供されます。
WSDL記述が利用できるようにならなければ、非WSDLモードで ``Zend\Soap\Client``\
を使いたいかもしれません。 すべての *SOAP*\ プロトコル・オプションは、
このモードで明示的に ``Zend\Soap\Client``\ クラス上に設定されなければなりません。

.. _zend.soap.client.constructor:

Zend\Soap\Clientコンストラクタ
-----------------------

``Zend\Soap\Client``\ コンストラクタには引数が２つあります:

   - *$wsdl*- WSDLファイルの *URI*

   - *$options*-*SOAP*\ クライアントオブジェクトを作成するためのオプション

これらのパラメータは両方とも、 それぞれ ``setWsdl($wsdl)``\ や ``setOptions($options)``\
メソッドで、 後から設定されるかもしれません。

.. note::

   **重要**

   もし非WSDLモードで ``Zend\Soap\Client``\ コンポーネントを使う場合、 'location' および
   'uri' オプションを設定し **なければなりません**\ 。

下記のオプションが許されています:

   - 'soap_version' ('soapVersion') - 使用する *SOAP*\ バージョン (SOAP_1_1 または SOAP_1_2).

   - 'classmap' ('classMap') - 一部の WSDL 型を *PHP*\ クラスにマップするために使います。

     このオプションは、キーとしてWSDL型、値として *PHP*\
     クラス名をもつ配列でなければなりません。

   - 'encoding' - 内部文字エンコーディング。
     (対外的なエンコーディングとしてUTF-8が常に使われます)

   - 'wsdl'``setWsdl($wsdlValue)``\ 呼び出しと同じです。

     このオプションを変更すると、 ``Zend\Soap\Client``\
     オブジェクトをWSDLモードに、または、から切り替えるかもしれません。

   - 'uri' -*SOAP*\ サービスのためのターゲットのネームスペース
     (非WSDLモードで必要です。WSDLモードでは動作しません)

   - 'location' - 要求する *URL* (非WSDLモードで必要です。WSDLモードでは動作しません)

   - 'style' - 要求形式 (WSDLモードでは動作しません): *SOAP_RPC* または *SOAP_DOCUMENT*

   - 'use' - メッセージをエンコードするメソッド (WSDLモードでは動作しません):
     *SOAP_ENCODED* または *SOAP_LITERAL*

   - 'login' および 'password' -*HTTP*\ 認証のための login および password

   - 'proxy_host', 'proxy_port', 'proxy_login' および 'proxy_password' - プロキシ・サーバ経由の
     *HTTP*\ 接続

   - 'local_cert' および 'passphrase' -*HTTPS*\ クライアント証明書認証オプション。

   - 'compression' - 圧縮オプション; *SOAP_COMPRESSION_ACCEPT*\ や *SOAP_COMPRESSION_GZIP*\ 、
     *SOAP_COMPRESSION_DEFLATE*\ の組み合わせです。 下記のように使われるでしょう:

        .. code-block:: php
           :linenos:

           // レスポンスの圧縮を受け付けます
           $client = new Zend\Soap\Client("some.wsdl",
             array('compression' => SOAP_COMPRESSION_ACCEPT));
           ...

           // 圧縮レベル５でqzipを使ってリクエストを圧縮します
           $client = new Zend\Soap\Client("some.wsdl",
             array('compression' => SOAP_COMPRESSION_ACCEPT | SOAP_COMPRESSION_GZIP | 5));
           ...

           // deflate 圧縮を使ってリクエストを圧縮します
           $client = new Zend\Soap\Client("some.wsdl",
             array('compression' => SOAP_COMPRESSION_ACCEPT | SOAP_COMPRESSION_DEFLATE));





.. _zend.soap.client.calls:

SOAPリクエストの実行
------------

``Zend\Soap\Client``\ オブジェクトを作成したら、 *SOAP*\
リクエストを実行する準備ができます。

ウェブ・サービス・メソッドそれぞれで、 一般的な *PHP*\ 型のパラメータを持つ仮想
``Zend\Soap\Client``\ オブジェクト・メソッドにマップされます。

それを下記の例のように使います:

   .. code-block:: php
      :linenos:

      //****************************************************************
      //                サーバのコード
      //****************************************************************
      // class MyClass {
      //     /**
      //      * このメソッドは ...
      //      *
      //      * @param integer $inputParam
      //      * @return string
      //      */
      //     public function method1($inputParam) {
      //         ...
      //     }
      //
      //     /**
      //      * このメソッドは ...
      //      *
      //      * @param integer $inputParam1
      //      * @param string  $inputParam2
      //      * @return float
      //      */
      //     public function method2($inputParam1, $inputParam2) {
      //         ...
      //     }
      //
      //     ...
      // }
      // ...
      // $server = new Zend\Soap\Server(null, $options);
      // $server->setClass('MyClass');
      // ...
      // $server->handle();
      //
      //****************************************************************
      //                サーバのコード終了
      //****************************************************************

      $client = new Zend\Soap\Client("MyService.wsdl");
      ...

      // $result1 は string です。
      $result1 = $client->method1(10);
      ...

      // $result2 は float です。
      $result2 = $client->method2(22, 'some string');




