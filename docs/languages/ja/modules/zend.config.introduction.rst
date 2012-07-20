.. _zend.config.introduction:

導入
==

``Zend_Config`` は、アプリケーションの設定データを
簡単に使用できるようにするために設計されたものです。
階層構造になったプロパティを使用して、設定データを簡単に
アプリケーションに読み込めるようになっています。
設定データは、階層構造のデータ保存をサポートしている
さまざまな媒体から読み込むことができます。 現時点で ``Zend_Config``
が提供している設定データアダプタは :ref:`Zend_Config_Ini <zend.config.adapters.ini>` と
:ref:`Zend_Config_Xml <zend.config.adapters.xml>`
の二種類で、テキストファイルに格納された設定データを使用できるようになっています。.

.. _zend.config.introduction.example.using:

.. rubric:: Zend_Config の使用例

通常は、 :ref:`Zend_Config_Ini <zend.config.adapters.ini>` あるいは :ref:`Zend_Config_Xml
<zend.config.adapters.xml>` のようなアダプタクラスを使用することが想定されています。
しかし、もし設定データが *PHP* の配列として存在するのなら、 単にそれを
``Zend_Config`` のコンストラクタに渡すだけで、
シンプルなオブジェクト指向のインターフェイスを使用できます。

.. code-block:: php
   :linenos:

   // 設定データは配列で渡されます
   $configArray = array(
       'webhost'  => 'www.example.com',
       'database' => array(
           'adapter' => 'pdo_mysql',
           'params'  => array(
               'host'     => 'db.example.com',
               'username' => 'dbuser',
               'password' => 'secret',
               'dbname'   => 'mydatabase'
           )
       )
   );

   // 設定データに対するオブジェクト指向のラッパーを作成します
   $config = new Zend_Config($configArray);

   // 設定データを表示します (結果は 'www.example.com' となります)
   echo $config->webhost;

   // 設定データを使用してデータベースに接続します
   $db = Zend_Db::factory($config->database->adapter,
                          $config->database->params->toArray());

   // もうひとつの方法: 単に Zend_Config オブジェクトを渡します
   // Zend_Db のファクトリは、その処理方法を知っています
   $db = Zend_Db::factory($config->database);

上の例で説明したように、 ``Zend_Config`` を使用すると、
コンストラクタに渡されたデータについて、
階層化されたプロパティの形式でアクセスできるようになります。

このようにオブジェクト思考形式でデータの値にアクセスするだけでなく、
``Zend_Config`` では *get()* メソッドも用意しています。
これは、指定した要素が存在しない場合にデフォルト値を返すように設定できます。
たとえば次のように使用します。

.. code-block:: php
   :linenos:

   $host = $config->database->get('host', 'localhost');

.. _zend.config.introduction.example.file.php:

.. rubric:: Zend_Config における PHP 設定ファイルの使用法

設定ファイルそのものを *PHP* で書きたいこともあるでしょう。
以下のようにすると、簡単にそれを行うことができます。

.. code-block:: php
   :linenos:

   // config.php
   return array(
       'webhost'  => 'www.example.com',
       'database' => array(
           'adapter' => 'pdo_mysql',
           'params'  => array(
               'host'     => 'db.example.com',
               'username' => 'dbuser',
               'password' => 'secret',
               'dbname'   => 'mydatabase'
           )
       )
   );

.. code-block:: php
   :linenos:

   // 設定を読み込みます
   $config = new Zend_Config(require 'config.php');

   // 設定データを出力します (この結果は 'www.example.com' です)
   echo $config->webhost;


