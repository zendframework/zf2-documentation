.. EN-Revision: none
.. _zend.mail.different-transports:

使用不同的Transport对象
================

有时你想想使用不同的连接来发送不同的邮件，你也可以不预先调用 *setDefaultTransport()*\
方法，而直接将Transport对象传递给 *send()*\ 。被传递的transport对象会在实际的 *send()*\
调用中替代缺省的transport：

.. _zend.mail.different-transports.example-1:

.. rubric:: 使用不同的Transport对象

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend\Mail\Mail();
   // build message...
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr1 = new Zend\Mail_Transport\Smtp('server@example.com');
   $tr2 = new Zend\Mail_Transport\Smtp('other_server@example.com');
   $mail->send($tr1);
   $mail->send($tr2);
   $mail->send();  // use default again?>

.. note::

   **外加的transports**

   外加transport，需要实现 *Zend\Mail_Transport\Interface*\ 接口。


