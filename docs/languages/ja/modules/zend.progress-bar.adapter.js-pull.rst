.. _zend.progressbar.adapter.jspull:

Zend_ProgressBar_Adapter_JsPull
===============================

``Zend_ProgressBar_Adapter_JsPull`` は jsPush とは逆の動作をします。つまり、
更新をブラウザにプッシュするのではなく更新情報をほかから受け取ることになります。
一般に、このアダプタを使う場合は ``Zend_ProgressBar`` の persistence
オプションを使用する必要があります。 通知を受け取ると、このアダプタは *JSON*
文字列をブラウザに送ります。 その内容は jsPush
アダプタから送られてくるものとほぼ同じです。 唯一の違いは、追加のパラメータ
*finished* が含まれることです。このパラメータは、 ``update()`` がコールされた場合は
``FALSE``\ 、 ``finish()`` がコールされた場合は ``TRUE`` となります。

アダプタのオプションを設定するには、 *set**
メソッドを使用するか、あるいはコンストラクタの最初のパラメータで 配列か
``Zend_Config`` インスタンスを渡します。 使用できるオプションは次のとおりです。

- *exitAfterSend*: データがブラウザに送信された後に、
  現在のリクエストを終了します。デフォルトは ``TRUE`` です。


