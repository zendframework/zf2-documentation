
Securing SMTP Transport
=======================

``Zend_Mail`` also supports the use of either TLS or *SSL* to secure a SMTP connection. This can be enabled be passing the 'ssl' parameter to the configuration array in the ``Zend_Mail_Transport_Smtp`` constructor with a value of either 'ssl' or 'tls'. A port can optionally be supplied, otherwise it defaults to 25 for TLS or 465 for *SSL* .


