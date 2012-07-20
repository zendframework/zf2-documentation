.. _zend.config.writer.introduction:

Zend_Config_Writer
==================

``Zend_Config_Writer`` は、設定ファイルに ``Zend_Config`` オブジェクトを書き出します。
アダプタなしでも動作するので、使用するのも簡単です。 デフォルトでは
``Zend_Config_Writer`` には 3
種類のアダプタが同梱されており、全てファイル・ベースです。 まず、 **filename** や
**config** のオプションを指定してライターのインスタンスを作成します。
それからライターの ``write()`` メソッドをコールすると、
設定ファイルが作成されます。 ``$filename`` や ``$config`` を、直接 ``write()``
メソッドで設定することもできます。現在は、次のライターが ``Zend_Config_Writer``
に同梱されています。

- ``Zend_Config_Writer_Array``

- ``Zend_Config_Writer_Ini``

- ``Zend_Config_Writer_Xml``

*INI* ライターでは、セクションについてのレンダリング用のモードが２つあります。
既定では、トップレベルの構成節は、常にセクション名に含まれます。
``$writer->setRenderWithoutSections()`` を呼ぶことにより、 オプションの全てが *INI*
ファイルのグローバル名前空間に含まれます。
そして、セクションは使用されません。

加えて、 ``Zend_Config_Writer_Ini`` にはオプションのパラメータ **nestSeparator**
が用意されています。
これは、ノードを区切る文字を定義します。デフォルトはドットひとつで、 これは
``Zend_Config_Ini`` のデフォルトと同じです。

``Zend_Config`` オブジェクトを変更したり作成したりする際には、
知っておくべきことがあります。値を作成したり変更したりするには、
パラメータのアクセサ (**->**) で ``Zend_Config``
オブジェクトのパラメータを設定します。
ルート内のセクションやブランチを作成するには、新規配列を作成します
("``$config->branch = array();``")。 セクションの継承関係を定義するには、ルート
``Zend_Config`` オブジェクトの ``setExtend()`` メソッドをコールします。

.. _zend.config.writer.example.using:

.. rubric:: Zend_Config_Writer の使用法

この例では、 ``Zend_Config_Writer_Xml``
で新しい設定ファイルを作成する方法を説明します。

.. code-block:: php
   :linenos:

   // config オブジェクトを作成します
   $config = new Zend_Config(array(), true);
   $config->production = array();
   $config->staging    = array();

   $config->setExtend('staging', 'production');

   $config->production->db = array();
   $config->production->db->hostname = 'localhost';
   $config->production->db->username = 'production';

   $config->staging->db = array();
   $config->staging->db->username = 'staging';

   // 次のいずれかの方法で設定ファイルを書き出します
   // a)
   $writer = new Zend_Config_Writer_Xml(array('config'   => $config,
                                              'filename' => 'config.xml'));
   $writer->write();

   // b)
   $writer = new Zend_Config_Writer_Xml();
   $writer->setConfig($config)
          ->setFilename('config.xml')
          ->write();

   // c)
   $writer = new Zend_Config_Writer_Xml();
   $writer->write('config.xml', $config);

これは、production と staging というセクションを持つ *XML*
設定ファイルを作成します。staging は production を継承しています。

.. _zend.config.writer.modifying:

.. rubric:: 既存の設定の変更

この例では、既存の設定ファイルを編集する方法を説明します。

.. code-block:: php
   :linenos:

   // すべてのセクションを既存の設定ファイルから読み込みますが継承は読み飛ばします
   $config = new Zend_Config_Ini('config.ini',
                                 null,
                                 array('skipExtends'        => true,
                                       'allowModifications' => true));

   // 値を変更します
   $config->production->hostname = 'foobar';

   // 設定ファイルを書き出します
   $writer = new Zend_Config_Writer_Ini(array('config'   => $config,
                                              'filename' => 'config.ini'));
   $writer->write();

.. note::

   **設定ファイルの読み込み**

   既存の設定ファイルを読み込んで変更をする場合は、
   すべてのセクションを読み込んで継承を読み飛ばすことが大切です。
   そうすることで、値がマージされてしまうことがなくなります。
   そのために、コンストラクタで **skipExtends** オプションを指定します。

構成節の文字列を作成するために、ファイル・ベースのライタ （ *INI* 、 *XML* 及び
*PHP* 配列） 全てで内部的に ``render()`` が使用されます。
コンフィギュレーション・データの文字列表現にアクセスする必要があれば、
このメソッドを外部からも使用できます。


