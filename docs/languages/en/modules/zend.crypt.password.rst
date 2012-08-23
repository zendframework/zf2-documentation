.. _zend.crypt.password:

Secure Password Storing
=======================

``Zend\Crypt\Password`` stores a users password in a secure way using dedicated adapters like the `bcrypt`_
algorithm.

The example below shows how to use the bcrypt algorithm to store a users password:

.. code-block:: php
   :linenos:

   use Zend\Crypt\Password\Bcrypt;

   $bcrypt = new Bcrypt()
   $securePass = $bcrypt->create('user password');

The output of the ``create()`` method is the encrypted password. This value can then be stored in a repository like a
database. Classic hashing mechanisms like MD5 or SHA are not considered secure anymore (`read
this post to know why`_).

To verify if a given password is valid against a bcrypt value you can use the ``verify()`` method. Example time:

.. code-block:: php
   :linenos:

   use Zend\Crypt\Password\Bcrypt;

   $bcrypt = new Bcrypt();
   $securePass = 'the stored bcrypt value';
   $password = 'the password to check';

   if ($bcrypt->verify($password, $bcrypt)) {
       echo "The password is correct! \n";
   } else {
       echo "The password is NOT correct.\n";
   }

By default, the ``Zend\Crypt\Password\Bcrypt`` class uses a value of 14 for bcrypts cost parameter. The cost parameter is an integer between 4 to
33. A greater value means longer execution time for bcrypt, thus more secure against brute force or
dictionary attacks.

If you want to change the cost parameter of the bcrypt algorithm you can use the ``setCost()`` method.

.. note::

   **Bcrypt with non-ASCII passwords (8-bit characters)**

   The bcrypt implementation used by PHP < 5.3.7 can contains a security flaw if the password uses 8-bit characters
   (`here's the security report`_). The impact of this bug was that most (but not all) passwords containing non-ASCII
   characters with the 8th bit set were hashed incorrectly, resulting in password hashes incompatible with those of
   OpenBSD's original implementation of bcrypt. This security flaw has been fixed starting from PHP 5.3.7 and the
   prefix used in the output was changed to '$2y$' in order to put evidence on the correctness of the hash value.
   If you are using PHP < 5.3.7 with 8-bit passwords, the ``Zend\Crypt\Password\Bcrypt`` throws an exception
   suggesting to upgrade to PHP 5.3.7+ or use only 7-bit passwords.



.. _`bcrypt`: http://en.wikipedia.org/wiki/Bcrypt
.. _`read this post to know why`: http://codahale.com/how-to-safely-store-a-password/
.. _`here's the security report`: http://php.net/security/crypt_blowfish.php
