.. _zend.crypt.key.derivation:

Key derivation function
=======================

In cryptography, a key derivation function (or KDF) derives one or more secret keys from a secret value such as a
master key or other known information such as a password or passphrase using a pseudo-random function. For
instance, a KDF function can be used to generate encryption or authentication keys from a user password. The
``Zend\Crypt\Key\Derivation`` implements a key derivation function using specific adapters.

User passwords are not really suitable to be used as keys in cryptographic algorithms, since users normally choose
keys they can write on keyboard. These passwords use only 6 to 7 bits per character (or less). It is highly
recommended to use always a KDF function to transform a user's password in a cryptographic key.

The output of the following key derivation functions is a binary string. If you need to store the value in a
database or a different persistent storage, we suggest to convert it in Base64 format, using `base64_encode()`_
function, or in hex format, using the `bin2hex()`_ function.

.. _zend.crypt.key.derivation.pbkdf2:

Pbkdf2 adapter
--------------

`Pbkdf2`_ is a KDF that applies a pseudorandom function, such as a cryptographic hash, to the input password
or passphrase along with a salt value and repeats the process many times to produce a derived key, which can
then be used as a cryptographic key in subsequent operations.
The added computational work makes password cracking much more difficult, and is known as `key stretching`_.

In the example below we show a typical usage of the ``Pbkdf2`` adapter.

.. code-block:: php
   :linenos:

   use Zend\Crypt\Key\Derivation\Pbkdf2;
   use Zend\Math\Rand;

   $pass = 'password';
   $salt = Rand::getBytes(strlen($pass), true);
   $key  = Pbkdf2::calc('sha256', $pass, $salt, 10000, strlen($pass)*2);

   printf ("Original password: %s\n", $pass);
   printf ("Derived key (hex): %s\n", bin2hex($key));

The ``Pbkdf2`` adapter takes the password (``$pass``) and generate a binary key with a size double of
the password. The syntax is ``calc($hash, $pass, $salt, $iterations, $length)`` where ``$hash`` is the name of
the hash function to use, ``$pass`` is the password, ``$salt`` is a pseudo random value, ``$iterations`` is
the number of iterations of the algorithm and ``$length`` is the size of the key to be generated. 
We used the ``Rand::getBytes`` function of the ``Zend\Math\Rand`` class to generate a random bytes using
a strong generators (the ``true`` value means the usage of strong generators).

The number of iterations is a very important parameter for the security of the algorithm. Big values means more
security. There is not a fixed value for that because the number of iterations depends on the CPU power.
You should always choose a number of iteration that prevent brute force attacks. For instance, a value of
1'000'000 iterations, that is equal to 1 sec of elaboration for the PBKDF2 algorithm, is enough secure using
an Intel Core i5-2500 CPU at 3.3 Ghz.

.. _zend.crypt.key.derivation.salteds2k:

SaltedS2k adapter
-----------------

The `SaltedS2k`_ algorithm uses an hash function and a salt to generate a key based on a user's password.
This algorithm doesn't use a parameter that specify the number of iterations and for that reason it's
considered less secure compared with Pbkdf2. 
We suggest to use the SaltedS2k algorithm only if you really need it.

Below is reported a usage example of the ``SaltedS2k`` adapter.

.. code-block:: php
   :linenos:

   use Zend\Crypt\Key\Derivation\SaltedS2k;
   use Zend\Math\Rand;

   $pass = 'password';
   $salt = Rand::getBytes(strlen($pass), true);
   $key  = SaltedS2k::calc('sha256', $pass, $salt, strlen($pass)*2);

   printf ("Original password: %s\n", $pass);
   printf ("Derived key (hex): %s\n", bin2hex($key));

.. _zend.crypt.key.derivation.scrypt:

Scrypt adapter
--------------

The `scrypt`_ algorithm uses the algorithm `Salsa20/8 core`_ and *Pbkdf2-SHA256* to generate a key based on a user's
password. This algorithm has been designed to be more secure against hardware brute-force attacks than alternative
functions such as `Pbkdf2`_ or `bcrypt`_. 

The scrypt algorithm is based on the idea of memory-hard algorithms and sequential memory-hard functions. 
A memory-hard algorithm is thus an algorithm which asymptotically uses almost as many memory locations as it uses
operations[#f1]_. A natural way to reduce the advantage provided by an attacker’s ability to construct highly parallel
circuits is to increase the size of a single key derivation circuit — if a circuit is twice as large, only half
as many copies can be placed on a given area of silicon — while still operating within the resources available
to software implementations, including a powerful CPU and large amounts of RAM.

    "From a test executed on modern (2009) hardware, if 5 seconds are spent computing a derived key, the cost of a
    hardware brute-force attack against scrypt is roughly 4000 times greater than the cost of a similar attack against
    bcrypt (to find the same password), and 20000 times greater than a similar attack against Pbkdf2."
    *Colin Percival* (the author of scrypt algorithm)


This algorithm uses 4 parameters to generate a key of 64 bytes:

* ``salt``, a random string;
* ``N``, the CPU cost;
* ``r``, the memory cost;
* ``p``, the parallelization cost.

Below is reported a usage example of the ``Scrypt`` adapter.

.. code-block:: php
   :linenos:

   use Zend\Crypt\Key\Derivation\Scrypt;
   use Zend\Math\Rand;

   $pass = 'password';
   $salt = Rand::getBytes(strlen($pass), true);
   $key  = Scrypt::calc($pass, $salt, 2048, 2, 1, 64);

   printf ("Original password: %s\n", $pass);
   printf ("Derived key (hex): %s\n", bin2hex($key));


.. note::

   **Performance of the scrypt implementation**

   The aim of the scrypt algorithm is to generate secure derived key preventing brute force
   attacks. Just like the other derivation functions, the more time (and memory) we spent executing the
   algorithm, the more secure the derived key will be.
   Unfortunately a pure PHP implementation of the scrypt algorithm is very slow compared with
   the C implementation (this is always true, if you compare execution time of C with PHP).
   If you want use a faster scrypt algorithm we suggest to install the `scrypt PECL`_ extension.
   The Scrypt adapter of Zend Framework is able to recognize if the PECL extension is loaded and use it
   instead of the pure PHP implementation.

.. _`base64_encode()`: http://php.net/manual/en/function.base64-encode.php
.. _`bin2hex()`: http://php.net/manual/en/function.bin2hex.php
.. _`Pbkdf2`: http://en.wikipedia.org/wiki/PBKDF2
.. _`key stretching`: http://en.wikipedia.org/wiki/Key_stretching
.. _`SaltedS2k`: http://www.faqs.org/rfcs/rfc2440.html
.. _`scrypt`: http://www.tarsnap.com/scrypt.html
.. _`Salsa20/8 core`: http://cr.yp.to/salsa20.html
.. _`bcrypt`: http://en.wikipedia.org/wiki/Bcrypt
.. _`Scrypt extension for PHP`: https://github.com/DomBlack/php-scrypt
.. _`php.net`: http://www.php.net
.. _`scrypt PECL`: http://pecl.php.net/package/scrypt 
.. [#f1] See Colin Percival's slides on scrypt from BSDCan'09: http://www.tarsnap.com/scrypt/scrypt-slides.pdf
