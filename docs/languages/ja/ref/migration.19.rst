.. _migration.19:

Zend Framework 1.9
==================

1.9.0 よりも前にリリースされた Zend Framework から 1.9
のどのリリースに更新する際でも、 下記の移行上の注意点に注意すべきです。

.. _migration.19.zend.file.transfer:

Zend_File_Transfer
------------------

.. _migration.19.zend.file.transfer.mimetype:

MimeType の検証
^^^^^^^^^^^^

セキュリティ上の理由から、 ``MimeType``\ 、 ``ExcludeMimeType``\ 、 ``IsCompressed`` および
``IsImage`` バリデータにおけるデフォルトのフォールバック機能を無効にしました。
つまり、 **fileInfo** 拡張モジュールあるいは **magicMime** 拡張モジュールがなければ、
検証が常に失敗するようになるということです。

ユーザ側から渡された *HTTP*
フィールドを使用して入力を検証する必要がある場合は、 ``enableHeaderCheck()``
メソッドを使用すればこの機能を有効にできます。

.. note::

   **セキュリティに関するヒント**

   ユーザ側から渡された *HTTP*
   フィールドに依存するのはセキュリティ上のリスクとなることに注意しましょう。
   これは簡単に改ざんすることができ、悪意のあるファイルを受け取る可能性があります。

.. _migration.19.zend.file.transfer.example:

.. rubric:: HTTP フィールドの使用を許可する

.. code-block:: php
   :linenos:

   // 初期化時に
   $valid = new Zend_File_Transfer_Adapter_Http(array('headerCheck' => true);

   // あるいは後から
   $valid->enableHeaderCheck();

.. _migration.19.zend.filter:

Zend_Filter
-----------

1.9のリリース以前は、 ``Zend_Filter``\ では、 static ``get()``\
メソッドを使うことができました。
リリース1.9と同時に、このメソッドは、より描写的な ``filterStatic()``\
に名前を変更されました。 古い ``get()`` メソッドは非推奨に区分されます。

.. _migration.19.zend.http.client:

Zend_Http_Client
----------------

.. _migration.19.zend.http.client.fileuploadsarray:

内部のアップロードされたファイル情報ストレージに変更
^^^^^^^^^^^^^^^^^^^^^^^^^^

Zend Framework のバージョン 1.9 では、 アップロードされるファイルに関する情報を
``Zend_Http_Client``\ が内部的に格納し、 ``Zend_Http_Client::setFileUpload()``\
メソッドを用いてセットする 方法で変化がありました。

複数のファイルを同じフォーム名で ファイルの配列としてアップロードできるように
この変化が取り入れられました。 この問題に関するより多くの情報は、
`このバグ・レポート`_ で見つけられます。

.. _migration.19.zend.http.client.fileuploadsarray.example:

.. rubric:: アップロードされたファイル情報の内部ストレージ

.. code-block:: php
   :linenos:

   // ファイル２つを同じフォーム要素名でファイルの配列としてアップロード
   $client = new Zend_Http_Client();
   $client->setFileUpload('file1.txt',
                          'userfile[]',
                          'some raw data',
                          'text/plain');
   $client->setFileUpload('file2.txt',
                          'userfile[]',
                          'some other data',
                          'application/octet-stream');

   // Zend Framework の 1.8 以前では、
   // protected メンバー $client->files の値はこうです:
   // $client->files = array(
   //     'userfile[]' => array('file2.txt',
                                'application/octet-stream',
                                'some other data')
   // );

   // Zend Framework の 1.9 以降では、$client->files の値はこうです:
   // $client->files = array(
   //     array(
   //         'formname' => 'userfile[]',
   //         'filename' => 'file1.txt,
   //         'ctype'    => 'text/plain',
   //         'data'     => 'some raw data'
   //     ),
   //     array(
   //         'formname' => 'userfile[]',
   //         'filename' => 'file2.txt',
   //         'formname' => 'application/octet-stream',
   //         'formname' => 'some other data'
   //     )
   // );

ご覧の通り、この変化は1つ以上のファイルで同じフォーム要素名を使えるようにします。
しかし、それは微妙な下位互換性変化を取り入れるので、そのように注意するべきです。

.. _migration.19.zend.http.client.getparamsrecursize:

Zend_Http_Client::\_getParametersRecursive() の廃止
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

バージョン1.9から始まりますが、 protected メソッド ``_getParametersRecursive()`` はもはや
``Zend_Http_Client`` に使われず、廃止されます。 それを使うと、 ``E_NOTICE`` メッセージが
*PHP*\ によって発生する原因になります。

``Zend_Http_Client``\ をサブクラスとして、このメソッドを呼ぶなら、 その代わりに
``Zend_Http_Client::_flattenParametersArray()`` static
メソッドを使用することに目を向けるべきです。

また、この ``_getParametersRecursive``\ は protected メソッドなので、 この変化は
``Zend_Http_Client``\ をサブクラスとするユーザーに 影響を及ぼすだけです。

.. _migration.19.zend.locale:

Zend_Locale
-----------

.. _migration.19.zend.locale.deprecated:

非推奨となるメソッド
^^^^^^^^^^

特別に用意されていたメソッドのいくつかが非推奨となります。
既存の挙動と重複しているからです。 古いメソッドも動作するにはしますが、
新しいメソッドについて説明する user notice が発生することに注意しましょう。
これらのメソッドは 2.0 で削除されます。
次の一覧で、新旧のメソッドコールを参照ください。

.. _migration.19.zend.locale.deprecated.table-1:

.. table:: 新旧のメソッドコールの一覧

   +----------------------------------------+--------------------------------------------+
   |古い方法                                    |新しい方法                                       |
   +========================================+============================================+
   |getLanguageTranslationList($locale)     |getTranslationList('language', $locale)     |
   +----------------------------------------+--------------------------------------------+
   |getScriptTranslationList($locale)       |getTranslationList('script', $locale)       |
   +----------------------------------------+--------------------------------------------+
   |getCountryTranslationList($locale)      |getTranslationList('territory', $locale, 2) |
   +----------------------------------------+--------------------------------------------+
   |getTerritoryTranslationList($locale)    |getTranslationList('territory', $locale, 1) |
   +----------------------------------------+--------------------------------------------+
   |getLanguageTranslation($value, $locale) |getTranslation($value, 'language', $locale) |
   +----------------------------------------+--------------------------------------------+
   |getScriptTranslation($value, $locale)   |getTranslation($value, 'script', $locale)   |
   +----------------------------------------+--------------------------------------------+
   |getCountryTranslation($value, $locale)  |getTranslation($value, 'country', $locale)  |
   +----------------------------------------+--------------------------------------------+
   |getTerritoryTranslation($value, $locale)|getTranslation($value, 'territory', $locale)|
   +----------------------------------------+--------------------------------------------+

.. _migration.19.zend.view.helper.navigation:

Zend_View_Helper_Navigation
---------------------------

1.9のリリースより前は、 メニュー・ヘルパー (``Zend_View_Helper_Navigation_Menu``) は、
サブメニューを正しく生成しませんでした。 ``onlyActiveBranch`` が ``TRUE`` で、
オプションの ``renderParents`` が ``FALSE`` のとき、 もし、最も深いアクティブなページが
``minDepth`` オプションより低い階層にあると、 何もレンダリングされないでしょう。

より簡単に言うと、もし ``minDepth`` が '1' に設定され、
アクティブなページが最初のレベルのページの一つなら、
以下の例が示すように、何もレンダリングされないでしょう。

下記のコンテナのセットアップを考えて見ましょう。

.. code-block:: php
   :linenos:

   <?php
   $container = new Zend_Navigation(array(
       array(
           'label' => 'Home',
           'uri'   => '#'
       ),
       array(
           'label'  => 'Products',
           'uri'    => '#',
           'active' => true,
           'pages'  => array(
               array(
                   'label' => 'Server',
                   'uri'   => '#'
               ),
               array(
                   'label' => 'Studio',
                   'uri'   => '#'
               )
           )
       ),
       array(
           'label' => 'Solutions',
           'uri'   => '#'
       )
   ));

下記のコードがビュースクリプトで使用されます。

.. code-block:: php
   :linenos:

   <?php echo $this->navigation()->menu()->renderMenu($container, array(
       'minDepth'         => 1,
       'onlyActiveBranch' => true,
       'renderParents'    => false
   )); ?>

リリース1.9より前は、上記のコードスニペットは、何も出力しません。

リリース1.9以降では、ページの子供がある限り、 ``Zend_View_Helper_Navigation_Menu`` の
``_renderDeepestMenu()`` メソッドは ``minDepth``
の１階層下のアクティブページを受け取ります。

今では、同じコードスニペットで下記を出力します。

.. code-block:: html
   :linenos:

   <ul class="navigation">
       <li>
           <a href="#">Server</a>
       </li>
       <li>
           <a href="#">Studio</a>
       </li>
   </ul>

.. _migration.19.security:

Security fixes as with 1.9.7
----------------------------

Additionally, users of the 1.9 series may be affected by other changes starting in version 1.9.7. These are all
security fixes that also have potential backwards compatibility implications.

.. _migration.19.security.zend.filter.html-entities:

Zend_Filter_HtmlEntities
^^^^^^^^^^^^^^^^^^^^^^^^

In order to default to a more secure character encoding, ``Zend_Filter_HtmlEntities`` now defaults to *UTF-8*
instead of *ISO-8859-1*.

Additionally, because the actual mechanism is dealing with character encodings and not character sets, two new
methods have been added, ``setEncoding()`` and ``getEncoding()``. The previous methods ``setCharSet()`` and
``setCharSet()`` are now deprecated and proxy to the new methods. Finally, instead of using the protected members
directly within the ``filter()`` method, these members are retrieved by their explicit accessors. If you were
extending the filter in the past, please check your code and unit tests to ensure everything still continues to
work.

.. _migration.19.security.zend.filter.strip-tags:

Zend_Filter_StripTags
^^^^^^^^^^^^^^^^^^^^^

``Zend_Filter_StripTags`` contains a flag, ``commentsAllowed``, that, in previous versions, allowed you to
optionally whitelist *HTML* comments in *HTML* text filtered by the class. However, this opens code enabling the
flag to *XSS* attacks, particularly in Internet Explorer (which allows specifying conditional functionality via
*HTML* comments). Starting in version 1.9.7 (and backported to versions 1.8.5 and 1.7.9), the ``commentsAllowed``
flag no longer has any meaning, and all *HTML* comments, including those containing other *HTML* tags or nested
commments, will be stripped from the final output of the filter.



.. _`このバグ・レポート`: http://framework.zend.com/issues/browse/ZF-5744
