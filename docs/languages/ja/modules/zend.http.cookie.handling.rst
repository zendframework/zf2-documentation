.. EN-Revision: none
.. _zend.http.cookies:

Zend_Http_Cookie および Zend_Http_CookieJar
========================================

.. _zend.http.cookies.introduction:

導入
--

``Zend_Http_Cookie`` は、お察しのとおり、 *HTTP* クッキーを表すクラスです。 *HTTP*
レスポンス文字列をパースしたりクッキーを収集したり、
そしてプロパティに簡単にアクセスしたりするためのメソッドがあります。
また、クッキーが所定の条件にマッチしているかどうかを調べることもできます。
たとえばリクエスト *URL*\ 、有効期限、セキュア接続か否かなどを調べます。

``Zend_Http_CookieJar`` は主に ``Zend_Http_Client`` で用いられ、ひとつあるいは複数の
``Zend_Http_Cookie`` オブジェクトを保持します。 ``Zend_Http_CookieJar`` オブジェクトを
``Zend_Http_Client`` オブジェクトにアタッチすると、 クライアントから *HTTP*
リクエストで送られるクッキーや クライアントが *HTTP*
レスポンスで受け取るクッキーがすべて CookieJar
オブジェクトに保存されます。そして、
クライアントが別のリクエストを送信する際には、まず CookieJar
オブジェクトを調べてリクエストにマッチするクッキーがあるかどうかを確認します。
あった場合は、それが自動的にリクエストヘッダに追加されます。 これは、連続した
*HTTP* リクエストでユーザのセッションを保持し続けたい場合に便利です。
セッション ID
が保存されたクッキーを、必要に応じて自動的に送信することができます。
さらに、必要に応じて ``Zend_Http_CookieJar`` オブジェクトをシリアライズし、 $_SESSION
に格納することもできます。

.. _zend.http.cookies.cookie.instantiating:

Zend_Http_Cookie のインスタンスの作成
---------------------------

クッキーオブジェクトのインスタンスを作成する方法は二通りあります。

   - コンストラクタで以下のような構文を使用します。 *new Zend_Http_Cookie(string $name,
     string $value, string $domain, [int $expires, [string $path, [boolean $secure]]]);*

     - *$name*: クッキーの名前 (例 'PHPSESSID') (必須)

     - *$value*: クッキーの値 (必須)

     - *$domain*: クッキーのドメイン (例 '.example.com') (必須)

     - *$expires*: クッキーの有効期限を表す UNIX タイムスタンプ
       (オプション。デフォルトは ``NULL``)。 設定しなかった場合は、有効期限なしの
       'セッションクッキー' として扱われます。

     - *$path*: クッキーのパス。たとえば '/foo/bar/' (オプション。デフォルトは '/')

     - *$secure*: クッキーの送信をセキュア接続 (*HTTPS*) 時に限るかどうか
       (オプション。デフォルトは ``FALSE``)

   - 静的メソッド fromString($cookieStr, [$refUri, [$encodeValue]]) をコールし、 *HTTP*
     レスポンスヘッダ 'Set-Cookie' あるいは *HTTP* リクエストヘッダ 'Cookie'
     に対応するクッキー文字列を指定します。
     この場合、クッキーの値は事前にエンコードしておく必要があります。
     クッキー文字列に 'domain' 部分が含まれない場合は、
     クッキーのドメインとパスを設定するための参照 *URI*
     を指定する必要があります。

     The *fromString* method accepts the following parameters:

     - ``$cookieStr``: a cookie string as represented in the 'Set-Cookie'*HTTP* response header or 'Cookie'*HTTP*
       request header (required)

     - ``$refUri``: a reference *URI* according to which the cookie's domain and path will be set. (optional,
       defaults to parsing the value from the $cookieStr)

     - ``$encodeValue``: If the value should be passed through urldecode. Also effects the cookie's behavior when
       being converted back to a cookie string. (optional, defaults to true)





      .. _zend.http.cookies.cookie.instantiating.example-1:

      .. rubric:: Zend_Http_Cookie のインスタンスの作成

      .. code-block:: php
         :linenos:

         // まずはコンストラクタを使用します。このクッキーの有効期限は二時間です。
         $cookie = new Zend_Http_Cookie('foo',
                                        'bar',
                                        '.example.com',
                                        time() + 7200,
                                        '/path');

         // HTTP レスポンスヘッダ Set-Cookie を設定して使用することもできます。
         // このクッキーは先ほどのものとほとんど同じですが、有効期限はありません。
         // また、セキュア接続時にのみ送信されます。
         $cookie = Zend_Http_Cookie::fromString('foo=bar; domain=.example.com; ' .
                                                'path=/path; secure');

         // クッキーのドメインが設定されていない場合は、手動で設定する必要があります。
         $cookie = Zend_Http_Cookie::fromString('foo=bar; secure;',
                                                'http://www.example.com/path');



   .. note::

      クッキーオブジェクトを作成するのに ``Zend_Http_Cookie``::fromString()
      メソッドを使用した場合は、クッキーの値は *URL*
      エンコードされていなければなりません。
      これはクッキー文字列と同様です。しかし、コンストラクタを使用する場合は、
      エンコードされたものではなく、デコードされた実際の値を使用します。



クッキーオブジェクトを文字列に変換するには、マジックメソッド \__toString()
を使用します。このメソッドは、 *HTTP* リクエストヘッダ "Cookie"
用の文字列を作成します。 クッキーの名前と値が表示され、最後はセミコロン (';')
となります。 この値は *URL* エンコードされ、そのまま Cookie
ヘッダとして使用できるようになります。



      .. _zend.http.cookies.cookie.instantiating.example-2:

      .. rubric:: Zend_Http_Cookie オブジェクトの文字列化

      .. code-block:: php
         :linenos:

         // 新しいクッキーを作成します。
         $cookie = new Zend_Http_Cookie('foo',
                                        'two words',
                                        '.example.com',
                                        time() + 7200,
                                        '/path');

         // これは 'foo=two+words;' を表示します。
         echo $cookie->__toString();

         // 上と同じことです。
         echo (string) $cookie;

         // PHP 5.2 以降では、これでもかまいません。
         echo $cookie;



.. _zend.http.cookies.cookie.accessors:

Zend_Http_Cookie のゲッターメソッド
--------------------------

``Zend_Http_Cookie`` のインスタンスを作成すると、 *HTTP*
クッキーのさまざまなプロパティを取得するためのメソッドが使用できるようになります。


   - *string getName()*: クッキーの名前を取得します。

   - *string getValue()*: デコードされたクッキーの値を取得します。

   - *string getDomain()*: クッキーのドメインを取得します。

   - *string getPath()*: クッキーのパスを取得します。デフォルトは '/' です。

   - *int getExpiryTime()*: クッキーの有効期限を UNIX タイムスタンプで取得します。
     設定されていない場合は ``NULL`` を返します。



さらに、チェック用のメソッドも提供されています。

   - *boolean isSecure()*:
     クッキーの送信がセキュア接続に限定されているかどうかを調べます。
     要するに、もし ``TRUE`` ならそのクッキーは *HTTPS*
     でしか送信されないということです。

   - *boolean isExpired(int $time = null)*:
     クッキーが有効期限切れになっているかどうかを調べます。
     有効期限が設定されていない場合は、常に ``TRUE`` を返します。$time
     を指定すると、 その時刻の時点で有効期限切れになるのかどうかを調べます。

   - *boolean isSessionCookie()*: クッキーが "セッションクッキー"、
     すなわち有効期限を持たないクッキー (セッション終了時に無効になるクッキー)
     であるかどうかを調べます。







      .. _zend.http.cookies.cookie.accessors.example-1:

      .. rubric:: Zend_Http_Cookie のゲッターメソッドの使用法

      .. code-block:: php
         :linenos:

         // まずクッキーを作成します
         $cookie =
             Zend_Http_Cookie::fromString('foo=two+words; ' +
                                          'domain=.example.com; ' +
                                          'path=/somedir; ' +
                                          'secure; ' +
                                          'expires=Wednesday, 28-Feb-05 20:41:22 UTC');

         echo $cookie->getName();   // これは 'foo' を表示します
         echo $cookie->getValue();  // これは 'two words' を表示します
         echo $cookie->getDomain(); // これは '.example.com' を表示します
         echo $cookie->getPath();   // これは '/' を表示します

         echo date('Y-m-d', $cookie->getExpiryTime());
         // これは '2005-02-28' を表示します

         echo ($cookie->isExpired() ? 'Yes' : 'No');
         // これは 'Yes' を表示します

         echo ($cookie->isExpired(strtotime('2005-01-01') ? 'Yes' : 'No');
         // これは 'No' を表示します

         echo ($cookie->isSessionCookie() ? 'Yes' : 'No');
         // これは 'No' を表示します



.. _zend.http.cookies.cookie.matching:

Zend_Http_Cookie が条件に一致するものかどうかを調べる
-----------------------------------

調べるために ``Zend_Http_Cookie`` に含まれているのは match() メソッドだけです。
このメソッドを使用して、送ろうとしている *HTTP*
リクエストに当てはまるクッキーであるかどうかを調べます。
その結果によって、クッキーをこのリクエストで送信するかどうかが決まります。
メソッドの構文やパラメータの内容は以下のとおりです。 *boolean
Zend_Http_Cookie->match(mixed $uri, [boolean $matchSessionCookies, [int $now]]);*

   - *mixed $uri*: ``Zend_Uri_Http`` オブジェクトで、
     ドメインやパスのチェックに使用します。オプションとして、 正しい形式の *URL*
     を文字列で渡すこともできます。 指定した *URL* のスキーム (*HTTP* あるいは
     *HTTPS*)、
     ドメインおよびパスがすべて一致した場合にのみ、クッキーがマッチします。

   - *boolean $matchSessionCookies*: セッションクッキーをマッチの対象にするかどうか。
     デフォルトは ``TRUE`` です。 ``FALSE`` に設定すると、
     有効期限の設定されていないクッキーはマッチしません。

   - *int $now*: クッキーの有効期限をチェックする基準となる時刻 (UNIX
     タイムスタンプ形式)。指定しない場合のデフォルトは、現在時刻です。





      .. _zend.http.cookies.cookie.matching.example-1:

      .. rubric:: クッキーがマッチするかどうかの確認

      .. code-block:: php
         :linenos:

         // まずクッキーオブジェクトを作成します。これはセキュアなセッションクッキーです。
         $cookie = Zend_Http_Cookie::fromString('foo=two+words; ' +
                                                'domain=.example.com; ' +
                                                'path=/somedir; ' +
                                                'secure;');

         $cookie->match('https://www.example.com/somedir/foo.php');
         // これは true を返します。

         $cookie->match('http://www.example.com/somedir/foo.php');
         // これは false を返します。接続がセキュアでないからです。

         $cookie->match('https://otherexample.com/somedir/foo.php');
         // これは false を返します。ドメインが違っているからです。

         $cookie->match('https://example.com/foo.php');
         // これは false を返します。パスが違っているからです。

         $cookie->match('https://www.example.com/somedir/foo.php', false);
         // これは false を返します。セッションクッキーはマッチさせないようにしているからです。

         $cookie->match('https://sub.domain.example.com/somedir/otherdir/foo.php');
         // これは true を返します。

         // 別のクッキーオブジェクトを作成します。今度はセキュアではなく、
         // 二時間で有効期限切れとなります。
         $cookie = Zend_Http_Cookie::fromString('foo=two+words; ' +
                                                'domain=www.example.com; ' +
                                                'expires='
                                                . date(DATE_COOKIE, time() + 7200));

         $cookie->match('http://www.example.com/');
         // これは true を返します。

         $cookie->match('https://www.example.com/');
         // これは true を返します。セキュアでないクッキーは、
         // セキュアな通信でも送信されます!

         $cookie->match('http://subdomain.example.com/');
         // これは false を返します。ドメインが違っているからです。

         $cookie->match('http://www.example.com/', true, time() + (3 * 3600));
         // これは false を返します。今から三時間後の時刻を指定したからです。



.. _zend.http.cookies.cookiejar:

Zend_Http_CookieJar のインスタンスの作成
------------------------------

``Zend_Http_CookieJar`` のインスタンスを直接作成する必要は、まずありません。
新しいクッキージャーを ``Zend_Http_Client`` オブジェクトにアタッチするには、単に
Zend_Http_Client->setCookieJar() メソッドをコールすればいいのです。これで、
新しい空のクッキージャーがクライアントに追加されます。このクッキージャーを取得するには
Zend_Http_Client->getCookieJar() を使用します。

それでもやっぱり自分で CookieJar のインスタンスを作成したいというのなら、 "new
Zend_Http_CookieJar()" と直接コールしてください。
コンストラクタには引数を何も指定しません。インスタンスを作成するもうひとつの方法としては、
静的メソッド Zend_Http_CookieJar::fromResponse() を使用するものがあります。
このメソッドは二つのパラメータを受け取ります。まず最初が ``Zend_Http_Response``
オブジェクト、そして二つ目は参照先 *URI* で、これは文字列あるいは ``Zend_Uri_Http``
オブジェクトのいずれかです。 このメソッドは新しい ``Zend_Http_CookieJar``
オブジェクトを返します。 このオブジェクトには、指定した *HTTP*
レスポンスによって設定されたクッキーが既に含まれています。
クッキーのドメインとパスが Set-Cookie ヘッダで指定されていない場合は、 参照先 *URI*
を使用して設定します。

.. _zend.http.cookies.cookiejar.adding_cookies:

Zend_Http_CookieJar オブジェクトへのクッキーの追加
-----------------------------------

通常は、CookieJar オブジェクトを追加した ``Zend_Http_Client``
オブジェクトが自動的に処理を行い、 *HTTP*
レスポンスで設定されたクッキーをジャーに追加してくれます。
自分でクッキーをジャーに追加するには、二通りの方法があります。

   - ``Zend_Http_CookieJar->addCookie($cookie[, $ref_uri])``:
     単一のクッキーをジャーに追加します。$cookie には ``Zend_Http_Cookie``
     オブジェクトあるいは文字列を指定します。文字列は自動的に Cookie
     オブジェクトに変換されます。文字列を指定する場合は、同時に $ref_uri
     も指定しなければなりません。これは参照先 *URI* で、文字列あるいは
     ``Zend_Uri_Http`` オブジェクトを渡します。これをもとにして、
     クッキーのデフォルトのドメインとパスを決定します。

   - ``Zend_Http_CookieJar->addCookiesFromResponse($response, $ref_uri)``: *HTTP*
     レスポンス内のすべてのクッキーをジャーに追加します。 $response は Set-Cookie
     ヘッダつきの ``Zend_Http_Response`` オブジェクトです。 $ref_uri は参照先 *URI*
     で、文字列あるいは ``Zend_Uri_Http`` オブジェクトとなります。
     これをもとにして、クッキーのデフォルトのドメインとパスを決定します。



.. _zend.http.cookies.cookiejar.getting_cookies:

Zend_Http_CookieJar オブジェクトからのクッキーの取得
------------------------------------

クッキーを追加する場合と同様、クッキーをジャーから取得する作業についても
通常は手動で行う必要はありません。 ``Zend_Http_Client`` オブジェクトは、その *HTTP*
リクエストで必要なクッキーを自動的に取得します。
とは言え、ジャーから手動でクッキーを取得するための方法も提供されています。
``getCookie()``\ 、 ``getAllCookies()`` および ``getMatchingCookies()`` の三通りの方法です。
さらに、CookieJar を順次処理していくことで、そこからすべての ``Zend_Http_Cookie``
オブジェクトを取得することができます。

注意すべき点は、これらのメソッドが特別なパラメータを受け取るようになっているということです。
このパラメータで、メソッドの返り値の型を指定します。
指定できる値は次の三種類です。

   - ``Zend_Http_CookieJar::COOKIE_OBJECT``: ``Zend_Http_Cookie`` オブジェクトを返します。
     返されるクッキーが複数の場合は、オブジェクトの配列を返します。

   - ``Zend_Http_CookieJar::COOKIE_STRING_ARRAY``: "foo=bar" 形式の文字列を返します。これは、
     *HTTP* リクエストの "Cookie" ヘッダで使用できる形式です。
     返されるクッキーが複数の場合は、文字列の配列を返します。

   - ``Zend_Http_CookieJar::COOKIE_STRING_CONCAT``: COOKIE_STRING_ARRAY
     と似ていますが、返されるクッキーが複数の場合には
     それらをひとつの長い文字列に連結して返します。 区切り文字はセミコロン (;)
     となります。 これは、マッチするすべてのクッキーを単一の *HTTP*
     リクエストヘッダ "Cookie" で送信したい場合に非常に便利です。



クッキー取得のためのさまざまなメソッドのについて説明します。

   - ``Zend_Http_CookieJar->getCookie($uri, $cookie_name[, $ret_as])``: その *URI* (ドメインおよびパス)
     と名前にもとづいて、 ジャーから単一のクッキーを取得します。 $uri は文字列か
     ``Zend_Uri_Http`` オブジェクトで、 *URI* を表します。 $cookie_name
     はクッキー名を表す文字列です。 $ret_as
     は先ほど説明したように返り値の型を指定します。 $ret_type
     はオプションで、デフォルトは COOKIE_OBJECT です。

   - ``Zend_Http_CookieJar->getAllCookies($ret_as)``: ジャーからすべてのクッキーを取得します。
     $ret_as は先ほど説明したように返り値の型を指定します。 指定しなかった場合の
     $ret_type のデフォルトは、COOKIE_OBJECT となります。

   - ``Zend_Http_CookieJar->getMatchingCookies($uri[, $matchSessionCookies[, $ret_as[, $now]]])``:
     指定した条件を満たす全てのクッキーをジャーから取得します。
     条件として指定するのは、 *URI* および有効期限です。

        - *$uri* は ``Zend_Uri_Http`` オブジェクトあるいは文字列です。 接続形式
          (セキュアかそうでないか)、ドメインおよびパスの条件を指定します。

        - *$matchSessionCookies* は boolean 値で、
          セッションクッキーを含めるかどうかを指定します。
          セッションクッキーとは、有効期限が指定されていないクッキーのことです。
          デフォルトは ``TRUE`` です。

        - *$ret_as* は、先ほど説明したように返り値の型を指定します。
          指定しなかった場合のデフォルトは COOKIE_OBJECT です。

        - *$now* は整数値で表した UNIX タイムスタンプで、 これを "現在時刻"
          として扱います。
          有効期限がこの時刻より前に設定されているクッキーはマッチしません。
          指定しなかった場合のデフォルト値は、現在時刻です。

     クッキーのマッチ方法についての詳細は :ref:` <zend.http.cookies.cookie.matching>`
     を参照ください。




