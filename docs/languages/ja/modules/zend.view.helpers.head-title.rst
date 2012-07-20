.. _zend.view.helpers.initial.headtitle:

HeadTitle ヘルパー
==============

*HTML* の **<title>** 要素を使用して、 *HTML* ドキュメントのタイトルを設定します。
``HeadTitle`` ヘルパーは、 プログラム上で作成したタイトルを保存しておいて、
後で出力の際にそれを取得するためのものです。

``HeadTitle`` ヘルパーは、 :ref:`Placeholder ヘルパー <zend.view.helpers.initial.placeholder>`
の具象実装です。 ``toString()`` メソッドをオーバーライドして ``<title>``
要素を生成するようにしており、 ``headTitle()`` メソッドによって title
要素の設定や集約を簡単にできるようになっています。 このメソッドのシグネチャは
``headTitle($title, $setType = null)`` です。デフォルトでは、 null のままだと、値はスタック
(title 部の内容を集約したもの) の最後に追加されます。しかしこれを 'PREPEND'
(スタックの先頭に追加する) や 'SET' (スタック全体を上書きする)
にすることもできます。

Since setting the aggregating (attach) order on each call to ``headTitle`` can be cumbersome, you can set a default
attach order by calling ``setDefaultAttachOrder()`` which is applied to all ``headTitle()`` calls unless you
explicitly pass a different attach order as the second parameter.

.. _zend.view.helpers.initial.headtitle.basicusage:

.. rubric:: HeadTitle ヘルパーの基本的な使用法

title タグは、いつでも好きなときに指定できます。
一般的な使用法としては、アプリケーション内での階層、
つまりサイト、コントローラ、アクションその他のリソースについての情報を示すことがあります。

.. code-block:: php
   :linenos:

   // コントローラとアクションの名前を title 部に設定します
   $request = Zend_Controller_Front::getInstance()->getRequest();
   $this->headTitle($request->getActionName())
        ->headTitle($request->getControllerName());

   // サイト名を title に設定します。これはレイアウトスクリプトで行うことになるでしょう
   $this->headTitle('Zend Framework');

   // 各部分を区切る文字列を設定します
   $this->headTitle()->setSeparator(' / ');

最後に、レイアウトスクリプト内でタイトルをレンダリングする際にそれを出力するだけです。

.. code-block:: php
   :linenos:

   <!-- <アクション名> / <コントローラ名> / Zend Framework と出力されます -->
   <?php echo $this->headTitle() ?>


