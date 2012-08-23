.. EN-Revision: none
.. _zend.cache.theory:

キャッシュの仕組み
=========

``Zend_Cache`` には、3 つのポイントがあります。まず最初は一意な ID (文字列) で、
これによってキャッシュレコードを識別します。二番目は、例に含まれる **'lifetime'**
ディレクティブです。これは、キャッシュされたリソースの
「賞味期限」を定義するものです。三番目のポイントとなるのが条件付きの実行処理で、
不要なコードを完全に読み飛ばすことで処理速度を向上させることになります。
フロントエンドの主となる関数 (例えば ``Zend_Cache_Core::get()``)
は、キャッシュがヒットしなかった場合には常に ``FALSE``
を返すよう設計されています。 そのため、キャッシュしたい (そして読み飛ばしたい)
部分を **if(){ ... }** 文で囲む際に、 条件式として ``Zend_Cache``
のメソッド自身を使用できるようになっています。
このブロックの最後では、出力内容を (例えば ``Zend_Cache_Core::save()`` などで)
保存する必要があります。

.. note::

   条件付きの実行処理を必ず記述しなければならないわけではありません。
   フロントエンドの種類によっては (例えば **Function** など)、
   すべてのロジックがフロントエンドの中で実装されています。

.. note::

   'Cache hit (キャッシュにヒットした)' とは、キャッシュレコードが見つかり、
   かつそのレコードが 'fresh (新鮮)' (言い換えると、まだ有効期限が切れていない)
   状態であることを表す言葉です。'Cache miss (キャッシュが見つからなかった)'
   はその正反対です。キャッシュが見つからなかった場合は、 データを
   (通常どおりに) 作成し、それをキャッシュしなければなりません。
   一方、キャッシュにヒットした場合は、
   バックエンドが自動的にキャッシュレコードを取得してくれます。

.. _zend.cache.factory:

Zend_Cache ファクトリメソッド
--------------------

使用可能な ``Zend_Cache`` フロントエンドのインスタンスを作成する方法を、
以下の例で示します。

.. code-block:: php
   :linenos:

   // バックエンドを選びます (例えば 'File' や 'Sqlite'...)
   $backendName = '[...]';

   // フロントエンドを選びます (例えば 'Core'、'Output'、'Page'...)
   $frontendName = '[...]';

   // 選択したフロントエンド用のオプションを配列に設定します
   $frontendOptions = array([...]);

   // 選択したバックエンド用のオプションを配列に設定します
   $backendOptions = array([...]);

   // インスタンスを作成します
   // (もちろん、最後の 2 つの引数は必須ではありません)
   $cache = Zend_Cache::factory($frontendName,
                                $backendName,
                                $frontendOptions,
                                $backendOptions);

これ以降のドキュメントでは、 ``$cache``
の中身が有効なフロントエンドになっているものとします。また、
選択したバックエンドにパラメータを渡す方法は理解できているものとします。

.. note::

   常に ``Zend_Cache::factory()`` を使用してフロントエンドの
   インスタンスを作成するようにしてください。フロントエンドやバックエンドを
   自前で作成しようとしても、期待通りには動作しないでしょう。

.. _zend.cache.tags:

レコードのタグ付け
---------

タグは、キャッシュレコードを分類するための仕組みです。 ``save()``
メソッドでキャッシュを保存する際に、
適用するタグを配列で指定できます。これを使用すると、
指定したタグが設定されているキャッシュレコードのみを削除するといったことが可能となります。

.. code-block:: php
   :linenos:

   $cache->save($huge_data, 'myUniqueID', array('tagA', 'tagB', 'tagC'));

.. note::

   ``save()`` メソッドには、オプションの第四引数 ``$specificLifetime``
   を指定できることに注意しましょう (``FALSE``
   以外を指定することで、このキャッシュレコードの有効期限を特定の値に設定できます)。

.. _zend.cache.clean:

キャッシュの削除
--------

特定のキャッシュ ID を削除/無効化するには、 ``remove()`` メソッドを使用します。

.. code-block:: php
   :linenos:

   $cache->remove('削除するID');

一回の操作で複数のキャッシュ ID を削除/無効化するには、 ``clean()``
メソッドを使用します。例えば、すべてのキャッシュレコードを削除するには次のようにします。

.. code-block:: php
   :linenos:

   // すべてのレコードを削除します
   $cache->clean(Zend_Cache::CLEANING_MODE_ALL);

   // 有効期限切れのレコードのみ削除します
   $cache->clean(Zend_Cache::CLEANING_MODE_OLD);

タグ 'tagA' および 'tagC'
に該当するキャッシュエントリを削除するには、このようにします。

.. code-block:: php
   :linenos:

   $cache->clean(
       Zend_Cache::CLEANING_MODE_MATCHING_TAG,
       array('tagA', 'tagC')
   );

タグ 'tagA' にも 'tagC'
にも該当しないキャッシュエントリを削除するには、このようにします。

.. code-block:: php
   :linenos:

   $cache->clean(
       Zend_Cache::CLEANING_MODE_NOT_MATCHING_TAG,
       array('tagA', 'tagC')
   );

タグ 'tagA' または 'tagC'
に該当するキャッシュエントリを削除するには、このようにします。

.. code-block:: php
   :linenos:

   $cache->clean(
       Zend_Cache::CLEANING_MODE_MATCHING_ANY_TAG,
       array('tagA', 'tagC')
   );

削除モードとして指定可能な値は ``CLEANING_MODE_ALL``\ 、 ``CLEANING_MODE_OLD``\ 、
``CLEANING_MODE_MATCHING_TAG``\ 、 ``CLEANING_MODE_NOT_MATCHING_TAG`` および ``CLEANING_MODE_MATCHING_ANY_TAG``
です。 後者は、その名が示すとおり、タグの配列と組み合わせて使用します。


