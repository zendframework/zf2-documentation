.. _zend.crypt.introduction:

Introduction to Zend\\Crypt
===========================

Zend\\Crypt provides support of some cryptographic tools. The available features are:

- encrypt-then-authenticate using symmetric ciphers (the authentication step is provided using HMAC);

- encrypt/decrypt using symmetric and public key algorithm (e.g. RSA algorithm);

- generate digital sign using public key algorithm (e.g. RSA algorithm);

- key exchange using the Diffie-Hellman method;

- Key derivation function (e.g. using PBKDF2 algorithm);

- Secure password hash (e.g. using Bcrypt algorithm);

- generate Hash values;

- generate HMAC values;

The main scope of this component is to offer an easy and secure way to protect and authenticate sensitive data in
PHP. Because the use of cryptography is not so easy we recommend to use the ``Zend\Crypt`` component only if you
have a minimum background on this topic. For an introduction to cryptography we suggest the following references:

   - Dan Boneh `"Cryptography course"`_ Stanford University, Coursera - free online course

   - N.Ferguson, B.Schneier, and T.Kohno, `"Cryptography Engineering"`_, John Wiley & Sons (2010)

   - B.Schneier `"Applied Cryptography"`_, John Wiley & Sons (1996)


.. note::

   **PHP-CryptLib**

   Most of the ideas behind the ``Zend\Crypt`` component have been inspired by the `PHP-CryptLib project`_ of
   `Anthony Ferrara`_. PHP-CryptLib is an all-inclusive pure PHP cryptographic library for all cryptographic needs.
   It is meant to be easy to install and use, yet extensible and powerful enough for even the most experienced
   developer.

.. _`"Cryptography course"`: https://www.coursera.org/course/crypto
.. _`"Cryptography Engineering"`: http://www.schneier.com/book-ce.html
.. _`"Applied Cryptography"`: http://www.schneier.com/book-applied.html
.. _`PHP-CryptLib project`: https://github.com/ircmaxell/PHP-CryptLib
.. _`Anthony Ferrara`: http://blog.ircmaxell.com/
