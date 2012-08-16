.. EN-Revision: none
.. _zend.view.helpers.initial.json:

JSON ヘルパー
=========

*JSON* を返すビューを作成する際に大事なのは、
適切なレスポンスヘッダを設定することです。 *JSON*
ビューヘルパーは、まさにその作業を行います。
さらに、デフォルトでレイアウト機能を無効にします (現在有効である場合)。 *JSON*
レスポンスでは通常レイアウト機能は使わないからです。

*JSON* ヘルパーは次のようなヘッダを設定します。

.. code-block:: text
   :linenos:

   Content-Type: application/json

たいていの *AJAX* ライブラリは、
レスポンスでこのヘッダを見つけると適切に処理してくれます。

*JSON* ヘルパーの使用法は、このように非常に単純です。

.. code-block:: php
   :linenos:

   <?php echo $this->json($this->data) ?>

.. note::

   **レイアウトの維持、およびZend_Json_Expr によるエンコードの有効化**

   *JSON* ヘルパーの各メソッドには、オプションで 2 番目の引数を指定できます。
   この 2 番目の引数は、レイアウト機能の有効/無効を指定する boolean フラグか
   あるいは ``Zend_Json::encode()``
   に渡して内部的なデータのエンコードに使用するオプションの配列となります。

   レイアウトを維持するには、2 番目のパラメータを ``TRUE``
   としなければなりません。 2
   番目のパラメータを配列ににする場合にレイアウトを維持するには、配列に
   ``keepLayouts`` というキーを含め、その値を ``TRUE`` にします。

   .. code-block:: php
      :linenos:

      // 2 番目の引数に true を指定するとレイアウトが有効になります
      echo $this->json($this->data, true);

      // あるいは、キー "keepLayouts" に true を指定します
      echo $this->json($this->data, array('keepLayouts' => true));

   ``Zend_Json::encode()`` は、ネイティブ *JSON* 式を ``Zend_Json_Expr``
   オブジェクトを使用してエンコードできます。
   このオプションはデフォルトでは無効になっています。 有効にするには、
   ``enableJsonExprFinder`` オプションに ``TRUE`` を設定します。

   .. code-block:: php
      :linenos:

      <?php echo $this->json($this->data, array(
          'enableJsonExprFinder' => true,
          'keepLayouts'          => true,
      )) ?>


