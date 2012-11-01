.. EN-Revision: none
.. _zend.file.transfer.introduction:

Zend\File\Transfer
==================

``Zend\File\Transfer`` を使用すると、
ファイルのアップロードやダウンロードを管理できます。
組み込みのバリデータを使ってファイルを検証したり、
フィルタによってファイルを変更したりという機能があります。 ``Zend\File\Transfer``
はアダプタ形式を採用しており、 *HTTP* や FTP、WEBDAV
などのさまざまな転送プロトコルを同じ *API* で使用できます。

.. note::

   **制限**

   現在の ``Zend\File\Transfer`` の実装では、 *HTTP* Post
   によるアップロードにしか対応していません。
   ファイルのダウンロードやその他のアダプタについては次のリリースで追加される予定です。
   実装されていないメソッドを実行すると例外をスローします。
   したがって、実際のところは ``Zend\File\Transfer\Adapter\Http``
   のインスタンスを直接操作することになります。
   これは、将来複数のアダプタが使用可能になった段階で変更される予定です。

.. note::

   **フォーム**

   ``Zend_Form`` を使う場合は ``Zend_Form`` の *API* を使うようにし、 ``Zend\File\Transfer``
   を直接使わないようにしましょう。 ``Zend_Form`` のファイル転送機能は
   ``Zend\File\Transfer`` で実装されているので、この章の説明は ``Zend_Form``
   のユーザにも有用です。

``Zend\File\Transfer`` の使い方はきわめて単純です。 ふたつの部分から成り立っており、
アップロードを行う *HTTP* フォームとアップロードされたファイルを ``Zend\File\Transfer``
で処理するコードを作成します。 次の例を参照ください。

.. _zend.file.transfer.introduction.example:

.. rubric:: シンプルなファイルアップロードフォーム

これは、基本的なファイルアップロード処理の例です。
まずはファイルアップロードフォームから。
今回の例では。アップロードしたいファイルはひとつです。

.. code-block:: xml
   :linenos:

   <form enctype="multipart/form-data" action="/file/upload" method="POST">
       <input type="hidden" name="MAX_FILE_SIZE" value="100000" />
           アップロードするファイルを選択: <input name="uploadedfile" type="file" />
       <br />
       <input type="submit" value="アップロード" />
   </form>

*HTML* を直接作成するのではなく、利便性を考慮して :ref:`Zend\Form_Element\File
<zend.form.standardElements.file>` を使っていることに注意しましょう。

次はアップロードしたファイルを受け取る側です。 今回の例では、受け取る側は
``/file/upload`` となります。そこで、 'file' コントローラにアクション ``upload()``
を作成します。

.. code-block:: php
   :linenos:

   $adapter = new Zend\File\Transfer\Adapter\Http();

   $adapter->setDestination('C:\temp');

   if (!$adapter->receive()) {
       $messages = $adapter->getMessages();
       echo implode("\n", $messages);
   }

このコードは ``Zend\File\Transfer`` のもっともシンプルな使用法を示すものです。
ローカルの保存先を ``setDestination()`` メソッドで指定して ``receive()``
メソッドをコールします。 アップロード時に何らかのエラーが発生した場合は、
返された例外の中でその情報を取得できます。

.. note::

   **注意**

   この例は、 ``Zend\File\Transfer`` の基本的な *API* を説明するためだけのものです。
   これをそのまま実際の環境で使用しては **いけません**\ 。
   深刻なセキュリティ問題を引き起こしてしまいます。
   常にバリデータを使用してセキュリティを向上させるようにしなければなりません。

.. _zend.file.transfer.introduction.adapters:

Zend\File\Transfer がサポートするアダプタ
------------------------------

``Zend\File\Transfer`` は、
さまざまなアダプタと転送方向をサポートするように作られています。
ファイルのアップロードやダウンロードだけでなく、転送
(あるアダプタでのアップロードと別のアダプタでのダウンロードを同時に行う)
にも対応できるように設計されています。 しかし、Zend Framework 1.6
の時点で存在するアダプタは Http アダプタひとつだけです。

.. _zend.file.transfer.introduction.options:

Zend\File\Transfer のオプション
-------------------------

``Zend\File\Transfer`` やそのアダプタはさまざまなオプションをサポートしています。
オプションはコンストラクタで指定することもできますし、 ``setOptions($options)``
で指定することもできます。 ``getOptions()``
は、実際に設定されているオプションを返します。
サポートするオプションは次のとおりです。

- **ignoreNoFile**: このオプションを ``TRUE`` にすると、
  ファイルがフォームからアップロードされなかったときにバリデータは何も行いません。
  このオプションの既定値は ``FALSE`` で、
  この場合はファイルがアップロードされなければエラーとなります。

.. _zend.file.transfer.introduction.checking:

ファイルのチェック
---------

``Zend\File\Transfer``
のメソッドの中には、さまざまな前提条件をチェックするためのものもあります。
これらは、アップロードされたファイルを処理する際に便利です。

- **isValid($files = null)**: このメソッドは、
  ファイルにアタッチされたバリデータを用いてそのファイルが妥当なものかどうかを検証します。
  ファイル名を省略した場合はすべてのファイルをチェックします。 ``isValid()`` を
  ``receive()`` の前にコールすることもできます。 この場合、 ``receive()``
  がファイルを受信する際に内部的に ``isValid()`` をコールすることはありません。

- **isUploaded($files = null)**: このメソッドは、
  指定したファイルがユーザによってアップロードされたものなのかどうかを調べます。
  これは、複数のファイルを任意でアップロードできるようにする場合などに便利です。
  ファイル名を省略した場合はすべてのファイルをチェックします。

- **isReceived($files = null)**: このメソッドは、
  指定したファイルがすでに受信済みであるかどうかを調べます。
  ファイル名を省略した場合はすべてのファイルをチェックします。

.. _zend.file.transfer.introduction.checking.example:

.. rubric:: ファイルのチェック

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // すべての既知の内部ファイル情報を返します
   $files = $upload->getFileInfo();

   foreach ($files as $file => $info) {
       // アップロードされたファイルか ?
       if (!$upload->isUploaded($file)) {
           print "ファイルをアップロードしてください";
           continue;
       }

       // バリデータを通過したか ?
       if (!$upload->isValid($file)) {
           print "$file は不適切です";
           continue;
       }
   }

   $upload->receive();

.. _zend.file.transfer.introduction.informations:

さらなるファイル情報
----------

``Zend\File\Transfer`` は、ファイルについてのさらなる情報を返すことができます。
次のメソッドが使用可能です。

- **getFileName($file = null, $path = true)**:
  このメソッドは、転送されたファイルの実際のファイル名を返します。

- **getFileInfo($file = null)**:
  このメソッドは、転送されたファイルのすべての内部情報を返します。

- **getFileSize($file = null)**:
  このメソッドは、指定したaifるの実際のファイルサイズを返します。

- **getHash($hash = 'crc32', $files = null)**:
  このメソッドは、転送されたファイルの内容のハッシュを返します。

- **getMimeType($files = null)**: このメソッドは、転送されたファイルの mimetype
  を返します。

``getFileName()`` の最初のパラメータには、
要素の名前を渡すことができます。名前を省略した場合は、
すべてのファイル名を配列で返します。 multifile
形式であった場合も結果は配列となります。
ファイルがひとつだけだった場合は結果を文字列で返します。

デフォルトでは、ファイル名はフルパス形式で返されます。
パス抜きのファイル名だけがほしい場合は、2 番目のパラメータ *$path*
を設定します。これを ``FALSE`` にするとパスの部分を取り除いた結果を返します。

.. _zend.file.transfer.introduction.informations.example1:

.. rubric:: ファイル名の取得

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();
   $upload->receive();

   // すべてのファイルのファイル名を返します
   $names = $upload->getFileName();

   // フォームの 'foo' 要素のファイル名を返します。
   $names = $upload->getFileName('foo');

.. note::

   ファイルを受信する際にファイル名が変わることがあることに注意しましょう。
   これは、ファイルを受信した後ですべてのフィルタが適用されるからです。
   ``getFileName()`` をコールするのは、ファイルを受信してからでなければなりません。

``getFileSize()`` は、デフォルトではファイルサイズを SI 記法で返します。
つまり、たとえば **2048** ではなく **2kB**
のようになるということです。単にサイズだけが知りたい場合は、オプション
``useByteString`` を ``FALSE`` に設定してください。

.. _zend.file.transfer.introduction.informations.example.getfilesize:

.. rubric:: ファイルのサイズの取得

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();
   $upload->receive();

   // 複数のファイルがアップロードされた場合は、すべてのファイルのサイズを配列で返します
   $size = $upload->getFileSize();

   // SI 記法を無効にし、数値のみを返すようにします
   $upload->setOption(array('useByteString' => false));
   $size = $upload->getFileSize();

.. note::

   **Client given filesize**

   Note that the filesize which is given by the client is not seen as save input. Therefor the real size of the
   file will be detected and returned instead of the filesize sent by the client.

``getHash()`` の最初のパラメータには、ハッシュアルゴリズムの名前を指定します。
使用できるアルゴリズムについては `PHP の hash_algos メソッド`_
を参照ください。アルゴリズムを省略した場合は **crc32**
をデフォルトのアルゴリズムとして使用します。

.. _zend.file.transfer.introduction.informations.example2:

.. rubric:: ファイルのハッシュの取得

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();
   $upload->receive();

   // 複数のファイルがアップロードされた場合は、すべてのファイルのハッシュを配列で返します
   $hash = $upload->getHash('md5');

   // フォームの 'foo' 要素のハッシュを返します。
   $names = $upload->getHash('crc32', 'foo');

.. note::

   **返り値**

   複数のファイルを指定した場合は、返される結果が配列となることに注意しましょう。

``getMimeType()`` はファイルの mimetype を返します。
複数のファイルがアップロードされた場合は配列、そうでない場合は文字列を返します。

.. _zend.file.transfer.introduction.informations.getmimetype:

.. rubric:: ファイルの mimetype の取得

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();
   $upload->receive();

   $mime = $upload->getMimeType();

   // フォーム要素 'foo' の mimetype を返します
   $names = $upload->getMimeType('foo');

.. note::

   **Client given mimetype**

   Note that the mimetype which is given by the client is not seen as save input. Therefor the real mimetype of the
   file will be detected and returned instead of the mimetype sent by the client.

.. warning::

   **ありえる例外**

   このメソッドは、fileinfo
   拡張モジュールが使用可能な場合はそれを使用することに注意しましょう。
   この拡張モジュールがみつからなかった場合は、mimemagic
   拡張モジュールを使用します。
   それもみつからなかった場合は、例外を発生します。

.. warning::

   **Original data within $_FILES**

   Due to security reasons also the original data within $_FILES will be overridden as soon as
   ``Zend\File\Transfer`` is initiated. When you want to omit this behaviour and have the original data simply set
   the ``detectInfos`` option to ``FALSE`` at initiation.

   This option will have no effect after you initiated ``Zend\File\Transfer``.

.. _zend.file.transfer.introduction.uploadprogress:

ファイルアップロードの進捗
-------------

``Zend\File\Transfer`` では、ファイルアップロードの進捗状況を知ることができます。
この機能を使用するには、 *APC* 拡張モジュール (ほとんどの *PHP*
環境においてデフォルトで提供されています) あるいは ``uploadprogress``
拡張モジュールが必要です。
これらの拡張モジュールがインストールされていれば、自動検出してそれを使用します。
進捗状況を取得するには、いくつかの事前条件があります。

まず、 *APC* あるいは ``uploadprogress`` のいずれかを有効にする必要があります。 *APC*
の機能は ``php.ini`` で無効化できることに注意しましょう。

次に、ファイルを送信するフォームの中に適切な hidden
フィールドを追加しなければなりません。 ``Zend\Form_Element\File`` を使う場合は、この
hidden フィールドは ``Zend_Form`` が自動的に追加します。

これらふたつの条件さえ満たせば、ファイルアップロードの進捗状況を *getProgress*
メソッドで取得できます。 実際には、これを処理する公式な方法は 2 通りあります。

.. _zend.file.transfer.introduction.uploadprogress.progressadapter:

progressbar アダプタを使用する
^^^^^^^^^^^^^^^^^^^^^

**Zend_ProgressBar** を使用して、
実際の進捗状況を取得した上でそれをシンプルにユーザに見せることができます。

そのためには、 ``getProgress()`` を最初にコールするときにお望みの
**Zend\ProgressBar\Adapter** を追加しなければなりません。
どのアダプタを使用すればいいのかについては :ref:`Zend_ProgressBar の標準のアダプタ
<zend.progressbar.adapters>` の章を参照ください。

.. _zend.file.transfer.introduction.uploadprogress.progressadapter.example1:

.. rubric:: progressbar アダプタを使用した実際の状態の取得

.. code-block:: php
   :linenos:

   $adapter = new Zend\ProgressBar_Adapter\Console();
   $upload  = Zend\File\Transfer\Adapter\Http::getProgress($adapter);

   $upload = null;
   while (!$upload['done']) {
       $upload = Zend\File\Transfer\Adapter\Http:getProgress($upload);
   }

完全な処理は、バックグラウンドで ``getProgress()`` によって行われます。

.. _zend.file.transfer.introduction.uploadprogress.manually:

getProgress() を手動で使用する
^^^^^^^^^^^^^^^^^^^^^^

``Zend_ProgressBar`` を使わずに手動で ``getProgress()`` を動作させることもできます。

``getProgress()`` を何も設定なしでコールします。
すると、いくつかのキーを含む配列が返されます。 使用している *PHP*
拡張モジュールによってその内容は異なります。
しかし、次のキーは拡張モジュールにかかわらず返されます。

- **id**: このアップロードの
  ID。その拡張モジュール内でのアップロードを一意に識別します。
  自動的に設定され、この値は決して変更することができません。

- **total**: アップロードされたファイル全体のサイズをバイト単位で表した整数値。

- **current**:
  現在までにアップロードされたファイルサイズをバイト単位で表した整数値。

- **rate**: アップロードの平均速度を「バイト/秒」単位で表した整数値。

- **done**: アップロードが終了したときは ``TRUE`` 、 そうでなければ ``FALSE``
  を返します。

- **message**: 実際のメッセージ。進捗を **10kB / 200kB**
  形式で表したテキストか、何か問題が起こった場合には有用なメッセージとなります。
  「問題」とは、何もアップロード中でない場合や
  進捗状況の取得に失敗した場合、あるいはアップロードがキャンセルされた場合を意味します。

- **progress**: このオプションキーには ``Zend\ProgressBar\Adapter`` あるいは Zend_ProgressBar
  のインスタンスが含まれ、
  プログレスバー内から実際のアップロード状況を取得できるようになります。

- **session**: このオプションキーには ``Zend_ProgressBar``
  内で使用するセッション名前空間の名前が含まれます。
  このキーが与えられなかったときのデフォルトは
  ``Zend\File\Transfer\Adapter\Http\ProgressBar`` です。

それ以外に返されるキーについては各拡張モジュールが直接返すものであり、
チェックしていません。

次の例は、手動で使用する方法を示すものです。

.. _zend.file.transfer.introduction.uploadprogress.manually.example1:

.. rubric:: 手動での進捗状況表示の使用法

.. code-block:: php
   :linenos:

   $upload  = Zend\File\Transfer\Adapter\Http::getProgress();

   while (!$upload['done']) {
       $upload = Zend\File\Transfer\Adapter\Http:getProgress($upload);
       print "\nActual progress:".$upload['message'];
       // 何か必要な処理をします
   }

.. note::

   **Knowing the file to get the progress from**

   The above example works when your upload identified is set to 'progress_key'. When you are using another
   identifier within your form you must give the used identifier as first parameter to ``getProgress()`` on the
   initial call.



.. _`PHP の hash_algos メソッド`: http://php.net/hash_algos
