.. EN-Revision: none
.. _zend.session.global_session_management:

グローバルセッションの管理
=============

セッションのデフォルトの挙動を変更するには、 ``Zend_Session``
の静的メソッドを使用します。グローバルセッションの管理や操作には、すべて
``Zend_Session`` を使用します。たとえば `ext/session のオプション`_ を設定するには、
``Zend_Session::setOptions()`` を使用します。 また、安全な *save_path* を使わなかったり
ext/session で一意なクッキー名を使用しなかったりすると、 ``Zend_Session::setOptions()``
はセキュリティの問題を引き起こします。

.. _zend.session.global_session_management.configuration_options:

設定オプション
-------

セッション名前空間が要求されると、事前に :ref:`Zend_Session::start()
<zend.session.advanced_usage.starting_a_session>` で開始されていない場合には ``Zend_Session``
が自動的にセッションを開始します。 もととなる PHP セッションの設定は
``Zend_Session`` のデフォルトを使用します。これを変更するには、事前に
``Zend_Session::setOptions()`` を使用して設定しておきます。

オプションを指定するには、そのベース名 ("*session.*" の後に続く部分) を
``Zend_Session::setOptions()`` に渡す配列のキーとします。
配列の値が、そのセッションオプションの値として用いられます。
何もオプションを設定しなければ、 ``Zend_Session``
はまずデフォルトオプションを使用し、 それがなければ php.ini の設定を使用します。
これらのオプションの扱いについてのよい案があれば、ぜひ `fw-auth@lists.zend.com`_
で教えてください。

.. _zend.session.global_session_management.setoptions.example:

.. rubric:: Zend_Config による Zend_Session の設定

このコンポーネントを :ref:`Zend_Config_Ini <zend.config.adapters.ini>`
で設定するには、まず設定オプションを *INI* ファイルに追加します。

.. code-block:: ini
   :linenos:

   ; 本番サーバのデフォルト設定
   [production]
   ; bug_compat_42
   ; bug_compat_warn
   ; cache_expire
   ; cache_limiter
   ; cookie_domain
   ; cookie_lifetime
   ; cookie_path
   ; cookie_secure
   ; entropy_file
   ; entropy_length
   ; gc_divisor
   ; gc_maxlifetime
   ; gc_probability
   ; hash_bits_per_character
   ; hash_function
   ; name は、同じドメインを共有する PHP アプリケーション間で一意でなければなりません
   name = UNIQUE_NAME
   ; referer_check
   ; save_handler
   ; save_path
   ; serialize_handler
   ; use_cookies
   ; use_only_cookies
   ; use_trans_sid

   ; remember_me_seconds = <整数の秒数>
   ; strict = on|off

   ; テスト環境の設定は本番サーバとほぼ同じです。設定が異なる部分だけを
   ; 以下で上書きします
   [development : production]
   ; このディレクトリを事前に作成し、PHP スクリプトから rwx (読み書き可能)
   ; にしておくことを忘れないようにしましょう
   save_path = /home/myaccount/zend_sessions/myapp
   use_only_cookies = on
   ; セッション ID クッキーを持続させる場合は、その有効期限を 10 日にします
   remember_me_seconds = 864000

次に、この設定ファイルを読み込んで、その内容を配列として ``Zend_Session::setOptions()``
に渡します。

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Ini('myapp.ini', 'development');

   Zend_Session::setOptions($config->toArray());

上の例であげたほとんどのオプションについては、 PHP
のドキュメントで説明されているので、ここでの説明は不要でしょう。
しかし、いくつか重要なものについては説明しておきます。

   - boolean *strict*-*new Zend_Session_Namespace()* を使用する際に、 ``Zend_Session``
     が自動的に開始しないようにします。

   - integer *remember_me_seconds*- ユーザエージェントが終了した
     (たとえば、ブラウザが終了した) あと、どれだけの期間セッション ID
     クッキーを持続させるか。

   - string *save_path*- 正確な値はシステムに依存し、開発者がそのディレクトリまでの
     **絶対パス** を指定する必要があります。 このディレクトリは、PHP
     のプロセスから読み書き可能でなければなりません。
     書き込み可能なパスを指定しなかった場合は、 ``Zend_Session`` の開始時 (``start()``
     がコールされた場合) に例外をスローします。

     .. note::

        **セキュリティリスク**

        そのパスが他のアプリケーションから読み取り可能になっていると、
        セッションハイジャックの可能性が生じます。また、
        他のアプリケーションから書き込み可能になっていると、
        `セッションポイズニング`_ の可能性が生じます。このパスを他のユーザや他の
        PHP
        アプリケーションと共有すると、さまざまなセキュリティ問題が発生します。
        たとえばセッションの内容を盗まれたり、セッションをのっとられたり、
        ガベージコレクションが衝突したり (たとえば、
        別のユーザのアプリケーションによって、PHP
        があなたのアプリケーションのセッションファイルを削除してしまう)
        などの可能性があります。

        たとえば、まず攻撃者が犠牲者のウェブサイトを訪問し、
        セッションクッキーを取得します。そしてそのクッキーのパスを、
        同一サーバにある彼のドメインに変更します。
        それから彼自身のウェブサイトにいって ``var_dump($_SESSION)`` を実行します。
        犠牲者がセッションでどのようなデータを使用しているのかを知ったら、
        次はセッションの状態を書き換え (セッションポイズニング)、
        そのセッションを使用して改めて犠牲者のウェブサイトにリクエストを送ります。
        それぞれのアプリケーションが、もう一方のアプリケーションの *save_path*
        に対する読み書き権限を持っていなかったとしても、 もし *save_path*
        が推測可能な場所でかつ攻撃者が両方のアプリケーションを制御できるのなら、
        攻撃者はその *save_path* を変更して自分のほうの *save_path*
        を使うようにできます。
        そしてこのようなセッションポイズニングは、一般的な設定の PHP
        で実行可能なことがあります。 そのため、 *save_path*
        の値は、ありがちな場所を避けるようにしなければなりません。
        また、各アプリケーションで別々にし、安全を確保するようにしましょう。

   - string *name*- 正しい値はシステムに依存します。 アプリケーション間で **一意**
     な値を開発者側で指定する必要があります。

     .. note::

        **セキュリティリスク**

        *php.ini* での *session.name* の設定が同じ (たとえばデフォルトの "PHPSESSID")
        で、同一ドメインに複数の PHP アプリケーションが存在する場合は、
        両方のウェブサイトで同じセッションデータを共有することになってしまいます。
        さらにその結果として、お互いのセッションデータが破壊されてしまう可能性があります。

   - boolean *use_only_cookies*- 以下で説明するセキュリティリスクを回避するため、
     このオプションはデフォルトのままにしておいてください。

        .. note::

           **セキュリティリスク**

           もしこの設定を無効にすると、攻撃者は簡単に犠牲者のセッション ID
           を盗めるようになります。攻撃者のウェブサイトへから、たとえば
           *http://www.example.com/index.php?PHPSESSID=fixed_session_id*
           のようなリンクを張るわけです。犠牲者がまだ example.com のセッション ID
           クッキーを持っていない場合に、セッション固定化攻撃が成功します。
           犠牲者がこの既知のセッション ID を使用するようになれば、
           攻撃者はこのセッションを使用して犠牲者になりすまし、
           犠牲者を装ってユーザエージェントを操作します。





.. _zend.session.global_session_management.headers_sent:

Error: Headers Already Sent
---------------------------

"Cannot modify header information - headers already sent" や "You must call .. before any output has been sent to
the browser; output started in ..."
のようなエラーが出た場合は、そのメッセージの直接の原因となった部分
(関数あるいはメソッド) がどこなのかをきちんと調べましょう。 HTTP
ヘッダを送信するアクション、たとえばブラウザのクッキーの変更などは、
通常の出力 (バッファリングされていない出力) の前に行う必要があります。ただし
PHP の出力バッファリングを使用している場合は例外です。

- 常に `出力バッファリング`_
  を使用するようにすると、この問題を避けられます。またパフォーマンスも向上するでしょう。
  たとえば *php.ini* で "*output_buffering = 65535*" とすると、64K
  のバッファで出力バッファリングを行います。
  出力バッファリングでパフォーマンスの向上を狙うことは
  本番サーバでも有効な手法ですが、バッファリングだけでは "headers already sent"
  問題を解消するには不十分です。
  アプリケーションで送信する内容がこのバッファサイズをこえないよう注意しましょう。
  さもないと、(HTTP ヘッダの前に送信する出力が)
  バッファサイズをこえた時点で断続的に問題が発生することでしょう。

- もし ``Zend_Session`` のメソッドでエラーが発生しているのなら、
  そのメソッドをよく見直してください。そのメソッドは、
  必要な処理を本当に行っていますか? たとえば、 ``destroy()``
  をデフォルトで使用すると、 HTTP
  ヘッダを送信してクライアント側のセッションクッキーを期限切れにします。
  これが不要な場合は ``destroy(false)`` としてください。 HTTP
  においては、クッキーを書き換える (期限切れにするなど) 処理は HTTP
  ヘッダで行われます。

- 別の方法としては、アプリケーションのロジックを見直して
  ヘッダを操作するアクションを
  あらゆる出力の前に済ませてしまうことがあります。

- PHP のソースファイルの最後でこのエラーが発生するのなら、 終了タグ "*?>*"
  を削除しましょう。
  これは不要です。また、終了タグの後に改行などの目に見えない文字があった場合、
  それが出力としてクライアントに送信されてしまいます。

.. _zend.session.global_session_management.session_identifiers:

セッション識別子
--------

導入: Zend Framework でセッションを用いる際の最も推奨される方法は、
ブラウザのクッキー (ブラウザに保存される、通常のクッキー)
を使用することです。個々のユーザを追跡するために、一意な識別子を URL
に埋め込むことは、お勧めしません。 デフォルトでは、このコンポーネントは、
クッキーのみを使用してセッション識別子を管理しています。
クッキーの値が、ブラウザのセッションの一意な識別子となります。 PHP の ext/session
は、この識別子を使用して ウェブサイトの訪問者との一対一の対応を保持し、
それぞれの訪問者ごとのセッションデータを持続して保持します。 Zend_Session*
は、この保存の仕組み (*$_SESSION*)
をオブジェクト指向のインターフェイスでラップしたものです。
残念ながら、もし攻撃者にクッキーの値 (セッション ID) がもれてしまうと、
攻撃者はそのセッションをのっとることができるようになってしまいます。
この問題は、PHP や Zend Framework に限ったものではありません。 ``regenerateId()``
メソッドを使用すると、 アプリケーション側でセッション ID
(訪問者のクッキーに保存される値)
を新しい値に変更できるようになります。この値は、 ランダムで予測不可能です。
注意: 厳密にいうと同じものではないのですが、この節では「ユーザエージェント」
と「ウェブブラウザ」を同じ意味で使用しています。
これは、読みやすさを考慮したためです。

なぜ?: 攻撃者にセッション識別子を知られてしまうと、 その攻撃者は別のユーザ
(犠牲者) になりすますことができるようになります。
そして、その犠牲者にしかアクセスできない情報を取得したり、
犠牲者のデータを操作したりといったことが
あなたのアプリケーションから行えるようになってしまうのです。 セッション ID
を変更することで、セッションハイジャックを防ぐことができます。 セッション ID
を変更した後は、変更後の値が攻撃者に知られない限り 攻撃者は新しいセッション ID
を使用できません。その結果、
訪問者のセッションをのっとることができなくなります。
仮に攻撃者が古いセッション ID を取得したとしても、 ``regenerateId()``
はセッションデータを古いセッション ID から新しいほうに移すので、古いセッション
ID からはどのデータにもアクセスできなくなります。

いつ regenerateId() を使うのか?: ``Zend_Session::regenerateId()`` を Zend Framework
の起動ファイルに追加するのが、もっとも安全かつ確実に
ユーザエージェントのクッキーにあるセッション ID を再生成する方法です。
セッション ID をいつ再生成するのかについての条件判断がない場合は、
ここに追加しておくとよいでしょう。
リクエストのたびに再生成するようにしておくと攻撃パターンのいくつかを防げますが、
中にはそれによるパフォーマンスの劣化やネットワーク帯域への負荷がきになる人もいるでしょう。
そこで、アプリケーション内でリスクの大きそうなところがどこかを判断し、
その場面でだけセッション ID を再生成するということも一般に行われています。
ウェブサイト訪問者のセッションの権限が「格上げされる」 (自分の "プロフィール"
を編集する前に再度認証を行うなど)
際や、セキュリティ上「重要な」パラメータが変更される際などには、 常に
``regenerateId()`` で新しいセッション ID を作成するようにしましょう。 ``rememberMe()``
関数をコールする際には、内部で自動的に ``regenerateId()`` がコールされます。
ユーザがウェブサイトへのログインに成功したら、 ``regenerateId()`` の代わりに
``rememberMe()`` を使うようにしましょう。

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation:

セッションハイジャックおよびセッション固定化
^^^^^^^^^^^^^^^^^^^^^^

`クロスサイトスクリプト (XSS) 脆弱性`_
を避けることは、セッションハイジャックを防ぐ助けになります。 `Secunia の統計`_
によると、XSS 問題は頻繁に発生します。これは、
ウェブアプリケーションの開発言語が何であっても同じです。 XSS
問題が決して起こらないことを期待するよりも、
もしそれが発生した場合の被害を最小限に抑える方法を考えましょう。 XSS
があれば、攻撃者は犠牲者のネットワークトラフィックに
直接アクセスする必要がなくなります。
犠牲者がすでにセッションクッキーを取得している場合、 Javascript XSS
があると攻撃者がそのクッキーを読み取り、
セッションを盗むことができるようになります。
犠牲者がまだセッションクッキーを持っていない場合は、 攻撃者は XSS を使用して
Javascript を注入し、 犠牲者のブラウザに既知の値のセッション ID
クッキーを作成します。 そして同じクッキーを攻撃者のシステムに設定し、
犠牲者のセッションをのっとります。
犠牲者が攻撃者のウェブサイトを訪問すると、攻撃者は
犠牲者のユーザエージェントに関するその他の特性もエミュレートできるようになります。
あなたの作成するウェブサイトに XSS 脆弱性があると、 攻撃者はそこに AJAX Javascript
を仕込み、知らないうちに攻撃者のウェブサイトを
「訪問」させてしまうことが可能になります。
攻撃者はそれによって犠牲者のブラウザの特性を取得し、
改ざんされたセッションでウェブサイトにアクセスするようになります。
しかし、開発者が *save_path* オプションに正しい値を設定しておくと、 攻撃者は PHP
セッションのサーバ側の状態を任意に変更できることはなくなります。

それ単体では、セッションを最初に使用する際に ``Zend_Session::regenerateId()``
をコールしてもセッション固定化攻撃は防げません。そのセッションが、
攻撃者によって偽装されたものであるかどうかを判別できる必要があります。
先ほど説明したこととは矛盾しているように感じられるかもしれません。
しかしここで、攻撃者自身が
まず最初にあなたのウェブサイトのセッションを開始した場合のことを考えてみましょう。
セッションを "最初に使用" するのは攻撃者です。 すると彼は、(``regenerateId()``
による) 初期化の結果を知ることになります。 その後、攻撃者や新しいセッション ID
と XSS 脆弱性を組み合わせて使用するか、
あるいは自分のウェブサイトにそのセッション ID を使用したリンクを埋め込みます
(これは、 *use_only_cookies = off* の場合にのみ動作します)。

同じセッション ID を使用している場合に
攻撃者と犠牲者を区別することができれば、
セッションハイジャックを直接行うことはできなくなります。
しかし、そのような区別を行うと、ユーザビリティが犠牲になってしまうことがあります。
区別するための方法が明確ではないからです。
たとえば、最初にセッションが作成されたときとは別の国に属する IP
アドレスからリクエストを受け取った場合、
そのリクエストはおそらく攻撃者からのものだと考えられます。
しかし、次のような条件のもとでは、ウェブサイトへのアクセスが
犠牲者からのものなのか攻撃者からのものなのかを区別する方法はありません。

   - 攻撃者が、まずあなたのウェブサイトにアクセスし、 有効なセッション ID
     を取得する

   - あなたのウェブサイトの XSS 脆弱性を使用して、 取得したものと同じセッション
     ID のクッキーを犠牲者のブラウザに送信する (セッションの固定化)

   - 犠牲者と攻撃者が、同じプロキシ群からアクセスしている (両方ともが AOL
     のような大企業のファイアウォール内にいる場合など)

以下のサンプルコードのようにすると、 攻撃者が犠牲者の現在のセッション ID
を知ることがはるかに困難になります。
ただし、上で説明した最初のふたつのステップを実行していない場合に限ります。

.. _zend.session.global_session_management.session_identifiers.hijacking_and_fixation.example:

.. rubric:: セッション固定化

.. code-block:: php
   :linenos:

   $defaultNamespace = new Zend_Session_Namespace();

   if (!isset($defaultNamespace->initialized)) {
       Zend_Session::regenerateId();
       $defaultNamespace->initialized = true;
   }

.. _zend.session.global_session_management.rememberme:

rememberMe(integer $seconds)
----------------------------

通常は、セッションが終わるのはユーザエージェントが終了したとき、
つまりユーザがウェブブラウザと閉じたときです。
しかし、アプリケーション側で、ブラウザを閉じた後でもユーザセッションを有効にしておくこともできます。
この機能を実現するには、持続クッキーを使用します。 セッションの開始前に
``Zend_Session::rememberMe()``
を使用すると、セッションクッキーの有効期限を制御できます。
秒数を指定しなかった場合は、セッションクッキーの持続期間はデフォルトの
*remember_me_seconds* となります。このデフォルト値は ``Zend_Session::setOptions()``
で設定します。 セッションの固定化/のっとり を防ぐには、
ユーザがアプリケーションの認証を通過したとき (「ログイン」フォームなどから)
にこの関数を使用します。

.. _zend.session.global_session_management.forgetme:

forgetMe()
----------

この関数は ``rememberMe()`` を補完するものです。
セッションクッキーの有効期限を変更し、
ユーザエージェントのセッションが終了したときに有効期限が切れるようにしたものを書き込みます。

.. _zend.session.global_session_management.sessionexists:

sessionExists()
---------------

このメソッドを使用して、現在のユーザエージェント/リクエスト
に対応するセッションが既に存在するかどうかを調べます。
これはセッションを開始する前に使用します。その他の ``Zend_Session`` および
``Zend_Session_Namespace`` のメソッドとは独立しています。

.. _zend.session.global_session_management.destroy:

destroy(bool $remove_cookie = true, bool $readonly = true)
----------------------------------------------------------

``Zend_Session::destroy()`` は、
現在のセッションに関連付けられているすべての持続的データを破棄します。
しかし、PHP の変数の値は何の影響も受けません。
したがって、名前空間つきのセッション (``Zend_Session_Namespace`` のインスタンス)
は読み込み可能な状態のままです。
「ログアウト」を行うには、オプションのパラメータを ``TRUE`` (デフォルト)
に設定し、 ユーザエージェントのセッション ID クッキーを削除します。
オプションのパラメータ *$readonly* を使用すると、 ``Zend_Session_Namespace``
のインスタンスを作成したり ``Zend_Session``
のメソッドからセッションデータへ書き込んだりすることができなくなります。

"Cannot modify header information - headers already sent"
というエラーが出た場合は、最初の引数として ``TRUE`` (セッションクッキーを削除)
を使用しないようにするか、あるいは :ref:` <zend.session.global_session_management.headers_sent>`
を参照ください。 つまり、 ``Zend_Session::destroy(true)`` をコールするなら PHP が HTTP
ヘッダを送信する前にするか、
あるいは出力バッファリングを有効にしなければなりません。
また、出力データの大きさが、設定したバッファサイズをこえてはいけません。
これにより、 ``destroy()`` のコール前に出力が送信されてしまうことを防ぎます。

.. note::

   **例外/エラー**

   デフォルトでは *$readonly* が有効になっています。
   そのため、セッションデータへの書き込みを含む操作を行うと、
   例外をスローします。

.. _zend.session.global_session_management.stop:

stop()
------

このメソッドは、単に ``Zend_Session`` のフラグを切り替え、
セッションデータへの書き込みをできないようにするだけのものです。
その他どのような機能を実装するかについては、フィードバックを受付中です。
潜在的な使用法としては、一時的に ``Zend_Session_Namespace`` インスタンスや ``Zend_Session``
のメソッドから セッションデータに書き込めなくすることがあります。
この場合、実行はビュー関連のコードに移譲されます。
これらのインスタンスやメソッドからの書き込みを含むアクションは、
例外をスローします。

.. _zend.session.global_session_management.writeclose:

writeClose($readonly = true)
----------------------------

セッションを終了して内容を書き込んだ後に、 *$_SESSION*
をバックエンドから切り離します。
これにより、このリクエストにおける内部データの変換が終了します。
オプションのパラメータ *$readonly* を使用すると、書き込み権限をなくします
(``Zend_Session`` あるいは ``Zend_Session_Namespace``
のメソッドから書き込みを試みると、例外をスローします)。

.. note::

   **例外/エラー**

   デフォルトでは *$readonly* が有効になっています。
   そのため、セッションデータへの書き込みを含む操作を行うと、
   例外をスローします。 しかし、既存のアプリケーションの中には、
   ``session_write_close()`` でセッションを終了した後でも *$_SESSION*
   に書き込み可能であることを想定しているものもあるでしょう。
   これが「最適な方法」だとは思いませんが、そのような場合のために *$readonly*
   オプションを用意しておきます。

.. _zend.session.global_session_management.expiresessioncookie:

expireSessionCookie()
---------------------

このメソッドは、有効期限切れのセッション ID クッキーを送信し、
クライアント側でセッションクッキーを削除させます。
このテクニックを用いて、クライアント側でのログアウト機能を実現することもあります。

.. _zend.session.global_session_management.savehandler:

setSaveHandler(Zend_Session_SaveHandler_Interface $interface)
-------------------------------------------------------------

ほとんどの開発者にとっては、デフォルトの保存ハンドラで十分でしょう。
このメソッドは、 `session_set_save_handler()`_ `session_set_save_handler()`_
のオブジェクト指向ラッパーです。

.. _zend.session.global_session_management.namespaceisset:

namespaceIsset($namespace)
--------------------------

このメソッドを使用して、セッション名前空間が存在するかどうかを調べます。
あるいは、特定の名前空間に特定のインデックスが存在するかどうかを調べます。

.. note::

   **例外/エラー**

   ``Zend_Session`` が読み取り可能に設定されていない場合 (``Zend_Session``
   が開始される前など) に例外がスローされます。

.. _zend.session.global_session_management.namespaceunset:

namespaceUnset($namespace)
--------------------------

``Zend_Session::namespaceUnset($namespace)`` を使用すると、
名前空間全体およびその内容を効率的に削除できます。 PHP のすべての配列と同様、
配列を含む変数を初期化しても配列の中身のオブジェクトまでは初期化されません。
もしそのオブジェクトへの参照が別の配列/オブジェクトにも格納されていたとすると、
そちら経由でオブジェクトの内容にアクセスできてしまいます。 したがって、
``namespaceUnset()`` によって名前空間のエントリの内容が "深いレベルまで"
実際に削除されることはありません。 さらに詳細な情報は、PHP マニュアルでの
`参照に関する説明`_ を参照ください。

.. note::

   **例外/エラー**

   名前空間が読み取り可能に設定されていない場合 (``destroy()`` の後など)
   に例外がスローされます。

.. _zend.session.global_session_management.namespaceget:

namespaceGet($namespace)
------------------------

非推奨: ``Zend_Session_Namespace`` の ``getIterator()`` を使用しましょう。このメソッドは、
*$namespace* の内容を配列で返します。このメソッドを外部から使用し続けたいという
論理的な理由がある場合は、メーリングリスト `fw-auth@lists.zend.com`_
にフィードバックをお願いします。
……っていうか、どんなネタでもいいのでメーリングリストに参加してください (^o^)

.. note::

   **例外/エラー**

   ``Zend_Session`` が読み取り可能に設定されていない場合 (``Zend_Session``
   が開始される前など) に例外がスローされます。

.. _zend.session.global_session_management.getiterator:

getIterator()
-------------

``getIterator()`` を使用して、全名前空間の名前を含む配列を取得します。

.. note::

   **例外/エラー**

   ``Zend_Session`` が読み取り可能に設定されていない場合 (``Zend_Session``
   が開始される前など) に例外がスローされます。



.. _`ext/session のオプション`: http://www.php.net/session#session.configuration
.. _`fw-auth@lists.zend.com`: mailto:fw-auth@lists.zend.com
.. _`セッションポイズニング`: http://en.wikipedia.org/wiki/Session_poisoning
.. _`出力バッファリング`: http://php.net/outcontrol
.. _`クロスサイトスクリプト (XSS) 脆弱性`: http://en.wikipedia.org/wiki/Cross_site_scripting
.. _`Secunia の統計`: http://secunia.com/
.. _`session_set_save_handler()`: http://php.net/session_set_save_handler
.. _`参照に関する説明`: http://php.net/references
