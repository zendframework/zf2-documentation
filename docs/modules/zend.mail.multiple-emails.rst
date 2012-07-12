
Sending Multiple Mails per SMTP Connection
==========================================

By default, a single SMTP transport creates a single connection and re-uses it for the lifetime of the script execution. You may send multiple e-mails through this SMTP connection. A RSET command is issued before each delivery to ensure the correct SMTP handshake is followed.

Optionally, you can also define a default From email address and name, as well as a default reply-to header. This can be done through the static methods ``setDefaultFrom()`` and ``setDefaultReplyTo()`` . These defaults will be used when you don't specify a From/Reply-to Address or -Name until the defaults are reset (cleared). Resetting the defaults can be done through the use of the ``clearDefaultFrom()`` and ``clearDefaultReplyTo`` .

If you wish to have a separate connection for each mail delivery, you will need to create and destroy your transport before and after each ``send()`` method is called. Or alternatively, you can manipulate the connection between each delivery by accessing the transport's protocol object.


