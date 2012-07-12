
HTML E-Mail
===========

To send an e-mail in *HTML* format, set the body using the method ``setBodyHTML()`` instead of ``setBodyText()`` . The *MIME* content type will automatically be set to ``text/html`` then. If you use both *HTML* and Text bodies, a multipart/alternative *MIME* message will automatically be generated:


