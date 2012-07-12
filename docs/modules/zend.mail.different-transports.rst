
Using Different Transports
==========================

In case you want to send different e-mails through different connections, you can also pass the transport object directly to ``send()`` without a prior call to ``setDefaultTransport()`` . The passed object will override the default transport for the actual ``send()`` request.

.. note::
    **Additional transports**

    Additional transports can be written by implementing ``Zend_Mail_Transport_Interface`` .


