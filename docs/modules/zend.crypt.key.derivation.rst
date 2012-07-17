
.. _zend.crypt.key.derivation:

Key derivation function
=======================

In cryptography, a key derivation function (or KDF) derives one or more secret keys from a secret value such as a master key or other known information such as a password or passphrase using a pseudo-random function. For instance, a KDF function can be used to generate encryption or authentication keys from a user password. The ``Zend\Crypt\Key\Derivation`` implements a key derivation function using specific adapters.

The adapter implemented so far is the `PBKDF2`_ algorithm. In the example below we show how to use it:

.. code-block:: php
   :linenos:

   use Zend\Crypt\Key\Derivation\PBKDF2;
   use Zend\Math\Math;

   $pass = 'password';
   $salt = Math::randBytes(strlen($pass), true);
   $key  = PBKDF2::calc('sha256', $pass, $salt, 10000, strlen($pass)*2);

   echo "Original password: $pass \n";
   echo "Key derivation   : $key \n";

In this example the PBKDF2 algorithm takes the password ($pass) and generate a binary key with a size double of the password. The syntax of PBKDF2 is ``calc($hash, $pass, $salt, $iterations, $length)`` where $hash is the name of the hash function to use, $pass is the password, $salt is a pseudo random value, $iterations is the number of iterations of the algorithm and $length is the size of the key to be generated. We used the ``randBytes()`` function of the ``Zend\Math\Math`` class to generate a random bytes using strong generators (the true options means the usage of strong generators).

The number of iterations is a very important parameter for the security of the algorithm. Big values means more security. There is not a fixed value for that because the number of iterations depends on the CPU power. You should choose a number of iteration that prevent brute force attacks. For instance, a value of 1'000'000 iterations, that is equal to 1 sec of elaboration for the PBKDF2 algorithm, is enough secure using an Intel Core i5-2500 CPU at 3.3 Ghz.



.. _`PBKDF2`: http://en.wikipedia.org/wiki/PBKDF2
