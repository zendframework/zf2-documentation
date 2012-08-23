.. EN-Revision: none
.. _zend.mail.different-transports:

異なる転送手段の使用
==========

複数のメールをそれぞれ別の接続を使用して送信したい場合は、 ``setDefaultTransport()``
をコールするかわりに ``send()``
にトランスポートオブジェクトを直接わたすことができます。 実際の ``send()``
の際に、 渡されたオブジェクトがデフォルトのトランスポートを上書きします。

.. _zend.mail.different-transports.example-1:

.. rubric:: 異なる転送手段の使用

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   // メッセージを作成します...
   $tr1 = new Zend_Mail_Transport_Smtp('server@example.com');
   $tr2 = new Zend_Mail_Transport_Smtp('other_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // もう一度デフォルトを使用します

.. note::

   **転送手段の追加**

   別の転送手段を用意するには、 ``Zend_Mail_Transport_Interface`` を実装します。


