.. _migration.09:

Zend Framework 0.9
==================

以前のバージョンから Zend Framework 0.9 またはそれ以降に更新する際は、
下記の移行上の注意点に注意すべきです。

.. _migration.09.zend.controller:

Zend_Controller
---------------

0.9.3 では :ref:`アクションヘルパー <zend.controller.actionhelpers>`
が利用できるようになりました。この変更にともない、以下のメソッドが削除され、
:ref:`リダイレクタ アクションヘルパー <zend.controller.actionhelpers.redirector>`
に組み込まれました。

- ``setRedirectCode()`` の代わりに ``Zend_Controller_Action_Helper_Redirector::setCode()``
  を使用します。

- ``setRedirectPrependBase()`` の代わりに ``Zend_Controller_Action_Helper_Redirector::setPrependBase()``
  を使用します。

- ``setRedirectExit()`` の代わりに ``Zend_Controller_Action_Helper_Redirector::setExit()``
  を使用します。

ヘルパーオブジェクトの取得方法や操作方法についての詳細は
:ref:`アクションヘルパーのドキュメント <zend.controller.actionhelpers>` を、
そしてリダイレクトの設定方法（新しいメソッドなど）についての詳細は
:ref:`リダイレクタ アクションヘルパーのドキュメント
<zend.controller.actionhelpers.redirector>` を参照ください。


