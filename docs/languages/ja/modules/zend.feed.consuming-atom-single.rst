.. _zend.feed.consuming-atom-single-entry:

単一の Atom エントリの処理
================

Atom の個々の ``<entry>`` 要素は、それ単体でも有効です。通常、 エントリの *URL*
はフィードの *URL* に ``/<エントリId>``
を続けたものになります。先に使用した例の場合は、 ``http://atom.example.com/feed/1``
となります。

単一のエントリを読み込む場合にも ``Zend_Feed_Atom``
オブジェクトを使用しますが、この場合は「無名 (anonymous)」
フィードが自動的に作成され、エントリがその中に含まれる形式になります。

.. _zend.feed.consuming-atom-single-entry.example.atom:

.. rubric:: Atom フィードからの単一のエントリの読み込み

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   echo 'このフィードには ' . $feed->count() . ' 件のエントリが含まれます。';

   $entry = $feed->current();

``<entry>`` のみのドキュメントにアクセスすることがわかっている場合は、
エントリオブジェクトを直接作成することもできます。

.. _zend.feed.consuming-atom-single-entry.example.entryatom:

.. rubric:: 単一エントリの Atom フィードに対する、エントリオブジェクトを直接使用したアクセス

.. code-block:: php
   :linenos:

   $entry = new Zend_Feed_Entry_Atom('http://atom.example.com/feed/1');
   echo $entry->title();


