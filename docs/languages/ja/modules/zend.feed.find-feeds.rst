.. EN-Revision: none
.. _zend.feed.findFeeds:

ウェブページからのフィードの取得
================

ウェブページの中には、そのページの内容に関連するフィードを参照する **<link>**
タグが含まれていることがあります。 ``Zend_Feed`` を使用すると、
単純にひとつのメソッドをコールするだけでこのようなフィードを取得できます。

.. code-block:: php
   :linenos:

   $feedArray = Zend_Feed::findFeeds('http://www.example.com/news.html');

``findFeeds()`` メソッドは ``Zend_Feed_Abstract``
オブジェクトの配列を返します。その内容は、 ``news.html`` の中の **<link>**
が指しているものとなります。 各フィードの形式によって、 ``$feedArray``
の対応するエントリは ``Zend_Feed_Rss`` あるいは ``Zend_Feed_Atom``
のインスタンスとなります。 *HTTP* 404
が返された場合やフィードの形式がおかしかった場合など、失敗した場合には
``Zend_Feed`` は ``Zend_Feed_Exception`` をスローします。


