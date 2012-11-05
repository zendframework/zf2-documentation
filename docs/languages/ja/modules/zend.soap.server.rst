.. EN-Revision: none
.. _zend.soap.server:

Zend\Soap\Server
================

``Zend\Soap\Server``\ クラスは、 ウェブ・サービス部分の開発を *PHP*\
プログラマーにとって簡単にすることを目的としています。

それは、ウェブサービス *API*\ を定義するクラスまたは機能を使って、
WSDLモードまたは非WSDLモードで使われるかもしれません。

``Zend\Soap\Server``\ コンポーネントがWSDLモードで動くとき、
サーバオブジェクトの挙動とトランスポート層オプションを定義する
すでに用意されたWSDLドキュメントを使います。

WSDLドキュメントは :ref:`Zend\Soap\AutoDiscoveryコンポーネント
<zend.soap.autodiscovery.introduction>`
によって提供される機能によって自動的に生成されるか、 または、
:ref:`Zend\Soap\Wsdlクラス <zend.soap.wsdl>`\ や、 その他の *XML*\ 生成ツールを使って、
手動で構成されます。

非WSDLモードが使われるならば、
すべてのプロトコル・オプションはオプション・メカニズムを用いて設定されなければなりません。

.. _zend.soap.server.constructor:

Zend\Soap\Serverコンストラクタ
-----------------------

``Zend\Soap\Server``\ コンストラクタは、
WSDLモードと非WSDLモードとでは少し使い方が違います。

.. _zend.soap.server.constructor.wsdl_mode:

WSDLモードのためのZend\Soap\Serverコンストラクタ
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

WSDLモードで動作する場合、 ``Zend\Soap\Server``\
コンストラクタは２つの引数を受け取ります:

   . *$wsdl* WSDLファイルの *URI* [#]_

   . *$options*-*SOAP*\ サーバオブジェクトを作成するためのオプション [#]_

     WSDLモードでは下記のオプションが許されています:

        - 'soap_version' ('soapVersion') - 使用する *SOAP*\ バージョン (SOAP_1_1 または SOAP_1_2)

        - 'actor' - サーバのためのアクター *URI*\ 。

        - 'classmap' ('classMap') - 一部の WSDL 型を *PHP*\
          クラスにマップするために使います。

          このオプションは、キーとしてWSDL型、値として *PHP*\
          クラス名をもつ配列でなければなりません。

        - 'encoding' - 内部文字エンコーディング。
          (対外的なエンコーディングとしてUTF-8が常に使われます)

        - 'wsdl'``setWsdl($wsdlValue)``\ 呼び出しと同じです。





.. _zend.soap.server.wsdl_mode:

非WSDLモードのためのZend\Soap\Serverコンストラクタ
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

非WSDLモードで ``Zend\Soap\Server``\ 機能を使うつもりなら、
最初のコンストラクタ・パラメータは ``NULL``\ に設定し **なければなりません**\ 。

この場合、'uri' オプションを設定しなければなりません。（下記参照）

２番目のコンストラクタ・パラメータ (*$options*) は、 *SOAP*\
サーバオブジェクトを作成するためのオプション配列です [#]_

非WSDLモードでは下記のオプションが許されています:

   - 'soap_version' ('soapVersion') - 使用する *SOAP*\ バージョン (SOAP_1_1 または SOAP_1_2)

   - 'actor' - サーバのためのアクター *URI*\ 。

   - 'classmap' ('classMap') - 一部の WSDL 型を *PHP*\ クラスにマップするために使います。

     このオプションは、キーとしてWSDL型、値として *PHP*\
     クラス名をもつ配列でなければなりません。

   - 'encoding' - 内部文字エンコーディング。
     (対外的なエンコーディングとしてUTF-8が常に使われます)

   - 'uri' (必須) -*SOAP*\ サーバのための *URI*\ ネームスペース



.. _zend.soap.server.api_define_methods:

ウェブ・サービスAPIを定義するメソッド
--------------------

*SOAP*\ を通して *PHP*\ コードにアクセスすることを許可したいときに、
ウェブサービス *API*\ を定義する2つの方法があります。

最初の一つは、ウェブサービス *API*\ を完全に記述しなければならない
``Zend\Soap\Server``\ オブジェクトに対して、 いくつかのクラスを付与することです:

   .. code-block:: php
      :linenos:

      ...
      class MyClass {
          /**
           * このメソッドは ...
           *
           * @param integer $inputParam
           * @return string
           */
          public function method1($inputParam) {
              ...
          }

          /**
           * このメソッドは ...
           *
           * @param integer $inputParam1
           * @param string  $inputParam2
           * @return float
           */
          public function method2($inputParam1, $inputParam2) {
              ...
          }

          ...
      }
      ...
      $server = new Zend\Soap\Server(null, $options);
      // クラスをSOAPサーバにバインド
      $server->setClass('MyClass');
      // 初期化済みのオブジェクトをSOAPサーバにバインド
      $server->setObject(new MyClass());
      ...
      $server->handle();



   .. note::

      **重要**

      対応するウェブサービスWSDLを準備するautodiscover機能を使うつもりならば、
      メソッドdocblockを使って各々のメソッドを完全に記述しなければなりません。



ウェブサービス *API*\ を定義する２つ目の方法は、 関数のセットや ``addFunction()``\
または ``loadFunctions()``\ メソッドを使うことです:

   .. code-block:: php
      :linenos:

      ...
      /**
       * この関数は...
       *
       * @param integer $inputParam
       * @return string
       */
      function function1($inputParam) {
          ...
      }

      /**
       * この関数は...
       *
       * @param integer $inputParam1
       * @param string  $inputParam2
       * @return float
       */
      function function2($inputParam1, $inputParam2) {
          ...
      }
      ...
      $server = new Zend\Soap\Server(null, $options);
      $server->addFunction('function1');
      $server->addFunction('function2');
      ...
      $server->handle();



.. _zend.soap.server.request_response:

リクエストおよびレスポンスオブジェクトの操作
----------------------

.. note::

   **高度な利用**

   このセクションではリクエスト/レスポンス処理の高度なオプションを説明します。
   スキップされるかもしれません。

``Zend\Soap\Server``\
コンポーネントは自動的にリクエスト/レスポンス処理を実行します。
しかし、その処理を捕まえて何らかの事前もしくは事後の処理をさせることもできます。

.. _zend.soap.server.request_response.request:

リクエスト処理
^^^^^^^

``Zend\Soap\Server::handle()``\ メソッドは、 標準的な入力ストリーム ('php://input')
からリクエストを取得します。 それは、 ``handle()``\
メソッドにオプションのパラメータを供給することによって、 または、 ``setRequest()``\
メソッドを用いてリクエストを設定することによって 上書きされるかもしれません:

   .. code-block:: php
      :linenos:

      ...
      $server = new Zend\Soap\Server(...);
      ...
      // オプションの $request パラメータを使ってリクエストを設定
      $server->handle($request);
      ...
      // setRequest() メソッドを使ってリクエストを設定
      $server->setRequest();
      $server->handle();



リクエストオブジェクトは以下のどれかを用いて表されるかもしれません:

   - DOMDocument (*XML*\ にキャストされます)

   - DOMNode ( 所有者のドキュメントは横取りされて *XML*\ にキャストされます)

   - SimpleXMLElement (*XML*\ にキャストされます)

   - stdClass (\__toString() が呼び出されて、有効な *XML*\ であることが確かめられます)

   - string (有効な *XML*\ であることが確かめられます)



最後に処理されたリクエストは ``getLastRequest()``\ メソッドを使って *XML*\
文字列として取得されます:

   .. code-block:: php
      :linenos:

      ...
      $server = new Zend\Soap\Server(...);
      ...
      $server->handle();
      $request = $server->getLastRequest();



.. _zend.soap.server.request_response.response:

レスポンスの事前処理
^^^^^^^^^^

``Zend\Soap\Server::handle()``\
メソッドは、出力ストリームに生成されたレスポンスを自動的に送ります。 それは
``setReturnResponse()``\ にパラメータとして ``TRUE``\ または ``FALSE``\
を与えてブロックできます。 [#]_ 生成されたレスポンスはこの場合、 ``handle()``\
メソッドにより戻されます。

   .. code-block:: php
      :linenos:

      ...
      $server = new Zend\Soap\Server(...);
      ...
      // 標準出力に送る代わりに、
      //handle() メソッドの返り値としてレスポンスを取得
      $server->setReturnResponse(true);
      ...
      $response = $server->handle();
      ...



ある処理のために、最後のレスポンスを ``getLastResponse()``\
メソッドで取得することもできます:

   .. code-block:: php
      :linenos:

      ...
      $server = new Zend\Soap\Server(...);
      ...
      $server->handle();
      $response = $server->getLastResponse();
      ...





.. [#] あとで ``setWsdl($wsdl)``\ メソッドを使って 設定されるかもしれません。
.. [#] オプションは後で ``setOptions($options)``\ を使って 設定されるかもしれません。
.. [#] オプションは後で ``setOptions($options)``\ メソッドを使って
       設定されるかもしれません。
.. [#] 戻るレスポンスフラグの現在の状態は ``setReturnResponse()``
       メソッドによりリクエストされます。