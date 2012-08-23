.. EN-Revision: none
.. _zend.view.helpers.initial.baseurl:

BaseUrl ヘルパー
============

フレームワークによって生成された大部分の *URL*\ が自動的に基底 *URL*\
を前に付加するとはいえ、 開発者はリソースへのパスを正しくするために
彼ら自身の *URL*\ の前に基底 *URL*\ を付加する必要があります。

BaseUrlヘルパーの使用法は非常に簡単です:

.. code-block:: php
   :linenos:

   /*
    * 下記では、page/application の基底URLが "/mypage" であると仮定します。
    */

   /*
    * 出力:
    * <base href="/mypage/" />
    */
   <base href="<?php echo $this->baseUrl(); ?>" />

   /*
    * 出力:
    * <link rel="stylesheet" type="text/css" href="/mypage/css/base.css" />
    */
   <link rel="stylesheet" type="text/css"
        href="<?php echo $this->baseUrl('css/base.css'); ?>" />

.. note::

   単純にする目的で、 ``Zend_Controller``\ に含まれた基底 *URL*\ から、 入り口の *PHP*\
   ファイル （例えば、「 ``index.php``\ 」）を剥ぎ取ります。
   しかし、何かの場面では、問題を引き起こす場合があります。
   問題が起きたら、固有のBaseUrlを設定するために、
   ``$this->getHelper('BaseUrl')->setBaseUrl()``\ を使います。


