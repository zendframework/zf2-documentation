.. _zend.service.nirvanix:

Zend_Service_Nirvanix
=====================

.. _zend.service.nirvanix.introduction:

導入
--

Nirvanix は Internet Media File System (*IMFS*)
です。インターネット上のストレージサービスに対して
ファイルをアップロードして保存し、ファイルを管理します。
また、標準的なウェブサービスインターフェイスでファイルにアクセスできます。
*IMFS* はクラスタ形式のファイルシステムで、インターネット越しにアクセスします。
また、メディアファイル (音声や動画など) に最適化されています。 *IMFS*
の目標は、ますます増えていくメディアストレージに対応する
スケーラビリティを提供すること、
そしていつでもどこでもそこにアクセスできることを保証することです。 最後に、
*IMFS* を使用すればアプリケーションからデータに対して
セキュアにアクセスできるようになります。また、
物理的なストレージを確保したり保守したりするためのコストも回避できます。

.. _zend.service.nirvanix.registering:

Nirvanix への登録
-------------

``Zend_Service_Nirvanix`` を使う前に、
まずアカウントを取得する必要があります。詳細な情報は、 Nirvanix
のウェブサイトにある `Getting Started`_ を参照ください。

登録を済ませると、ユーザ名とパスワードそしてアプリケーションキーが得られます。
``Zend_Service_Nirvanix`` を使うには、 これらすべてが必要となります。

.. _zend.service.nirvanix.apiDocumentation:

API ドキュメント
----------

Nirvanix *IMFS* へのアクセス方法には、 *SOAP* を使用する方法と (より高速な) REST
サービスを使用する方法があります。 ``Zend_Service_Nirvanix`` は、REST
サービスに対する比較的軽量な *PHP* 5 ラッパーを提供します。

``Zend_Service_Nirvanix`` の狙いは Nirvanix REST
サービスをより簡単に使用できるようにすることですが、 Nirvanix
サービス自体についてきちんと理解しておくことも大切です。

`Nirvanix API Documentation`_
に、このサービスについての概要から詳細な情報までがまとめられています。
このドキュメントを熟読し、 ``Zend_Service_Nirvanix``
を使う際にも常に参照するようにしましょう。

.. _zend.service.nirvanix.features:

機能
--

Nirvanix の REST サービスは、 *PHP* の `SimpleXML`_ 拡張モジュールと ``Zend_Http_Client``
を使うだけでもうまく操作できます。しかしこの方法だと、
リクエスト時にセッショントークンを毎回渡したり、
レスポンスの内容を確認してエラーコードを調べたりといった繰り返し処理が面倒です。

``Zend_Service_Nirvanix`` には次のような機能があります。



   - Nirvanix の認証情報を一元管理し、 Nirvanix 名前空間内で使いまわします。

   - HTTP
     クライアントをそのまま使うよりもより便利なプロキシオブジェクトを用意し、
     REST サービスへのアクセス時に毎回 HTTP POST
     リクエストを手で作成させるような手間を省きます。

   - レスポンスオブジェクトのラッパーを用意し、
     レスポンスをパースしてエラー時には例外をスローするようにします。
     これにより、コマンドが成功したかどうかを調べるような
     面倒くさい処理を軽減させることができます。

   - ありがちな操作を行うための、便利なメソッドを提供します。



.. _zend.service.nirvanix.storing-your-first:

さぁはじめましょう
---------

Nirvanix への登録をすませたら、 *IMFS* 上にファイルを格納する準備は完了です。 *IMFS*
上で必要となる作業として最もよくあるものは、
新規ファイルの作成や既存ファイルのダウンロード、
そしてファイルの削除といったところでしょう。 ``Zend_Service_Nirvanix`` には、これら 3
つの操作のための便利なメソッドが用意されています。

.. code-block:: php
   :linenos:

   $auth = array('username' => 'your-username',
                 'password' => 'your-password',
                 'appKey'   => 'your-app-key');

   $nirvanix = new Zend_Service_Nirvanix($auth);
   $imfs = $nirvanix->getService('IMFS');

   $imfs->putContents('/foo.txt', 'contents to store');

   echo $imfs->getContents('/foo.txt');

   $imfs->unlink('/foo.txt');

``Zend_Service_Nirvanix``
を利用する際の最初の手続きは常に、サービスに対する認証となります。
これは、認証情報を上のように ``Zend_Service_Nirvanix``
のコンストラクタに渡すことで行います。 連想配列の内容が、Nirvanix に対する POST
パラメータとして直接渡されます。

Nirvanix は、ウェブサービスを `名前空間`_
で区別しています。個々の名前空間が、関連する操作群をカプセル化しています。
``Zend_Service_Nirvanix`` のインスタンスを取得したら、 ``getService()``
メソッドをコールして 使いたい名前空間へのプロキシを作成します。 上の例では、
*IMFS* 名前空間へのプロキシを作成しています。

使いたい名前空間へのプロキシを取得したら、そのメソッドをコールします。
プロキシ上では、REST *API* の任意のコマンドを使用できます。
また、プロキシにはウェブサービスのコマンドをラップする便利なメソッドも用意されています。
上の例では、 *IMFS* の便利なメソッドを使用して新規ファイルを作成し、
それを取得して表示し、最後にファイルを削除しています。

.. _zend.service.nirvanix.understanding-proxy:

プロキシについて
--------

先ほどの理恵では、 ``getService()`` メソッドを使用して *IMFS*
名前空間へのプロキシオブジェクトを取得しました。
このプロキシオブジェクトを使用すると、Nirvanix の REST サービスを通常の *PHP*
のメソッドコールと同じ方式で行うことができます。 自分で HTTP
リクエストオブジェクトを作成する方式ではこのようにはいきません。

プロキシオブジェクトには、その他の便利なメソッドも用意されています。
``Zend_Service_Nirvanix`` が用意するこれらのメソッドを使用すれば、 Nirvanix
ウェブサービスをよりシンプルに使用できます。 先ほどの例では ``putContents()`` や
``getContents()``\ 、 そして ``unlink()`` といったメソッドを使用していますが、 REST *API*
にはこれらに直接対応するものは存在しません。 これらのメソッドは
``Zend_Service_Nirvanix`` が提供しているもので、REST *API*
上でのより複雑な操作を抽象化したものです。

プロキシオブジェクトに対するその他のすべてのメソッドコールは、
プロキシによって動的に変換され、同等の REST *API* に対する HTTP POST
リクエストとなります。 これは、メソッド名を *API* のコマンドとして使用し、
最初の引数に渡した連想配列を POST パラメータとして使用します。

たとえば、REST *API* のメソッド `RenameFile`_
をコールすることを考えてみましょう。このメソッドに対応する便利なメソッドは
``Zend_Service_Nirvanix`` には用意されていません。

.. code-block:: php
   :linenos:

   $auth = array('username' => 'your-username',
                 'password' => 'your-password',
                 'appKey'   => 'your-app-key');

   $nirvanix = new Zend_Service_Nirvanix($auth);
   $imfs = $nirvanix->getService('IMFS');

   $result = $imfs->renameFile(array('filePath' => '/path/to/foo.txt',
                                     'newFileName' => 'bar.txt'));

上の例では、 *IMFS* 名前空間へのプロキシを作成します。 そして、プロキシ上で
``renameFile()`` メソッドをコールします。 このメソッドは *PHP*
のコード上では定義されていないので、 ``__call()`` に渡されます。 そして、REST *API*
に対する POST リクエストに変換され、 連想配列を POST パラメータとして使用します。

Nirvanix の *API* ドキュメントには、このメソッドには *sessionToken*
が必須であるとかかれていますが、プロキシオブジェクトにこれを渡していません。
これは、利便性を考慮して自動的に付加されるようになっています。

この操作の結果は ``Zend_Service_Nirvanix_Response`` オブジェクトで返されます。これは
Nirvanix が返す XML をラップしたものです。エラーが発生した場合は
``Zend_Service_Nirvanix_Exception`` を返します。

.. _zend.service.nirvanix.examining-results:

結果の吟味
-----

Nirvanix の REST *API* は、常に結果を XML で返します。 ``Zend_Service_Nirvanix`` は、この XML を
*SimpleXML* 拡張モジュールでパースして、 結果として得られた *SimpleXMLElement* を
``Zend_Service_Nirvanix_Response`` オブジェクトに変換します。

サービスから返された結果の内容を調べるいちばん簡単な方法は、 *PHP*
の組み込み関数である ``print_r()`` などを使用することです。

.. code-block:: php
   :linenos:

   <?php
   $auth = array('username' => 'your-username',
                 'password' => 'your-password',
                 'appKey'   => 'your-app-key');

   $nirvanix = new Zend_Service_Nirvanix($auth);
   $imfs = $nirvanix->getService('IMFS');

   $result = $imfs->putContents('/foo.txt', 'fourteen bytes');
   print_r($result);
   ?>

   Zend_Service_Nirvanix_Response Object
   (
       [_sxml:protected] => SimpleXMLElement Object
           (
               [ResponseCode] => 0
               [FilesUploaded] => 1
               [BytesUploaded] => 14
           )
   )

*SimpleXMLElement* の任意のプロパティやメソッドにアクセスできます。 上の例では、
*$result->BytesUploaded* を使用して 取得したバイト数を調べています。 *SimpleXMLElement*
に直接アクセスしたい場合は *$result->getSxml()* を使用します。

Nirvanix からの帰り値のほとんどは、成功を表すもの (*ResponseCode* がゼロ) です。通常は
*ResponseCode* をチェックする必要はありません。
というのも、結果がゼロ以外になる場合は ``Zend_Service_Nirvanix_Exception``
がスローされるからです。 エラー処理については次のセクションを参照ください。

.. _zend.service.nirvanix.handling-errors:

エラー処理
-----

Nirvanix を使用する際には、 サービスからエラーが返されることも想定して
適切にエラー処理を行うようにすることが大切です。

REST サービスに対するすべて操作の結果は XML で返され、 その中には *ResponseCode*
要素が含まれています。 たとえば次のようになります。

.. code-block:: xml
   :linenos:

   <Response>
      <ResponseCode>0</ResponseCode>
   </Response>

上の例のように *ResponseCode* がゼロの場合は、
その操作が成功したことを表します。操作が成功しなかった場合は *ResponseCode*
がゼロ以外の値となり、さらに *ErrorMessage* 要素が含まれるようになります。

*ResponseCode* がゼロでないかどうかを 毎回チェックするのは手間がかかるので、
``Zend_Service_Nirvanix`` は自動的に Nirvanix が返す各レスポンスの内容をチェックします。
*ResponseCode* がエラーを表す値であった場合は ``Zend_Service_Nirvanix_Exception``
がスローされます。

.. code-block:: xml
   :linenos:

   $auth = array('username' => 'your-username',
                 'password' => 'your-password',
                 'appKey'   => 'your-app-key');
   $nirvanix = new Zend_Service_Nirvanix($auth);

   try {

     $imfs = $nirvanix->getService('IMFS');
     $imfs->unlink('/a-nonexistant-path');

   } catch (Zend_Service_Nirvanix_Exception $e) {
     echo $e->getMessage() . "\n";
     echo $e->getCode();
   }

上の例で使用している ``unlink()`` は、REST *API* の *DeleteFiles*
コマンドをラップした便利なメソッドです。 `DeleteFiles`_ コマンドが要求する The
*filePath* パラメータに、 存在しないパスを指定しています。その結果、
``Zend_Service_Nirvanix`` からは例外がスローされます。 メッセージは "Invalid
path"、そしてコードは 70005 となります。

`Nirvanix API ドキュメント`_ に、各コマンドに関連するエラーが説明されています。
必要に応じて、各コマンドを *try* ブロックでラップするようにしましょう。
あるいは複数のコマンドをひとつの *try* ブロックにまとめてもかまいません。



.. _`Getting Started`: http://www.nirvanix.com/gettingStarted.aspx
.. _`Nirvanix API Documentation`: http://developer.nirvanix.com/sitefiles/1000/API.html
.. _`SimpleXML`: http://www.php.net/simplexml
.. _`名前空間`: http://developer.nirvanix.com/sitefiles/1000/API.html#_Toc175999879
.. _`RenameFile`: http://developer.nirvanix.com/sitefiles/1000/API.html#_Toc175999923
.. _`DeleteFiles`: http://developer.nirvanix.com/sitefiles/1000/API.html#_Toc175999918
.. _`Nirvanix API ドキュメント`: http://developer.nirvanix.com/sitefiles/1000/API.html
