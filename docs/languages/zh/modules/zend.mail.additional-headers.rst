.. _zend.mail.additional-headers:

Additional Headers
==================

``Zend\Mail\Message`` provides several methods to set additional Mail Headers:



   - ``setReplyTo($email, $name=null)``: sets the Reply-To: header.

   - ``setDate($date = null)``: sets the Date: header. This method uses current time stamp by default. Or You can
     pass time stamp, date string or ``DateTime`` instance to this method.

   - ``setMessageId($id = true)``: sets the Message-Id: header. This method can generate message ID automatically
     by default. Or You can pass your message ID string to this method. This method call ``createMessageId()``
     internally.



.. note::

   **Return-Path**

   If you set Return-Path on your mail, see :ref:`Configuring sendmail transport
   <zend.mail.introduction.sendmail>`. Unfortunately, ``setReturnPath($email)`` method does not perform this
   purpose.

Furthermore, arbitrary mail headers can be set by using the ``addHeader()`` method. It requires two parameters
containing the name and the value of the header field. A third optional parameter determines if the header should
have only one or multiple values:

.. _zend.mail.additional-headers.example-1:

.. rubric:: Adding E-Mail Message Headers

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Message();
   $mail->addHeader('X-MailGenerator', 'MyCoolApplication');
   $mail->addHeader('X-greetingsTo', 'Mom', true); // multiple values
   $mail->addHeader('X-greetingsTo', 'Dad', true);


