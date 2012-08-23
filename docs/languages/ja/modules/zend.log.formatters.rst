.. EN-Revision: none
.. _zend.log.formatters:

フォーマッタ
======

フォーマッタの役割は、 ``event`` 配列からイベントの内容を受け取り、
それを文字列としてフォーマットして出力することです。

ライターによっては行指向ではないものもあります。そのような場合はフォーマッタは使用できません。
たとえばデータベースライターなどがその例で、
これはイベントの項目を直接データベースのカラムに書き出します。
フォーマッタをサポートできないライターに対してフォーマッタを設定しようとすると、
例外がスローされます。

.. _zend.log.formatters.simple:

単純なフォーマット
---------

``Zend_Log_Formatter_Simple`` はデフォルトのフォーマッタです。
これは、何もフォーマッタを指定しなかった場合に自動的に設定されます。
デフォルトの設定は、次のようになります。

.. code-block:: php
   :linenos:

   $format = '%timestamp% %priorityName% (%priority%): %message%' . PHP_EOL;
   $formatter = new Zend_Log_Formatter_Simple($format);

フォーマッタを個々のライターオブジェクトに対して設定するには、ライターの
``setFormatter()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $writer = new Zend_Log_Writer_Stream('php://output');
   $formatter = new Zend_Log_Formatter_Simple('hello %message%' . PHP_EOL);
   $writer->setFormatter($formatter);

   $logger = new Zend_Log();
   $logger->addWriter($writer);

   $logger->info('there');

   // "hello there" と出力します

``Zend_Log_Formatter_Simple`` のコンストラクタには、
パラメータとして書式指定文字列を渡すことができます。
この文字列には、キーをパーセント記号で囲んだもの (例. ``%message%``) を含めます。
書式指定文字列には、イベントデータの配列の任意のキーを含めることができます。
デフォルトのキーを取得するには、 ``Zend_Log_Formatter_Simple`` の定数 DEFAULT_FORMAT
を使用します。

.. _zend.log.formatters.xml:

XML へのフォーマット
------------

``Zend_Log_Formatter_Xml`` は、ログのデータを *XML* 文字列に変換します。
デフォルトでは、イベントデータ配列のすべての項目を自動的に記録します。

.. code-block:: php
   :linenos:

   $writer = new Zend_Log_Writer_Stream('php://output');
   $formatter = new Zend_Log_Formatter_Xml();
   $writer->setFormatter($formatter);

   $logger = new Zend_Log();
   $logger->addWriter($writer);

   $logger->info('通知メッセージ');

上のコードの出力は、次のような *XML* になります
(可読性を確保するため空白を補っています)。

.. code-block:: xml
   :linenos:

   <logEntry>
     <timestamp>2007-04-06T07:24:37-07:00</timestamp>
     <message>通知メッセージ</message>
     <priority>6</priority>
     <priorityName>INFO</priorityName>
   </logEntry>

ルート要素を変更したり、 *XML*
の要素名とイベントデータ配列の項目名の対応を指定したりすることも可能です。
``Zend_Log_Formatter_Xml`` のコンストラクタの最初のパラメータには、
ルート要素の名前を指定します。また、
二番目のパラメータには要素名の対応を表す連想配列を指定します。

.. code-block:: php
   :linenos:

   $writer = new Zend_Log_Writer_Stream('php://output');
   $formatter = new Zend_Log_Formatter_Xml('log',
                                           array('msg' => 'message',
                                                 'level' => 'priorityName')
                                          );
   $writer->setFormatter($formatter);

   $logger = new Zend_Log();
   $logger->addWriter($writer);

   $logger->info('通知メッセージ');

上のコードは、ルート要素の名前をデフォルトの ``logEntry`` から ``log``
に変更します。また、要素名 ``msg`` をイベントデータの項目 ``message``
に対応させます。 出力結果は次のようになります。

.. code-block:: xml
   :linenos:

   <log>
     <msg>通知メッセージ</msg>
     <level>INFO</level>
   </log>


