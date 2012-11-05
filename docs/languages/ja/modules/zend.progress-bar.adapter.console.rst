.. EN-Revision: none
.. _zend.progressbar.adapter.console:

Zend\ProgressBar_Adapter\Console
================================

``Zend\ProgressBar_Adapter\Console`` は、
ターミナル用に使用するテキストベースのアダプタです。
ターミナルの横幅を自動的に検出できますが、 独自に幅を指定することもできます。
プログレスバーとともに表示する要素や、その順序も変更できます。
また、プログレスバーそのものの形式も設定できます。

.. note::

   **自動的なコンソール幅の認識**

   この機能を \*nix 系のシステムで使用するには *shell_exec* が必要です。Windows
   ではターミナルの幅は 80 文字固定なので、 認識処理は不要です。

アダプタのオプションを設定するには、 *set**
メソッドを使用するか、あるいはコンストラクタの最初のパラメータで 配列か
``Zend_Config`` インスタンスを渡します。 使用できるオプションは次のとおりです。

- *outputStream*: さまざまな出力ストリーム。 STDOUT
  意外に出力したい場合に使用します。 *php://stderr* のようなストリーム、
  あるいはファイルへのパスを指定できます。

- *width*: 整数値、あるいは ``Zend\Console\ProgressBar`` の定数 ``AUTO``\ 。

- *elements*: デフォルトは ``NULL``\ 。 あるいは以下の ``Zend\Console\ProgressBar``
  の定数のうちの少なくともひとつを値として持つ配列。

  - ``ELEMENT_PERCENT``: パーセントであらわした現在値。

  - ``ELEMENT_BAR``: パーセンテージを表示するバー。

  - ``ELEMENT_ETA``: 自動的に計算した予想残り時間。 この要素が表示されるのは、開始後
    5 秒たってからです。 それまでは正確な結果を算出できないからです。

  - ``ELEMENT_TEXT``: 現在の処理に関する状況を説明するオプションのメッセージ。

- *textWidth*: ``ELEMENT_TEXT`` 要素の幅を文字数で表したもの。デフォルトは 20。

- *charset*: ``ELEMENT_TEXT`` 要素の文字セット。デフォルトは utf-8。

- *barLeftChar*: プログレスバー内で左側のインジケータとして使用する文字列。

- *barRightChar*: プログレスバー内で右側のインジケータとして使用する文字列。

- *barIndicatorChar*: プログレスバー内でインジケータとして使用する文字列。
  これは空にすることもできます。


