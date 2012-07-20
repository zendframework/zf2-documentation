.. _zend.db.table.definition:

Zend_Db_Table_Definition
========================

.. _zend.db.table.definition.introduction:

導入
--

``Zend_Db_Table_Definition``\ は、 具象のインスタンス化を通じて ``Zend_Db_Table``\
を使うときに、 使う必要のある、
関連を記述するために利用できるクラスと構成オプションです。

.. _zend.db.table.definition.usage:

基本的な利用法
-------

拡張した ``Zend_Db_Table_Abstract`` クラスを設定するとき、
利用できる同様なオプションの全てに対して、 定義ファイルを記述すると、
それらのオプションも利用できます。
上述の定義でテーブル全ての完全な定義を知ることができるように、
この定義ファイルはインスタンス化の際のクラスに渡すべきです。

下記は、テーブル名とテーブル・オブジェクトの関連を記述する定義です。 注: 'name'
が定義から省略されると、 定義済みのテーブルのキーとして管理されます。
（この例は、下記の例の 'genre' 節です。）

.. _zend.db.table.definition.example1:

.. rubric:: データベース・データモデルの定義を記述

.. code-block:: php
   :linenos:

   $definition = new Zend_Db_Table_Definition(array(
       'author' => array(
           'name' => 'author',
           'dependentTables' => array('book')
           ),
       'book' => array(
           'name' => 'book',
           'referenceMap' => array(
               'author' => array(
                   'columns' => 'author_id',
                   'refTableClass' => 'author',
                   'refColumns' => 'id'
                   )
               )
           ),
       'genre' => null,
       'book_to_genre' => array(
           'referenceMap' => array(
               'book' => array(
                   'columns' => 'book_id',
                   'refTableClass' => 'book',
                   'refColumns' => 'id'
                   ),
               'genre' => array(
                   'columns' => 'genre_id',
                   'refTableClass' => 'genre',
                   'refColumns' => 'id'
                   )
               )
           )
       ));

ご覧の通り、通常、拡張した ``Zend_Db_Table_Abstract`` クラスで出会うであろう
オプションは、同様にこの配列で文書化されます。 ``Zend_Db_Table``
コンストラクタに渡されるとき、
この定義は適切な列を返すために作成する必要がある どんなテーブルにでも
**残存します**\ 。

下記は、 上述のデータモデルと一致する ``findDependentRowset()``\ と ``findManyToManyRowset()``\
呼び出しと同様に、 プライマリ・テーブル・インスタンス化の例です:

.. _zend.db.table.definition.example2:

.. rubric:: 記述された定義との相互作用

.. code-block:: php
   :linenos:

   $authorTable = new Zend_Db_Table('author', $definition);
   $authors = $authorTable->fetchAll();

   foreach ($authors as $author) {
       echo $author->id
          . ': '
          . $author->first_name
          . ' '
          . $author->last_name
          . PHP_EOL;
       $books = $author->findDependentRowset('book');
       foreach ($books as $book) {
           echo '    Book: ' . $book->title . PHP_EOL;
           $genreOutputArray = array();
           $genres = $book->findManyToManyRowset('genre', 'book_to_genre');
           foreach ($genres as $genreRow) {
               $genreOutputArray[] = $genreRow->name;
           }
           echo '        Genre: ' . implode(', ', $genreOutputArray) . PHP_EOL;
       }
   }

.. _zend.db.table.definition.advanced-usage:

高度な利用法
------

時々、テーブル・ゲートウェイの定義、
及び利用の両方のパラダイムを使うことを望みます:
拡張と具象のインスタンス化の両方によって。
こうするために、定義外のどんなテーブル構成をも単純に無視してください。
これで、Zend_Db_Tableが定義キーの代わりに実際の参照されたクラスを探すことができます。

上記の例をもとに、
テーブル構成のうちの1つはZend_Db_Table_Abstractを拡張したクラスであることができます。
その一方で、残りのテーブルは定義の一部として保ちます。
この新しい定義とどのように相互作用するかも示します。

.. _zend.db.table.definition.example3:

.. rubric:: Zend_Db_Table定義の混合利用との相互作用

.. code-block:: php
   :linenos:

   class MyBook extends Zend_Db_Table_Abstract
   {
       protected $_name = 'book';
       protected $_referenceMap = array(
           'author' => array(
               'columns' => 'author_id',
               'refTableClass' => 'author',
               'refColumns' => 'id'
               )
           );
   }

   $definition = new Zend_Db_Table_Definition(array(
       'author' => array(
           'name' => 'author',
           'dependentTables' => array('MyBook')
           ),
       'genre' => null,
       'book_to_genre' => array(
           'referenceMap' => array(
               'book' => array(
                   'columns' => 'book_id',
                   'refTableClass' => 'MyBook',
                   'refColumns' => 'id'
                   ),
               'genre' => array(
                   'columns' => 'genre_id',
                   'refTableClass' => 'genre',
                   'refColumns' => 'id'
                   )
               )
           )
       ));

   $authorTable = new Zend_Db_Table('author', $definition);
   $authors = $authorTable->fetchAll();

   foreach ($authors as $author) {
       echo $author->id
          . ': '
          . $author->first_name
          . ' '
          . $author->last_name
          . PHP_EOL;
       $books = $author->findDependentRowset(new MyBook());
       foreach ($books as $book) {
           echo '    Book: ' . $book->title . PHP_EOL;
           $genreOutputArray = array();
           $genres = $book->findManyToManyRowset('genre', 'book_to_genre');
           foreach ($genres as $genreRow) {
               $genreOutputArray[] = $genreRow->name;
           }
           echo '        Genre: ' . implode(', ', $genreOutputArray) . PHP_EOL;
       }
   }


