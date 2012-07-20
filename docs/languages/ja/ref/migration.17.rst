.. _migration.17:

Zend Framework 1.7
==================

以前のバージョンから Zend Framework 1.7 またはそれ以降に更新する際は、
下記の移行上の注意点に注意すべきです。

.. _migration.17.zend.controller:

Zend_Controller
---------------

.. _migration.17.zend.controller.dispatcher:

ディスパッチャインターフェイスの変更
^^^^^^^^^^^^^^^^^^

ユーザからの指摘により、 ``Zend_Controller_Action_Helper_ViewRenderer``
が使っているディスパッチャ抽象クラスのメソッドの中で
ディスパッチャインターフェイスに存在しないものがあることに気づきました。
次のメソッドを追加し、
自作のディスパッチャが同梱の実装と共存できるようにしています。

- ``formatModuleName()``:
  リクエストオブジェクト内に格納されたりしている生のコントローラ名を受け取り、
  それを再フォーマットして ``Zend_Controller_Action``
  を継承した適切なクラス名にします。

.. _migration.17.zend.file.transfer:

Zend_File_Transfer
------------------

.. _migration.17.zend.file.transfer.validators:

フィルタやバリデータを使用する際の変更点
^^^^^^^^^^^^^^^^^^^^

``Zend_File_Transfer`` のバリデータが ``Zend_Config``
と組み合わせて使えないという指摘がありました。
名前つき配列を使っていなかったからです。

そこで、 ``Zend_File_Transfer`` 用のすべてのフィルタとバリデータを作り直しました。
古い構文でも動作しますがこれは非推奨となり、 設定せずに実行すると *PHP* の notice
が発生するようになります。

次のリストは、パラメータの使用法に関する変更点をまとめたものです。

.. _migration.17.zend.file.transfer.validators.rename:

Rename フィルタ
^^^^^^^^^^^

- 古い形式の *API*: ``Zend_Filter_File_Rename($oldfile, $newfile, $overwrite)``

- 新しい形式の *API*: ``Zend_Filter_File_Rename($options)`` ``$options``
  には次の配列キーを使えます。 **source** (``$oldfile`` と同等)、 **target** (``$newfile``
  と同等)、 **overwrite** (``$overwrite`` と同等)

.. _migration.17.zend.file.transfer.validators.rename.example:

.. rubric:: rename フィルタの 1.6 から 1.7 での変更点

.. code-block:: php
   :linenos:

   // 1.6 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addFilter('Rename',
                      array('/path/to/oldfile', '/path/to/newfile', true));

   // 1.7 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addFilter('Rename',
                      array('source' => '/path/to/oldfile',
                            'target' => '/path/to/newfile',
                            'overwrite' => true));

.. _migration.17.zend.file.transfer.validators.count:

Count バリデータ
^^^^^^^^^^^

- 古い形式の *API*: ``Zend_Validate_File_Count($min, $max)``

- 新しい形式の *API*: ``Zend_Validate_File_Count($options)`` ``$options``
  には次の配列キーを使えます。 **min** (``$min`` と同等)、 **max** (``$max`` と同等)

.. _migration.17.zend.file.transfer.validators.count.example:

.. rubric:: count バリデータの 1.6 から 1.7 での変更点

.. code-block:: php
   :linenos:

   // 1.6 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Count',
                         array(2, 3));

   // 1.7 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Count',
                         false,
                         array('min' => 2,
                               'max' => 3));

.. _migration.17.zend.file.transfer.validators.extension:

Extension バリデータ
^^^^^^^^^^^^^^^

- 古い形式の *API*: ``Zend_Validate_File_Extension($extension, $case)``

- 新しい形式の *API*: ``Zend_Validate_File_Extension($options)`` ``$options``
  には次の配列キーを使えます。 ***** (``$extension``
  と同等、任意の他のキーを使用可能)、 **case** (``$case`` と同等)

.. _migration.17.zend.file.transfer.validators.extension.example:

.. rubric:: extension バリデータの 1.6 から 1.7 での変更点

.. code-block:: php
   :linenos:

   // 1.6 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Extension',
                         array('jpg,gif,bmp', true));

   // 1.7 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Extension',
                         false,
                         array('extension1' => 'jpg,gif,bmp',
                               'case' => true));

.. _migration.17.zend.file.transfer.validators.filessize:

FilesSize バリデータ
^^^^^^^^^^^^^^^

- 古い形式の *API*: ``Zend_Validate_File_FilesSize($min, $max, $bytestring)``

- 新しい形式の *API*: ``Zend_Validate_File_FilesSize($options)`` ``$options``
  には次の配列キーを使えます。 **min** (``$min`` と同等)、 **max** (``$max`` と同等)、
  **bytestring** (``$bytestring`` と同等)

さらに ``useByteString()`` メソッドのシグネチャも変わりました。
このメソッドの使用法は、
そのバリデータが生成するメッセージでバイト文字列を使うことを想定しているかどうかを調べるだけになりました。
フラグの値を設定するには ``setUseByteString()`` メソッドを使用します。

.. _migration.17.zend.file.transfer.validators.filessize.example:

.. rubric:: filessize バリデータの 1.6 から 1.7 での変更点

.. code-block:: php
   :linenos:

   // 1.6 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('FilesSize',
                      array(100, 10000, true));

   // 1.7 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => 100,
                               'max' => 10000,
                               'bytestring' => true));

   // 1.6 の例
   $upload->useByteString(true); // set flag

   // 1.7 の例
   $upload->setUseByteSting(true); // set flag

.. _migration.17.zend.file.transfer.validators.hash:

Hash バリデータ
^^^^^^^^^^

- 古い形式の *API*: ``Zend_Validate_File_Hash($hash, $algorithm)``

- 新しい形式の *API*: ``Zend_Validate_File_Hash($options)`` ``$options``
  には次の配列キーを使えます。 ***** (``$hash`` と同等、任意の他のキーを使用可能)、
  **algorithm** (``$algorithm`` と同等)、

.. _migration.17.zend.file.transfer.validators.hash.example:

.. rubric:: hash バリデータの 1.6 から 1.7 での変更点

.. code-block:: php
   :linenos:

   // 1.6 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Hash',
                      array('12345', 'md5'));

   // 1.7 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Hash',
                         false,
                         array('hash1' => '12345',
                               'algorithm' => 'md5'));

.. _migration.17.zend.file.transfer.validators.imagesize:

ImageSize バリデータ
^^^^^^^^^^^^^^^

- 古い形式の *API*: ``Zend_Validate_File_ImageSize($minwidth, $minheight, $maxwidth, $maxheight)``

- 新しい形式の *API*: ``Zend_Validate_File_FilesSize($options)`` ``$options``
  には次の配列キーを使えます。 **minwidth** (``$minwidth`` と同等)、 **maxwidth** (``$maxwidth``
  と同等)、 **minheight** (``$minheight`` と同等)、 **maxheight** (``$maxheight`` と同等)

.. _migration.17.zend.file.transfer.validators.imagesize.example:

.. rubric:: imagesize バリデータの 1.6 から 1.7 での変更点

.. code-block:: php
   :linenos:

   // 1.6 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('ImageSize',
                         array(10, 10, 100, 100));

   // 1.7 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('ImageSize',
                         false,
                         array('minwidth' => 10,
                               'minheight' => 10,
                               'maxwidth' => 100,
                               'maxheight' => 100));

.. _migration.17.zend.file.transfer.validators.size:

Size バリデータ
^^^^^^^^^^

- 古い形式の *API*: ``Zend_Validate_File_Size($min, $max, $bytestring)``

- 新しい形式の *API*: ``Zend_Validate_File_Size($options)`` ``$options``
  には次の配列キーを使えます。 **min** (``$min`` と同等)、 **max** (``$max`` と同等)、
  **bytestring** (``$bytestring`` と同等)

.. _migration.17.zend.file.transfer.validators.size.example:

.. rubric:: size バリデータの 1.6 から 1.7 での変更点

.. code-block:: php
   :linenos:

   // 1.6 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Size',
                         array(100, 10000, true));

   // 1.7 の例
   $upload = new Zend_File_Transfer_Adapter_Http();
   $upload->addValidator('Size',
                         false,
                         array('min' => 100,
                               'max' => 10000,
                               'bytestring' => true));

.. _migration.17.zend.locale:

Zend_Locale
-----------

.. _migration.17.zend.locale.islocale:

isLocale() を使う際の変更点
^^^^^^^^^^^^^^^^^^^

コーディング規約に従うと、 ``isLocale()`` は boolean
値を返さなければなりませんでした。
以前のバージョンでは、成功したばあいに文字列を返していました。 リリース 1.7
では、互換性モードが追加されて文字列を返す古い挙動も使えます。
しかし、このばあいは新しい挙動に変更するようにというユーザ警告が発生します。
古い挙動の ``isLocale()`` が行っていた再ルーティングはもはや不要で、 すべての I18n
は自分自身で再ルーティングを行います。

あなたのスクリプトを新しい *API*
用に変更するには、次のようにメソッドを使用します。

.. _migration.17.zend.locale.islocale.example:

.. rubric:: isLocale() を 1.6 用から 1.7 用に変更する方法

.. code-block:: php
   :linenos:

   // 1.6 の例
   if ($locale = Zend_Locale::isLocale($locale)) {
       // ここで何かします
   }

   // 1.7 の例

   // 互換性モードを変更して警告の発生を防ぐ必要があります
   // これは起動ファイルで行うことができます
   Zend_Locale::$compatibilityMode = false;

   if (Zend_Locale::isLocale($locale)) {
   }

2 番目のパラメータを使えば、
そのロケールが正しくて再ルーティングが発生しなかったかどうかがわかることに注意しましょう。

.. code-block:: php
   :linenos:

   // 1.6 の例
   if ($locale = Zend_Locale::isLocale($locale, false)) {
       // ここで何かします
   }

   // 1.7 の例

   // 互換性モードを変更して警告の発生を防ぐ必要があります
   // これは起動ファイルで行うことができます
   Zend_Locale::$compatibilityMode = false;

   if (Zend_Locale::isLocale($locale, false)) {
       if (Zend_Locale::isLocale($locale, true)) {
           // ロケールはありません
       }

       // もとの文字列はロケールを持ちませんが再ルーティングできます
   }

.. _migration.17.zend.locale.islocale.getdefault:

getDefault() を使用する際の変更
^^^^^^^^^^^^^^^^^^^^^^

``getDefault()`` メソッドの意味が変わりました。
フレームワークにロケールが統合され、それを ``setDefault()``
で設定できるようになったからです。
このメソッドはもはやロケールチェインを返すことはなく、
フレームワークのロケールに設定されたものだけを返します。

あなたのスクリプトを新しい *API*
用に変更するには、次のようにメソッドを使用します。

.. _migration.17.zend.locale.islocale.getdefault.example:

.. rubric:: getDefault() を 1.6 用から 1.7 用に変更する方法

.. code-block:: php
   :linenos:

   // 1.6 の例
   $locales = $locale->getDefault(Zend_Locale::BROWSER);

   // 1.7 の例

   // 互換性モードを変更して警告の発生を防ぐ必要があります
   // これは起動ファイルで行うことができます
   Zend_Locale::$compatibilityMode = false;

   $locale = Zend_Locale::getOrder(Zend_Locale::BROWSER);

古い実装における ``getDefault()`` の 2
番目のパラメータはもはや使えないことに注意しましょう。
返り値がそれと同じ値となります。

.. note::

   デフォルトでは古い挙動も有効ですが、ユーザ警告が発生します。
   新しい挙動にあわせてコードを変更し終えたら、 互換性モードを ``FALSE``
   に変更して警告が発生しないようにしなければなりません。

.. _migration.17.zend.translator:

Zend_Translator
---------------

.. _migration.17.zend.translator.languages:

言語の設定
^^^^^

言語の自動検出を使用したり ``Zend_Translator`` に手動で言語を設定したりする際に、
「追加に失敗」や「翻訳がない」などの理由で notice
が発行されることがありました。
以前のリリースでは、場合によっては例外が発生することもありました。

その原因は、存在しない言語をユーザが指定した際に
何が問題なのかを知る簡単な方法がなかったことにあります。 そこで私たちは notice
を発行させるようにしていたのです。
ログに記録が残るので、サポートしていない言語がリクエストされたことがわかるようになります。
そしてたとえ notice が発行されたとしても、コード自体は問題なく動作します。

しかし、xdebug のような独自のエラーハンドラ/例外ハンドラを使った場合など、
意図せぬものも含めてすべての notice を拾ってしまうこともあります。
そういった独自のハンドラは *PHP* の設定を上書きしてしまうことがあるからです。

これらの notice を発生させないようにするためには、新たなオプション 'disableNotices'
を ``TRUE`` に設定するだけです。デフォルトは ``FALSE`` となっています。

.. _migration.17.zend.translator.example:

.. rubric:: notice を取得せずに言語の設定を行う

ここでは、'en' に対応しているところにユーザから 'fr'
がリクエストされたものと家庭します。この翻訳は登録されていません。

.. code-block:: php
   :linenos:

   $language = new Zend_Translator('gettext',
                                  '/path/to/translations',
                                  'auto');

この場合、存在しない言語 'fr' が指定されたことに関する notice が発行されます。
オプションを追加すると、この notice は発生しなくなります。

.. code-block:: php
   :linenos:

   $language = new Zend_Translator('gettext',
                                  '/path/to/translations',
                                  'auto',
                                  array('disableNotices' => true));

.. _migration.17.zend.view:

Zend_View
---------

.. note::

   ``Zend_View`` 内の *API* 変更は、 リリース 1.7.5
   またはそれ以降にアップグレードする際にだけ注意すべきです。

Zend Framework 開発陣は、1.7.5 より前のバージョンにおいて ``Zend_View::render()``
メソッドにローカルファイル読み込み (Local File Inclusion: *LFI*)
脆弱性の問題があることに気づきました。 1.7.5
より前のバージョンでは、このメソッドはデフォルトで 親ディレクトリを指す記法
("../" や "..\\") を含むビュースクリプトも指定できてしまいます。
フィルタリングをしていないユーザ入力が ``render()`` メソッドに渡されると、 *LFI*
攻撃を受ける可能性が出てきます。

.. code-block:: php
   :linenos:

   // $_GET['foobar'] = '../../../../etc/passwd' だったら……
   echo $view->render($_GET['foobar']); // LFI

``Zend_View`` は、このようなビュースクリプトがリクエストされると
デフォルトで例外を発生させるようになりました。

.. _migration.17.zend.view.disabling:

render() メソッドにおける LFI 保護機能の無効化
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

多くの開発者から「ユーザの入力では **ない**
場面で、意図的にこれらの記法を使っていることもある」という指摘を受けたため、
特別なフラグを用意してデフォルトの保護機能を無効化できるようにしました。
無効化する方法は二通りあります。コンストラクタのオプションで 'lfiProtectionOn'
キーを指定するか、あるいは ``setLfiProtection()`` メソッドをコールします。

.. code-block:: php
   :linenos:

   // コンストラクタでの無効化
   $view = new Zend_View(array('lfiProtectionOn' => false));

   // メソッドコールによる無効化
   $view = new Zend_View();
   $view->setLfiProtection(false);


