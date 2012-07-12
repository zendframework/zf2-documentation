
SMTP Authentication
===================

``Zend_Mail`` supports the use of SMTP authentication, which can be enabled be passing the 'auth' parameter to the configuration array in the ``Zend_Mail_Transport_Smtp`` constructor. The available built-in authentication methods are PLAIN, LOGIN and CRAM-MD5 which all expect a 'username' and 'password' value in the configuration array.

.. note::
    **Authentication types**

    The authentication type is case-insensitive but has no punctuation. E.g. to use CRAM-MD5 you would pass 'auth' => 'crammd5' in the ``Zend_Mail_Transport_Smtp`` constructor.


