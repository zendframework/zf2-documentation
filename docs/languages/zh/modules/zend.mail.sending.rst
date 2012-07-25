.. _zend.mail.sending:

通过SMTP发送邮件
==========

以SMTP方式发送邮件， *Zend_Mail_Transport_Smtp*\
对象需要在send()方法被调用之前创建并注册到 *Zend_Mail*\
中去。当前脚本程序中所有使用 *Zend_Mail::send()*\ 发送的邮件，都将以SMTP方式传送：

.. _zend.mail.sending.example-1:

.. rubric:: 通过 SMTP 发送邮件

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail/Transport/Smtp.php';
   $tr = new Zend_Mail_Transport_Smtp('mail.example.com');
   Zend_Mail::setDefaultTransport($tr);

*setDefaultTransport()*\ 方法的调用和 *Zend_Mail_Transport_Smtp*\
对象的构造代价并不昂贵。这两行可以添加在脚本程序的配置文件(例如config.inc或者类似文件)中，从而为整个脚本程序配置
*Zend_Mail*\ 类的行为。如此可以把配置信息从应用程序逻辑分离出来邮件是通过SMTP还是
`mail()`_\ 发送，使用什么邮件服务器等等。



.. _`mail()`: http://php.net/mail
