.. _zend.filter.set.realpath:

RealPath
========

このフィルタは与えられたリンクとパス名を解決して、正規化された絶対パス名を返します。
'``/./``' や '``/../``' への参照、 及び、入力パスの余分な '``/``'
記号は取り除かれます。 結果のパスにはいかなるシンボリックリンクも無く、
'``/./``' や '``/../``' 文字もありません。

たとえばファイルが存在しない場合、 ``Zend_Filter_RealPath``\ は失敗すると ``FALSE``\
を返します。 もし最後のパスのコンポーネントだけが存在しない場合、 *BSD*
システムでは ``Zend_Filter_RealPath``\ は失敗しますが、 他のシステムでは ``FALSE``\
を返します。

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_RealPath();
   $path   = '/www/var/path/../../mypath';
   $filtered = $filter->filter($path);

   // '/www/mypath' を返します。

それらが存在しないとき、
たとえば、生成したいパスのために実際のパスを取得したいとき、
パスを得るためにしばしば役に立ちます。 初期化で ``FALSE``\
を渡すこともできますし、 それを設定するために ``setExists()``\
を使うこともできます。

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_RealPath(false);
   $path   = '/www/var/path/../../non/existing/path';
   $filtered = $filter->filter($path);

   // file_exists または realpath が false を返すときでも
   // '/www/non/existing/path' を返します。


