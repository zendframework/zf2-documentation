.. _migration.08:

Zend Framework 0.8
==================

以前のバージョンから Zend Framework 0.8 またはそれ以降に更新する際は、
下記の移行上の注意点に注意すべきです。

.. _migration.08.zend.controller:

Zend_Controller
---------------

前回変更された、もっとも基本的な *MVC*
コンポーネントの使用法は、そのまま同じです。

.. code-block:: php
   :linenos:

   Zend_Controller_Front::run('/path/to/controllers');

しかし、ディレクトリ構造を見直し、いくつかのコンポーネントが削除されました。
また、名前が変更されたり新たに追加されたものもあります。以下にそれらをまとめます。

- ``Zend_Controller_Router`` は削除されました。 かわりに rewrite
  ルータを使用してください。

- ``Zend_Controller_RewriteRouter`` は ``Zend_Controller_Router_Rewrite`` という名前に変わり、
  このフレームワークの標準ルータに格上げされました。 ``Zend_Controller_Front`` は、
  特に別のルータを指定しない限りこのルータをデフォルトで使用します。

- rewrite ルータで使用する、新しいルートクラスが追加されました。名前は
  ``Zend_Controller_Router_Route_Module`` です。 これは *MVC*
  で使用するデフォルトのルートのほかに、 :ref:`コントローラモジュール
  <zend.controller.modular>` をサポートしています。

- ``Zend_Controller_Router_StaticRoute`` は ``Zend_Controller_Router_Route_Static``
  という名前に変わりました。

- ``Zend_Controller_Dispatcher`` は ``Zend_Controller_Dispatcher_Standard``
  という名前に変わりました。

- ``Zend_Controller_Action::_forward()`` の引数が変わりました。
  新しいシグネチャは次のとおりです。

  .. code-block:: php
     :linenos:

     final protected function _forward($action,
                                       $controller = null,
                                       $module = null,
                                       array $params = null);

  ``$action`` は常に必須です。 コントローラを指定しなかった場合は、
  現在のコントローラ内のアクションであるとみなされます。 ``$controller``
  を指定しなかった場合は、 ``$module`` は常に無視されます。 最後に、 ``$params``
  で指定した任意の値が リクエストオブジェクトに追加されます。
  コントローラやモジュールは不要だがパラメータは渡したいという場合は、
  コントローラやモジュールに ``NULL`` を指定します。


