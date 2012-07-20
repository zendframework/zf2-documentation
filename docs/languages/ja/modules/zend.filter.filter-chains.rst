.. _zend.filter.filter_chains:

フィルタチェイン
========

ひとつの値に対して、複数のフィルタを指定した順に適用しなければならないことがよくあります。
たとえば、ログインフォームで受け付けるユーザ名を
小文字の英字のみに限定する場合などです。 ``Zend_Filter``
は、複数のフィルタを連結する機能を提供しています。
以下のコードで、二つのフィルタをユーザ名に対して適用する方法を説明します。

.. code-block:: php
   :linenos:

   // フィルタチェインを作成し、そこにフィルタを追加します
   $filterChain = new Zend_Filter();
   $filterChain->addFilter(new Zend_Filter_Alpha())
               ->addFilter(new Zend_Filter_StringToLower());

   // ユーザ名をフィルタリングします
   $username = $filterChain->filter($_POST['username']);

フィルタは、 ``Zend_Filter`` に追加した順に適用されます。
上の例では、まずユーザ名から非英字を除去したあとで、
大文字を小文字に変換します。

``Zend_Filter_Interface`` を実装したオブジェクトなら何でも、
フィルタチェインに追加できます。

.. _zend.filter.filter_chains.order:

Changing filter chain order
---------------------------

Since 1.10, the ``Zend_Filter`` chain also supports altering the chain by prepending or appending filters. For
example, the next piece of code does exactly the same as the other username filter chain example:

.. code-block:: php
   :linenos:

   // Create a filter chain and add filters to the chain
   $filterChain = new Zend_Filter();

   // this filter will be appended to the filter chain
   $filterChain->appendFilter(new Zend_Filter_StringToLower());

   // this filter will be prepended at the beginning of the filter chain.
   $filterChain->prependFilter(new Zend_Filter_Alpha());

   // Filter the username
   $username = $filterChain->filter($_POST['username']);


