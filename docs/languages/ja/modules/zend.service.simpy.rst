.. _zend.service.simpy:

Zend_Service_Simpy
==================

.. _zend.service.simpy.introduction:

導入
--

``Zend_Service_Simpy`` は、ソーシャルブックマークサービスである Simpy 用のフリーな REST
*API* の、軽量なラッパーです。

``Zend_Service_Simpy`` を使用するには Simpy
アカウントが必要です。アカウントを取得するには、 `Simpy のウェブサイト`_
にいきます。 Simpy REST *API* についての詳細な情報は `Simpy REST API ドキュメント`_
を参照ください。

Simpy REST *API* を使用すると、Simpy
のウェブサイトが提供するサービスを利用できます。 以下の節は、 ``Zend_Service_Simpy``
で利用できる機能の概要をまとめたものです。



   - リンク: 作成、取得、更新、削除

   - タグ: 取得、削除、名前の変更、統合、分割

   - メモ: 作成、取得、更新、削除

   - ウォッチリスト: 取得、すべてを取得



.. _zend.service.simpy.links:

リンク
---

リンクを問い合わせると、登録日の降順で結果が返されます。
リンクの検索は、タイトルやニックネーム、タグ、メモ
そしてリンクに関連付けられたウェブページの内容にもとづいて行うことができます。
Simpy の検索は、これらのフィールドのいずれかあるいはすべてを対象に
フレーズや論理演算子、ワイルドカードを使用して行うことができます。
詳細な情報は、Simpy FAQ の `検索構文`_ や `検索フィールド`_
といった節を参照ください。

.. _zend.service.simpy.links.querying:

.. rubric:: リンクの問い合わせ

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('あなたのユーザ名', 'あなたのパスワード');

   /* 直近に追加された 10 件のリンクを探します */
   $linkQuery = new Zend_Service_Simpy_LinkQuery();
   $linkQuery->setLimit(10);

   /* リンクを取得し、表示します */
   $linkSet = $simpy->getLinks($linkQuery);
   foreach ($linkSet as $link) {
       echo '<a href="';
       echo $link->getUrl();
       echo '">';
       echo $link->getTitle();
       echo '</a><br />';
   }

   /* 直近に追加されたリンクのうち、タイトルに 'PHP' が含まれるものを
      5 件まで探します */
   $linkQuery->setQueryString('title:PHP');
   $linkQuery->setLimit(5);

   /* タイトルに 'French'、タグに 'language' が含まれる
      すべてのリンクを探します */
   $linkQuery->setQueryString('+title:French +tags:language');

   /* タイトルに 'French' を含み、タグに 'travel' を含まない
      すべてのリンクを探します */
   $linkQuery->setQueryString('+title:French -tags:travel');

   /* 2006/12/09 に追加されたすべてのリンクを探します */
   $linkQuery->setDate('2006-12-09');

   /* 2006/12/09 より後 (その日を含まない) に追加された
      すべてのリンクを探します */
   $linkQuery->setAfterDate('2006-12-09');

   /* 2006/12/09 より前 (その日を含まない) に追加された
      すべてのリンクを探します */
   $linkQuery->setBeforeDate('2006-12-09');

   /* 2006/12/01 から 2006/12/09 (両端の日を含まない) に追加された
      すべてのリンクを探します */
   $linkQuery->setBeforeDate('2006-12-01');
   $linkQuery->setAfterDate('2006-12-09');

リンクの識別は、 *URL* によって行います。言い換えると、 既存のリンクと同じ *URL*
のリンクを保存しようとすると
既存のリンクが新しいデータで上書きされるということです。

.. _zend.service.simpy.links.modifying:

.. rubric:: リンクの変更

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('あなたのユーザ名', 'あなたのパスワード');

   /* リンクを保存します */
   $simpy->saveLink(
       'Zend Framework' // タイトル
       'http://framework.zend.com', // URL
       Zend_Service_Simpy_Link::ACCESSTYPE_PUBLIC, // アクセス形式
       'zend, framework, php' // タグ
       'Zend Framework home page' // 別のタイトル
       'This site rocks!' // メモ
   );

   /* 既存のリンクを新しいデータで上書きします */
   $simpy->saveLink(
       'Zend Framework'
       'http://framework.zend.com',
       Zend_Service_Simpy_Link::ACCESSTYPE_PRIVATE, // アクセス形式を変更しました
       'php, zend, framework' // タグの順番を変更しました
       'Zend Framework' // 別のタイトルを変更しました
       'This site REALLY rocks!' // メモを変更しました
   );

   /* リンクを削除します */
   $simpy->deleteLink('http://framework.zend.com');

   /* あなたのリンクを大掃除する簡単な方法 (^o^) */
   $linkSet = $this->_simpy->getLinks();
   foreach ($linkSet as $link) {
       $this->_simpy->deleteLink($link->getUrl());
   }

.. _zend.service.simpy.tags:

タグ
--

取得時に、そのタグを使用しているリンク数の降順 (多いものが先)
でタグが並べ替えられます。

.. _zend.service.simpy.tags.working:

.. rubric:: タグの処理

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('あなたのユーザ名', 'あなたのパスワード');

   /* タグつきでリンクを保存します */
   $simpy->saveLink(
       'Zend Framework' // タイトル
       'http://framework.zend.com', // URL
       Zend_Service_Simpy_Link::ACCESSTYPE_PUBLIC, // アクセス形式
       'zend, framework, php' // タグ
   );

   /* リンクおよびメモで使用しているすべてのタグの一覧を取得します */
   $tagSet = $simpy->getTags();

   /* 各タグと、それを使用しているリンク数を表示します */
   foreach ($tagSet as $tag) {
       echo $tag->getTag();
       echo ' - ';
       echo $tag->getCount();
       echo '<br />';
   }

   /* 'zend' タグを使用しているすべてのリンクから、そのタグを削除します */
   $simpy->removeTag('zend');

   /* 'framework' タグの名前を 'frameworks' に変更します */
   $simpy->renameTag('framework', 'frameworks');

   /* 'frameworks' タグを 'framework' および
   'development' に分割します。つまり、'frameworks' タグを
   使用しているすべてのリンクからこのタグを削除し、'framework'
   および 'development' をそれらのリンクに追加します */
   $simpy->splitTag('frameworks', 'framework', 'development');

   /* 'framework' および 'development' のふたつのタグを
   'frameworks' に統合します。これは分割の反対の作業です */
   $simpy->mergeTags('framework', 'development', 'frameworks');

.. _zend.service.simpy.notes:

メモ
--

メモの保存、取得および削除が可能です。 メモは、数値 ID によって識別されます。

.. _zend.service.simpy.notes.working:

.. rubric:: メモの扱い

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('あなたのユーザ名', 'あなたのパスワード');

   /* メモを保存します */
   $simpy->saveNote(
       'Test Note', // タイトル
       'test,note', // タグ
       'This is a test note.' // 説明
   );

   /* 既存のメモを上書きします */
   $simpy->saveNote(
       'Updated Test Note', // タイトル
       'test,note,updated', // タグ
       'This is an updated test note.', // 説明
       $note->getId() // 一意な ID
   );

   /* 直近に追加された 10 件のメモを探します */
   $noteSet = $simpy->getNotes(null, 10);

   /* メモを表示します */
   foreach ($noteSet as $note) {
       echo '<p>';
       echo $note->getTitle();
       echo '<br />';
       echo $note->getDescription();
       echo '<br >';
       echo $note->getTags();
       echo '</p>';
   }

   /* タイトルに 'PHP' が含まれるすべてのメモを探します */
   $noteSet = $simpy->getNotes('title:PHP');

   /* タイトルに 'PHP' が含まれ、説明に 'framework' が含まれない
      すべてのメモを探します */
   $noteSet = $simpy->getNotes('+title:PHP -description:framework');

   /* メモを削除します */
   $simpy->deleteNote($note->getId());

.. _zend.service.simpy.watchlists:

ウォッチリスト
-------

ウォッチリストは、 *API* を用いて作成したり削除したりすることはできません。
取得のみが可能です。したがって、 *API* を使用してアクセスする前には Simpy
のウェブサイトでウォッチリストを作成しておく必要があります。

.. _zend.service.simpy.watchlists.retrieving:

.. rubric:: ウォッチリストの取得

.. code-block:: php
   :linenos:

   $simpy = new Zend_Service_Simpy('あなたのユーザ名', 'あなたのパスワード');

   /* すべてのウォッチリストの一覧を取得します */
   $watchlistSet = $simpy->getWatchlists();

   /* 各ウォッチリストのデータを表示します */
   foreach ($watchlistSet as $watchlist) {
       echo $watchlist->getId();
       echo '<br />';
       echo $watchlist->getName();
       echo '<br />';
       echo $watchlist->getDescription();
       echo '<br />';
       echo $watchlist->getAddDate();
       echo '<br />';
       echo $watchlist->getNewLinks();
       echo '<br />';

       foreach ($watchlist->getUsers() as $user) {
           echo $user;
           echo '<br />';
       }

       foreach ($watchlist->getFilters() as $filter) {
           echo $filter->getName();
           echo '<br />';
           echo $filter->getQuery();
           echo '<br />';
       }
   }

   /* 個々のウォッチリストを、ID を指定して取得します */
   $watchlist = $simpy->getWatchlist($watchlist->getId());
   $watchlist = $simpy->getWatchlist(1);



.. _`Simpy のウェブサイト`: http://simpy.com
.. _`Simpy REST API ドキュメント`: http://www.simpy.com/doc/api/rest
.. _`検索構文`: http://www.simpy.com/faq#searchSyntax
.. _`検索フィールド`: http://www.simpy.com/faq#searchFieldsLinks
