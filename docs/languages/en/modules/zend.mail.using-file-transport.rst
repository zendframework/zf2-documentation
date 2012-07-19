.. _zend.mail.file-transport:

Using File Transport
====================

``Zend_Mail_Transport_File`` is useful in a development environment or for testing purposes. Instead of sending any
real emails it simply dumps the email's body and headers to a file in the filesystem. Like the other transports it
may be configured using ``Zend_Application_Resource_Mail`` or passed to the ``send()`` method of a ``Zend_Mail``
instance.

The transport has two optional parameters that can be passed to the constructor or via ``setOptions()`` method. The
``path`` option specifies the base path where new files are saved. If nothing is set transport tries to get the
default system directory for temporary files calling ``sys_get_temp_dir``. The second parameter, ``callback``,
defines what function is used to generate a filename. As an example, assume we need to use recipient's email plus
some hash as the filename:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail();
   $mail->addTo('somebody@example.com', 'Some Recipient');
   // build message...
   $tr = new Zend_Mail_Transport_File(array('callback' => function ($transport){
       return $transport->recipients . '_' . mt_rand() . '.tmp';
   }));
   $mail->send($tr);

The resulting file will be something like ``somebody@example.com_1493362665.tmp``


