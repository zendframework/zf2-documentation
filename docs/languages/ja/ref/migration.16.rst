.. EN-Revision: none
.. _migration.16:

Zend Framework 1.6
==================

以前のバージョンから Zend Framework 1.6 またはそれ以降に更新する際は、
下記の移行上の注意点に注意すべきです。

.. _migration.16.zend.controller:

Zend_Controller
---------------

.. _migration.16.zend.controller.dispatcher:

ディスパッチャインターフェイスの変更
^^^^^^^^^^^^^^^^^^

``Zend\Controller\Front`` と ``Zend\Controller\Router\Route\Module``
は、ディスパッチャインターフェイスにないメソッドを使用していました。 次の 3
つのメソッドを追加し、
自作のディスパッチャが同梱の実装と共存できるようにしています。

- ``getDefaultModule()``: デフォルトモジュールの名前を返します。

- ``getDefaultControllerName()``: デフォルトコントローラの名前を返します。

- ``getDefaultAction()``: デフォルトアクションの名前を返します。

.. _migration.16.zend.file.transfer:

Zend\File\Transfer
------------------

.. _migration.16.zend.file.transfer.validators:

バリデータを使う際の変更点
^^^^^^^^^^^^^

``Zend\File\Transfer`` のバリデータが ``Zend_Form``
のデフォルトのものと同じようには動作しないという指摘がありました。 ``Zend_Form``
では ``$breakChainOnFailure`` パラメータを利用でき、検証エラーが発生した際に
それ以降のバリデータを動作させないようにすることができます。

そこで、 ``Zend\File\Transfer``
の既存のバリデータにもこのパラメータを追加することにしました。

- 古い形式の *API*: ``addValidator($validator, $options, $files)``.

- 新しい形式の *API*: ``addValidator($validator, $breakChainOnFailure, $options, $files)``.

既存のスクリプトを新しい *API* に移行するには、バリデータの定義の後に ``FALSE``
を追加します。

.. _migration.16.zend.file.transfer.example:

.. rubric:: ファイルバリデータを 1.6.1 から 1.6.2 に移行する方法

.. code-block:: php
   :linenos:

   // 1.6.1 での例
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('FilesSize', array('1B', '100kB'));

   // 同じ例を 1.6.2 以降用にしたもの
   // boolean false が追加されていることに注意しましょう
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('FilesSize', false, array('1B', '100kB'));


