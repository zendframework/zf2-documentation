.. EN-Revision: none
.. _zend.gdata.spreadsheets:

Google Spreadsheets の使用法
========================

Google Spreadsheets データ *API* を使用すると、 スプレッドシートの中身を Google データ
*API* フィード形式で閲覧したり それを更新したりすることができるようになります。
あるユーザのスプレッドシートの一覧を取得したり、
既存のスプレッドシートのワークシートを編集・削除したり、
ワークシートの中身を問い合わせたりといったことも可能です。

Google Spreadsheets *API* についての詳細な情報は
`http://code.google.com/apis/spreadsheets/overview.html`_ を参照ください。

.. _zend.gdata.spreadsheets.creating:

スプレッドシートの作成
-----------

Spreadsheets データ *API* は、現在はプログラム上でのスプレッドシートの
作成・削除はサポートしていません。

.. _zend.gdata.spreadsheets.listspreadsheets:

スプレッドシートの一覧の取得
--------------

特定のユーザのスプレッドシートの一覧を取得するには Spredsheets サービスの
*getSpreadsheetFeed* メソッドを使用します。 このサービスが返す
``Zend_Gdata_Spreadsheets_SpreadsheetFeed``
オブジェクトに、認証済みユーザのスプレッドシート一覧が格納されます。

.. code-block:: php
   :linenos:

   $service = Zend_Gdata_Spreadsheets::AUTH_SERVICE_NAME;
   $client = Zend_Gdata_ClientLogin::getHttpClient($user, $pass, $service);
   $spreadsheetService = new Zend_Gdata_Spreadsheets($client);
   $feed = $spreadsheetService->getSpreadsheetFeed();

.. _zend.gdata.spreadsheets.listworksheets:

ワークシートの一覧の取得
------------

ひとつのスプレッドシートの中には複数のワークシートがあります。
各スプレッドシートは、その内部のすべてのワークシートをあらわすメタフィード含んでいます。

スプレッドシートのキー (すでに取得済みの ``Zend_Gdata_Spreadsheets_SpreadsheetEntry``
オブジェクトの <id>)
を指定すると、そのスプレッドシートのワークシート一覧を含むフィードを取得できます。

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_DocumentQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $feed = $spreadsheetService->getWorksheetFeed($query);

この結果である ``Zend_Gdata_Spreadsheets_WorksheetFeed``
オブジェクトは、サーバからのレスポンスを表します。
その他の場合と同じように、このフィードには ``Zend_Gdata_Spreadsheets_WorksheetEntry``
オブジェクト (*$feed->entries*) の一覧が含まれます。
個々のオブジェクトがひとつのワークシートを表します。

.. _zend.gdata.spreadsheets.listfeeds:

リストベースのフィードの扱い
--------------

ワークシートには通常複数の行が含まれ、各行には複数のセルが存在します。
ワークシートのデータを取得するには、リストベースのフィード
(各エントリがひとつの行を表す) かあるいはセルベースのフィード
(各エントリがひとつのセルを表す) を使用します。
セルベースのフィードについては、 「 :ref:`セルベースのフィードの扱い
<zend.gdata.spreadsheets.cellfeeds>`\ 」 を参照ください。

以下の節では、リストベースのフィードを取得して行を追加し、
さまざまなパラメータを指定してクエリを送信する方法を説明します。

リストフィードでは、スプレッドシート内のデータについていくつかの前提条件があります。

リストフィードでは、ワークシートの最初の行をヘッダ行として扱います。 Spreadsheets
は、ヘッダ行のセルの名前をもとにして *XML* 要素を動的に作成します。 Gdata
フィードを提供したいユーザは、
ワークシートの一行目にカラムヘッダ以外を書いてはいけません。

リストフィードには、先頭行の次の行から最初に空行が現れるまでのすべての行が含まれます。
空行が登場した時点でデータセットが終了します。
期待通りのデータがフィードに含まれていない場合は、
ワークシートの内容を確認して途中に空行がないかどうかを見てみましょう。
特に、二行目が空行だったりするとリストフィードには一切データが含まれなくなります。

リストフィードの行は、そのワークシートが持っているのと同じだけのカラムを保持します。

.. _zend.gdata.spreadsheets.listfeeds.get:

リストベースのフィードの取得
^^^^^^^^^^^^^^

ワークシートのリストフィードを取得するには、Spreadsheets サービスの *getListFeed*
メソッドを使用します。

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_ListQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $listFeed = $spreadsheetService->getListFeed($query);

その結果得られた ``Zend_Gdata_Spreadsheets_ListFeed`` オブジェクトである ``$listfeed``
が、サーバからのレスポンスを表します。 またこのフィードは
``Zend_Gdata_Spreadsheets_ListEntry`` オブジェクトの配列 (*$listFeed->entries*)
を含んでおり、この配列の各要素がワークシートのひとつの行を表します。

各 ``Zend_Gdata_Spreadsheets_ListEntry`` には配列 *custom*
が含まれ、これがその行のデータを保持します。
この配列の内容を取り出して表示するには次のようにします。

.. code-block:: php
   :linenos:

   $rowData = $listFeed->entries[1]->getCustom();
   foreach($rowData as $customEntry) {
     echo $customEntry->getColumnName() . " = " . $customEntry->getText();
   }

もうひとつの配列である *customByName*
を使用すると、エントリのセルに対して名前を指定して直接アクセスできるようになります。
これは、特定のヘッダにアクセスしたい場合などに便利です。

.. code-block:: php
   :linenos:

   $customEntry = $listFeed->entries[1]->getCustomByName('my_heading');
   echo $customEntry->getColumnName() . " = " . $customEntry->getText();

.. _zend.gdata.spreadsheets.listfeeds.reverse:

逆順での行の並べ替え
^^^^^^^^^^

デフォルトでは、フィード内の行の並び順は GUI
で見たときの行の並び順と同じです。つまり行番号順ということです。
行を逆順で取得するには、 ``Zend_Gdata_Spreadsheets_ListQuery`` オブジェクトの reverse
プロパティを ``TRUE`` に設定します。

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_ListQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $query->setReverse('true');
   $listFeed = $spreadsheetService->getListFeed($query);

もしワークシート内での位置ではなく特定のカラムの値で (あるいはその逆順で)
並べ替えたい場合は、 ``Zend_Gdata_Spreadsheets_ListQuery`` オブジェクトの *orderby* の値を
*column:<そのカラムのヘッダ>* とします。

.. _zend.gdata.spreadsheets.listfeeds.sq:

構造化問い合わせ
^^^^^^^^

``Zend_Gdata_Spreadsheets_ListQuery`` の *sq* を設定することで、
指定した条件を満たすエントリだけのフィードを得ることができます。
たとえば、個人データを記録したワークシートがあるとしましょう。
ひとつの行に一人のデータが記録されています。 この中から名前が "John" で年齢が 25
才より大きい人のデータだけを抜き出したい場合は、 次のように *sq* を設定します。

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_ListQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $query->setSpreadsheetQuery('name=John and age>25');
   $listFeed = $spreadsheetService->getListFeed($query);

.. _zend.gdata.spreadsheets.listfeeds.addrow:

行の追加
^^^^

スプレッドシートに行を追加するには、Spreadsheet サービスの *insertRow*
メソッドを使用します。

.. code-block:: php
   :linenos:

   $insertedListEntry = $spreadsheetService->insertRow($rowData,
                                                       $spreadsheetKey,
                                                       $worksheetId);

``$rowData`` パラメータには、 カラムのキーとその値を関連付けた配列を指定します。
このメソッドは、追加した行に対応する ``Zend_Gdata_Spreadsheets_SpreadsheetsEntry``
オブジェクトを返します。

Spreadsheets
は、リストベースのフィードの一番最後の行の直後に新しい行を追加します。
つまり、最初に登場する空行の直前ということです。

.. _zend.gdata.spreadsheets.listfeeds.editrow:

行の編集
^^^^

``Zend_Gdata_Spreadsheets_ListEntry`` オブジェクトを取得したら、Spreadsheet サービスの
*updateRow* メソッドを使用してその中身を更新できます。

.. code-block:: php
   :linenos:

   $updatedListEntry = $spreadsheetService->updateRow($oldListEntry,
                                                      $newRowData);

``$oldListEntry`` パラメータには、更新するエントリを指定します。 ``$newRowData``
はカラムのキーと値を関連付けた配列です。
これを新しいデータとして使用します。このメソッドは、更新した行に対応する
``Zend_Gdata_Spreadsheets_SpreadsheetsEntry`` オブジェクトを返します。

.. _zend.gdata.spreadsheets.listfeeds.deleterow:

行の削除
^^^^

行を削除するには、単に ``Zend_Gdata_Spreadsheets`` オブジェクトの *deleteRow*
メソッドをコールするだけです。 削除したい既存のエントリを指定します。

.. code-block:: php
   :linenos:

   $spreadsheetService->deleteRow($listEntry);

あるいは、そのエントリ自身の *delete* メソッドをコールするという手もあります。

.. code-block:: php
   :linenos:

   $listEntry->delete();

.. _zend.gdata.spreadsheets.cellfeeds:

セルベースのフィードの扱い
-------------

セルベースのフィードでは、各エントリがひとつのセルを表します。

ひとつのワークシートで
セルベースのフィードとリストベースのフィードを同時に使用するのはやめておきましょう。

.. _zend.gdata.spreadsheets.cellfeeds.get:

セルベースのフィードの取得
^^^^^^^^^^^^^

ワークシートのセルフィードを取得するには、Spreadsheets サービスの *getCellFeed*
メソッドを使用します。

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_CellQuery();
   $query->setSpreadsheetKey($spreadsheetKey);
   $query->setWorksheetId($worksheetId);
   $cellFeed = $spreadsheetService->getCellFeed($query);

その結果得られた ``Zend_Gdata_Spreadsheets_CellFeed`` オブジェクトである ``$cellFeed``
が、サーバからのレスポンスを表します。 またこのフィードは
``Zend_Gdata_Spreadsheets_CellEntry`` オブジェクトの配列 (*$cellFeed>entries*)
を含んでおり、この配列の各要素がワークシートのひとつのセルを表します。
この情報を表示するには次のようにします。

.. code-block:: php
   :linenos:

   foreach($cellFeed as $cellEntry) {
     $row = $cellEntry->cell->getRow();
     $col = $cellEntry->cell->getColumn();
     $val = $cellEntry->cell->getText();
     echo "$row, $col = $val\n";
   }

.. _zend.gdata.spreadsheets.cellfeeds.cellrangequery:

セルの範囲の問い合わせ
^^^^^^^^^^^

ワークシートの最初のカラムのセルを取得したいとしましょう。
次のようにすると、最初のカラムだけを含むセルフィードを取得できます。

.. code-block:: php
   :linenos:

   $query = new Zend_Gdata_Spreadsheets_CellQuery();
   $query->setMinCol(1);
   $query->setMaxCol(1);
   $query->setMinRow(2);
   $feed = $spreadsheetService->getCellsFeed($query);

これは、二行目以降のデータの最初のカラムのみのデータを返します。

.. _zend.gdata.spreadsheets.cellfeeds.updatecell:

セルの内容の変更
^^^^^^^^

セルの内容を変更するには、 行、カラム、そして新しい値を指定して *updateCell*
をコールします。

.. code-block:: php
   :linenos:

   $updatedCell = $spreadsheetService->updateCell($row,
                                                  $col,
                                                  $inputValue,
                                                  $spreadsheetKey,
                                                  $worksheetId);

新しいデータが、ワークシートの指定した位置に配置されます。
指定したセルに既にデータが存在する場合は、上書きされます。 注意: *updateCell*
を使用すると、 もともとそのセルが空であった場合もデータを更新します。



.. _`http://code.google.com/apis/spreadsheets/overview.html`: http://code.google.com/apis/spreadsheets/overview.html
