.. _zend.log.writers.syslog:

システムログへの書き込み
============

``Zend_Log_Writer_Syslog``\ は、 システムログ (syslog) にログ項目を書きます。
内部的には、それは *PHP*\ の ``openlog()``\ や ``closelog()``\ 、 そして ``syslog()``\
関数の代わりです。

``Zend_Log_Writer_Syslog``\ が役立つ例の１つは、
クラスター形成されたマシンからシステムログ機能を通して集計されるログです。
多くのシステムでは、システム・イベントをリモートでログ収集できます。
それにより、システム管理者が単一のログファイルでマシンのクラスタをモニターできるようになります。

デフォルトで、生成されるsyslogメッセージはすべて、
文字列「Zend_Log」という接頭辞が付きます。
コンストラクタ、またはアプリケーション・アクセッサにアプリケーション名を渡すことで、
そのようなログメッセージを特定する異なる「アプリケーション」名を指定するかもしれません。

.. code-block:: php
   :linenos:

   //インスタンス生成時に任意で "application" キーを渡します。
   $writer = new Zend_Log_Writer_Syslog(array('application' => 'FooBar'));

   //そのほかいつでも
   $writer->setApplicationName('BarBaz');

システムログでは "facility" やアプリケーション・タイプ、
またはログ収集メッセージを指定できます。
多くのシステム・ロガーは、実は機能毎に異なるログファイルを生成します。
それは、前と同じように、サーバ活動をモニターする管理者を助けます。

コンストラクタ、またはアクセッサでログ機能を指定するかもしれません。 それは、
`openlog() マニュアル`_\ で定義される ``openlog()``\
定数のうちの１つでなければなりません。

.. code-block:: php
   :linenos:

   //インスタンス生成時に任意で "facility" キーを渡します。
   $writer = new Zend_Log_Writer_Syslog(array('facility' => LOG_AUTH));

   //そのほかいつでも
   $writer->setFacility(LOG_USER);

ログ収集時に、デフォルトの ``Zend_Log`` 優先度定数を使い続けるかもしれません。
内部的には、それらは適切な ``syslog()`` 優先度定数にマップされます。



.. _`openlog() マニュアル`: http://php.net/openlog
