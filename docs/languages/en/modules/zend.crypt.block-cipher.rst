.. _zend.crypt.blockcipher:

Encrypt/decrypt using block ciphers
===================================

``Zend\Crypt\BlockCipher`` implements the encrypt-then-authenticate mode using `HMAC`_ to provide authentication.

The symmetric cipher can be choose with a specific adapter that implements the
``Zend\Crypt\Symmetric\SymmetricInterface``. We support the standard algorithms of the `Mcrypt`_ extension. The
adapter that implements the Mcrypt is ``Zend\Crypt\Symmetric\Mcrypt``.

In the following code we reported an example on how to use the BlockCipher class to encrypt-then-authenticate a
string using the `AES`_ block cipher (with a key of 256 bit) and the HMAC algorithm (using the `SHA-256`_ hash
function).

.. code-block:: php
   :linenos:

   use Zend\Crypt\BlockCipher;

   $blockCipher = BlockCipher::factory('mcrypt', array('algo' => 'aes'));
   $blockCipher->setKey('encryption key');
   $result = $blockCipher->encrypt('this is a secret message');
   echo "Encrypted text: $result \n";

The BlockCipher is initialized using a factory method with the name of the cipher adapter to use (mcrypt) and the
parameters to pass to the adapter (the AES algorithm). In order to encrypt a string we need to specify an
encryption key and we used the ``setKey()`` method for that scope. The encryption is provided by the ``encrypt()``
method.

The output of the encryption is a string, encoded in Base64 (default), that contains the HMAC value, the IV vector,
and the encrypted text. The encryption mode used is the `CBC`_ (with a random `IV`_ by default) and SHA256 as default
hash algorithm of the HMAC.
The Mcrypt adapter encrypts using the `PKCS#7 padding`_ mechanism by default. You can specify a different padding
method using a special adapter for that (Zend\\Crypt\\Symmetric\\Padding). The encryption and authentication keys
used by the ``BlockCipher`` are generated with the `PBKDF2`_ algorithm, used as key derivation function from the
user's key specified using the ``setKey()`` method.

.. note::

   **Key size**

   BlockCipher try to use always the longest size of the key for the specified cipher. For instance, for the
   AES algorithm it uses 256 bits and for the `Blowfish`_ algorithm it uses 448 bits.

You can change all the default settings passing the values to the factory parameters. For instance, if you want to
use the Blowfish algorithm, with the CFB mode and the SHA512 hash function for HMAC you have to initialize the
class as follow:

.. code-block:: php
   :linenos:

   use Zend\Crypt\BlockCipher;

   $blockCipher = BlockCipher::factory('mcrypt', array(
                                   'algo' => 'blowfish',
                                   'mode' => 'cfb',
                                   'hash' => 'sha512'
                               ));

.. note::

   **Recommendation**

   If you are not familiar with symmetric encryption techniques we strongly suggest to use the default values of
   the ``BlockCipher`` class. The default values are: AES algorithm, CBC mode, HMAC with SHA256, PKCS#7 padding.

To decrypt a string we can use the ``decrypt()`` method. In order to successfully decrypt a string we have to
configure the BlockCipher with the same parameters of the encryption. 

We can also initialize the BlockCipher manually without use the factory method. We can inject the symmetric cipher
adapter directly to the constructor of the BlockCipher class. For instance, we can rewrite the previous example as
follow:

.. code-block:: php
   :linenos:

   use Zend\Crypt\BlockCipher;
   use Zend\Crypt\Symmetric\Mcrypt;

   $blockCipher = new BlockCipher(new Mcrypt(array('algo' => 'aes')));
   $blockCipher->setKey('encryption key');
   $result = $blockCipher->encrypt('this is a secret message');
   echo "Encrypted text: $result \n";



.. _`HMAC`: http://en.wikipedia.org/wiki/HMAC
.. _`Mcrypt`: http://php.net/manual/en/book.mcrypt.php
.. _`AES`: http://en.wikipedia.org/wiki/Advanced_Encryption_Standard
.. _`SHA-256`: http://en.wikipedia.org/wiki/SHA-2
.. _`CBC`: http://en.wikipedia.org/wiki/Block_cipher_modes_of_operation#Cipher-block_chaining_.28CBC.29
.. _`IV`: http://en.wikipedia.org/wiki/Initialization_vector
.. _`PKCS#7 padding`: http://en.wikipedia.org/wiki/Padding_%28cryptography%29
.. _`PBKDF2`: http://en.wikipedia.org/wiki/PBKDF2
.. _`Blowfish`: http://en.wikipedia.org/wiki/Blowfish_%28cipher%29
