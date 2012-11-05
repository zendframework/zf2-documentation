.. EN-Revision: none
.. _zend.http.client.advanced:

Zend\Http\Client - 高度な使用法
=========================

.. _zend.http.client.redirections:

HTTP リダイレクト
-----------

デフォルトでは、 ``Zend\Http\Client`` は自動的に五段階までの *HTTP*
リダイレクトを処理します。これを変更するには、設定パラメータ 'maxredirects'
を変更します。

*HTTP*/1.1 の RFC によると、 *HTTP* 301 および 302
レスポンスを受け取ったクライアントは、
指定された場所に同じリクエストを再送する必要があります。
この際には同じリクエストメソッドを使用しなければなりません。
しかし、ほとんどのクライアントはこの機能を実装しておらず、
リダイレクトの際には常に GET メソッドを使用するようになっています。
デフォルトでは、Zend\Http\Client も同じように動作します。 つまり、301 や 302
によるリダイレクト指示を受けると、 GET パラメータや POST
パラメータをすべてリセットした上で新しい場所に GET
リクエストを送信します。この振る舞いを変更するには、設定パラメータ
'strictredirects' を ``TRUE`` に設定します。



      .. _zend.http.client.redirections.example-1:

      .. rubric:: 301 や 302 のレスポンスに対する RFC 2616 準拠のリダイレクト

      .. code-block:: php
         :linenos:

         // 厳格なリダイレクト
         $client->setConfig(array('strictredirects' => true));

         // 厳格でないリダイレクト
         $client->setConfig(array('strictredirects' => false));



リクエストを送信してからリダイレクトが行われた回数を取得するには
getRedirectionsCount() メソッドを使用します。

.. _zend.http.client.cookies:

クッキーの追加および持続的なクッキーの使用
---------------------

Zend\Http\Client を使用すると、リクエストに簡単にクッキーを追加できます。
ヘッダを変更したりする必要はありません。クッキーを追加するには setCookie()
メソッドを使用します。このメソッドにはいくつかの用法があります。



      .. _zend.http.client.cookies.example-1:

      .. rubric:: setCookie() によるクッキーの設定

      .. code-block:: php
         :linenos:

         // 簡単でシンプルな方法: クッキーの名前と値を指定します。
         $client->setCookie('flavor', 'chocolate chips');

         // クッキー文字列 (name=value) を直接指定します。
         // 値を URL エンコードしておく必要があることに注意しましょう。
         $client->setCookie('flavor=chocolate%20chips');

         // Zend\Http\Cookie オブジェクトを指定します。
         $cookie = Zend\Http\Cookie::fromString('flavor=chocolate%20chips');
         $client->setCookie($cookie);

Zend\Http\Cookie オブジェクトについての詳細は :ref:` <zend.http.cookies>` を参照ください。

Zend\Http\Client は、クッキーの持続性 (stickiness) も提供しています。
送受信したクッキーをクライアントの内部で保持し、
それ以降のリクエストで自動的に再送信します。
これは、たとえばリモートサイトにログインして 認証情報やセッション ID
のクッキーを取得してから次のリクエストに進む場合などに便利です。



      .. _zend.http.client.cookies.example-2:

      .. rubric:: クッキーの持続化

      .. code-block:: php
         :linenos:

         // クッキーの持続性を有効にし、ジャーに保存します
         $client->setCookieJar();

         // 最初のリクエスト: ログインし、セッションを開始します
         $client->setUri('http://example.com/login.php');
         $client->setParameterPost('user', 'h4x0r');
         $client->setParameterPost('password', '1337');
         $client->request('POST');

         // レスポンスに設定されたクッキー (たとえばセッション ID クッキーなど)
         // の内容は、自動的にジャーに保存されます。

         // 次のリクエストを送信します。この際に、
         // 先ほど保存されたクッキーが自動的に送信されます。
         $client->setUri('http://example.com/read_member_news.php');
         $client->request('GET');

Zend\Http\CookieJar クラスについての詳細は :ref:` <zend.http.cookies.cookiejar>`
を参照ください。

.. _zend.http.client.custom_headers:

独自のリクエストヘッダの設定
--------------

独自のヘッダを指定するには setHeaders() メソッドを使用します。
このメソッドには、さまざまな用法があります。それを以下の例で説明します。



      .. _zend.http.client.custom_headers.example-1:

      .. rubric:: 独自のリクエストヘッダの設定

      .. code-block:: php
         :linenos:

         // ひとつのヘッダを設定します。既存の値を上書きします。
         $client->setHeaders('Host', 'www.example.com');

         // 上とまったく同じことを別の方法で行います。
         $client->setHeaders('Host: www.example.com');

         // 同一のヘッダに対して複数の値を設定します
         // (Cookie ヘッダなどに有用です)。
         $client->setHeaders('Cookie', array(
             'PHPSESSID=1234567890abcdef1234567890abcdef',
             'language=he'
         ));



setHeader() は、複数のヘッダを一度に設定することも簡単にできます。
その場合は、ヘッダの配列をパラメータとして指定します。



      .. _zend.http.client.custom_headers.example-2:

      .. rubric:: 複数の独自リクエストヘッダの設定

      .. code-block:: php
         :linenos:

         // 複数のヘッダを設定します。既存の値を上書きします。
         $client->setHeaders(array(
             'Host' => 'www.example.com',
             'Accept-encoding' => 'gzip,deflate',
             'X-Powered-By' => 'Zend Framework'));

         // 配列には文字列を含めることができます。
         $client->setHeaders(array(
             'Host: www.example.com',
             'Accept-encoding: gzip,deflate',
             'X-Powered-By: Zend Framework'));



.. _zend.http.client.file_uploads:

ファイルのアップロード
-----------

ファイルを *HTTP* でアップロードするには setFileUpload メソッドを使用します。
このメソッドの最初の引数はファイル名、二番目の引数はフォーム名、
そしてオプションの三番目の引数がデータとなります。 三番目のパラメータが ``NULL``
の場合は、
最初のパラメータに指定したファイル名のファイルがあるものとみなされ、
Zend\Http\Client がそれを読み込んでアップロードしようとします。
三番目のパラメータが ``NULL`` 以外の場合は、
ファイル名は最初のパラメータを使用しますが実際の内容はディスク上に存在する必要がなくなります。
二番目のパラメータのフォーム名は常に必須です。HTML
フォームでアップロードする場合、これは >input< タグの "name"
属性と等しくなります。 四番目のオプションのパラメータは、ファイルの content-type
です。 指定しなかった場合、Zend\Http\Client は、
ディスクから読み込んだファイルに対して mime_content_type 関数を使用して content-type
を判定します。 いずれの場合でも、デフォルトの MIME 型は application/octet-stream
となります。



      .. _zend.http.client.file_uploads.example-1:

      .. rubric:: setFileUpload によるファイルのアップロード

      .. code-block:: php
         :linenos:

         // 任意のデータをファイルとしてアップロードします。
         $text = 'this is some plain text';
         $client->setFileUpload('some_text.txt', 'upload', $text, 'text/plain');

         // 既存のファイルをアップロードします。
         $client->setFileUpload('/tmp/Backup.tar.gz', 'bufile');

         // ファイルを送信します。
         $client->request('POST');

最初の例では、変数 $text の内容がアップロードされ、サーバ上で $_FILES['upload']
として使用できるようになります。二番目の例では、 既存のファイル /tmp/Backup.tar.gz
をサーバにアップロードし、サーバ上で $_FILES['bufile']
として使用できるようになります。 content-type
は自動的に推測されます。推測に失敗した場合は、 'application/octet-stream'
に設定されます。

.. note::

   **ファイルのアップロード**

   ファイルをアップロードする際には、 *HTTP* リクエストの content-type は自動的に
   multipart/form-data に設定されます。 ファイルをアップロードするには、POST あるいは
   PUT リクエストを使用しなければならないことに注意しましょう。
   大半のサーバでは、それ以外のリクエストメソッドが使用された場合にはその本文を無視します。

.. _zend.http.client.raw_post_data:

生の POST データの送信
--------------

Zend\Http\Client で生の POST データを送信するには setRawData()
メソッドを使用します。このメソッドはふたつのパラメータを受け取ります。
まず最初が、リクエスト本文で送信するデータです。
二番目のパラメータはオプションで、データの content-type を指定します。
このパラメータはオプションですが、リクエストを送信する前にはできるだけ設定しておくようにしましょう。
setRawData() 以外にも、別のメソッド setEncType() を使用することもできます。



      .. _zend.http.client.raw_post_data.example-1:

      .. rubric:: 生の POST データの送信

      .. code-block:: php
         :linenos:

         $xml = '<book>' .
                '  <title>海流の中の島々</title>' .
                '  <author>アーネスト・ヘミングウェイ</author>' .
                '  <year>1970</year>' .
                '</book>';

         $client->setRawData($xml, 'text/xml')->request('POST');

         // 同じことを、別の方法でもできます。
         $client->setRawData($xml)->setEncType('text/xml')->request('POST');

このデータをサーバ側で使用するには、 *PHP* の変数 $HTTP_RAW_POST_DATA あるいは php://input
ストリームを使用します。

.. note::

   **生の POST データの使用**

   リクエストに生の POST データを設定すると、その他の POST
   パラメータやアップロードするファイルの内容がすべて上書きされます。
   同一リクエストでこれらを共用しようとしないでください。 大半のサーバは、POST
   リクエスト以外ではリクエスト本文を無視することも覚えておきましょう。

.. _zend.http.client.http_authentication:

HTTP 認証
-------

現在 Zend\Http\Client がサポートしているのは、ベーシック *HTTP* 認証のみです。
この機能を利用するには ``setAuth()`` メソッドを使用するか、
あるいはユーザ名とパスワードを URI で指定します。 ``setAuth()``
メソッドが受け取るパラメータは三つで、
ユーザ名とパスワード、そしてオプションで認証タイプとなります。
先ほど説明したように、現在はベーシック認証しかサポートしていません
(将来的にはダイジェスト認証もサポートする予定です)。



      .. _zend.http.client.http_authentication.example-1:

      .. rubric:: HTTP 認証用のユーザとパスワードの設定

      .. code-block:: php
         :linenos:

         // ベーシック認証を使用します。
         $client->setAuth('shahar', 'myPassword!', Zend\Http\Client::AUTH_BASIC);

         // ベーシック認証はデフォルトなので、このように省略することもできます。
         $client->setAuth('shahar', 'myPassword!');

         // ユーザ名とパスワードを URI で指定することもできます
         $client->setUri('http://christer:secret@example.com');



.. _zend.http.client.multiple_requests:

同一クライアントでの複数リクエストの送信
--------------------

``Zend\Http\Client``
は、複数の連続したリクエストを同一オブジェクトで処理できるようになっています。
これは、スクリプト内で複数の場所からデータを取得する場合や、 特定の *HTTP*
リソースにアクセスする際にログインしてセッションクッキーを取得する必要がある場合などに便利です。

同一ホストからの複数のリクエストを行う際には、設定フラグ 'keepalive'
を有効にすることを強く推奨します。 こうすると、もしサーバが keep-alive
をサポートしている場合に、
すべてのリクエストが完了してクライアントオブジェクトが破棄されるまでは接続が保持されます。
これにより、サーバとの *TCP* 接続を何度もオープンしなおす手間が省けます。

同一クライアントから複数のリクエストを送信が、
各リクエストのパラメータは完全に区別したいといった場合は、 resetParameters()
メソッドを使用します。これにより、GET や POST
のパラメータ、リクエストの本文そしてリクエスト固有のヘッダがリセットされ、
次のリクエストには持ち越されなくなります。

.. note::

   **パラメータのリセット**

   リクエスト固有でないヘッダは、 ``resetParameters()``
   メソッドを使用した時、既定ではリセットされません。 'Content-length' と 'Content-type'
   ヘッダのみリセットされます。 これにより、たとえば 'Accept-language' や
   'Accept-encoding' のようなヘッダを付け忘れることを防ぎます。

   ヘッダの全てと、URIやメソッド以外のその他のデータを消去するには、
   ``resetParameters(true)`` を使用してください。

連続したリクエストのために作られているもうひとつの機能が、
クッキージャーオブジェクトです。クッキージャーを使用すると、
最初のリクエストの際にサーバから受け取ったクッキーを自動的に保存できます。
そしてそれ以降のリクエストの際には保存したクッキーを自動的に送信するのです。
これにより、たとえば実際のデータ取得リクエストの前に認証リクエストを行うことなどが可能となります。

アプリケーションがユーザ単位の認証を必要としており、
アプリケーション内の複数のスクリプトで連続したリクエストが発生する場合は、
クッキージャーオブジェクトをセッションに格納することをお勧めします。
こうすると、一度認証を受けるだけでそれをセッション全体で使いまわせるようになります。

.. _zend.http.client.multiple_requests.example-1:

.. rubric:: 単一のクライアントによる連続したリクエストの実行

.. code-block:: php
   :linenos:

   // まず、クライアントのインスタンスを作成します。
   $client = new Zend\Http\Client('http://www.example.com/fetchdata.php', array(
       'keepalive' => true
   ));

   // セッションにクッキーが保存されていますか?
   if (isset($_SESSION['cookiejar']) &&
       $_SESSION['cookiejar'] instanceof Zend\Http\CookieJar)) {

       $client->setCookieJar($_SESSION['cookiejar']);
   } else {
       // いなければ、認証を行ってクッキーを保存します。
       $client->setCookieJar();
       $client->setUri('http://www.example.com/login.php');
       $client->setParameterPost(array(
           'user' => 'shahar',
           'pass' => 'somesecret'
       ));
       $client->request(Zend\Http\Client::POST);

       // さあ、パラメータを消去して URI を元のものに戻しましょう
       // (サーバによって設定されたクッキーは、ジャーに保存されている
       //  ことに注意しましょう)
       $client->resetParameters();
       $client->setUri('http://www.example.com/fetchdata.php');
   }

   $response = $client->request(Zend\Http\Client::GET);

   // クッキーをセッションに保存し、次のページで使用します。
   $_SESSION['cookiejar'] = $client->getCookieJar();

.. _zend.http.client.streaming:

データ・ストリーミング
-----------

``Zend\Http\Client`` はデフォルトでデータを *PHP* 文字列として受け取り、
そして返します。しかしながら、巨大なファイルを送信または受信する多くのケースではこのような場合
メモリーは不必要に確保されたり、もしくはコストがかかります。
このようなケースのために、 ``Zend\Http\Client`` はファイル(一般的には *PHP*
ストリーム)からの読み込みと ファイル(ストリーム)への書き込みをサポートします。

ストリームを用いて ``Zend\Http\Client`` とデータの受け渡しを行うために、 ``setRawData()``
メソッドを ストリームリソースであるデータ引数とともに使用します。 (例、
``fopen()`` の戻り値).



      .. _zend.http.client.streaming.example-1:

      .. rubric:: ストリーミングでHTTP サーバにファイルを送信

      .. code-block:: php
         :linenos:

         $fp = fopen("mybigfile.zip", "r");
         $client->setRawData($fp, 'application/zip')->request('PUT');



PUT リクエストだけが現在 HTTP サーバーへのストリームの送信をサポートしています。

サーバーからストリームとしてデータを受信するために ``setStream()`` を使用します。
オプション引数にはデータがストアされるファイル名を指定します。
引数が(デフォルト値) ``TRUE``
だった場合、テンポラリファイルが使用されレスポンスオブジェクと破棄された場合に消去されます。
``FALSE`` を引数に設定するとストリーミング機能は無効になります。

ストリーミングを使用した際、 ``request()`` メソッドは ``Zend\Http\Client\Response\Stream``
クラスのオブジェクトを返却するでしょう。これは二つの便利なメソッドを持っています：
``getStreamName()`` はレスポンスがストアされたファイルの場所名を返却します。 また
``getStream()`` はレスポンスを読み込めるストリームを返却します。

あなたは事前に定義したファイルへレスポンスを書き込んだり、
ストアしたり送出したりするためにテンポラリファイルを使用したり、通常のストリーム機能で使用される別のファイルへ書きだせます。




      .. _zend.http.client.streaming.example-2:

      .. rubric:: ストリーミングでHTTP サーバからファイルを受信

      .. code-block:: php
         :linenos:

         $client->setStream(); // 一時ファイルを使用
         $response = $client->request('GET');
         // ファイルをコピー
         copy($response->getStreamName(), "my/downloads/file");
         // ストリームを使用
         $fp = fopen("my/downloads/file2", "w");
         stream_copy_to_stream($response->getStream(), $fp);
         // 既知のファイルに書き出すこともできます
         $client->setStream("my/downloads/myfile)->request('GET');




