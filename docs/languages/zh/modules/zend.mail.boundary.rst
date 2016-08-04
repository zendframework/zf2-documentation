.. _zend.mail.boundary:

Controlling the MIME Boundary
=============================

In a multipart message, a *MIME* boundary for separating the different parts of the message is normally generated
at random. In some cases, however, you might want to specify the *MIME* boundary that is used. This can be done
using the ``setMimeBoundary()`` method, as in the following example:

.. _zend.mail.boundary.example-1:

.. rubric:: Changing the MIME Boundary

.. code-block:: php
   :linenos:

   $mail = new Zend\Mail\Message();
   $mail->setMimeBoundary('=_' . md5(microtime(1) . $someId++));
   // build message...


