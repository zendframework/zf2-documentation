.. _zend.view.helpers.initial.action:

Action ビューヘルパー
==============

``Action`` ビューヘルパーは、
ビュースクリプトから指定したコントローラのアクションを実行し、
その結果のレスポンスオブジェクトを返します。
これは、特定のアクションが再利用可能なコンテンツを返す場合や、 いわゆる
"ウィジェット風" のコンテンツを返す場合に便利です。

最終的に ``_forward()`` されたりリダイレクトされたりするアクションは使えず、
空の文字列を返します。

``Action`` ビューヘルパーの *API* はコントローラアクションを起動する大半の *MVC*
コンポーネントと同じで、 ``action($action, $controller, $module = null, array $params = array())``
のようになります。 ``$action`` と ``$controller``
は必須です。モジュールを省略した場合はデフォルトのモジュールを使用します。

.. _zend.view.helpers.initial.action.usage:

.. rubric:: Action ビューヘルパーの基本的な使用法

たとえば ``CommentController`` に ``listAction()`` というメソッドがあったとしましょう。
コメント一覧を取得するために現在のリクエストからこのメソッドを起動するには、
次のようにします。

.. code-block:: php
   :linenos:

   <div id="sidebar right">
       <div class="item">
           <?php echo $this->action('list',
                                    'comment',
                                    null,
                                    array('count' => 10)); ?>
       </div>
   </div>


