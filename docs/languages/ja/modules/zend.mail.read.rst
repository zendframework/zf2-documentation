.. _zend.mail.read:

メールメッセージの読み込み
=============

``Zend_Mail`` を使用すると、
ローカルあるいはリモートに保存されたメールを読み込むことができます。
すべての保存形式に共通の基本 *API* では、メッセージ数を数えたり
メッセージを読み込んだりできます。また、
いくつかの保存形式では、特殊な追加機能も実装されています。
各保存形式で実装されている機能の概要については以下の表を参照ください。

.. _zend.mail.read.table-1:

.. table:: メール読み込み機能の概要

   +--------------+------+-------+------+------+
   |機能            |Mbox  |Maildir|Pop3  |IMAP  |
   +==============+======+=======+======+======+
   |保存形式          |ローカル  |ローカル   |リモート  |リモート  |
   +--------------+------+-------+------+------+
   |メッセージの取得      |Yes   |Yes    |Yes   |Yes   |
   +--------------+------+-------+------+------+
   |MIME パートの取得   |エミュレート|エミュレート |エミュレート|エミュレート|
   +--------------+------+-------+------+------+
   |フォルダ          |Yes   |Yes    |No    |Yes   |
   +--------------+------+-------+------+------+
   |メッセージ/フォルダ の作成|No    |対応予定   |No    |対応予定  |
   +--------------+------+-------+------+------+
   |フラグ           |No    |Yes    |No    |Yes   |
   +--------------+------+-------+------+------+
   |容量制限          |No    |Yes    |No    |No    |
   +--------------+------+-------+------+------+

.. _zend.mail.read-example:

Pop3 によるシンプルな読み込み例
------------------

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'localhost',
                                            'user'     => 'test',
                                            'password' => 'test'));

   echo $mail->countMessages() . " messages found\n";
   foreach ($mail as $message) {
       echo "Mail from '{$message->from}': {$message->subject}\n";
   }

.. _zend.mail.read-open-local:

ローカルに保存されたメールのオープン
------------------

ローカルのメール保存形式としては、Mbox および Maildir
をサポートしています。これらはともに、もっともシンプルな形式です。

Mbox ファイルからメールを読み込むには、そのファイル名を ``Zend_Mail_Storage_Mbox``
のコンストラクタに渡すだけです。

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Mbox(array('filename' =>
                                                '/home/test/mail/inbox'));

Maildir もほぼ同様ですが、こちらはディレクトリ名を指定します。

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Maildir(array('dirname' =>
                                                   '/home/test/mail/'));

どちらのコンストラクタも、もし読み込めなかった場合は ``Zend_Mail_Exception``
をスローします。

.. _zend.mail.read-open-remote:

リモートに保存されたメールのオープン
------------------

リモートの保存形式としては、もっとも有名なふたつである Pop3 と Imap
をサポートしています。それぞれ、
ホスト名とユーザ名を指定して接続、ログインします。
デフォルトのパスワードは空の文字列で、デフォルトのポート番号は
そのプロトコルの *RFC* で指定されているものです。

.. code-block:: php
   :linenos:

   // Pop3 での接続
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

   // Imap での接続
   $mail = new Zend_Mail_Storage_Imap(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

   // 非標準のポートの例
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com',
                                            'port'     => 1120
                                            'user'     => 'test',
                                            'password' => 'test'));

どちらの保存形式についても、 *SSL* や TLS をサポートしています。 *SSL*
を使用する場合、デフォルトのポートは *RFC* にあるとおりに変更されます。

.. code-block:: php
   :linenos:

   // Zend_Mail_Storage_Pop3 の例ですが、Zend_Mail_Storage_Imap でも同様です

   // SSL を使用する場合はポートが異なります (デフォルトは Pop3 なら 995、Imap なら 993)
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'SSL'));

   // TLS を使用します
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'TLS'));

どちらのコンストラクタも、エラーの形式によって ``Zend_Mail_Exception`` あるいは
``Zend_Mail_Protocol_Exception`` (``Zend_Mail_Exception`` を継承したもの) をスローします。

.. _zend.mail.read-fetching:

メッセージの取得およびシンプルなメソッド
--------------------

ストレージをオープンしたら、メッセージを取得できます。
メッセージを取得するには、メッセージ番号が必要です。
これは、最初のメッセージを 1 番とする連番となります。
メッセージを取得する際に使用するメソッドは ``getMessage()`` です。

.. code-block:: php
   :linenos:

   $message = $mail->getMessage($messageNum);

配列形式のアクセスもサポートしていますが、 ``getMessage()``
に追加のパラメータを渡すことはサポートしていません。
なにも気にせずデフォルトでいいなら、このように使用します。

.. code-block:: php
   :linenos:

   $message = $mail[$messageNum];

全メッセージについて順に処理するために、Iterator
インターフェイスも実装されています。

.. code-block:: php
   :linenos:

   foreach ($mail as $messageNum => $message) {
       // 何かの処理 ...
   }

保存されているメッセージ数を数えるには、 ``countMessages()``
メソッドあるいは配列形式のアクセスを使用します。

.. code-block:: php
   :linenos:

   // メソッド
   $maxMessage = $mail->countMessages();

   // 配列形式のアクセス
   $maxMessage = count($mail);

メールを削除するには、 ``removeMessage()``
メソッドあるいは配列形式のアクセスを使用します。

.. code-block:: php
   :linenos:

   // メソッド
   $mail->removeMessage($messageNum);

   // 配列形式のアクセス
   unset($mail[$messageNum]);

.. _zend.mail.read-message:

メッセージの操作
--------

``getMessage()`` でメッセージを取得したら、
次にしたくなることは、ヘッダの取得やマルチパートメッセージの各パートの取得などでしょう。
すべてのヘッダには、プロパティあるいはメソッド ``getHeader()``
(一般的でないヘッダの場合) でアクセスできます。
ヘッダ名は、内部では小文字で表されます。
したがって、メールメッセージ内のでのヘッダ名は関係ありません。
また、ヘッダ名にダッシュが入っている場合は、 camel-case
で保持されます。どちらの記法でもヘッダが見つからなかった場合は、例外がスローされます。
そんな場合は、 ``headerExists()`` メソッドを使用すれば
ヘッダが存在するかどうかを調べることができます。

.. code-block:: php
   :linenos:

   // メッセージオブジェクトを取得します
   $message = $mail->getMessage(1);

   // メッセージの件名を出力します
   echo $message->subject . "\n";

   // content-type ヘッダを取得します
   $type = $message->contentType;

   // CC が設定されているかどうかを調べます
   if( isset($message->cc) ) { // あるいは $message->headerExists('cc');
       $cc = $message->cc;
   }

同名のヘッダが複数ある場合 (たとえば Received ヘッダなど)、
それを文字列ではなく配列として扱うこともできます。これは ``getHeader()``
メソッドを使用して行います。

.. code-block:: php
   :linenos:

   // ヘッダをプロパティとして取得します - 結果は常に文字列で、
   // メッセージ内で複数あらわれる場合は改行文字で区切られます
   $received = $message->received;

   // getHeader() メソッドを使用しても同様です
   $received = $message->getHeader('received', 'string');

   // 配列形式の場合、複数あらわれるとそれぞれ別のエントリとなるので便利です
   $received = $message->getHeader('received', 'array');
   foreach ($received as $line) {
       // なにかをします
   }

   // 書式を指定しなかった場合は内部表現で取得します
   // (ひとつしかない場合は文字列、複数ある場合は配列となります)
   $received = $message->getHeader('received');
   if (is_string($received)) {
       // メッセージ内にそのヘッダはひとつしかありません
   }

``getHeaders()`` メソッドは、すべてのヘッダを配列で返します。
キーはヘッダ名を小文字にしたもので、値は文字列 (そのヘッダがひとつの場合)
あるいは文字列の配列 (そのヘッダが複数の場合) となります。

.. code-block:: php
   :linenos:

   // すべてのヘッダを出力します
   foreach ($message->getHeaders() as $name => $value) {
       if (is_string($value)) {
           echo "$name: $value\n";
           continue;
       }
       foreach ($value as $entry) {
           echo "$name: $entry\n";
       }
   }

マルチパートメッセージがないのなら、その内容は ``getContent()``
で簡単に取得できます。ヘッダの場合とは異なり、
内容は必要になった時点で初めて取得します (いわゆる遅延取得っていうやつです)。

.. code-block:: php
   :linenos:

   // メッセージの内容を HTML で出力します
   echo '<pre>';
   echo $message->getContent();
   echo '</pre>';

マルチパートメッセージであるかどうかを調べるには ``isMultipart()``
メソッドを使用します。マルチパートメッセージがある場合は、 ``getPart()``
メソッドで ``Zend_Mail_Part`` のインスタンスを取得します。 ``Zend_Mail_Part`` は
``Zend_Mail_Message`` の基底クラスなので、 ``getHeader()`` や ``getHeaders()``\ 、 ``getContent()``\
、 ``getPart()``\ 、 ``isMultipart`` といったメソッドを同様に使えます。
また、ヘッダもプロパティとして使用できます。

.. code-block:: php
   :linenos:

   // マルチパートの最初の部分を取得します
   $part = $message;
   while ($part->isMultipart()) {
       $part = $message->getPart(1);
   }
   echo 'Type of this part is ' . strtok($part->contentType, ';') . "\n";
   echo "Content:\n";
   echo $part->getContent();

``Zend_Mail_Part`` は *RecursiveIterator* も実装しています。
つまり、すべてのパートを順にスキャンすることも簡単にできます。また、
結果を簡単に出力できるよう、マジックメソッド ``__toString()``
を実装しています。このメソッドは、パートの中身を返します。

.. code-block:: php
   :linenos:

   // 最初の text/plain パートを出力します
   $foundPart = null;
   foreach (new RecursiveIteratorIterator($mail->getMessage(1)) as $part) {
       try {
           if (strtok($part->contentType, ';') == 'text/plain') {
               $foundPart = $part;
               break;
           }
       } catch (Zend_Mail_Exception $e) {
           // 無視します
       }
   }
   if (!$foundPart) {
       echo 'プレーンテキストのパートがありません';
   } else {
       echo "プレーンテキストパート: \n" . $foundPart;
   }

.. _zend.mail.read-flags:

フラグのチェック
--------

Maildir および IMAP はフラグの保存をサポートしています。 ``Zend_Mail_Storage``
クラスには、maildir や IMAP
で使用するすべてのフラグに対応する定数が定義されています。これは
``Zend_Mail_Storage::FLAG_<flagname>`` という名前です。 フラグをチェックするには、
``Zend_Mail_Message`` の ``hasFlag()`` メソッドを使用します。 ``getFlags()``
で、設定されているすべてのフラグを取得できます。

.. code-block:: php
   :linenos:

   // 未読メッセージを探します
   echo "未読メール\n";
   foreach ($mail as $message) {
       if ($message->hasFlag(Zend_Mail_Storage::FLAG_SEEN)) {
           continue;
       }
       // 新着メールのマークをつけます
       if ($message->hasFlag(Zend_Mail_Storage::FLAG_RECENT)) {
           echo '! ';
       } else {
           echo '  ';
       }
       echo $message->subject . "\n";
   }

   // フラグをチェックします
   $flags = $message->getFlags();
   echo "Message is flagged as: ";
   foreach ($flags as $flag) {
       switch ($flag) {
           case Zend_Mail_Storage::FLAG_ANSWERED:
               echo '返信済み ';
               break;
           case Zend_Mail_Storage::FLAG_FLAGGED:
               echo 'フラグ設定済み ';
               break;

           // ...
           // その他のフラグのチェック
           // ...

           default:
               echo $flag . '(未知のフラグ) ';
       }
   }

IMAP ではユーザやクライアントが独自にフラグを設定できます。 ``Zend_Mail_Storage``
で定数が定義されていない、
このようなフラグを取得することも可能です。これらは文字列として返され、
``hasFlag()`` で同じようにチェックできます。

.. code-block:: php
   :linenos:

   // クライアントで定義したフラグ $IsSpam, $SpamTested を調べます
   if (!$message->hasFlag('$SpamTested')) {
       echo 'まだスパムチェックがすんでいません';
   } else if ($message->hasFlag('$IsSpam')) {
       echo 'このメッセージはスパムです';
   } else {
       echo 'このメッセージはハムです (スパムではありません)';
   }

.. _zend.mail.read-folders:

フォルダの使用法
--------

Pop3 以外のすべての保存形式は、フォルダをサポートしています。
これはメールボックスとも言います。各保存形式で、
フォルダをサポートするために実装しているインターフェイスが
``Zend_Mail_Storage_Folder_Interface`` です。
これらすべてのクラスでは、コンストラクタで追加のオプションパラメータ *folder*
を指定できます。これは、ログイン後に使用するフォルダを指定するものです。

ローカルの保存形式では、 ``Zend_Mail_Storage_Folder_Mbox`` あるいは
``Zend_Mail_Storage_Folder_Maildir`` のいずれかのクラスを使用します。どちらもパラメータ
*dirname* が必須で、これは基底ディレクトリの名前となります。 maildir
のフォーマットは maildir++ で定義されているもの
(デフォルトの区切り文字はドットです)、一方 Mbox は Mbox
ファイルのディレクトリ階層を使用します。Mbox の基底ディレクトリに INBOX
という名前の Mbox ファイルがない場合は、
コンストラクタで別のフォルダを設定する必要があります。

``Zend_Mail_Storage_Imap`` は、デフォルトでフォルダをサポートしています。
これらの保存形式をオープンする例を以下に示します。

.. code-block:: php
   :linenos:

   // mbox でフォルダを使用します
   $mail = new Zend_Mail_Storage_Folder_Mbox(array('dirname' =>
                                                       '/home/test/mail/'));

   // mbox で INBOX 以外のデフォルトフォルダを使用します。
   // Zend_Mail_Storage_Folder_Maildir および Zend_Mail_Storage_Imap でも動作します
   $mail = new Zend_Mail_Storage_Folder_Mbox(array('dirname' =>
                                                       '/home/test/mail/',
                                                   'folder'  =>
                                                       'Archive'));

   // maildir でフォルダを使用します
   $mail = new Zend_Mail_Storage_Folder_Maildir(array('dirname' =>
                                                          '/home/test/mail/'));

   // maildir で区切り文字にコロンを使用します。Maildir++ の推奨する形式です
   $mail = new Zend_Mail_Storage_Folder_Maildir(array('dirname' =>
                                                          '/home/test/mail/',
                                                      'delim'   => ':'));

   // imap の場合は、フォルダを使用するしないにかかわらず同じ形式です
   $mail = new Zend_Mail_Storage_Imap(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

getFolders($root = null) メソッドを使用すると、
ルートフォルダあるいは指定したフォルダから始まるフォルダ階層を取得できます。
返り値は ``Zend_Mail_Storage_Folder`` のインスタンスとなります。これは *RecursiveIterator*
を実装しており、子要素もすべて ``Zend_Mail_Storage_Folder`` のインスタンスとなります。
これらの各インスタンスはローカル名およびグローバル名を持っており、 それぞれ
``getLocalName()`` メソッドおよび ``getGlobalName()`` メソッドで取得できます。
グローバル名とはルートフォルダからの絶対名称 (区切り文字を含む) で、
ローカル名とは親フォルダから見た名前のことです。

.. _zend.mail.read-folders.table-1:

.. table:: Mail フォルダの名前

   +---------------+-------+
   |グローバル名         |ローカル名  |
   +===============+=======+
   |/INBOX         |INBOX  |
   +---------------+-------+
   |/Archive/2005  |2005   |
   +---------------+-------+
   |List.ZF.General|General|
   +---------------+-------+

イテレータを使用する際は、要素のキーはローカル名となります。
グローバル名を取得するには、マジックメソッド ``__toString()`` を使用します。
フォルダによっては、選択できないものもあるかもしれません。
これは、そのフォルダにメッセージを保存できず、
メッセージを選ぼうとしてエラーになっていることを意味します。
これを確認するためのメソッドが ``isSelectable()`` です。
ツリー全体をビューに出力するのは、このように非常に簡単です。

.. code-block:: php
   :linenos:

   $folders = new RecursiveIteratorIterator($this->mail->getFolders(),
                                            RecursiveIteratorIterator::SELF_FIRST);
   echo '<select name="folder">';
   foreach ($folders as $localName => $folder) {
       $localName = str_pad('', $folders->getDepth(), '-', STR_PAD_LEFT) .
                    $localName;
       echo '<option';
       if (!$folder->isSelectable()) {
           echo ' disabled="disabled"';
       }
       echo ' value="' . htmlspecialchars($folder) . '">'
           . htmlspecialchars($localName) . '</option>';
   }
   echo '</select>';

現在選択されているフォルダを返すメソッドは ``getSelectedFolder()``
です。フォルダを変更するには ``selectFolder()`` メソッドを使用します。
このメソッドのパラメータには、グローバル名を指定しなければなりません。
区切り文字を書き込んでしまうことを防ぎたければ、 ``Zend_Mail_Storage_Folder``
インスタンスのプロパティを使用します。

.. code-block:: php
   :linenos:

   // 選択した保存形式とその設定により、$rootFolder->Archive->2005
   // は以下の内容と同等になります
   //   /Archive/2005
   //  Archive:2005
   //  INBOX.Archive.2005
   //  ...
   $folder = $mail->getFolders()->Archive->2005;
   echo 'Last folder was '
      . $mail->getSelectedFolder()
      . "new folder is $folder\n";
   $mail->selectFolder($folder);

.. _zend.mail.read-advanced:

高度な使用法
------

.. _zend.mail.read-advanced.noop:

NOOP の使用
^^^^^^^^

リモートの保存形式を使用しており、何らかの事情で接続をずっと保持し続けたい場合は
noop を使用します。

.. code-block:: php
   :linenos:

   foreach ($mail as $message) {

       // 何かの計算 ...

       $mail->noop(); // 接続をキープします

       // また別の処理 ...

       $mail->noop(); // 接続をキープします
   }

.. _zend.mail.read-advanced.caching:

インスタンスのキャッシュ
^^^^^^^^^^^^

``Zend_Mail_Storage_Mbox``\ 、 ``Zend_Mail_Storage_Folder_Mbox``\ 、 ``Zend_Mail_Storage_Maildir`` および
``Zend_Mail_Storage_Folder_Maildir`` は、マジックメソッド ``__sleep()`` と ``__wakeup()``
を実装しています。 つまり、シリアライズが可能であるということです。
これで、ファイルやディレクトリツリーを何度もパースする必要がなくなります。
難点があるとすれば、Mbox や Maildir を変更することができなくなるということです。
簡単な解決策としては、最終更新時刻が変更されたときに Mbox
ファイルをパースしなおしたり、
フォルダがなくなった場合にフォルダ構造を再パースしたり
(これはエラーとなりますが、その後別のフォルダを検索できます)
といったことが考えられます。よりよい方法は、シグナルファイル的なものを用意して
変更情報をそこに記録し、まずそれをチェックしてからキャッシュを利用するようにすることです。

.. code-block:: php
   :linenos:

   // ここでは、特定のキャッシュハンドラ/クラスは使用しません。
   // 使用するキャッシュハンドラにあわせてコードを変更してください
   $signal_file = '/home/test/.mail.last_change';
   $mbox_basedir = '/home/test/mail/';
   $cache_id = 'example mail cache ' . $mbox_basedir . $signal_file;

   $cache = new Your_Cache_Class();
   if (!$cache->isCached($cache_id) ||
       filemtime($signal_file) > $cache->getMTime($cache_id)) {
       $mail = new Zend_Mail_Storage_Folder_Pop3(array('dirname' =>
                                                           $mbox_basedir));
   } else {
       $mail = $cache->get($cache_id);
   }

   // 何らかの処理 ...

   $cache->set($cache_id, $mail);

.. _zend.mail.read-advanced.extending:

プロトコルクラスの拡張
^^^^^^^^^^^

リモートの保存形式では、ふたつのクラス ``Zend_Mail_Storage_<Name>`` および
``Zend_Mail_Protocol_<Name>`` を使用しています。
プロトコルクラスは、プロトコルのコマンドを処理して、レスポンスを *PHP*
に受け渡しします。コマンドに対応したメソッド、
さまざまなデータ構造に対応した変数を保持します。
もう一方のメインクラスでは、共通インターフェイスを実装します。

プロトコルを追加したい場合は、プロトコルクラスを継承したものを作成し、
それをメインクラスのコンストラクタで使用します。 例として、PHP3
接続の前に別のポートをノックしなければならないという場面を考えてみましょう。

.. code-block:: php
   :linenos:

   class Example_Mail_Exception extends Zend_Mail_Exception
   {
   }

   class Example_Mail_Protocol_Exception extends Zend_Mail_Protocol_Exception
   {
   }

   class Example_Mail_Protocol_Pop3_Knock extends Zend_Mail_Protocol_Pop3
   {
       private $host, $port;

       public function __construct($host, $port = null)
       {
           // このクラスでは自動接続は行いません
           $this->host = $host;
           $this->port = $port;
       }

       public function knock($port)
       {
           $sock = @fsockopen($this->host, $port);
           if ($sock) {
               fclose($sock);
           }
       }

       public function connect($host = null, $port = null, $ssl = false)
       {
           if ($host === null) {
               $host = $this->host;
           }
           if ($port === null) {
               $port = $this->port;
           }
           parent::connect($host, $port);
       }
   }

   class Example_Mail_Pop3_Knock extends Zend_Mail_Storage_Pop3
   {
       public function __construct(array $params)
       {
           // ... $params をここでチェックします! ...
           $protocol = new Example_Mail_Protocol_Pop3_Knock($params['host']);

           // 「特別な」処理をここでします
           foreach ((array)$params['knock_ports'] as $port) {
               $protocol->knock($port);
           }

           // 正しい状態に修正します
           $protocol->connect($params['host'], $params['port']);
           $protocol->login($params['user'], $params['password']);

           // 親を初期化します
           parent::__construct($protocol);
       }
   }

   $mail = new Example_Mail_Pop3_Knock(array('host'        => 'localhost',
                                             'user'        => 'test',
                                             'password'    => 'test',
                                             'knock_ports' =>
                                                 array(1101, 1105, 1111)));

ご覧の通り、メインクラスのコンストラクタでは
接続、ログイン、(サポートされるなら) フォルダの選択
までを済ませているものと期待しています。
したがって、独自のプロトコルクラスを使用する場合は、
これらを確実に処理しておく必要があります。そうしないと、
その後のメソッドが失敗してしまいます。

.. _zend.mail.read-advanced.quota:

容量制限の使用 (1.5 以降)
^^^^^^^^^^^^^^^^

``Zend_Mail_Storage_Writable_Maildir`` は Maildir++
の容量制限をサポートしています。デフォルトではこの機能は無効になっていますが、
手動で使用することもできます。これは、自動チェックをしたくないとき (つまり
``appendMessage()``\ 、 ``removeMessage()`` および ``copyMessage()`` でチェックを行わず maildirsize
ファイルにもエントリを追加しないとき) に使えます。
この機能を有効にすると、容量制限に達した maildir
に書き込もうとしたときに例外がスローされます。

容量制限関連のメソッドは ``getQuota()``\ 、 ``setQuota()`` および ``checkQuota()`` の 3
つです。

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Writable_Maildir(array('dirname' =>
                                                      '/home/test/mail/'));
   $mail->setQuota(true); // true で有効に、そして false で無効にします
   echo 'Quota check is now ', $mail->getQuota() ? 'enabled' : 'disabled', "\n";
   // チェックを無効にしている場合でも手動でのチェックは使用できます
   echo 'You are ', $mail->checkQuota() ? 'over quota' : 'not over quota', "\n";

``checkQuota()`` は、より詳細な情報も返します。

.. code-block:: php
   :linenos:

   $quota = $mail->checkQuota(true);
   echo 'You are ', $quota['over_quota'] ? 'over quota' : 'not over quota', "\n";
   echo 'You have ',
        $quota['count'],
        ' of ',
        $quota['quota']['count'],
        ' messages and use ';
   echo $quota['size'], ' of ', $quota['quota']['size'], ' octets';

maildirsize ファイルで指定したものではなく独自の容量制限を使用したい場合は、
``setQuota()`` を使用します。

.. code-block:: php
   :linenos:

   // メッセージ数とオクテットサイズに対応しています。順序が重要です
   $quota = $mail->setQuota(array('size' => 10000, 'count' => 100));

独自の容量チェックを追加するには、単一の文字をキーとして使用します。
キーが保存されます (が、チェックはされません)。 ``Zend_Mail_Storage_Writable_Maildir``
を継承して独自の容量制限 を定義することもできます。 maildirsize
ファイルが存在しないときにのみ使用します (Maildir++ ではこれが起こりえます)。

.. code-block:: php
   :linenos:

   class Example_Mail_Storage_Maildir extends Zend_Mail_Storage_Writable_Maildir {
       // getQuota は、容量チェックの際に $fromStorage = true でコールされます
       public function getQuota($fromStorage = false) {
           try {
               return parent::getQuota($fromStorage);
           } catch (Zend_Mail_Storage_Exception $e) {
               if (!$fromStorage) {
                   // 未知のエラー
                   throw $e;
               }
               // maildirsize ファイルが見つからないようです

               list($count, $size) = get_quota_from_somewhere_else();
               return array('count' => $count, 'size' => $size);
           }
       }
   }


