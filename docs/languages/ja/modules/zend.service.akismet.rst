.. _zend.service.akismet:

Zend_Service_Akismet
====================

.. _zend.service.akismet.introduction:

導入
--

``Zend_Service_Akismet`` は、 `Akismet API`_ のクライアント機能を提供します。Akismet
サービスは、 入力データがスパムかどうかを判定するために用いられます。
また、あるデータを「スパムである」とか「無実である (ハム)」
などと登録するためのメソッドも公開しています。 もともとは Wordpress
向けのスパムを識別するために作られたものですが、
あらゆる型のデータに対して使用できます。

Akismet を使用するには API キーが必要です。 キーを取得するには `WordPress.com`_
でアカウントを作成します。blog を作成する必要はありません。
単にアカウントを作成するだけで API キーが使用できます。

さらに、Akismet を使用する場合は、 フィルタリングしたいデータを指す URL
を指定してリクエストする必要があります。 Akismet は WordPress
向けに作られたものであることから、 これは blog url と呼ばれます。
これは、コンストラクタの二番目の引数として渡さなければなりません。
ただ、いつでも ``setBlogUrl()`` で変更することができますし、
その他のメソッドコールの際に 'blog' キーを指定して上書きすることもできます。

.. _zend.service.akismet.verifykey:

API キーの検証
---------

``Zend_Service_Akismet::verifyKey($key)`` を使用して、Akismet API
キーが有効かどうかを検証します。
たいていの場合は特に検証する必要もないでしょうが、
改ざんされていないかどうか調べたり、
新しく取得したキーが実際に使用可能かどうかを調べたり
といった場合にこのメソッドを使用します。

.. code-block:: php
   :linenos:

   // API キー、そしてアプリケーションやリソースへの URL
   // を指定してインスタンスを作成します
   $akismet = new Zend_Service_Akismet($apiKey,
                                       'http://framework.zend.com/wiki/');
   if ($akismet->verifyKey($apiKey) {
       echo "このキーは有効です。\n";
   } else {
       echo "このキーは無効です。\n";
   }

引数を指定せずにコールすると、 ``verifyKey()`` はコンストラクタで指定した API
キーを使用します。

``verifyKey()`` は、Akismet の *verify-key* REST メソッドを実装したものです。

.. _zend.service.akismet.isspam:

スパムのチェック
--------

``Zend_Service_Akismet::isSpam($data)`` を使用して、Akismet
がそのデータをスパムとみなすかどうかを調べます。
引数はひとつで、ここに連想配列を指定することができます。
この配列には、次のキーを設定しなければなりません。

- *user_ip* は、データを送信したユーザの IP アドレスです (あなたの IP
  アドレスではなく、 あなたのサイトを使用しているユーザの IP アドレスです)。

- *user_agent* は、データを送信したユーザの UserAgent 文字列
  (ブラウザおよびバージョン) です。

以下のキーも、API 側で認識されます。

- *blog* は、リソースやアプリケーションを指す 完全な URL
  です。指定しなかった場合は、 コンストラクタに渡した URL を使用します。

- *referrer* は、送信時の HTTP_REFERER ヘッダの内容です
  (スペルに注意しましょう。ヘッダの名前とは異なります)。

- *permalink* は、送信するデータの永続的な場所 (もしあれば) です。

- *comment_type* は、データの形式です。 ここで指定する値は API で定義されており、
  'comment'、'trackback'、'pingback' および 空の文字列 ('') などがあります。しかし、
  任意の値を指定することができます。

- *comment_author* は、データの送信者の名前です。

- *comment_author_email* は、 データの送信者のメールアドレスです。

- *comment_author_url* は、 データの送信者の URL あるいはホームページです。

- *comment_content* は、 実際に送信されたデータの内容です。

その他の環境変数の内容を送信し、
そのデータがスパムであるかどうかの判断材料とさせることもできます。 Akismet
は、$_SERVER 配列の中身をすべて送信することを推奨しています。

``isSpam()`` メソッドは true あるいは false を返します。 API
キーが無効な場合は例外をスローします。

.. _zend.service.akismet.isspam.example-1:

.. rubric:: isSpam() の使用法

.. code-block:: php
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 ' . (Windows; U; Windows NT ' .
                                 '5.2; en-GB; rv:1.8.1) Gecko/20061010 ' .
                                 'Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => '誰かさん',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "スパマーじゃないもん。信じて!"
   );
   if ($akismet->isSpam($data)) {
       echo "悪いけど、たぶんあなたはスパマーでしょう。";
   } else {
       echo "私たちのサイトへようこそ!";
   }

``isSpam()`` は、Akismet API のメソッド *comment-check* を実装したものです。

.. _zend.service.akismet.submitspam:

既知のスパムの送信
---------

時には、スパムがフィルタを通過してしまうこともあります。
フィルタを通過したデータの中に、もし「これはスパムだろう」
というものが見つかったら、それを Akismet
に送信しましょう。それにより、フィルタの性能が向上します。

``Zend_Service_Akismet::submitSpam()`` に指定する配列は、 ``isSpam()``
に渡すものと同じ形式です。 しかし、このメソッドは値を返しません。 API
キーが無効な場合は例外が発生します。

.. _zend.service.akismet.submitspam.example-1:

.. rubric:: submitSpam() の使用法

.. code-block:: php
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT 5.2;' .
                                 'en-GB; rv:1.8.1) Gecko/20061010 Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => '誰かさん',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "スパマーじゃないもん。信じて!"
   );
   $akismet->submitSpam($data));

``submitSpam()`` は、Akismet API のメソッド *submit-spam* を実装したものです。

.. _zend.service.akismet.submitham:

無実のデータ (ハム) の送信
---------------

時には、Akismet が間違ってスパムと判定してしまうこともあります。 そのため、Akismet
がスパムと判断したデータのログを定期的にチェックする必要があります。
このような現象を発見したら、そのデータを Akismet に「ハム」
あるいは無実のデータとして送信しましょう (ハムは善玉、スパムは悪玉です)。

``Zend_Service_Akismet::submitHam()`` に指定する配列は、 ``isSpam()`` や ``submitSpam()``
に渡すものと同じ形式です。また、 ``submitSpam()`` と同様、値を返しません。 API
キーが無効な場合は例外が発生します。

.. _zend.service.akismet.submitham.example-1:

.. rubric:: submitHam() の使用法

.. code-block:: php
   :linenos:

   $data = array(
       'user_ip'              => '111.222.111.222',
       'user_agent'           => 'Mozilla/5.0 (Windows; U; Windows NT 5.2;' .
                                 'en-GB; rv:1.8.1) Gecko/20061010 Firefox/2.0',
       'comment_type'         => 'contact',
       'comment_author'       => '誰かさん',
       'comment_author_email' => 'nospam@myhaus.net',
       'comment_content'      => "スパマーじゃないもん。信じて!"
   );
   $akismet->submitHam($data));

``submitHam()`` は、Akismet API のメソッド *submit-ham* を実装したものです。

.. _zend.service.akismet.accessors:

Zend 固有のアクセス用メソッド
-----------------

Akismet API では四つのメソッドしか定義されていませんが、 ``Zend_Service_Akismet`` では
それ以外のアクセス用メソッドも用意しています。
これらを使用して、内部のプロパティを変更します。

- ``getBlogUrl()`` および ``setBlogUrl()`` は、リクエストで使用する blog URL
  を取得したり変更したりします。

- ``getApiKey()`` および ``setApiKey()`` は、リクエストで使用する API
  キーを取得したり変更したりします。

- ``getCharset()`` および ``setCharset()``
  は、リクエストで使用する文字セットを取得したり変更したりします。

- ``getPort()`` および ``setPort()`` は、リクエストで使用する *TCP*
  ポートを取得したり変更したりします。

- ``getUserAgent()`` および ``setUserAgent()`` は、リクエストで使用する HTTP
  ユーザエージェントを 取得したり変更したりします。 注意:
  これは、サービスに送信するデータの user_agent
  ではありません。サービスへのリクエストを作成する際に HTTP User-Agent
  ヘッダで指定する内容となります。

  ユーザエージェントに設定する値は *some user agent/version | Akismet/version*
  形式でなければなりません。デフォルトは *Zend Framework/ZF-VERSION | Akismet/1.11* です。
  *ZF-VERSION* の部分には現在の Zend Framework のバージョン、つまり定数
  ``Zend_Framework::VERSION`` の値があてはまります。



.. _`Akismet API`: http://akismet.com/development/api/
.. _`WordPress.com`: http://wordpress.com/
