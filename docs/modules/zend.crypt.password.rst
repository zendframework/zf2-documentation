
Password secure storing
=======================

The ``Zend\Crypt\Password`` store a user's password in a secure way using dedicated adapters like the `bcrypt`_ algorithm.

In the example below we show hot to use the bcrypt algorithm to store a user's password:

.. code-block:: php
    :linenos:
    
    use Zend\Crypt\Password\Bcrypt;
    
    $bcrypt = new Bcrypt()
    $securePass = $bcrypt->create('user password');
    

The output of the ``create()`` method is the encrypted password. This value can be stored in a repository, like a database instead of use alternative mechanism like MD5 or MD5 + salt that are not considered secure anymore ( `read this post to know why`_ ).

To verify if a given password is valid against a bcrypt value you can use the ``verify()`` method. Below is reported an example:

.. code-block:: php
    :linenos:
    
    use Zend\Crypt\Password\Bcrypt;
    
    $bcrypt = new Bcrypt();
    $securePass = 'the bcrypt value stored somewhere';
    $password = 'the password to check';
    
    if ($bcrypt->verify($password, $bcrypt)) {
        echo "The password is correct! \n";
    } else {
        echo "The password is NOT correct.\n";
    }
    

By default the ``Zend\Crypt\Password\Bcrypt`` class uses a value of 14 for the cost parameter of the bcrypt. This is an important value for the security of the bcrypt algorithm. The cost parameter is an integer value between 4 to 33. Greater values means more execution time for the bcrypt that means more security against brute force or dictionary attacks. As for the PBKDF2 algorithm there is not a fixed value for that parameter that can be considered secure. The default value of 14 is about 1 second of computation using an Intel Core i5-2500 CPU at 3.3 Ghz that can be considered secure.

If you want to change the cost parameter of the bcrypt algorithm you can use the ``setCost()`` method.

.. note::
    **Bcrypt with non-ASCII passwords (8-bit characters)**

    The bcrypt implementation used by PHP < 5.3.7 can contains a security flaw if the password uses 8-bit characters ( `here the security report`_ ). The impact of this bug was that most (but not all) passwords containing non-ASCII characters with the 8th bit set were hashed incorrectly, resulting in password hashes incompatible with those of OpenBSD's original implementation of bcrypt. This security flaw has been fixed starting from PHP 5.3.7 and the prefix used in the output has changed in '$2y$' in order to put evidence on the correctness of the hash value. If you are using PHP < 5.3.7 with 8-bit passwords the ``Zend\Crypt\Password\Bcrypt`` throws an exception suggesting to upgrade to PHP 5.3.7+ or use only 7-bit passwords.


.. _`bcrypt`: http://en.wikipedia.org/wiki/Bcrypt
.. _`read this post to know why`: http://codahale.com/how-to-safely-store-a-password/
.. _`here the security report`: http://php.net/security/crypt_blowfish.php
