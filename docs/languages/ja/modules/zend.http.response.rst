.. EN-Revision: none
.. _zend.http.response:

Zend_Http_Response
==================

.. _zend.http.response.introduction:

導入
--

``Zend_Http_Response`` は、 *HTTP* レスポンスに簡単にアクセスできるようにします。
また、 *HTTP*
レスポンスメッセージをパースするための静的メソッド群も提供します。 通常は、
``Zend_Http_Response`` は ``Zend_Http_Client`` リクエストの返す結果として使用します。

ほとんどの場合は、Zend_Http_Response オブジェクトのインスタンスを作成するには
fromString() メソッドを使用します。これは、 *HTTP*
レスポンスメッセージを含む文字列を受け取って新しい Zend_Http_Response
オブジェクトを返します。



      .. _zend.http.response.introduction.example-1:

      .. rubric:: ファクトリメソッドを使用した Zend_Http_Response オブジェクトの作成

      .. code-block:: php
         :linenos:

         $str = '';
         $sock = fsockopen('www.example.com', 80);
         $req =     "GET / HTTP/1.1\r\n" .
                 "Host: www.example.com\r\n" .
                 "Connection: close\r\n" .
                 "\r\n";

         fwrite($sock, $req);
         while ($buff = fread($sock, 1024))
             $str .= $sock;

         $response = Zend_Http_Response::fromString($str);



コンストラクタを使用して新しいオブジェクトを作成することもできます。
その際には、レスポンスの全パラメータを指定します。

*public function __construct($code, $headers, $body = null, $version = '1.1', $message = null)*

- ``$code``: *HTTP* レスポンスコード (たとえば 200 や 404 など)。

- ``$headers``: *HTTP* レスポンスヘッダの連想配列 (たとえば 'Host' => 'example.com' など)。

- ``$body``: レスポンス本文の文字列。

- ``$version``: *HTTP* レスポンスのバージョン (通常は 1.0 あるいは 1.1)。

- ``$message``: *HTTP* レスポンスメッセージ (たとえば 'OK' や 'Internal Server Error' など)。
  指定しなかった場合は、レスポンスコードに応じたメッセージが設定されます。

.. _zend.http.response.testers:

真偽チェック用のメソッド
------------

``Zend_Http_Response`` のインスタンスを取得すると、
レスポンスの種類を調べるためのメソッドが使用できるようになります。
これらのメソッドは、すべて ``TRUE`` あるいは ``FALSE`` を返します。

   - *Boolean isSuccessful()*: リクエストが成功したかどうかを調べます。 *HTTP*
     レスポンスコードが 1xx か 2xx であった場合に ``TRUE`` を返します。

   - *Boolean isError()*: レスポンスコードがエラーを意味しているかどうかを調べます。
     *HTTP* レスポンスコードが 4xx (クライアントのエラー) あるいは 5xx
     (サーバのエラー) であった場合に ``TRUE`` を返します。

   - *Boolean isRedirect()*: レスポンスがリダイレクトされているかどうかを調べます。
     *HTTP* レスポンスコードが 3xx であった場合に ``TRUE`` を返します。





      .. _zend.http.response.testers.example-1:

      .. rubric:: isError() メソッドの使用によるレスポンスの検証

      .. code-block:: php
         :linenos:

         if ($response->isError()) {
           echo "データ転送エラー。\n"
           echo "サーバからの応答: " . $response->getStatus() .
                " " . $response->getMessage() . "\n";
         }
         // .. ここでレスポンスを処理します...



.. _zend.http.response.acessors:

アクセス用メソッド群
----------

レスポンスオブジェクトの本来の目的は、レスポンスパラメータに簡単にアクセスすることです。


   - *int getStatus()*: *HTTP* レスポンスステータスコード (たとえば 200 や 504 など)
     を取得します。

   - *string getMessage()*: *HTTP* レスポンスステータスのメッセージ (たとえば "Not Found" や
     "Authorization Required" など) を取得します。

   - *string getBody()*: *HTTP* レスポンス本文をデコードしたものを取得します。

   - *string getRawBody()*: そのままの状態の、おそらくエンコードされている *HTTP*
     レスポンス本文を取得します。たとえば GZIP
     などでエンコードされていたとしても、 それはデコードされません。

   - *array getHeaders()*: *HTTP* レスポンスヘッダを、連想配列形式 (たとえば 'Content-type' =>
     'text/html' など) で取得します。

   - *string|array getHeader($header)*: $header で指定した、 特定の *HTTP*
     レスポンスヘッダを取得します。

   - *string getHeadersAsString($status_line = true, $br = "\n")*:
     ヘッダ全体を文字列として取得します。$status_line が ``TRUE`` の場合 (デフォルト)
     は、 最初のステータス行 (たとえば "HTTP/1.1 200 OK" など) も返されます。 改行は $br
     パラメータで指定します (たとえば "<br />" などにもできます)。

   - *string asString($br = "\n")*: レスポンスメッセージ全体を文字列として取得します。
     改行は $br パラメータで指定します (たとえば "<br />" などにもできます)。
     マジックメソッド \__toString()
     を使ってオブジェクトを文字列にキャストできます。 これは asString()
     へのプロキシとなります。





      .. _zend.http.response.acessors.example-1:

      .. rubric:: Zend_Http_Response へのアクセス用メソッドの使用

      .. code-block:: php
         :linenos:

         if ($response->getStatus() == 200) {
           echo "リクエストの結果は次のようになりました。<br />";
           echo $response->getBody();
         } else {
           echo "データの取得時にエラーが発生しました。<br />";
           echo $response->getStatus() . ": " . $response->getMessage();
         }



   .. note::

      **常に返り値をチェックする**

      レスポンスには同じヘッダを複数含めることができるので、 getHeader() メソッドや
      getHeaders() メソッドの返す結果は
      文字列の場合もあれば文字列の配列となる場合もあります。
      返された値が文字列なのか配列なのかを常にチェックするようにしましょう。





      .. _zend.http.response.acessors.example-2:

      .. rubric:: レスポンスヘッダへのアクセス

      .. code-block:: php
         :linenos:

         $ctype = $response->getHeader('Content-type');
         if (is_array($ctype)) $ctype = $ctype[0];

         $body = $response->getBody();
         if ($ctype == 'text/html' || $ctype == 'text/xml') {
           $body = htmlentities($body);
         }

         echo $body;



.. _zend.http.response.static_parsers:

静的 HTTP レスポンスパーサ
----------------

``Zend_Http_Response`` クラスには、内部で使用するメソッドもいくつか含まれています。
これは、 *HTTP*
レスポンスメッセージを処理したりパースしたりするためのものです。
これらのメソッドは静的メソッドとして公開されています。
つまり外部からでも使用できるということです。特にインスタンスを作成しなくても、
レスポンスの一部を抽出したりなどといった目的で使用可能です。

   - *int Zend_Http_Response::extractCode($response_str)*: *HTTP* レスポンスコード (たとえば 200 や
     404 など) を $response_str から抽出し、それを返します。

   - *string Zend_Http_Response::extractMessage($response_str)*: *HTTP* レスポンスメッセージ
     (たとえば "OK" や "File Not Found" など) を $response_str から抽出し、それを返します。

   - *string Zend_Http_Response::extractVersion($response_str)*: *HTTP* バージョン (たとえば 1.1 や 1.0
     など) を $response_str から抽出し、それを返します。

   - *array Zend_Http_Response::extractHeaders($response_str)*: *HTTP* レスポンスヘッダを $response_str
     から抽出し、それを配列で返します。

   - *string Zend_Http_Response::extractBody($response_str)*: *HTTP* レスポンス本文を $response_str
     から抽出し、それを返します。

   - *string Zend_Http_Response::responseCodeAsText($code = null, $http11 = true)*: レスポンスコード $code
     に対応する、標準的な *HTTP* レスポンスメッセージを取得します。 たとえば $code
     が 500 の場合は "Internal Server Error" を返します。 $http11 が ``TRUE`` の場合
     (デフォルト) は *HTTP*/1.1 のメッセージを、 そうでない場合は *HTTP*/1.0
     のメッセージを返します。 $code
     を省略した場合は、このメソッドは、すべての既知の *HTTP*
     レスポンスコードを連想配列 (code => message) で返します。



パーサメソッド以外にも、このクラスには 一般的な *HTTP*
レスポンスエンコーディングに対応したデコーダが含まれています。

   - *string Zend_Http_Response::decodeChunkedBody($body)*: "Content-Transfer-Encoding: Chunked"
     の本文をデコードします。

   - *string Zend_Http_Response::decodeGzip($body)*: "Content-Encoding: gzip" の本文をデコードします。

   - *string Zend_Http_Response::decodeDeflate($body)*: "Content-Encoding: deflate"
     の本文をデコードします。




