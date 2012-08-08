.. EN-Revision: none
.. _zend.view.helpers.initial.headmeta:

HeadMeta ヘルパー
=============

*HTML* の **<meta>** 要素は、 *HTML* ドキュメントに関するメタ情報を扱います。
たとえばキーワードや文字セット、キャッシュ方式などです。 Meta タグには 'http-equiv'
形式と 'name' 形式があり、 'content' 属性が必須となります。また、 'lang' あるいは
'scheme' のいずれかの属性を含むことができます。

``HeadMeta`` ヘルパーは、 meta
タグを設定したり追加したりするための次のようなメソッドを提供します。

- ``appendName($keyValue, $content, $conditionalName)``

- ``offsetSetName($index, $keyValue, $content, $conditionalName)``

- ``prependName($keyValue, $content, $conditionalName)``

- ``setName($keyValue, $content, $modifiers)``

- ``appendHttpEquiv($keyValue, $content, $conditionalHttpEquiv)``

- ``offsetSetHttpEquiv($index, $keyValue, $content, $conditionalHttpEquiv)``

- ``prependHttpEquiv($keyValue, $content, $conditionalHttpEquiv)``

- ``setHttpEquiv($keyValue, $content, $modifiers)``

``$keyValue`` は 'name' あるいは 'http-equiv' キーの値を定義します。 ``$content`` は 'content'
キーの値を定義し、 ``$modifiers`` はオプションで連想配列を指定します。この配列には
'lang' や 'scheme' といったキーが含まれます。

ヘルパーメソッド ``headMeta()`` で meta タグを設定することもできます。
このメソッドのシグネチャは ``headMeta($content, $keyValue, $keyType = 'name', $modifiers = array(),
$placement = 'APPEND')`` です。 ``$keyValue`` には、 ``$keyType`` ('name' あるいは 'http-equiv')
で指定したキーのコンテンツを指定します。 ``$placement`` は 'SET'
(既存の値をすべて上書きする) か 'APPEND' (スタックの最後に追加する)、 あるいは
'PREPEND' (スタックの先頭に追加する) となります。

``HeadMeta`` は ``append()`` や ``offsetSet()``\ 、 ``prepend()``\ 、そして ``set()``
をそれぞれオーバーライドして、上にあげた特別なメソッドを使用させるようにします。
内部的には、各項目を ``stdClass`` のトークンとして保管し、 あとで ``itemToString()``
メソッドでシリアライズします。 これはスタック内の項目についてチェックを行い、
オプションでそれを修正したものを返します。

``HeadMeta`` ヘルパーは、 :ref:`Placeholder ヘルパー <zend.view.helpers.initial.placeholder>`
の具象実装です。

.. _zend.view.helpers.initial.headmeta.basicusage:

.. rubric:: HeadMeta ヘルパーの基本的な使用法

meta タグは、いつでも好きなときに指定できます。
一般的には、クライアント側でのキャッシュの制御方法や SEO
用キーワードなどを指定します。

たとえば、SEO 用のキーワードを指定したい場合は 'keywords' という名前の meta
タグを作成します。
そして、そのページに関連するキーワードを値として指定します。

.. code-block:: php
   :linenos:

   // meta タグでキーワードを指定します
   $this->headMeta()->appendName('keywords', 'framework, PHP, productivity');

クライアント側でのキャッシュの制御方法を指定したい場合は、 http-equiv
タグを設定してルールを指定します。

.. code-block:: php
   :linenos:

   // クライアント側でのキャッシュを無効にします
   $this->headMeta()->appendHttpEquiv('expires',
                                      'Wed, 26 Feb 1997 08:21:57 GMT')
                    ->appendHttpEquiv('pragma', 'no-cache')
                    ->appendHttpEquiv('Cache-Control', 'no-cache');

meta タグの使い方としてもうひとつよくあるのは、
コンテンツタイプや文字セット、言語を指定するものです。

.. code-block:: php
   :linenos:

   // コンテンツタイプと文字セットを設定します
   $this->headMeta()->appendHttpEquiv('Content-Type',
                                      'text/html; charset=UTF-8')
                    ->appendHttpEquiv('Content-Language', 'en-US');

If you are serving an *HTML*\ 5 document, you should provide the character set like this:

.. code-block:: php
   :linenos:

   // HTML5 で文字セットを設定します
   $this->headMeta()->setCharset('UTF-8'); // <meta charset="UTF-8"> のように見えます

最後の例として、リダイレクトの前に見せるメッセージを "meta refresh"
で指定するものを示します。

.. code-block:: php
   :linenos:

   // 3 秒後に新しい URL に移動させます
   $this->headMeta()->appendHttpEquiv('Refresh',
                                      '3;URL=http://www.some.org/some.html');

レイアウト内で meta タグを指定し終えたら、ヘルパーの内容を出力します。

.. code-block:: php
   :linenos:

   <?php echo $this->headMeta() ?>


