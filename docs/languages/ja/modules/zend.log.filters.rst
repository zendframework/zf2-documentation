.. EN-Revision: none
.. _zend.log.filters:

フィルタ
====

フィルタオブジェクトは、ログに書き出されるメッセージをブロックします。

.. _zend.log.filters.all-writers:

すべてのライターに対するフィルタリング
-------------------

すべてのライターの前にフィルタをかけるには、任意の数のフィルタを ``addFilter()``
メソッドでログオブジェクトに追加します。

.. code-block:: php
   :linenos:

   $logger = new Zend_Log();

   $writer = new Zend_Log_Writer_Stream('php://output');
   $logger->addWriter($writer);

   $filter = new Zend_Log_Filter_Priority(Zend_Log::CRIT);
   $logger->addFilter($filter);

   // ブロックされます
   $logger->info('通知メッセージ');

   // 記録されます
   $logger->emerg('緊急メッセージ');

ログオブジェクトにフィルタを追加すると、
フィルタを全て通過したものだけをライターが受け取るようになります。

.. _zend.log.filters.single-writer:

ライターのインスタンスに対するフィルタリング
----------------------

特定のライターインスタンスに対してだけフィルタをかけるには、ライターの
``addFilter()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $logger = new Zend_Log();

   $writer1 = new Zend_Log_Writer_Stream('/path/to/first/logfile');
   $logger->addWriter($writer1);

   $writer2 = new Zend_Log_Writer_Stream('/path/to/second/logfile');
   $logger->addWriter($writer2);

   // writer2 にのみフィルタをかけます
   $filter = new Zend_Log_Filter_Priority(Zend_Log::CRIT);
   $writer2->addFilter($filter);

   // writer1 には記録され、writer2 からはブロックされます
   $logger->info('通知メッセージ');

   // 両方のライターに記録されます
   $logger->emerg('緊急メッセージ');


