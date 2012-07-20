.. _zend.db.table.relationships:

導入
==

.. _zend.db.table.relationships.introduction:

導入
--

リレーショナルデータベースでは、テーブル間の関連 (リレーション)
が設定されています。 あるテーブル内のエンティティが、
データベーススキーマで定義されている参照整合性制約を使用して
他のエンティティとリンクしているのです。

``Zend_Db_Table_Row`` クラスは、他のテーブルの
関連する行を問い合わせるためのメソッドを持っています。

.. _zend.db.table.relationships.defining:

リレーションの定義
---------

抽象クラス ``Zend_Db_Table_Abstract`` を継承して、各テーブル用のクラスを作成します。
詳細は :ref:` <zend.db.table.defining>` を参照ください。
また、以下のコードで使用しているデータベースの構成については :ref:`
<zend.db.adapter.example-database>` を参照ください。

以下に、これらのテーブルに対応する *PHP* クラス定義を示します。

.. code-block:: php
   :linenos:

   class Accounts extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'accounts';
       protected $_dependentTables = array('Bugs');
   }

   class Products extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'products';
       protected $_dependentTables = array('BugsProducts');
   }

   class Bugs extends Zend_Db_Table_Abstract
   {
       protected $_name            = 'bugs';

       protected $_dependentTables = array('BugsProducts');

       protected $_referenceMap    = array(
           'Reporter' => array(
               'columns'           => 'reported_by',
               'refTableClass'     => 'Accounts',
               'refColumns'        => 'account_name'
           ),
           'Engineer' => array(
               'columns'           => 'assigned_to',
               'refTableClass'     => 'Accounts',
               'refColumns'        => 'account_name'
           ),
           'Verifier' => array(
               'columns'           => array('verified_by'),
               'refTableClass'     => 'Accounts',
               'refColumns'        => array('account_name')
           )
       );
   }

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       protected $_name = 'bugs_products';

       protected $_referenceMap    = array(
           'Bug' => array(
               'columns'           => array('bug_id'),
               'refTableClass'     => 'Bugs',
               'refColumns'        => array('bug_id')
           ),
           'Product' => array(
               'columns'           => array('product_id'),
               'refTableClass'     => 'Products',
               'refColumns'        => array('product_id')
           )
       );

   }

``Zend_Db_Table`` で UPDATE や DELETE の連鎖操作をエミュレートする場合は、 配列
``$_dependentTables`` を親テーブルで宣言し、
従属しているテーブルをそこで指定します。 *SQL*
でのテーブル名ではなく、クラス名を使用するようにしましょう。

.. note::

   *RDBMS* サーバが実装している参照整合性制約によって連鎖操作を行う場合は、
   ``$_dependentTables`` を宣言しません。 詳細は :ref:` <zend.db.table.relationships.cascading>`
   を参照ください。

各従属テーブルのクラス内で、配列 ``$_referenceMap`` を宣言します。これは、参照の
"ルール" を定義する連想配列となります。
参照ルールとは、リレーションの親テーブルが何になるのか、
従属テーブルのどのカラムと親テーブルのどのカラムが対応するのかを示すものです。

ルールのキーを、配列 ``$_referenceMap`` のインデックスとして使用します。
このルールのキーは、各リレーションを指定する際に使用します。
わかりやすい名前をつけるようにしましょう。 あとでご覧いただくように、 *PHP*
のメソッド名の一部を使用するとよいでしょう。

上のサンプル *PHP* コードでは、Bugs テーブルクラスのルールのキーは *'Reporter'*\ 、
*'Engineer'*\ 、 *'Verifier'* および *'Product'* となります。

配列 ``$_referenceMap`` の各ルールエントリの内容もまた、連想配列です。
このルールエントリの内容について、以下で説明します。

- **columns** =>
  文字列あるいは文字列の配列で、従属テーブル内での外部キー列の名前を指定します。

  たいていの場合はカラムはひとつだけですが、
  複数カラムのキーとなるテーブルもあります。

- **refTableClass** => 親テーブルのクラス名を指定します。 *SQL*
  テーブルの物理的な名前ではなく、クラス名を使用します。

  通常は、従属テーブルから親テーブルへの参照はひとつだけになります。
  しかし、テーブルによっては同一の親テーブルへの参照を複数持つものもあります。
  サンプルのデータベースでは、 *bugs* テーブルから *products*
  テーブルへの参照はひとつだけです。 しかし、 *bugs* テーブルから *accounts*
  テーブルへの参照は三つあります。 それぞれの参照を、配列 ``$_referenceMap``
  の個別のエントリとします。

- **refColumns** =>
  文字列あるいは文字列の配列で、親テーブルの主キーのカラム名を指定します。

  たいていの場合はカラムはひとつだけですが、
  複数カラムのキーとなるテーブルもあります。
  複数カラムのキーを使用する場合は、 *'columns'* エントリでのカラムの順番と
  *'refColumns'* エントリでのカラムの順番が一致する必要があります。

  この要素の指定は必須ではありません。 *refColumns* を省略した場合は、
  親テーブルの主キーカラムをデフォルトで使用します。

- **onDelete** => 親テーブルの行が削除されたときに実行する動作を指定します。詳細は
  :ref:` <zend.db.table.relationships.cascading>` を参照ください。

- **onUpdate** =>
  親テーブルで主キーカラムの値が更新されたときに実行する動作を指定します。詳細は
  :ref:` <zend.db.table.relationships.cascading>` を参照ください。

.. _zend.db.table.relationships.fetching.dependent:

従属行セットの取得
---------

親テーブルに対するクエリの結果を Row オブジェクトとして取得すれば、
その行を参照している従属テーブルの行を取得できます。
使用するメソッドは、次のようになります。

.. code-block:: php
   :linenos:

   $row->findDependentRowset($table, [$rule]);

このメソッドは ``Zend_Db_Table_Rowset_Abstract`` オブジェクトを返します。
その中には、従属テーブル ``$table`` の行のうち、 ``$row``
が指す行を参照しているものが含まれます。

最初の引数 ``$table`` には、 従属テーブルのクラス名を表す文字列を指定します。
文字列ではなく、テーブルクラスのオブジェクトで指定することもできます。

.. _zend.db.table.relationships.fetching.dependent.example:

.. rubric:: 従属行セットの取得

この例では、 *Accounts* テーブルから取得した行オブジェクトについて、
その人が報告したバグを *Bugs* テーブルから探す方法を示します。

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();

   $bugsReportedByUser = $user1234->findDependentRowset('Bugs');

二番目の引数 ``$rule`` はオプションです。 これは、従属テーブルクラスの配列
``$_referenceMap`` でのルールのキーの名前を指定します。
ルールを指定しなかった場合は、配列の中で
その親テーブルを参照している最初のルールを使用します。
最初のもの以外のルールを使用する必要がある場合は、
キーを指定しなければなりません。

上の例のコードでは、ルールのキーを指定していません。
したがって、親テーブルにマッチする最初のルールをデフォルトで使用します。
ここでは *'Reporter'* がそれにあたります。

.. _zend.db.table.relationships.fetching.dependent.example-by:

.. rubric:: ルールを指定することによる従属行セットの取得

この例では、 *Accounts* テーブルから取得した行オブジェクトについて、
修正担当者がその人になっているバグを *Bugs*
テーブルから探す方法を示します。この例における、
このリレーションに対応する参照ルールのキーは *'Engineer'* です。

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();

   $bugsAssignedToUser = $user1234->findDependentRowset('Bugs', 'Engineer');

条件や並び順の指定、行数の制限を追加するには、 親の行の select
オブジェクトを使用します。





      .. _zend.db.table.relationships.fetching.dependent.example-by-select:

      .. rubric:: Zend_Db_Table_Select による従属行セットの取得

      この例では *Accounts* テーブルから行オブジェクトを取得し、
      修正担当者がその人である *Bugs* を探し、 最大 3
      件までを名前の順に取得します。

      .. code-block:: php
         :linenos:

         $accountsTable = new Accounts();
         $accountsRowset = $accountsTable->find(1234);
         $user1234 = $accountsRowset->current();
         $select = $accountsTable->select()->order('name ASC')
                                           ->limit(3);

         $bugsAssignedToUser = $user1234->findDependentRowset('Bugs',
                                                              'Engineer',
                                                              $select);

別の方法として、"マジックメソッド"
を使用して従属テーブルの行を問い合わせることもできます。
以下のパターンのいずれかに該当するメソッドを Row オブジェクトでコールすると、
``Zend_Db_Table_Row_Abstract`` は ``findDependentRowset('<TableClass>', '<Rule>')``
メソッドを実行します。



- *$row->find<TableClass>()*

- *$row->find<TableClass>By<Rule>()*

上のパターンにおいて、 *<TableClass>* および *<Rule>* は、それぞれ
従属テーブルのクラス名、親テーブルとの参照関係を表す
従属テーブルのルールのキーとなります。

.. note::

   他のアプリケーションフレームワーク、たとえば Ruby on Rails などでは、いわゆる
   "inflection (語尾変化)" という仕組みを採用しているものもあります。
   これにより、使用する状況に応じて識別子のスペルを変更できるようになります。
   あまり複雑にならないようにするため、 ``Zend_Db_Table_Row``
   ではこの仕組みを提供していません。 メソッドのコール時に指定するテーブルの ID
   やルールのキーは、 クラス名やキー名と正確に一致しなければなりません。

.. _zend.db.table.relationships.fetching.dependent.example-magic:

.. rubric:: マジックメソッドの使用による従属行セットの取得

この例では、先ほどの例と同じ従属行セットを見つける方法を示します。
今回は、テーブルとルールを文字列で指定するのではなく、
マジックメソッドを使用します。

.. code-block:: php
   :linenos:

   $accountsTable = new Accounts();
   $accountsRowset = $accountsTable->find(1234);
   $user1234 = $accountsRowset->current();

   // デフォルトの参照ルールを使用します
   $bugsReportedBy = $user1234->findBugs();

   // 参照ルールを指定します
   $bugsAssignedTo = $user1234->findBugsByEngineer();

.. _zend.db.table.relationships.fetching.parent:

親の行の取得
------

従属テーブルに対するクエリの結果を Row オブジェクトとして取得すれば、
その従属行が参照している親テーブルの行を取得できます。
使用するメソッドは、次のようになります。

.. code-block:: php
   :linenos:

   $row->findParentRow($table, [$rule]);

従属テーブルに対応する親テーブルの行は、常にひとつだけです。
したがって、このメソッドは Rowset オブジェクトではなく Row
オブジェクトを返します。

最初の引数 ``$table`` には、 親テーブルのクラス名を表す文字列を指定します。
文字列ではなく、テーブルクラスのオブジェクトで指定することもできます。

.. _zend.db.table.relationships.fetching.parent.example:

.. rubric:: 親の行の取得

この例では、 *Bugs* テーブルから (たとえば status が 'NEW' のものなどの)
行オブジェクトを取得し、そのバグを報告した人に対応する行を *Accounts*
テーブルから探す方法を示します。

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->fetchAll(array('bug_status = ?' => 'NEW'));
   $bug1 = $bugsRowset->current();

   $reporter = $bug1->findParentRow('Accounts');

二番目の引数 ``$rule`` はオプションです。 これは、従属テーブルクラスの配列
``$_referenceMap`` でのルールのキーの名前を指定します。
ルールを指定しなかった場合は、配列の中で
その親テーブルを参照している最初のルールを使用します。
最初のもの以外のルールを使用する必要がある場合は、
キーを指定しなければなりません。

上の例のコードでは、ルールのキーを指定していません。
したがって、親テーブルにマッチする最初のルールをデフォルトで使用します。
ここでは *'Reporter'* がそれにあたります。

.. _zend.db.table.relationships.fetching.parent.example-by:

.. rubric:: ルールを指定することによる親の行の取得

この例では、テーブル *Bugs* から取得した行オブジェクトについて、
そのバグの修正担当者のアカウント情報を探す方法を示します。
このリレーションに対応する参照ルールのキーは *'Engineer'* です。

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->fetchAll(array('bug_status = ?', 'NEW'));
   $bug1 = $bugsRowset->current();

   $engineer = $bug1->findParentRow('Accounts', 'Engineer');

別の方法として、"マジックメソッド"
を使用して親テーブルの行を問い合わせることもできます。
以下のパターンのいずれかに該当するメソッドを Row オブジェクトでコールすると、
``Zend_Db_Table_Row_Abstract`` は ``findParentRow('<TableClass>', '<Rule>')`` メソッドを実行します。

- *$row->findParent<TableClass>([Zend_Db_Table_Select $select])*

- *$row->findParent<TableClass>By<Rule>([Zend_Db_Table_Select $select])*

上のパターンにおいて、 *<TableClass>* および *<Rule>()* は、それぞれ
親テーブルのクラス名、親テーブルとの参照関係を表す
従属テーブルのルールのキーとなります

.. note::

   メソッドのコール時に指定するテーブルの ID やルールのキーは、
   クラス名やキー名と正確に一致しなければなりません。

.. _zend.db.table.relationships.fetching.parent.example-magic:

.. rubric:: マジックメソッドの使用による親の行の取得

この例では、先ほどの例と同じ親の行を見つける方法を示します。
今回は、テーブルとルールを文字列で指定するのではなく、
マジックメソッドを使用します。

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->fetchAll(array('bug_status = ?', 'NEW'));
   $bug1 = $bugsRowset->current();

   // デフォルトの参照ルールを使用します
   $reporter = $bug1->findParentAccounts();

   // 参照ルールを指定します
   $engineer = $bug1->findParentAccountsByEngineer();

.. _zend.db.table.relationships.fetching.many-to-many:

多対多のリレーションを使用した行セットの取得
----------------------

多対多のリレーションの片方のテーブル (この例では "元テーブル"
と呼ぶことにします) に対するクエリの結果を Row
オブジェクトとして取得すれば、もう一方のテーブル (この例では "対象テーブル"
と呼ぶことにします) の対応する行を取得できます。
使用するメソッドは、次のようになります。

.. code-block:: php
   :linenos:

   $row->findManyToManyRowset($table,
                              $intersectionTable,
                              [$rule1,
                                  [$rule2,
                                      [Zend_Db_Table_Select $select]
                                  ]
                              ]);

このメソッドは ``Zend_Db_Table_Rowset_Abstract`` オブジェクトを返します。
その中には、テーブル ``$table``
の行のうち、多対多のリレーションを満たすものが含まれます。 元テーブルの行
``$row`` を使用して中間テーブルの行を探し、
さらにそれを対象テーブルと結合します。

最初の引数 ``$table`` には、
多対多のリレーションの対象テーブルのクラス名を表す文字列を指定します。
文字列ではなく、テーブルクラスのオブジェクトで指定することもできます。

二番目の引数 ``$intersectionTable`` には、
多対多のリレーションの中間テーブルのクラス名を表す文字列を指定します。
文字列ではなく、テーブルクラスのオブジェクトで指定することもできます。

.. _zend.db.table.relationships.fetching.many-to-many.example:

.. rubric:: 多対多の形式の行セットの取得

この例では、元テーブル *Bugs* から取得した行オブジェクトについて、対象テーブル
*Products* の行を探す方法を示します。
これは、そのバグに関連する製品を表すものです。

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->find(1234);
   $bug1234 = $bugsRowset->current();

   $productsRowset = $bug1234->findManyToManyRowset('Products',
                                                    'BugsProducts');

三番目と四番目の引数 ``$rule1`` および ``$rule2`` はオプションです。
これは、中間テーブルの配列 ``$_referenceMap``
でのルールのキーの名前を表す文字列です。

``$rule1`` は、中間テーブルから元テーブルへのリレーションを表す
ルールのキーです。この例では、 *BugsProducts* から *Bugs*
へのリレーションがそれにあたります。

``$rule2`` は、中間テーブルから対象テーブルへのリレーションを表す
ルールのキーです。この例では、 *Bugs* から *Products*
へのリレーションがそれにあたります。

親や従属行を取得するメソッドと同様、もしルールを指定しなければ、 配列
``$_referenceMap`` の中でそのリレーションに該当する最初のルールを使用します。
最初のもの以外のルールを使用する必要がある場合は、
キーを指定しなければなりません。

上の例のコードでは、ルールのキーを指定していません。
したがって、マッチする最初のルールをデフォルトで使用します。 ここでは、
``$rule1`` が *'Reporter'*\ 、 そして ``$rule2`` が *'Product'* になります。

.. _zend.db.table.relationships.fetching.many-to-many.example-by:

.. rubric:: ルールを指定することによる多対多の形式の行セットの取得

この例では、元テーブル *Bugs* から取得した行オブジェクトについて、対象テーブル
*Products* の行を探す方法を示します。
これは、そのバグに関連する製品を表すものです。

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->find(1234);
   $bug1234 = $bugsRowset->current();

   $productsRowset = $bug1234->findManyToManyRowset('Products',
                                                    'BugsProducts',
                                                    'Bug');

別の方法として、"マジックメソッド"
を使用して多対多のリレーションの対象テーブルの行を問い合わせることもできます。
以下のパターンのいずれかに該当するメソッドをコールすると、
``Zend_Db_Table_Row_Abstract`` は *findManyToManyRowset('<TableClass>', '<IntersectionTableClass>', '<Rule1>',
'<Rule2>')* メソッドを実行します。

- *$row->find<TableClass>Via<IntersectionTableClass> ([Zend_Db_Table_Select $select])*

- *$row->find<TableClass>Via<IntersectionTableClass>By<Rule1> ([Zend_Db_Table_Select $select])*

- *$row->find<TableClass>Via<IntersectionTableClass>By<Rule1>And<Rule2> ([Zend_Db_Table_Select $select])*

上のパターンにおいて、 *<TableClass>* および *<IntersectionTableClass>* は、それぞれ
対象テーブルのクラス名および中間テーブルのクラス名となります。 また *<Rule1>*
および *<Rule2>* は、それぞれ中間テーブルから元テーブル、
週間テーブルから対象テーブルへの参照を表すルールのキーとなります。

.. note::

   メソッドのコール時に指定するテーブルの ID やルールのキーは、
   クラス名やキー名と正確に一致しなければなりません。

.. _zend.db.table.relationships.fetching.many-to-many.example-magic:

.. rubric:: マジックメソッドの使用による多対多の形式の行セットの取得

この例では、製品からの多対多のリレーションの
対象テーブルの行を見つける方法を示します。
そのバグに関連する製品を見つけます。

.. code-block:: php
   :linenos:

   $bugsTable = new Bugs();
   $bugsRowset = $bugsTable->find(1234);
   $bug1234 = $bugsRowset->current();

   // デフォルトの参照ルールを使用します
   $products = $bug1234->findProductsViaBugsProducts();

   // 参照ルールを指定します
   $products = $bug1234->findProductsViaBugsProductsByBug();

.. _zend.db.table.relationships.cascading:

書き込み操作の連鎖
---------

.. note::

   **データベースでの DRI の宣言**

   ``Zend_Db_Table`` の連鎖操作を宣言するのは、 *RDBMS* が宣言参照整合性 (DRI)
   をサポートしていない場合 **のみ** を想定しています。

   たとえば、MySQL の MyISAM ストレージエンジンや SQLite では DRI
   をサポートしていません。 このような場合は、 ``Zend_Db_Table``
   での連鎖操作の宣言が有用となるでしょう。

   もし *RDBMS* が DRI の *ON DELETE* 句 および *ON UPDATE* 句を実装しているのなら、
   データベーススキーマでそれを宣言すべきです。 ``Zend_Db_Table``
   の連鎖機能を使ってはいけません。 *RDBMS* が実装する連鎖 DRI を使用したほうが、
   データベースのパフォーマンスや一貫性、整合性の面で有利です。

   もっとも重要なのは、 *RDBMS* と ``Zend_Db_Table``
   クラスの両方で同時に連鎖操作を宣言してはいけないということです。

親テーブルに対して ``UPDATE`` あるいは ``DELETE`` を行った際に、
従属テーブルに対して行う操作を指定できます。

.. _zend.db.table.relationships.cascading.example-delete:

.. rubric:: 連鎖削除の例

この例では *Products* テーブルの行を削除します。 その際に、 *Bugs*
テーブルの従属行も 自動的に削除するように設定されています。

.. code-block:: php
   :linenos:

   $productsTable = new Products();
   $productsRowset = $productsTable->find(1234);
   $product1234 = $productsRowset->current();

   $product1234->delete();
   // 自動的に Bugs テーブルにも連鎖し、
   // 従属する行が削除されます

同様に、 ``UPDATE`` で親テーブルの主キーの値を変更した場合は、
従属テーブルの外部キーの値も自動的に新しい値に更新したくなることでしょう。
これにより、その参照を最新の状態にできます。

シーケンスなどの機能を用いて主キーを生成している場合は、
通常はその値を変更する必要はありません。しかし、 **自然キー**
を使用している場合は、 値が変わる可能性もあります。そのような場合は、
従属テーブルに対して連鎖更新を行う必要があるでしょう。

``Zend_Db_Table`` で連鎖リレーションを宣言するには、 ``$_referenceMap``
の中でのルールを編集し、 連想配列のキー *'onDelete'* および *'onUpdate'* に文字列
'cascade' (あるいは定数 ``self::CASCADE``) を設定します。
親テーブルから行が削除されたり主キーの値が更新されたりする前に、
その行を参照している従属テーブルの行が まず削除あるいは更新されます。

.. _zend.db.table.relationships.cascading.example-declaration:

.. rubric:: 連鎖操作の宣言の例

以下の例では、 *Products*
テーブルのある行が削除されたときに、その行を参照している *Bugs*
テーブルの行が自動的に削除されます。 参照マップのエントリの要素 *'onDelete'* が
``self::CASCADE`` に設定されているからです。

以下の例では、親クラスの主キーの値が変更されても
連鎖更新は起こりません。これは、参照マップのエントリの要素 *'onUpdate'* が
``self::RESTRICT`` に設定されているからです。 *'onUpdate'*
エントリ自体を省略しても同じ結果となります。

.. code-block:: php
   :linenos:

   class BugsProducts extends Zend_Db_Table_Abstract
   {
       ...
       protected $_referenceMap = array(
           'Product' => array(
               'columns'           => array('product_id'),
               'refTableClass'     => 'Products',
               'refColumns'        => array('product_id'),
               'onDelete'          => self::CASCADE,
               'onUpdate'          => self::RESTRICT
           ),
           ...
       );
   }

.. _zend.db.table.relationships.cascading.notes:

連鎖操作に関する注意点
^^^^^^^^^^^

**Zend_Db_Table が実行する連鎖操作はアトミックではありません。**

つまり、もしデータベース自身が参照整合性制約を実装している場合、 ``Zend_Db_Table``
クラスが実行した連鎖 ``UPDATE``
がその制約と競合し、参照整合性に違反してしまうことになるということです。
``Zend_Db_Table`` の連鎖 ``UPDATE`` を使用できるのは、
データベース側で参照整合性制約を設定していない場合 **のみ** です。

連鎖 ``DELETE`` に関しては、参照整合性に違反してしまう恐れはあまりありません。
従属行の削除は、参照する親の行が削除される前に
アトミックでない処理として行うことができます。

しかしながら、 ``UPDATE`` および ``DELETE``
のどちらについても、アトミックでない方法でデータを変更すると、
整合性がない状態のデータを他のユーザに見られてしまうというリスクが発生します。
たとえば、ある行とそのすべての従属行を削除することを考えましょう。
ほんの一瞬ですが、「従属行は削除したけれど親行はまだ削除していない」
という状態を他のクライアントプログラムから見られてしまう可能性があります。
そのクライアントプログラムは、従属行がない親行を見て、
それが意図した状態であると考えることでしょう。
クライアントが読み込んだデータが
変更の途中の中途半端な状態であることなど、知るすべもありません。

アトミックでない変更による問題を軽減するには、
トランザクションを使用してその変更を他と隔離します。 しかし *RDBMS*
によってはトランザクションをサポートしていないものもありますし、
まだコミットされていない "ダーティな"
変更を他のクライアントから見られるようにしているものもあります。

**Zend_Db_Table の連鎖処理は Zend_Db_Table からのみ実行できます。**

``Zend_Db_Table`` クラスで定義した連鎖削除や更新は、Row クラスで ``save()``
メソッドあるいは ``delete()`` メソッドを実行した際に適用されます。
しかし、クエリツールや別のアプリケーションなどの
別ルートでデータを更新あるいは削除した場合は、 連鎖操作は発生しません。
``Zend_Db_Adapter`` クラスの ``update()`` メソッドや ``delete()``
メソッドを実行したとしても、 ``Zend_Db_Table`` で定義した連鎖操作は実行されません。

**連鎖 INSERT はありません。**

連鎖 ``INSERT`` はサポートしていません。 親テーブルに行を追加したら、
従属テーブルへの行の追加は別の処理として行う必要があります。


