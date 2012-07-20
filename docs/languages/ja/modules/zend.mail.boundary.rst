.. _zend.mail.boundary:

MIME バウンダリの制御
=============

マルチパートメッセージで個々のパートを区切るための *MIME*
バウンダリは、通常はランダムに生成される文字列となります。 しかし、使用する
*MIME* バウンダリを指定したくなる場合もあるでしょう。 ``setMimeBoundary()``
メソッドを次の例のように使用すれば、 これが実現できます。

.. _zend.mail.boundary.example-1:

.. rubric:: MIME バウンダリの変更

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++));
   // メッセージを作成します...


