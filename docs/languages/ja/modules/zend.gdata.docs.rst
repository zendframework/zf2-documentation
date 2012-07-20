.. _zend.gdata.docs:

Google Documents List Data API の使用法
===================================

Google Documents List Data *API* は、 クライアントアプリケーションから Google Documents
にドキュメントをアップロードしたり、 ドキュメントの一覧を Google Data *API* ("GData")
形式のフィードで取得したりするためのものです。
クライアントアプリケーションからユーザのドキュメントの一覧をリクエストしたり、
ドキュメントの中身を問い合わせたりできます。

Google Documents List *API* についての詳細は `http://code.google.com/apis/documents/overview.html`_
を参照ください。

.. _zend.gdata.docs.listdocuments:

ドキュメントの一覧の取得
------------

特定のユーザの Google Documents の一覧を取得するには、docs サービスの
``getDocumentListFeed`` メソッドを使用します。 このサービスは
``Zend_Gdata_Docs_DocumentListFeed`` オブジェクトを返します。
その中には、認証済みユーザに関連付けられたドキュメントの一覧が含まれます。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Docs::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $docs = new Zend_Gdata_Docs($client);
   $feed = $docs->getDocumentListFeed();

結果として得られる ``Zend_Gdata_Docs_DocumentListFeed``
オブジェクトが、サーバからの応答を表します。 このフィードには
``Zend_Gdata_Docs_DocumentListEntry`` オブジェクトの一覧 (``$feed->entries``) が含まれ、
それぞれがひとつの Google Document を表します。

.. _zend.gdata.docs.creating:

ドキュメントのアップロード
-------------

新しい Google Document を作成するには、
ワープロ文書やスプレッドシート、あるいはプレゼンテーションをアップロードします。
この例はインタラクティブなサンプル Docs.php
で、これはライブラリに同梱されています。
これは、ファイルをアップロードした後で、
サーバからその結果の情報を取得して表示するものです。

.. code-block:: php
   :linenos:

   /**
    * Upload the specified document
    *
    * @param Zend_Gdata_Docs $docs The service object to use for communicating
    *     with the Google Documents server.
    * @param boolean $html True if output should be formatted for display in a
    *     web browser.
    * @param string $originalFileName The name of the file to be uploaded. The
    *     MIME type of the file is determined from the extension on this file
    *     name. For example, test.csv is uploaded as a comma separated volume
    *     and converted into a spreadsheet.
    * @param string $temporaryFileLocation (optional) The file in which the
    *     data for the document is stored. This is used when the file has been
    *     uploaded from the client's machine to the server and is stored in
    *     a temporary file which does not have an extension. If this parameter
    *     is null, the file is read from the originalFileName.
    */
   function uploadDocument($docs, $html, $originalFileName,
                           $temporaryFileLocation) {
     $fileToUpload = $originalFileName;
     if ($temporaryFileLocation) {
       $fileToUpload = $temporaryFileLocation;
     }

     // Upload the file and convert it into a Google Document. The original
     // file name is used as the title of the document and the MIME type
     // is determined based on the extension on the original file name.
     $newDocumentEntry = $docs->uploadFile($fileToUpload, $originalFileName,
         null, Zend_Gdata_Docs::DOCUMENTS_LIST_FEED_URI);

     echo "New Document Title: ";

     if ($html) {
         // Find the URL of the HTML view of this document.
         $alternateLink = '';
         foreach ($newDocumentEntry->link as $link) {
             if ($link->getRel() === 'alternate') {
                 $alternateLink = $link->getHref();
             }
         }
         // Make the title link to the document on docs.google.com.
         echo "<a href=\"$alternateLink\">\n";
     }
     echo $newDocumentEntry->title."\n";
     if ($html) {echo "</a>\n";}
   }

.. _zend.gdata.docs.queries:

ドキュメントのフィードの検索
--------------

ドキュメントの一覧を検索するには、 `標準的な Google Data API クエリパラメータ`_
を使用します。 カテゴリを使用して、ドキュメントの種類 (ワープロ文書、
スプレッドシート) を絞り込みます。
フルテキストのクエリ文字列を使用して、ドキュメントの全文検索を行います。
ドキュメントの一覧に固有のパラメータについての詳細な情報は、 `Documents List Data API
リファレンスガイド`_ を参照ください。

.. _zend.gdata.docs.listwpdocuments:

ワープロ文書の一覧の取得
^^^^^^^^^^^^

指定した型のすべてのドキュメントを含むフィードを取得することもできます。
たとえば、ワープロ文書の一覧を取得するには、
次のようなカテゴリクエリを使用します。

.. code-block:: php
   :linenos:

   $feed = $docs->getDocumentListFeed(
       'http://docs.google.com/feeds/documents/private/full/-/document');
.. _zend.gdata.docs.listspreadsheets:

スプレッドシートの一覧の取得
^^^^^^^^^^^^^^

Google Spreadsheets の一覧を取得するには、 次のようなカテゴリクエリを使用します。

.. code-block:: php
   :linenos:

   $feed = $docs->getDocumentListFeed(
       'http://docs.google.com/feeds/documents/private/full/-/spreadsheet');
.. _zend.gdata.docs.textquery:

テキストクエリの実行
^^^^^^^^^^

ドキュメントの中身を検索するには、リクエスト内で ``Zend_Gdata_Docs_Query``
を使用します。 クエリオブジェクトを使用してクエリ *URI* を組み立て、
検索する単語をパラメータとして渡します。
これは、ある文字列を含むドキュメントを一覧から探すクエリの例です。

.. code-block:: php
   :linenos:

   $docsQuery = new Zend_Gdata_Docs_Query();
   $docsQuery->setQuery($query);
   $feed = $client->getDocumentListFeed($docsQuery);


.. _`http://code.google.com/apis/documents/overview.html`: http://code.google.com/apis/documents/overview.html
.. _`標準的な Google Data API クエリパラメータ`: http://code.google.com/apis/gdata/reference.html#Queries
.. _`Documents List Data API リファレンスガイド`: http://code.google.com/apis/documents/reference.html#Parameters
