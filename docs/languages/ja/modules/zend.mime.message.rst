.. EN-Revision: none
.. _zend.mime.message:

Zend\Mime\Message
=================

.. _zend.mime.message.introduction:

導入
--

``Zend\Mime\Message`` は *MIME* 準拠のメッセージを表すものであり、
ひとつあるいは複数の部分に分かれたメッセージ (:ref:`Zend\Mime\Part <zend.mime.part>`
オブジェクトで表されます) を保持できます。 ``Zend\Mime\Message`` では、 ``Zend\Mime\Part``
を使用して *MIME* 準拠のマルチパートメッセージを作成します。
エンコーディングやバウンダリの処理も透過的に行われます。 与えられた文字列から
``Zend\Mime\Message`` オブジェクトを再構成することも可能です (実験段階です)。
:ref:`Zend_Mail <zend.mail>` で使用しています。

.. _zend.mime.message.instantiation:

インスタンスの作成
---------

``Zend\Mime\Message`` には明示的なコンストラクタはありません。

.. _zend.mime.message.addparts:

MIME パートの追加
-----------

:ref:`Zend\Mime\Part <zend.mime.part>` オブジェクトを ``Zend\Mime\Message``
オブジェクトに追加するには、 *->addPart($part)* をコールします。

*->getParts()* メソッドは、 ``Zend\Mime\Message`` 内のすべての :ref:`Zend\Mime\Part <zend.mime.part>`
オブジェクトを配列で返します。配列に保存されているのは ``Zend\Mime\Part``
オブジェクトへの参照なので、内容を変更できます。
配列に新たなパートを追加したり並び順を変更したりした場合は、
*->setParts($partsArray)* をコールして配列を :ref:`Zend\Mime\Part <zend.mime.part>`
オブジェクトに書き戻さなければなりません。

関数 *->isMultiPart()* は、 ``Zend\Mime\Message``
オブジェクトに複数のパートが登録されている場合に ``TRUE`` を返します。
この場合、実際の出力はマルチパート Mime メッセージとなります。

.. _zend.mime.message.bondary:

バウンダリの扱い
--------

``Zend\Mime\Message`` は、バウンダリを生成するために通常は ``Zend_Mime``
オブジェクトを使用します。 バウンダリを独自に定義する必要があったり
``Zend\Mime\Message`` が使用する ``Zend_Mime``
オブジェクトの振る舞いを変更したりしたい場合は、 ``Zend_Mime``
オブジェクトを自分で作成して ``Zend\Mime\Message``
に登録します。通常は、この必要はありません。 この ``Zend\Mime\Message`` で使用する
``Zend_Mime`` インスタンスを設定するには、 *->setMime(Zend_Mime $mime)* を使用します。

*->getMime()* は ``Zend_Mime`` のインスタンスを返します。 これは、 ``generateMessage()``
がコールされた際にメッセージをレンダリングする際に使用されます。

*->generateMessage()* は、 ``Zend\Mime\Message`` の内容を文字列にレンダリングします。

.. _zend.mime.message.parse:

文字列をパースすることによる Zend\Mime\Message オブジェクトの作成 (実験段階)
-------------------------------------------------

*MIME* に準拠したメッセージを含む文字列をもとにして、 ``Zend\Mime\Message``
オブジェクトを構築できます。 ``Zend\Mime\Message``
には、このような文字列をパースして ``Zend\Mime\Message`` オブジェクトを返す
静的なファクトリメソッドが用意されています。

``Zend\Mime\Message::createFromMessage($str, $boundary)`` は、渡された文字列をデコードして
``Zend\Mime\Message`` オブジェクトを返します。 *->getParts()*
を使用すると、その中身を確認できます。


