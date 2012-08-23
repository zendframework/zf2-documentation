.. EN-Revision: none
.. _zend.mail.additional-headers:

En-têtes additionnels
=====================

``Zend_Mail`` provides several methods to set additional Mail Headers:

   - ``setReplyTo($email, $name=null)``: sets the Reply-To: header.

   - ``setDate($date = null)``: sets the Date: header. This method uses current time stamp by default. Or You can
     pass time stamp, date string or ``Zend_Date`` instance to this method.

   - ``setMessageId($id = true)``: sets the Message-Id: header. This method can generate message ID automatically
     by default. Or You can pass your message ID string to this method. This method call ``createMessageId()``
     internally.



.. note::

   **Return-Path**

   If you set Return-Path on your mail, see :ref:`Configuring sendmail transport
   <zend.mail.introduction.sendmail>`. Unfortunately, ``setReturnPath($email)`` method does not perform this
   purpose.

Des en-têtes arbitraires peuvent être définis en utilisant la méthode ``addHeader()``. Elle a besoin de deux
paramètres contenant le nom et la valeur du champ d'en-tête. Un troisième paramètre optionnel détermine si
l'en-tête doit avoir une ou plusieurs valeurs :

.. _zend.mail.additional-headers.example-1:

.. rubric:: Ajouter des en-têtes à l'émail

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->addHeader('X-MailGenerator', 'MaSuperApplication');
   $mail->addHeader('X-greetingsTo', 'Maman', true); // plusieurs valeurs
   $mail->addHeader('X-greetingsTo', 'Papa', true);


