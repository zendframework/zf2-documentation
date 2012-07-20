.. _zend.json.server:

Zend_Json_Server - JSON-RPCサーバー
===============================

``Zend_Json_Server``\ は `JSON-RPC`_ サーバー実装です。それは `バージョン 2 仕様`_ と同様に
`JSON-RPCバージョン 1 仕様`_ の両方をサポートします;
それは、サービスのメタデータをサービス利用者に提供するために、 `サービス
マッピング定義 (SMD) 仕様`_\ の *PHP*\ 実装を提供します。

JSON-RPCは、軽量なリモート・プロシージャ呼出しプロトコルです。
そのプロトコルでは、 *JSON*\ をそのメッセージのエンベロープのために利用します。
このJSON-RPC実装は *PHP*\ の `SoapServer`_ *API*\ に従います。
このことにより典型的状況では、簡単に下記のことができます:

- サーバーオブジェクトのインスタンス化

- 一つ以上の関数やクラス/オブジェクトをサーバーオブジェクトに配置

- リクエストの handle()

``Zend_Json_Server``\ は どんな付属のクラスまたは関数でも :ref:` <zend.server.reflection>`\
Reflectionを実行することを利用します。
また、SMDと実施するメソッド呼び出しのシグナチュアとの両方をビルドするためにその情報を使います。
そのように、それはどんな付属の関数またはクラス・メソッドでも完全な *PHP*
docblock文書を最小限、持つ命令文です:

- パラメータとそれらで期待される変数の型の全て

- 戻り値変数の型

``Zend_Json_Server``\ はこの時だけPOSTリクエストをリスンします;
幸いにも、この文書の時点では、ワイルドなJSON-RPC実装の大半は、
そのようにリクエストをポストするだけです。 次の例で示されるように、
リクエストの処理だけではなく、サービスSMDの配信の両方で
同じサーバーエンドポイントを簡単に利用できるようにします。

.. _zend.json.server.usage:

.. rubric:: Zend_Json_Server利用方法

最初に、JSON-RPCサーバーによって公開したいクラスを定義しましょう。 そのクラスを
'Calculator' とし、 'add'、'subtract'、'multiply' 及び 'divide'メソッドを定義します:

.. code-block:: php
   :linenos:

   /**
    * Calculator - JSON-RPCを通じて公開するサンプル・クラス。
    */
   class Calculator
   {
       /**
        * ２つの変数の合計を返します
        *
        * @param  int $x
        * @param  int $y
        * @return int
        */
       public function add($x, $y)
       {
           return $x + $y;
       }

       /**
        * ２つの変数の差を返します
        *
        * @param  int $x
        * @param  int $y
        * @return int
        */
       public function subtract($x, $y)
       {
           return $x - $y;
       }

       /**
        * ２つの変数の積を返します
        *
        * @param  int $x
        * @param  int $y
        * @return int
        */
       public function multiply($x, $y)
       {
           return $x * $y;
       }

       /**
        * ２つの変数の除算結果を返します
        *
        * @param  int $x
        * @param  int $y
        * @return float
        */
       public function divide($x, $y)
       {
           return $x / $y;
       }
   }

それぞれのメソッドで戻り値のための項目だけでなく、
それぞれのパラメータとその型を示す項目を持つdocblockを持つことに注意してください。
それに関しては、Zend Frameworkで ``Zend_Json_Server``\ や
その他のいずれのサーバー構成要素を利用するときでも、これは **絶対重要**\ です。

それでは、リクエストを処理するためのスクリプトを作成します:

.. code-block:: php
   :linenos:

   $server = new Zend_Json_Server();

   // どのような機能が利用できるか示します:
   $server->setClass('Calculator');

   //リクエストを処理:
   $server->handle();

しかしながら、JSON-RPCクライアントがメソッドを自動検出できるように、
SMDを返す問題を対象にしません。 それは、 *HTTP*\
がメソッドをリクエストすることを確定し、
それから、若干のサーバー・メタデータを指定することによって達成されます:

.. code-block:: php
   :linenos:

   $server = new Zend_Json_Server();
   $server->setClass('Calculator');

   if ('GET' == $_SERVER['REQUEST_METHOD']) {
       // URLのエンドポイント及び使用するJSON-RPCのバージョンを示します:
       $server->setTarget('/json-rpc.php')
              ->setEnvelope(Zend_Json_Server_Smd::ENV_JSONRPC_2);

       // SMDをつかみます
       $smd = $server->getServiceMap();

       // クライアントにSMDを返します
       header('Content-Type: application/json');
       echo $smd;
       return;
   }

   $server->handle();

DojoツールキットでJSON-RPCサーバーを利用するなら、
その２つがきちんと相互作用することを確実にするために、
特別な互換性フラグをセットする必要もあります:

.. code-block:: php
   :linenos:

   $server = new Zend_Json_Server();
   $server->setClass('Calculator');

   if ('GET' == $_SERVER['REQUEST_METHOD']) {
       $server->setTarget('/json-rpc.php')
              ->setEnvelope(Zend_Json_Server_Smd::ENV_JSONRPC_2);
       $smd = $server->getServiceMap();

       // Dojo互換を設定します:
       $smd->setDojoCompatible(true);

       header('Content-Type: application/json');
       echo $smd;
       return;
   }

   $server->handle();

.. _zend.json.server.details:

高度な詳細
-----

``Zend_Json_Server``\ の機能の大半が :ref:` <zend.json.server.usage>`\ で説明されており、
より高度な機能を利用できます。

.. _zend.json.server.details.zendjsonserver:

Zend_Json_Server
^^^^^^^^^^^^^^^^

``Zend_Json_Server``\ は、 JSON-RPCを提供する中心的なクラスです;
それはすべてのリクエストを扱い、 レスポンス・ペイロードを返します。
下記のメソッドがあります:

- ``addFunction($function)``: サーバーに関連するユーザーランド関数を指定します。

- ``setClass($class)``: サーバーに関連するクラスまたはオブジェクトを指定します;
  そのアイテムのすべてのpublicメソッドは、 JSON-RPCメソッドに公開されます。

- *fault($fault = null, $code = 404, $data = null)*: ``Zend_Json_Server_Error``\
  オブジェクトを生成して返します。

- ``handle($request = false)``: JSON-RPCリクエストを処理します; 任意で、利用するための
  ``Zend_Json_Server_Request``\ オブジェクトを渡します。 (デフォルトで１つ生成されます)

- ``getFunctions()``: 付属のメソッド全ての一覧を返します。

- *setRequest(Zend_Json_Server_Request $request)*:
  サーバーのために使用するためのリクエストオブジェクトを指定します。

- ``getRequest()``: サーバーで使われるリクエストオブジェクトを取得します。

- *setResponse(Zend_Json_Server_Response $response)*:
  サーバーのために使用するためのレスポンスオブジェクトを設定します。

- ``getResponse()``: サーバーで使われるレスポンスオブジェクトを取得します。

- ``setAutoEmitResponse($flag)``:
  サーバーがレスポンスとすべてのヘッダを自動的に送り出さなければならないかどうか示します;
  デフォルトで、これは ``TRUE`` です。

- ``autoEmitResponse()``: レスポンスの自動送出が使用可能かどうか決定します。

- ``getServiceMap()``: ``Zend_Json_Server_Smd``\ オブジェクトの形で
  サービス・マップ記述を取得します

.. _zend.json.server.details.zendjsonserverrequest:

Zend_Json_Server_Request
^^^^^^^^^^^^^^^^^^^^^^^^

JSON-RPCのリクエスト環境は、 ``Zend_Json_Server_Request``\
オブジェクトにカプセル化されます。
このオブジェクトによって、リクエストIDやパラメータ、JSON-RPC仕様のバージョンを含む
JSON-RPCリクエストの必要な部分を設定できます。 それには *JSON*\
または一組のオプションによってそれ自体をロードする能力があって、 それ自体を
``toJson()``\ メソッドにより *JSON*\ として翻訳できます。

リクエスト・オブジェクトでは、以下のメソッドを利用できます:

- ``setOptions(array $options)``: オブジェクトの設定を指定します。 ``$options``\ は、どの 'set'
  メソッドにもマッチするキーを含むでしょう: ``setParams()``\ 、 ``setMethod()``\ 、
  ``setId()``\ 及び ``setVersion()``

- ``addParam($value, $key = null)``: メソッド呼び出しで使うパラメータを追加します。
  パラメータは値そのものか、パラメータ名を任意に含むことができます。

- ``addParams(array $params)``: 一度に複数のパラメータを追加します。 ``addParam()``\
  の代わりになります。

- ``setParams(array $params)``: 一度に全てのパラメータを設定します;
  既存の全てのパラメータを上書きします。

- ``getParam($index)``: 位置または名前でパラメータを返します。

- ``getParams()``: 一度に全てのパラメータを返します。

- ``setMethod($name)``: 呼び出すメソッドを設定します。

- ``getMethod()``: 呼び出されるメソッドを取得します。

- ``isMethodError()``: リクエストが異常で、エラーに終わるかどうか決定します。

- ``setId($name)``:
  リクエスト識別子（クライアントでレスポンスにリクエストにマッチすることに使われる）をセットします。

- ``getId()``: リクエストの識別子を取得します。

- ``setVersion($version)``: リクエストが適合するJSON-RPC仕様バージョンを設定します。
  おそらく '1.0' かまたは '2.0' のどちらかです。

- ``getVersion()``: リクエストで使われるJSON-RPC仕様バージョンを取得します。

- ``loadJson($json)``: *JSON*\ 文字列からリクエストオブジェクトを読み込みます。

- ``toJson()``: リクエストを *JSON*\ ストリングに翻訳します。

*HTTP*\ に特有のバージョンは、 ``Zend_Json_Server_Request_Http``\ を通して利用できます。
このクラスは *php://input*\ を通じてリクエストを取得し、 ``getRawJson()``\
メソッドを通じて生の *JSON*\ へのアクセスを可能にします。

.. _zend.json.server.details.zendjsonserverresponse:

Zend_Json_Server_Response
^^^^^^^^^^^^^^^^^^^^^^^^^

JSON-RPCレスポンス・ペイロードは、 ``Zend_Json_Server_Response``\
オブジェクトにカプセル化されます。 このオブジェクトにより、
リクエストの戻り値、レスポンスがエラーかどうか、
リクエスト識別子、レスポンスが従うJSON-RPC仕様バージョン、
そして任意にサービス・マップをセットできます。

レスポンス・オブジェクトでは、以下のメソッドを利用できます:

- ``setResult($value)``: レスポンス結果を設定します。

- ``getResult()``: レスポンス結果を取得します。

- *setError(Zend_Json_Server_Error $error)*: エラーオブジェクトを設定します。 設定すると、
  *JSON*\ にシリアライズ化するとき、これがレスポンスとして使われます。

- ``getError()``: もしあれば、エラーオブジェクトを取得します。

- ``isError()``: レスポンスがエラー・レスポンスであるかどうか。

- ``setId($name)``: リクエスト識別子
  （クライアントはオリジナルのリクエストでレスポンスにマッチするかもしれません）
  を設定します。

- ``getId()``: リクエスト識別子を取得します。

- ``setVersion($version)``: レスポンスが適合するJSON-RPCバージョンを設定します。

- ``getVersion()``: レスポンスが適合するJSON-RPCバージョンを取得します。

- ``toJson()``:
  レスポンスがエラー・レスポンスで、エラー・オブジェクトをシリアライズ化するならば、
  *JSON*\ に対するレスポンスをシリアライズ化します。

- ``setServiceMap($serviceMap)``:
  サービス・マップ・オブジェクトをレスポンスに設定します。

- ``getServiceMap()``: もしあれば、サービス・マップ・オブジェクトを取得します。

*HTTP*\ に依存したバージョンは、 ``Zend_Json_Server_Response_Http``\ を通じて利用できます。
このクラスは *JSON*\ としてレスポンスをシリアライズ化するだけでなく、 適切な
*HTTP*\ ヘッダを送ります。

.. _zend.json.server.details.zendjsonservererror:

Zend_Json_Server_Error
^^^^^^^^^^^^^^^^^^^^^^

JSON-RPCには、エラー状況を報告するために、特別なフォーマットがあります。
エラーはすべて、最小限、エラー・メッセージとエラーコードを用意する必要があります;
任意に、追加のデータ（例えばbacktrace）を用意できます。

エラーコードは、 `XML-RPC EPIプロジェクト`_\
によって推奨されるコードに由来します。 ``Zend_Json_Server``\
は、エラー状態に基づくコードを適切に割り当てます。
アプリケーション例外のためには、コード '-32000' が使われます。

``Zend_Json_Server_Error`` は以下のメソッドを公開します:

- ``setCode($code)``: エラーコードを設定します;
  認められたXML-RPCエラーコード範囲にそのコードがないならば、
  -32000が割り当てられます。

- ``getCode()``: 現行のエラーコードを取得します。

- ``setMessage($message)``: エラーメッセージを設定します。

- ``getMessage()``: 現行のエラーメッセージを取得します。

- ``setData($data)``: backtraceのような、
  エラーを制限する補助データをさらにセットします。

- ``getData()``: 現行のエラー補助データをいずれも取得します。

- ``toArray()``: エラーを配列にキャストします。 配列は
  'code'や'message'及び'data'キーを含むでしょう。

- ``toJson()``: エラーをJSON-RPCエラー表現にキャストします。

.. _zend.json.server.details.zendjsonserversmd:

Zend_Json_Server_Smd
^^^^^^^^^^^^^^^^^^^^

SMDは、サービス・マッピング記述、
特定のウェブ・サービスとクライアントが相互作用できる方法を定義する *JSON*\
スキーマ、を表します。 この文書の時点では、 `仕様`_\
は正式にまだ批准されませんでした、
しかし、それは他のJSON-RPC利用者のクライアントだけでなく、
Dojoツールキットの範囲内ですでに使用中です。

最も基本的には、サービス・マッピング記述は、トランスポート（POST、GET、
*TCP*/IP、その他）
リクエスト・エンベロープ・タイプ（通常、サーバーのプロトコルに基づきます）、
サービスプロバイダのターゲット *URL*\ 、
そして利用できるサービスマップのメソッドを示します。
JSON-RPCの場合、サービス・マップは利用できるメソッドのリストです、
そしてそれは、各々のメソッドの期待される戻り値タイプだけでなく、
利用できるパラメータとタイプを文書化します。

``Zend_Json_Server_Smd``\ は、
サービス・マップをビルドするオブジェクト指向方法を準備します。
最も基本的には、ミューテータを用いてサービスを記述しているメタデータをそれに渡して、
サービス（メソッドと関数）を指定します。

サービス記述自体は、 一般的に ``Zend_Json_Server_Smd_Service``\ のインスタンスです;
``Zend_Json_Server_Smd``\ の
いろいろなサービス・ミューテータへの配列としてすべての情報を渡すこともできます、
そして、それはサービス・オブジェクトのインスタンスを生成します。
サービス・オブジェクトは、サービス名（一般的に関数またはメソッド名）、
パラメータ（名前、型と位置）や戻り値の型のような情報を含みます。
めったに使われない機能ですが、
各々のサービスはそれ自身のターゲットとエンベロープを任意に持つことができます。

付属のクラスと関数のreflectionを用いて、 ``Zend_Json_Server``\
は舞台裏ですべてを実際に行ないます;
クラスと関数自身への参照で提供することができないカスタム機能を準備する必要がある場合だけ、
あなた自身のサービス・マップを生成しなければなりません。

``Zend_Json_Server_Smd``\ での利用可能なメソッドを含みます:

- ``setOptions(array $options)``: オプション配列からSMDオブジェクトをセットアップします。
  ミューテーターのすべてを、キーとして使うことができます。 (メソッドは 'set'
  で始まります)

- ``setTransport($transport)``:
  サービスにアクセスするために使われるトランスポートを設定します; 現行では POST
  だけがサポートされます。

- ``getTransport()``: 現行のサービストランスポートを取得します。

- ``setEnvelope($envelopeType)``:
  サービスにアクセスするために使われるであろうリクエスト・エンベロープを設定します。
  現行では定数の ``Zend_Json_Server_Smd::ENV_JSONRPC_1``\ 及び ``Zend_Json_Server_Smd::ENV_JSONRPC_2``\
  をサポートします。

- ``getEnvelope()``: 現行のリクエスト・エンベロープを取得します。

- ``setContentType($type)``: リクエストが使うであろうコンテンツタイプを設定します。
  (デフォルトでは、これは 'application/json' です)

- ``getContentType()``:
  サービスにリクエストするための、現行のコンテンツタイプを取得します。

- ``setTarget($target)``: サービスのための *URL*\ エンドポイントを設定します。

- ``getTarget()``: サービスのための *URL*\ エンドポイントを取得します。

- ``setId($id)``: 一般的に、（ターゲットと同じく）これはサービスの *URL*\
  エンドポイントです。

- ``getId()``: サービスIDを取得します。 (一般的に、サービスの *URL*\
  エンドポイントです)

- ``setDescription($description)``: サービスの定義を設定します。
  (一般的に、サービスの目的を説明する物語の情報です)

- ``getDescription()``: サービスの定義を取得します。

- ``setDojoCompatible($flag)``:
  SMDがDojoツールキットと互換かどうか示すフラグを設定します。 ``TRUE``
  の場合、生成された *JSON* SMDは、
  DojoのJSON-RPCクライアントが期待する形式に従ってフォーマットされます。

- ``isDojoCompatible()``: Dojo互換性フラグの値を返します。 (デフォルトでは ``FALSE`` です)

- ``addService($service)``: マップするサービスを追加します。 ``Zend_Json_Server_Smd_Service``\
  のコンストラクタに渡す情報の配列か、
  またはそのクラスのインスタンスでしょう。

- ``addServices(array $services)``: 一度に複数のサービスを追加します。

- ``setServices(array $services)``: 一度に複数のサービスを設定します。
  以前に設定されたサービスを全て上書きします。

- ``getService($name)``: 名前でサービスを取得します。

- ``getServices()``: 付属のサービスを全て取得します。

- ``removeService($name)``: マップからサービスを除去します。

- ``toArray()``: サービスマップを配列にキャストします。

- ``toDojoArray()``: サービスマップをDojoツールキット互換の配列にキャストします。

- ``toJson()``: サービスマップを *JSON*\ 表現にキャストします。

``Zend_Json_Server_Smd_Service``\ には下記のメソッドがあります:

- ``setOptions(array $options)``: 配列からオブジェクトの状態を設定します。
  どのミューテーター(メソッドは 'set' で始まります)でもキーとして使われ、
  このメソッドを通じて設定されるでしょう。

- ``setName($name)``: サービス名を設定します。 (一般的には、関数やメソッドの名前)

- ``getName()``: サービス名を取得します。

- ``setTransport($transport)``: サービスのトランスポートを設定します。 (現行では、
  ``Zend_Json_Server_Smd``\ によりサポートされる トランスポートのみ許可されます)

- ``getTransport()``: Retrieve the current transport.

- ``setTarget($target)``: サービスの *URL*\ エンドポイントを設定します。
  (一般的には、サービスが付与される全体的なSMDとこれは同じです。)

- ``getTarget()``: サービスの *URL*\ エンドポイントを取得します。

- ``setEnvelope($envelopeType)``: サービスのエンベロープタイプを設定します。 (現行では、
  ``Zend_Json_Server_Smd``\ によりサポートされる エンベロープのみ許可されます)

- ``getEnvelope()``: サービスのエンベロープタイプを取得します。

- *addParam($type, array $options = array(), $order = null)*: サービスにパラメータを追加します。
  デフォルトで、パラメータ型だけは必要です。
  しかしながら、下記のオプションのように、指令を与えたいかもしれません:

  - **name**: パラメータ名

  - **optional**: パラメータが任意か否か

  - **default**: パラメータの既定値

  - **description**: パラメータを記述するテキスト

- ``addParams(array $params)``: 一度にいくつかのパラメータを追加します;
  各々のパラメータは、最小限、パラメータ型を記述する '型' 、 さらに任意で '順序'
  キーを含む連想配列でなければなりません。 その他の全てのキーは ``addOption()``\ に
  ``$options``\ として渡されます。

- ``setParams(array $params)``: 一度に複数のパラメーターを設定します。
  既存のパラメータを全て上書きします。

- ``getParams()``: 現行で設定されているパラメータを全て取得します。

- ``setReturn($type)``: サービスの返り値の型を設定します。

- ``getReturn()``: サービスの返り値の型を取得します。

- ``toArray()``: サービスを配列にキャストします。

- ``toJson()``: サービスを *JSON*\ 表現にキャストします。



.. _`JSON-RPC`: http://groups.google.com/group/json-rpc/
.. _`バージョン 2 仕様`: http://groups.google.com/group/json-rpc/web/json-rpc-1-2-proposal
.. _`JSON-RPCバージョン 1 仕様`: http://json-rpc.org/wiki/specification
.. _`サービス マッピング定義 (SMD) 仕様`: http://groups.google.com/group/json-schema/web/service-mapping-description-proposal
.. _`SoapServer`: http://www.php.net/manual/ja/class.soapserver.php
.. _`XML-RPC EPIプロジェクト`: http://xmlrpc-epi.sourceforge.net/specs/rfc.fault_codes.php
.. _`仕様`: http://groups.google.com/group/json-schema/web/service-mapping-description-proposal
