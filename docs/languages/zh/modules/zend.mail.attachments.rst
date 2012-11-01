.. EN-Revision: none
.. _zend.mail.attachments:

附件
==

使用 *createAttachment()*\ 方法可以将文件附加到邮件中。 *Zend_Mail*\
会缺省地认为该文件是二进制对象(application/octet-stream)，以 base64编码传输,
并且作为邮件的附件处理。通过传递额外的参数给 *createAttachment()*\
方法可以覆盖上述缺省设定：

.. _zend.mail.attachments.example-1:

.. rubric:: 带附件的邮件

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend\Mail\Mail();
   // build message...
   $mail->createAttachment($someBinaryString);
   $mail->createAttachment($myImage, 'image/gif', Zend\Mime\Mime::DISPOSITION_INLINE, Zend\Mime\Mime::ENCODING_8BIT);

如果你想得到对此附件MIME段产生的更多控制，你可以使用 *createAttachment()*\
方法的返回值来修改它的属性。方法 *createAttachment()*\ 返回了一个 *Zend\Mime\Part*\ 对象：

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend\Mail\Mail();

   $at = $mail->createAttachment($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->send();

创建 *Zend\Mime\Part* 实例和用 *addAttachment()* 添加它的替代方案：

.. code-block:: php
   :linenos:

   <?php
   require_once 'Zend/Mail.php';
   $mail = new Zend\Mail\Mail();

   $at = new Zend\Mime\Part($myImage);
   $at->type        = 'image/gif';
   $at->disposition = Zend\Mime\Mime::DISPOSITION_INLINE;
   $at->encoding    = Zend\Mime\Mime::ENCODING_8BIT;
   $at->filename    = 'test.gif';

   $mail->addAttachment($at);

   $mail->send();


