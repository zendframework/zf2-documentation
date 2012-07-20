.. _zend.file.transfer.validators:

Zend_File_Transfer 用のバリデータ
==========================

``Zend_File_Transfer`` にはファイル関連のバリデータがいくつか同梱されています。
これらを使用してセキュリティを向上させ、攻撃から身を守るようにしましょう。
バリデータは、それを使ってこそ役に立つものなのですから。 ``Zend_File_Transfer``
が提供するバリデータは ``Zend_Validator`` コンポーネントに含まれ、 ``Zend_Validate_File_*``
という名前がついています。 現在使用できるバリデータは次のとおりです。

- *Count*: このバリデータはファイルの数をチェックします。
  最小値と最大値を指定し、そのいずれかに違反した場合にエラーをスローします。

- *Crc32*: このバリデータはファイルの内容の crc32 ハッシュ値をチェックします。 *Hash*
  バリデータをもとにしたもので、 Crc32
  のみをサポートする便利でシンプルなバリデータを提供します。

- *ExcludeExtension*: このバリデータはファイルの拡張子をチェックします。
  渡されたファイルの拡張子が定義済みのものだった場合にエラーをスローします。
  これにより、特定の拡張子だけを除外できるようになります。

- *ExcludeMimeType*: このバリデータはファイルの *MIME* 型をチェックします。 *MIME*
  型の種類を検証し、指定したファイルの *MIME*
  型がそれと一致するときにエラーをスローします。

- *Exists*: このバリデータはファイルの存在をチェックします。
  指定したファイルが存在しない場合にエラーをスローします。

- *Extension*: このバリデータはファイルの拡張子をチェックします。
  渡されたファイルの拡張子が未定義のものだった場合にエラーをスローします。

- *FilesSize*: このバリデータはすべてのファイルのサイズをチェックします。
  すべてのファイルのサイズを内部的に記憶し、
  その合計が制限値を超えた場合にエラーをスローします。
  サイズの最小値と最大値を指定できます。

- *ImageSize*: このバリデータは画像のサイズをチェックします。
  幅と高さについて、最小値と最大値を検証できます。

- *IsCompressed*:
  このバリデータはファイルが圧縮されているかどうかをチェックします。 *MimeType*
  バリデータにもとづいて、 zip や arc
  といった圧縮アーカイブ形式かどうかを判断します。
  特定のアーカイブ形式のみに制限することもできます。

- *IsImage*: このバリデータはファイルが画像であるかどうかをチェックします。
  *MimeType* バリデータにもとづいて、 jpg や gif
  といった画像ファイルであるかどうかを判断します。
  特定の画像形式のみに制限することもできます。

- *Hash*: このバリデータはファイルの内容のハッシュ値をチェックします。
  複数のアルゴリズムをサポートしています。

- *Md5*: このバリデータはファイルの内容の md5 ハッシュ値をチェックします。 *Hash*
  バリデータをもとにしたもので、 Md5
  のみをサポートする便利でシンプルなバリデータを提供します。

- *MimeType*: このバリデータはファイルの *MIME* 型をチェックします。 *MIME*
  型の種類を検証し、指定したファイルの *MIME*
  型がそれと一致しないときにエラーをスローします。

- *NotExists*: このバリデータはファイルの存在をチェックします。
  指定したファイルが存在する場合にエラーをスローします。

- *Sha1*: このバリデータはファイルの内容の sha1 ハッシュ値をチェックします。 *Hash*
  バリデータをもとにしたもので、 sha1
  のみをサポートする便利でシンプルなバリデータを提供します。

- *Size*: このバリデータは各ファイルのサイズをチェックします。
  最小値と最大値を指定し、そのいずれかに違反した場合にエラーをスローします。

- *Upload*: このバリデータは内部的に使用するもので、
  アップロード時に何らかの問題が発生していないかどうかをチェックします。
  自分でこれを設定してはいけません。これは、 ``Zend_File_Transfer``
  自身が自動的に設定します。
  ですので、このバリデータのことは忘れてしまってもかまいません。
  ただ、そういうバリデータが存在することだけを覚えておきましょう。

- *WordCount*: このバリデータはファイル内の単語数をチェックします。
  最小値と最大値を指定し、そのいずれかに違反した場合にエラーをスローします。

.. _zend.file.transfer.validators.usage:

Zend_File_Transfer でのバリデータの使用法
------------------------------

バリデータの使い方はきわめて簡単です。
バリデータを追加したり操作したりするには、次のメソッドを使用します。

- ``isValid($files = null)``:
  指定したファイルがすべてのバリデータを使用したかどうかを調べます。 *$files*
  には、実際のファイル名あるいは要素名、
  またはテンポラリファイル名を指定します。

- *addValidator($validator, $breakChainOnFailure, $options = null, $files = null)*:
  指定したバリデータをバリデータスタックに追加します
  (オプションで、指定したファイルにだけ追加することもできます)。 *$validator*
  に指定するのは、 バリデータのインスタンスかあるいはバリデータの型の短い名前
  (たとえば 'Count') です。

- *addValidators(array $validators, $files = null)*:
  指定した複数のバリデータをバリデータスタックに追加します。
  各エントリは、バリデータの型とオプションのペアか あるいはキー 'validator'
  を持つ配列となります
  (配列の場合、バリデータのオプションはインスタンスの作成時に設定するものとします)。

- *setValidators(array $validators, $files = null)*:
  既存のバリデータを、指定したバリデータで上書きします。
  バリデータの指定方法は ``addValidators()`` と同じです。

- ``hasValidator($name)``: バリデータが登録されているかどうかを調べます。

- ``getValidator($name)``: 前回登録されたバリデータを返します。

- ``getValidators($files = null)``: 登録されているバリデータを返します。 *$files*
  を渡すと、そのファイルに関連するバリデータを返します。

- ``removeValidator($name)``: 前回登録されたバリデータを削除します。

- ``clearValidators()``: 登録されているすべてのバリデータを消去します。

.. _zend.file.transfer.validators.usage.example:

.. rubric:: ファイル転送用のバリデータの追加

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // ファイルサイズを 20000 バイトに設定します
   $upload->addValidator('Size', false, 20000);

   // ファイルサイズの最小値を 20 バイト、最大値を 20000 バイトに設定します
   $upload->addValidator('Size', false, array('min' => 20, 'max' => 20000));

   // ファイルサイズの最小値を 20 バイト、最大値を 20000 バイトに設定し、
   // 同時にファイルの数も設定します
   $upload->setValidators(array(
       'Size'  => array('min' => 20, 'max' => 20000),
       'Count' => array('min' => 1, 'max' => 3),
   ));

.. _zend.file.transfer.validators.usage.exampletwo:

.. rubric:: 特定のファイルに対してのみのバリデータの適用

``addValidator()``\ 、 ``addValidators()`` および ``setValidators()`` は、それぞれ最後の引数
*$files* を指定できます。
この引数にはファイル名あるいはファイル名の配列を指定し、
指定したファイルに対してのみバリデータを設定します。

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // ファイルサイズを 20000 バイトとし、それを 'file2' にのみ適用します
   $upload->addValidator('Size', false, 20000, 'file2');

一般的には、単純に ``addValidators()`` メソッドをコールすることになるでしょう。
これは何度でもコールできます。

.. _zend.file.transfer.validators.usage.examplemultiple:

.. rubric:: 複数のバリデータの追加

単に ``addValidator()`` を複数回コールするほうがシンプルに書けます。
個々のバリデータごとにコールするというわけです。
これはコードの可読性も向上させ、保守性もあがります。
すべてのメソッドは流れるようなインターフェイスを提供しているので、
複数回のコールは以下のように書くことができます。

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // ファイルサイズを 20000 バイトに設定します
   $upload->addValidator('Size', false, 20000)
          ->addValidator('Count', false, 2)
          ->addValidator('Filessize', false, 25000);

.. note::

   同じバリデータを複数回設定することもできます。 しかしそんなことをすると、
   同じバリデータに異なるオプションを設定したときにおかしなことになるので注意しましょう。

最後に、単純にファイルをチェックするには ``isValid()`` を使用します。

.. _zend.file.transfer.validators.usage.exampleisvalid:

.. rubric:: ファイルの検証

``isValid()`` には、 アップロードあるいはダウンロードされるファイル名だけでなく、
テンポラリファイル名やフォーム要素の名前を指定することもできます。
パラメータを省略したり null を指定したりした場合は、
すべてのファイルが検証対象となります。

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // ファイルサイズを 20000 バイトに設定します
   $upload->addValidator('Size', false, 20000)
          ->addValidator('Count', false, 2)
          ->addValidator('Filessize', false, 25000);

   if (!$upload->isValid()) {
       print "検証に失敗";
   }

.. note::

   ``isValid()`` は、
   ファイルを受け取った際にそれまでコールされていなければ自動的にコールされることに注意しましょう。

検証に失敗した場合は、何が問題だったのかについての情報を取得したくなることでしょう。
``getMessages()`` を使うとすべての検証メッセージを配列で取得できます。 また
``getErrors()`` はすべてのエラーコードを返し、 ``hasErrors()``
は検証エラーが見つかった時点で ``TRUE`` を返します。

.. _zend.file.transfer.validators.count:

Count バリデータ
-----------

*Count* バリデータは、 渡されたファイルの数をチェックします。
次のオプションをサポートしています。

- *min*: 転送するファイル数の最小値。

  .. note::

     このオプションを使用する場合は、
     このバリデータを最初にコールした際にファイル数の最小値を指定する必要があります。
     そうしないとエラーが返されます。

  このオプションで、受け取りたいファイル数の最小値を指定できます。

- *max*: 転送するファイル数の最大値。

  このオプションで、受け取りたいファイル数を制限できます。
  それだけでなく、フォームで定義されている以上の数のファイルを送られるなどの攻撃を防ぐこともできます。

文字列あるいは整数値を指定してインスタンス化すると、その値は *max*
とみなされます。あるいは、後から ``setMin()`` や ``setMax()``
でオプションを設定することもできますし、 ``getMin()`` や ``getMax()``
で設定内容を取得することもできます。

.. _zend.file.transfer.validators.count.example:

.. rubric:: Count バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // ファイルの数を最大 2 に制限します
   $upload->addValidator('Count', false, 2);

   // 最大でも 5 個、少なくとも 1 つのファイルが返されるよう制限します
   $upload->addValidator('Count', false, array('min' =>1, 'max' => 5));

.. note::

   このバリデータは、チェックしたファイルの数を内部に保存することに注意しましょう。
   最大値を超えたファイルはエラーを返します。

.. _zend.file.transfer.validators.crc32:

Crc32 バリデータ
-----------

*Crc32* バリデータは、転送されたファイルの中身のハッシュをチェックします。
このバリデータは、 *PHP* の hash 拡張モジュールの crc32 アルゴリズムを使用します。
次のオプションをサポートしています。

- ***: 任意のキーあるいは数値添字配列を設定します。
  この値を、検証対象のハッシュと比較します。

  異なるキーを使用して複数のハッシュを設定できます。
  すべてのキーの内容をチェックし、
  どれにも一致しなかった場合にのみ検証が失敗します。

.. _zend.file.transfer.validators.crc32.example:

.. rubric:: Crc32 バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // アップロードされたファイルのハッシュが指定したものと一致するかどうかをチェックします
   $upload->addValidator('Crc32', false, '3b3652f');

   // ふたつの異なるハッシュを指定します
   $upload->addValidator('Crc32', false, array('3b3652f', 'e612b69'));

.. _zend.file.transfer.validators.excludeextension:

ExcludeExtension バリデータ
----------------------

*ExcludeExtension* バリデータは、 渡されたファイルの拡張子をチェックします。
次のオプションをサポートしています。

- ***: 任意のキーあるいは数値添字配列を指定します。
  指定したファイルがこの拡張子を使用していないかどうかをチェックします。

- *case*: 検証時に大文字小文字を区別するかどうかを設定します。
  デフォルトでは大文字小文字を区別しません。
  このオプションはすべての拡張子に対して適用されることに注意しましょう。

このバリデータで複数の拡張子を指定するには、
カンマ区切りの文字列あるいは配列を使用します。 ``setExtension()``\ 、 ``addExtension()``
および ``getExtension()`` といったメソッドで拡張子の設定や取得が可能です。

大文字小文字を区別したチェックが有用なこともあります。
そのため、コンストラクタの 2 番目のパラメータ *$case*
を指定できるようになっています。これを ``TRUE``
に設定すると、大文字小文字を区別して拡張子を検証します。

.. _zend.file.transfer.validators.excludeextension.example:

.. rubric:: ExcludeExtension バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // 拡張子 php あるいは exe のファイルは許可しません
   $upload->addValidator('ExcludeExtension', false, 'php,exe');

   // 拡張子 php あるいは exe のファイルを許可しない設定を配列記法で行います
   $upload->addValidator('ExcludeExtension', false, array('php', 'exe'));

    // 大文字小文字を区別するチェックを行います
   $upload->addValidator('ExcludeExtension',
                         false,
                         array('php', 'exe', 'case' => true));
   $upload->addValidator('ExcludeExtension',
                         false,
                         array('php', 'exe', 'case' => true));

.. note::

   このバリデータがチェックするのはファイルの拡張子のみであることに注意しましょう。
   実際の *MIME* 型などはチェックしません。

.. _zend.file.transfer.validators.excludemimetype:

ExcludeMimeType バリデータ
---------------------

*ExcludeMimeType* バリデータは、 転送されるファイルの *MIME* 型をチェックします。
次のオプションをサポートしています。

- ***: 任意のキー、あるいは数値添字配列を指定します。 検証したい *MIME*
  型を設定します。

  このオプションで、許可したくないファイルの *MIME* 型を定義できます。

- *headerCheck*: ``TRUE`` に設定すると、 **fileInfo** あるいは **mimeMagic**
  拡張モジュールがない場合にも *HTTP*
  情報からファイルタイプをチェックします。このオプションのデフォルト値は
  ``FALSE`` です。

このバリデータで複数の *MIME* 型を指定するには、
カンマ区切りの文字列あるいは配列を使用します。 ``setMimeType()``\ 、 ``addMimeType()``
および ``getMimeType()`` といったメソッドで *MIME* 型の設定や取得が可能です。

.. _zend.file.transfer.validators.excludemimetype.example:

.. rubric:: ExcludeMimeType バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // すべてのファイルで gif 画像の MIME 型を許可しません
   $upload->addValidator('ExcludeMimeType', false, 'image/gif');

   // すべてのファイルで gif 画像および jpg 画像の MIME 型を許可しません
   $upload->addValidator('ExcludeMimeType', false, array('image/gif', 'image/jpeg');

   // すべてのファイルで画像を許可しません
   $upload->addValidator('ExcludeMimeType', false, 'image');

上の例で示したように、複数の *MIME*
型をひとつのグループとして扱うこともできます。
画像ファイルならすべて許可したいという場合は、 *MIME* 型に 'image' と指定します。
'image' 以外にも 'audio'、'video'、'text などが使用可能です。

.. note::

   *MIME* 型のグループを拒否してしまうと、意図していないものも含めて
   そのグループのすべての形式のファイルを拒否してしまうことに注意しましょう。
   たとえば 'image' を拒否したら 'image/jpeg' や 'image/vasa'
   などすべての画像形式を拒否することになります。
   すべての形式を拒否していいのかどうか不安な場合は、
   グループ指定ではなく個別の *MIME* 型を指定するようにしましょう。

.. _zend.file.transfer.validators.exists:

Exists バリデータ
------------

*Exists* バリデータは、 指定したファイルの存在をチェックします。
次のオプションをサポートしています。

- ***: 任意のキーあるいは数値添字配列を指定し、
  ファイルが指定したディレクトリに存在するかどうかをチェックします。

このバリデータで複数のディレクトリを指定するには、
カンマ区切りの文字列あるいは配列を使用します。 ``setDirectory()``\ 、 ``addDirectory()``
および ``getDirectory()`` といったメソッドでディレクトリの設定や取得が可能です。

.. _zend.file.transfer.validators.exists.example:

.. rubric:: Exists バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // temp ディレクトリをチェック対象に追加します
   $upload->addValidator('Exists', false, '\temp');

   // ふたつのディレクトリを配列記法で追加します
   $upload->addValidator('Exists',
                         false,
                         array('\home\images', '\home\uploads'));

.. note::

   このバリデータは、ファイルが存在するかどうかをすべてのディレクトリでチェックすることに注意しましょう。
   指定したディレクトリのうちのどこかひとつでもファイルが存在しなかった場合に検証が失敗します。

.. _zend.file.transfer.validators.extension:

Extension バリデータ
---------------

*Extension* バリデータは、 渡されたファイルの拡張子をチェックします。
次のオプションをサポートしています。

- ***: 任意のキーあるいは数値添字配列を設定し、
  指定したファイルがこの拡張子かどうかをチェックします。

- *case*: チェックの際に大文字小文字を区別するかどうかを設定します。
  デフォルトでは大文字小文字を区別しません。
  このオプションは、すべての拡張子に対して適用されることに注意しましょう。

このバリデータで複数の拡張子を指定するには、
カンマ区切りの文字列あるいは配列を使用します。 ``setExtension()``\ 、 ``addExtension()``
および ``getExtension()`` といったメソッドで拡張子の設定や取得が可能です。

場合によっては大文字小文字を区別してチェックしたくなることもあるでしょう。
そんなときのために、コンストラクタで 2 番目のパラメータ *$case*
を指定できます。これを ``TRUE``
にすると、大文字小文字を区別して拡張子のチェックを行います。

.. _zend.file.transfer.validators.extension.example:

.. rubric:: Extension バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // 拡張子を jpg と png のみに制限します
   $upload->addValidator('Extension', false, 'jpg,png');

   // 配列形式で、拡張子を jpg と png のみに制限します
   $upload->addValidator('Extension', false, array('jpg', 'png'));

   // 大文字小文字を区別したチェックを行います
   $upload->addValidator('Extension', false, array('mo', 'png', 'case' => true));
   if (!$upload->isValid('C:\temp\myfile.MO')) {
       print 'Not valid because MO and mo do not match with case sensitivity;
   }

.. note::

   このバリデータがチェックするのはファイルの拡張子のみであることに注意しましょう。
   実際の *MIME* 型などはチェックしません。

.. _zend.file.transfer.validators.filessize:

FilesSize バリデータ
---------------

*FilesSize* バリデータは、 すべてのファイルの合計サイズをチェックします。
次のオプションをサポートしています。

- *min*: ファイルサイズの総合計の最小値を設定します。
  このオプションで、転送されるファイルの合計サイズの最小値を指定します。

- *max*: ファイルサイズの総合計の最大値を設定します。

  このオプションで、転送されるファイルの合計サイズの最大値を指定できます。
  個別のファイルのサイズはチェックしません。

- *bytestring*: 失敗したときに返す情報を、
  人間が読みやすい形式にするかファイルサイズそのものにするかを設定します。

  このオプションで、ユーザが受け取る結果が '10864' あるいは '10MB'
  のどちらの形式になるのかを指定できます。デフォルト値は ``TRUE`` で、'10MB'
  形式となります。

文字列を指定してインスタンス化すると、その値は *max* とみなされます。 後から
``setMin()`` や ``setMax()`` でオプションを設定することもできますし、 ``getMin()`` や
``getMax()`` で設定内容を取得することもできます。

サイズの指定には SI 記法も使えます。
これは多くのオペレーティングシステムでもサポートされているものです。 **20000
bytes** と書くかわりに、 **20kB** とすることができるのです。すべての単位は、1024
単位に変換されます。 使用できる単位は *kB*\ 、 *MB*\ 、 *GB*\ 、 *TB*\ 、 *PB* および *EB*
です。先ほど説明したとおり、1kB は 1024
バイトであることに注意する必要があります。

.. _zend.file.transfer.validators.filessize.example:

.. rubric:: FilesSize バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // アップロードされるファイルサイズの合計を 40000 バイトまでに制限します
   $upload->addValidator('FilesSize', false, 40000);

   // アップロードされるファイルサイズの合計を最大 4MB、最小 10kB に制限します
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => '10kB', 'max' => '4MB'));

   // さきほどと同じですが、結果をプレーンなファイルサイズで返します
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => '10kB',
                               'max' => '4MB',
                               'bytestring' => false));

.. note::

   このバリデータは、チェックしたファイルのサイズを内部に保存することに注意しましょう。
   最大値を超えたファイルはエラーを返します。

.. _zend.file.transfer.validators.imagesize:

ImageSize バリデータ
---------------

*ImageSize* バリデータは、 画像ファイルのサイズをチェックします。
次のオプションをサポートしています。

- *minheight*: 画像の高さの最小値を設定します。

- *maxheight*: 画像の高さの最大値を設定します。

- *minwidth*: 画像の幅の最小値を設定します。

- *maxwidth*: 画像の幅の最大値を設定します。

``setImageMin()`` や ``setImageMax()`` で最小値・最大値を設定することもできますし、
``getMin()`` や ``getMax()`` で設定内容を取得することもできます。

利便性を考慮して、 ``setImageWidth()`` や ``setImageHeight()``
といったメソッドも用意されています。これは、幅や高さの最小値と最大値を設定します。
もちろん、それに対応する ``getImageWidth()`` や ``getImageHeight()`` も使用可能です。

サイズの検証をしたくない場合は、その部分に値 ``NULL`` を設定します。

.. _zend.file.transfer.validators.imagesize.example:

.. rubric:: ImageSize バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // 画像の高さを 100-200 ピクセル、幅を 40-80 ピクセルに制限します
   $upload->addValidator('ImageSize', false,
                         array('minwidth' => 40,
                               'maxwidth' => 80,
                               'minheight' => 100,
                               'maxheight' => 200)
                         );

   // 検証用の幅をリセットします
   $upload->setImageWidth(array('minwidth' => 20, 'maxwidth' => 200));

.. _zend.file.transfer.validators.iscompressed:

IsCompressed バリデータ
------------------

*IsCompressed* バリデータは、 転送されたファイルが zip や arc
のような圧縮アーカイブ形式であるかどうかをチェックします。 このバリデータは
*MimeType* バリデータを使用しており、
同じメソッドとオプションをサポートしています。
このバリデータを特定の圧縮形式のみに制限するには、 そのメソッドを使用します。

.. _zend.file.transfer.validators.iscompressed.example:

.. rubric:: IsCompressed バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // アップロードされたファイルが圧縮アーカイブであるかどうかチェックします
   $upload->addValidator('IsCompressed', false);

   // zip ファイルのみを対象とするようこのバリデータを制限します
   $upload->addValidator('IsCompressed', false, array('application/zip'));

   // よりシンプルな記法で、zip ファイルのみを対象とするようこのバリデータを制限します
   $upload->addValidator('IsCompressed', false, 'zip');

.. note::

   指定した *MIME*
   型がアーカイブ型であるかどうかのチェックは行われないことに注意しましょう。
   たとえば gif
   ファイルがこのバリデータを通過するように設定することも可能です。
   アーカイブ型かどうかのチェックには 'MimeType'
   バリデータを使用したほうが読みやすいコードとなります。

.. _zend.file.transfer.validators.isimage:

IsImage バリデータ
-------------

*IsImage* バリデータは、 転送されたファイルが gif や jpeg
のような画像ファイルであるかどうかをチェックします。 このバリデータは *MimeType*
バリデータを使用しており、 同じメソッドとオプションをサポートしています。
このバリデータを特定の画像形式のみに制限するには、 そのメソッドを使用します。

.. _zend.file.transfer.validators.isimage.example:

.. rubric:: IsImage バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // アップロードされたファイルが画像ファイルであるかどうかチェックします
   $upload->addValidator('IsImage', false);

   // gif ファイルのみを対象とするようこのバリデータを制限します
   $upload->addValidator('IsImage', false, array('application/gif'));

   // よりシンプルな記法で、gif ファイルのみを対象とするようこのバリデータを制限します
   $upload->addValidator('IsImage', false, 'jpeg');

.. note::

   指定した *MIME* 型が image
   型であるかどうかのチェックは行われないことに注意しましょう。 たとえば gif
   ファイルがこのバリデータを通過するように設定することも可能です。 image
   型かどうかのチェックには 'MimeType'
   バリデータを使用したほうが読みやすいコードとなります。

.. _zend.file.transfer.validators.hash:

Hash バリデータ
----------

*Hash* バリデータは、転送されたファイルの中身のハッシュをチェックします。
このバリデータは、 *PHP* の hash 拡張モジュールを使用します。
次のオプションをサポートしています。

- ***: 任意のキーあるいは数値添字配列を設定します。
  この値と、検証対象のハッシュとを比較します。

  配列形式で複数のハッシュを設定できます。 すべてのキーの内容をチェックし、
  どれにも一致しなかった場合にのみ検証が失敗します。

- *algorithm*: ハッシュの取得に使用するアルゴリズムを設定します。

  複数のアルゴリズムを設定するには、 ``addHash()`` メソッドを複数回コールします。

.. _zend.file.transfer.validators.hash.example:

.. rubric:: Hash バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // アップロードされたファイルのハッシュが指定したものと一致するかどうかをチェックします
   $upload->addValidator('Hash', false, '3b3652f');

   // ふたつの異なるハッシュを指定します
   $upload->addValidator('Hash', false, array('3b3652f', 'e612b69'));

   // 別のアルゴリズムでチェックを行います
   $upload->addValidator('Hash',
                         false,
                         array('315b3cd8273d44912a7',
                               'algorithm' => 'md5'));

.. note::

   このバリデータは、役 34 のハッシュアルゴリズムをサポートしています。
   よく使われるものとしては 'crc32' や 'md5' そして 'sha1' があります。
   サポートするアルゴリズムの一覧は、 `php.net`_ の `hash_algos メソッド`_
   を参照ください。

.. _zend.file.transfer.validators.md5:

Md5 バリデータ
---------

*Md5* バリデータは、転送されたファイルの中身のハッシュをチェックします。
このバリデータは、 *PHP* の hash 拡張モジュールの md5 アルゴリズムを使用します。
次のオプションをサポートしています。

- ***: 任意のキーあるいは数値添字配列を設定します。

  配列形式で複数のハッシュを設定できます。 すべてのキーの内容をチェックし、
  どれにも一致しなかった場合にのみ検証が失敗します。

.. _zend.file.transfer.validators.md5.example:

.. rubric:: Md5 バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // アップロードされたファイルのハッシュが指定したものと一致するかどうかをチェックします
   $upload->addValidator('Md5', false, '3b3652f336522365223');

   // ふたつの異なるハッシュを指定します
   $upload->addValidator('Md5',
                         false,
                         array('3b3652f336522365223',
                               'eb3365f3365ddc65365'));

.. _zend.file.transfer.validators.mimetype:

MimeType バリデータ
--------------

*MimeType* バリデータは、 転送されるファイルの *MIME* 型をチェックします。
次のオプションをサポートしています。

- ***: 任意のキーあるいは数値添字配列を指定します。 検証したい *MIME*
  型を設定します。

  許可したいファイルの *MIME* 型を定義します。

- *headerCheck*: ``TRUE`` に設定すると、 **fileInfo** あるいは **mimeMagic**
  拡張モジュールがない場合にも *HTTP*
  情報からファイルタイプをチェックします。このオプションのデフォルト値は
  ``FALSE`` です。

- *magicfile*: 使用する magicfile。

  このオプションで、使用する magicfile を定義します。
  指定しなかったり空だったりした場合は、定数 MAGIC
  を使用します。このオプションは Zend Framework 1.7.1 以降で使用可能です。

このバリデータで複数の *MIME* 型を指定するには、
カンマ区切りの文字列あるいは配列を使用します。 ``setMimeType()``\ 、 ``addMimeType()``
および ``getMimeType()`` といったメソッドで *MIME* 型の設定や取得が可能です。

fileinfo が使用する magicfile を設定するには、オプション 'magicfile' を使用します。
さらに、 ``setMagicFile()`` や ``getMagicFile()`` といったメソッドで後から magicfile
の設定や取得が可能です。 これらのメソッドは Zend Framework 1.7.1
以降で使用可能です。

.. _zend.file.transfer.validators.mimetype.example:

.. rubric:: MimeType バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // MIME 型を制限し、gif 画像のみを許可するようにします
   $upload->addValidator('MimeType', false, 'image/gif');

   // すべてのファイルが gif および jpeg 画像でなければならないように MIME 型を制限します
   $upload->addValidator('MimeType', false, array('image/gif', 'image/jpeg');

   // すべてのファイルが画像であるように MIME 型を制限します
   $upload->addValidator('MimeType', false, 'image');

   // 別の magicfile を使用します
   $upload->addValidator('MimeType',
                         false,
                         array('image',
                               'magicfile' => '/path/to/magicfile.mgx'));

上の例で示したように、複数の *MIME*
型をひとつのグループとして扱うこともできます。
画像ファイルならすべて許可したいという場合は、 *MIME* 型に 'image' と指定します。
'image' 以外にも 'audio'、'video'、'text などが使用可能です。

.. note::

   *MIME*
   型のグループを許可してしまうと、アプリケーション側で対応しているか否かにかかわらず
   そのグループのすべての形式のファイルを許可してしまうことに注意しましょう。
   たとえば 'image' を許可したら 'image/xpixmap' や 'image/vasa'
   も受け付けることになりますが、おそらくこれは問題となるでしょう。
   アプリケーション側ですべての形式を処理できるかどうか不安なら、
   グループ指定ではなく個別の *MIME* 型を指定するようにしましょう。

.. note::

   このコンポーネントは、もし *fileinfo*
   拡張モジュールが使用可能ならそれを使用します。使用できない場合は
   *mime_content_type* 関数を使用します。 この関数コールが失敗した場合は、 *HTTP*
   で渡された *MIME* 型を使用します。

   *fileinfo* も *mime_content_type*
   も使えない場合は、セキュリティの問題に注意する必要があります。 *HTTP*
   から取得する *MIME* 型はセキュアではなく、 容易に改ざんできます。

.. _zend.file.transfer.validators.notexists:

NotExists バリデータ
---------------

*NotExists* バリデータは、 指定したファイルの存在をチェックします。
次のオプションをサポートしています。

- ***: 任意のキーあるいは数値添字配列を設定し、
  ファイルが指定したディレクトリに存在しないかどうかをチェックします。

このバリデータで複数のディレクトリを指定するには、
カンマ区切りの文字列あるいは配列を使用します。 ``setDirectory()``\ 、 ``addDirectory()``
および ``getDirectory()`` といったメソッドでディレクトリの設定や取得が可能です。

.. _zend.file.transfer.validators.notexists.example:

.. rubric:: NotExists バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // temp ディレクトリをチェック対象に追加します
   $upload->addValidator('NotExists', false, '\temp');

   // ふたつのディレクトリを配列記法で追加します
   $upload->addValidator('NotExists', false,
                         array('\home\images',
                               '\home\uploads')
                        );

.. note::

   このバリデータは、ファイルが存在しないかどうかをすべてのディレクトリでチェックすることに注意しましょう。
   指定したディレクトリのうちのどこかひとつでもファイルが存在した場合に検証が失敗します。

.. _zend.file.transfer.validators.sha1:

Sha1 バリデータ
----------

*Sha1* バリデータは、転送されたファイルの中身のハッシュをチェックします。
このバリデータは、 *PHP* の hash 拡張モジュールの sha1 アルゴリズムを使用します。
次のオプションをサポートしています。

- ***: 任意のキーあるいは数値添字配列を設定します。

  配列形式で複数のハッシュを設定できます。 すべてのキーの内容をチェックし、
  どれにも一致しなかった場合にのみ検証が失敗します。

.. _zend.file.transfer.validators.sha1.example:

.. rubric:: sha1 バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // アップロードされたファイルのハッシュが指定したものと一致するかどうかをチェックします
   $upload->addValidator('sha1', false, '3b3652f336522365223');

   // ふたつの異なるハッシュを指定します
   $upload->addValidator('Sha1',
                         false, array('3b3652f336522365223',
                                      'eb3365f3365ddc65365'));

.. _zend.file.transfer.validators.size:

Size バリデータ
----------

*Size* バリデータは、 個々のファイルのサイズをチェックします。
次のオプションをサポートしています。

- *Min*: ファイルサイズの最小値を設定します。

  このオプションで、転送されるファイルの個々のサイズの最小値を指定できます。

- *Max*: ファイルサイズの最大値を設定します。

  このオプションで、転送されるファイルの個々のサイズを制限できます。

- *bytestring*: 失敗したときに返す情報を、
  人間が読みやすい形式にするかファイルサイズそのものにするかを設定します。

  このオプションで、ユーザが受け取る結果が '10864' あるいは '10MB'
  のどちらの形式になるのかを指定できます。デフォルト値は ``TRUE`` で、'10MB'
  形式となります。

文字列を指定してインスタンス化すると、その値は *max*
とみなされます。あるいは、後から ``setMin()`` や ``setMax()``
でオプションを設定することもできますし、 ``getMin()`` や ``getMax()``
で設定内容を取得することもできます。

サイズの指定には SI 記法も使えます。
これは多くのオペレーティングシステムでもサポートされているものです。 **20000
bytes** と書くかわりに、 **20kB** とすることができるのです。すべての単位は、1024
単位に変換されます。 使用できる単位は *kB*\ 、 *MB*\ 、 *GB*\ 、 *TB*\ 、 *PB* および *EB*
です。先ほど説明したとおり、1kB は 1024
バイトであることに注意する必要があります。

.. _zend.file.transfer.validators.size.example:

.. rubric:: Size バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // ファイルサイズを 40000 バイトまでに制限します
   $upload->addValidator('Size', false, 40000);

   // 指定したファイルのサイズを最大 4MB、最小 10kB に制限し、
   // さらにエラー時に返す結果をユーザに優しい形式ではなく
   // プレーンな数値とします
   $upload->addValidator('Size',
                         false,
                         array('min' => '10kB',
                               'max' => '4MB',
                               'bytestring' => false));

.. _zend.file.transfer.validators.wordcount:

WordCount バリデータ
---------------

*WordCount* バリデータは、 指定したファイル内の単語数をチェックします。
次のオプションをサポートしています。

- *min*: 見つかった単語数の最小値を設定します。

- *max*: 見つかった単語数の最大値を設定します。

文字列あるいは整数値を指定してインスタンス化すると、その値は *max*
とみなされます。あるいは、後から ``setMin()`` や ``setMax()``
でオプションを設定することもできますし、 ``getMin()`` や ``getMax()``
で設定内容を取得することもできます。

.. _zend.file.transfer.validators.wordcount.example:

.. rubric:: WordCount バリデータの使用法

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // ファイル内の単語数を 2000 語までに制限します
   $upload->addValidator('WordCount', false, 2000);

   // ファイル内の単語数を最大 5000 語、最小 1000 語に制限します
   $upload->addValidator('WordCount', false, array('min' => 1000, 'max' => 5000));



.. _`php.net`: http://php.net
.. _`hash_algos メソッド`: http://php.net/hash_algos
