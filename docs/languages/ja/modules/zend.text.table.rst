.. EN-Revision: none
.. _zend.text.table.introduction:

Zend\Text\Table
===============

``Zend\Text\Table`` は、さまざまなデコレータを使用して
テキストベースの表をその場で作成するためのコンポーネントです。
これは、たとえばテキスト形式のメールで構造化されたデータを送信したい場合などに便利です。
その場合は等幅フォントを使う必要があります。 また、CLI
アプリケーションで表形式の情報を表示する場合にも便利です。 ``Zend\Text\Table``
は、複数行にわたるカラムやカラムの連結、
テキストの配置の指定に対応しています。

.. note::

   **エンコーディング**

   ``Zend\Text\Table`` のデフォルトでは、文字列が UTF-8
   でエンコードされていることを前提としています。
   もしそれ以外を使用している場合は、文字エンコーディングを
   コンストラクタあるいは ``Zend\Text_Table\Column`` の *setContent*
   メソッドのパラメータで指定します。
   もうひとつの方法として、もしそのエンコーディングをプロセス全体で使う場合には
   ``Zend\Text\Table::setInputCharset($charset)`` で標準の入力文字セットを定義できます。
   表を出力する際に別の文字セットを使用したい場合は、
   ``Zend\Text\Table::setOutputCharset($charset)`` で設定します。

``Zend\Text\Table`` オブジェクトは行の集まりで構成されており、
行は列の集まりで構成されています。行と列を表すのが、それぞれ ``Zend\Text_Table\Row``
および ``Zend\Text_Table\Column`` です。
表を作成する際に、表のオプションを配列で指定できます。
指定できるオプションは次のとおりです。



   - *columnWidths* (必須): 配列で、すべてのカラムとその幅 (文字数) を指定します。

   - *decorator*: テーブルの罫線に使用するデコレータ。 デフォルトは *unicode* ですが、
     *ascii*
     あるいは独自のデコレータオブジェクトのインスタンスを指定することもできます。

   - *padding*: カラムの左右の余白文字数。 デフォルトはゼロです。

   - *AutoSeparate*: 各行を横線でどのように区切るかの方法。
     デフォルトは、すべての行間を区切ります。これは、次の ``Zend\Text\Table``
     の定数のビットマスクで指定します。



        - ``Zend\Text\Table::AUTO_SEPARATE_NONE``

        - ``Zend\Text\Table::AUTO_SEPARATE_HEADER``

        - ``Zend\Text\Table::AUTO_SEPARATE_FOOTER``

        - ``Zend\Text\Table::AUTO_SEPARATE_ALL``

     ヘッダは常に最初の行、フッタは常に最後の行となります。



表に行を追加するには、 ``Zend\Text_Table\Row`` のインスタンスを作成して、それを
*appendRow* メソッドで追加します。行自体には何もオプションはありません。
配列を直接 *appendRow* メソッドに渡すこともできます。
この場合は、複数の列オブジェクトからなる行オブジェクトに自動的に変換されます。

行に列を追加する方法も同じです。 ``Zend\Text_Table\Column`` のインスタンスを作成し、
列のオプションをコンストラクタで指定するか、あるいは後から *set**
メソッドで設定します。
最初のパラメータは列の中身で、これは複数行にすることもできます。
複数行にする場合は *\n* で行を区切ります。 2
番目のパラメータは配置を指定します。デフォルトは左詰めで、 ``Zend\Text_Table\Column``
のクラス定数のいずれかを指定できます。



   - ``ALIGN_LEFT``

   - ``ALIGN_CENTER``

   - ``ALIGN_RIGHT``

3 番目のパラメータは列の連結 (colspan) を指定します。 たとえば、このパラメータに
"2" を指定すると、 表の中で 2 つの列が連結されるようになります。
最後のパラメータは列の中身のエンコーディングです。 ASCII および UTF-8
以外を使用する場合は必ず指定しなければなりません。
行を列に追加するには、行オブジェクトの *appendColumn*
のパラメータに列オブジェクトを指定してコールします。 あるいは、文字列を直接
*appendColumn* メソッドに渡すこともできます。

最後に、表をレンダリングするには *render* メソッドを使用します。あるいは、 *echo
$table;* や *$tableString = (string) $table* などとしてマジックメソッド *__toString*
を使用することもできます。

.. _zend.text.table.example.using:

.. rubric:: Zend\Text\Table の使用例

この例では、 ``Zend\Text\Table`` でシンプルな表を作成するための方法を示します。

.. code-block:: php
   :linenos:

   $table = new Zend\Text\Table(array('columnWidths' => array(10, 20)));

   // シンプルな例
   $table->appendRow(array('Zend', 'Framework'));

   // あるいは冗長な例
   $row = new Zend\Text_Table\Row();

   $row->appendColumn(new Zend\Text_Table\Column('Zend'));
   $row->appendColumn(new Zend\Text_Table\Column('Framework'));

   $table->appendRow($row);

   echo $table;

この結果は次のようになります。

.. code-block:: text
   :linenos:

   ┌──────────┬────────────────────┐
   │Zend      │Framework           │
   └──────────┴────────────────────┘


