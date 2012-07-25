.. _zend.mail.boundary:

控制MIME分界线
=========

在一个包含多个段的邮件里，用于分隔邮件不同段的MIME分界线(MIME
boundary)通常是随机生成的。但是在某些情况下，你也许会希望使用特定的MIME分界线。如下面的例子所示，你可以使用
*setMimeBoundary()*\ 方法来做到这一点：

.. _zend.mail.boundary.example-1:

.. rubric:: 更改MIME分界线

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++));
   // build message...



