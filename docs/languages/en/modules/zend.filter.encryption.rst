.. _zend.filter.set.encrypt:

Encrypt and Decrypt
-------------------

These filters allow to encrypt and decrypt any given string. Therefor they make use of Adapters. Actually there are
adapters for the ``Zend\Crypt\BlockCipher`` class and the ``OpenSSL`` extension of *PHP*.

.. _zend.filter.set.encrypt.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\Encrypt`` and ``Zend\Filter\Decrypt``:

- **adapter**: This sets the encryption adapter which should be used

- **algorithm**: Only ``BlockCipher``. The algorithm which has to be used by the adapter
 ``Zend\Crypt\Symmetric\Mcrypt``. It should be one of the algorithm ciphers supported by
 ``Zend\Crypt\Symmetric\Mcrypt`` (see the ``getSupportedAlgorithms()`` method). If not set it
 defaults to ``aes``, the Advanced Encryption Standard (see :ref:`Zend\\Crypt\\BlockCipher<zend.crypt.blockcipher>`
 for more details).

- **compression**: If the encrypted value should be compressed. Default is no compression.

- **envelope**: Only ``OpenSSL``. The encrypted envelope key from the user who encrypted the content. You can
  either provide the path and filename of the key file, or just the content of the key file itself. When the
  ``package`` option has been set, then you can omit this parameter.

- **key**: Only ``BlockCipher``. The encryption key with which the input will be encrypted. You need the same key
  for decryption.

- **mode**: Only ``BlockCipher``. The encryption mode which has to be used. It should be one of the modes which can
  be found under `PHP's mcrypt modes`_. If not set it defaults to 'cbc'.

- **mode_directory**: Only ``BlockCipher``. The directory where the mode can be found. If not set it defaults to
  the path set within the ``Mcrypt`` extension.

- **package**: Only ``OpenSSL``. If the envelope key should be packed with the encrypted value. Default is
  ``FALSE``.

- **private**: Only ``OpenSSL``. Your private key which will be used for encrypting the content. Also the private
  key can be either a filename with path of the key file, or just the content of the key file itself.

- **public**: Only ``OpenSSL``. The public key of the user whom you want to provide the encrypted content. You can
  give multiple public keys by using an array. You can either provide the path and filename of the key file, or
  just the content of the key file itself.

- **vector**: Only ``BlockCipher``. The initialization vector which shall be used. If not set it will be a random
  vector.

.. _zend.filter.set.encrypt.adapterusage:

.. rubric:: Adapter Usage

As these two encryption methodologies work completely different, also the usage of the adapters differ. You have to
select the adapter you want to use when initiating the filter.

.. code-block:: php
   :linenos:

   // Use the BlockCipher adapter
   $filter1 = new Zend\Filter\Encrypt(array('adapter' => 'BlockCipher'));

   // Use the OpenSSL adapter
   $filter2 = new Zend\Filter\Encrypt(array('adapter' => 'openssl'));

To set another adapter you can also use ``setAdapter()``, and the ``getAdapter()`` method to receive the actual set
adapter.

.. code-block:: php
   :linenos:

   // Use the OpenSSL adapter
   $filter = new Zend\Filter\Encrypt();
   $filter->setAdapter('openssl');

.. note::

   When you do not supply the ``adapter`` option or do not use ``setAdapter()``, then the ``BlockCipher`` adapter
   will be used per default.

.. _zend.filter.set.encrypt.blockcipher:

.. rubric:: Encryption with BlockCipher

To encrypt a string using the ``BlockCipher`` you have to specify the encryption key using the ``setKey()`` method
or passing it during the constructor.

.. code-block:: php
   :linenos:

   // Use the default AES encryption algorithm
   $filter = new Zend\Filter\Encrypt(array('adapter' => 'BlockCipher'));
   $filter->setKey('encryption key');

   // or
   // $filter = new Zend\Filter\Encrypt(array(
   //     'adapter' => 'BlockCipher',
   //     'key'     => 'encryption key'
   // ));

   $encrypted = $filter->filter('text to be encrypted');
   printf ("Encrypted text: %s\n", $encrypted);


You can get and set the encryption values also afterwards with the ``getEncryption()`` and ``setEncryption()``
methods.

.. code-block:: php
   :linenos:

   // Use the default AES encryption algorithm
   $filter = new Zend\Filter\Encrypt(array('adapter' => 'BlockCipher'));
   $filter->setKey('encryption key');
   var_dump($filter->getEncryption());

   // Will print:
   //array(4) {
   //  ["key_iteration"]=>
   //  int(5000)
   //  ["algorithm"]=>
   //  string(3) "aes"
   //  ["hash"]=>
   //  string(6) "sha256"
   //  ["key"]=>
   //  string(14) "encryption key"
   //}

.. note::

   The ``BlockCipher`` adapter uses the `Mcrypt`_ PHP extension by default. That means you will need to
   install the `Mcrypt` module in your PHP environment.

If you don't specify an initialization Vector (`salt` or `iv`), the BlockCipher will generate a random value
during each encryption. If you try to execute the following code the output will be always different (note
that even if the output is always different you can decrypt it using the same key).

.. code-block:: php
   :linenos:

   $key  = 'encryption key';
   $text = 'message to encrypt';

   // use the default adapter that is BlockCipher
   $filter = new \Zend\Filter\Encrypt();
   $filter->setKey('encryption key');
   for ($i=0; $i < 10; $i++) {
      printf("%d) %s\n", $i, $filter->filter($text));
   }

If you want to obtain the same output you need to specify a fixed Vector, using the `setVector()` method.
This script will produce always the same encryption output.

.. code-block:: php
   :linenos:

   // use the default adapter that is BlockCipher
   $filter = new \Zend\Filter\Encrypt();
   $filter->setKey('encryption key');
   $filter->setVector('12345678901234567890');
   printf("%s\n", $filter->filter('message'));

   // output:
   // 04636a6cb8276fad0787a2e187803b6557f77825d5ca6ed4392be702b9754bb3MTIzNDU2Nzg5MDEyMzQ1NgZ+zPwTGpV6gQqPKECinig=

.. note::

   For a security reason it's always better to use a different Vector on each encryption. We suggest to use the
   `setVector()` method only if you really need it.

.. _zend.filter.set.encrypt.mcryptdecrypt:

.. rubric:: Decryption with BlockCipher

For decrypting content which was previously encrypted with ``BlockCipher`` you need to have the options with which
the encryption has been called.

If you used only the encryption key, you can just use it to decrypt the content. As soon as you have provided
all options decryption is as simple as encryption.

.. code-block:: php
   :linenos:

   $content = '04636a6cb8276fad0787a2e187803b6557f77825d5ca6ed4392be702b9754bb3MTIzNDU2Nzg5MDEyMzQ1NgZ+zPwTGpV6gQqPKECinig=';
   // use the default adapter that is BlockCipher
   $filter = new Zend\Filter\Decrypt();
   $filter->setKey('encryption key');
   printf("Decrypt: %s\n", $filter->filter($content));

   // output:
   // Decrypt: message

Note that even if we did not specify the same Vector, the ``BlockCipher`` is able to decrypt the message because
the Vector is stored in the encryption string itself (note that the Vector can be stored in plaintext, it is not a
secret, the Vector is only used to improve the randomness of the encryption algorithm).


.. note::

   You should also note that all settings which be checked when you create the instance or when you call
   ``setEncryption()``.

.. _zend.filter.set.encrypt.openssl:

.. rubric:: Encryption with OpenSSL

When you have installed the ``OpenSSL`` extension you can use the ``OpenSSL`` adapter. You can get or set the
public keys also afterwards with the ``getPublicKey()`` and ``setPublicKey()`` methods. The private key can also be
get and set with the related ``getPrivateKey()`` and ``setPrivateKey()`` methods.

.. code-block:: php
   :linenos:

   // Use openssl and provide a private key
   $filter = new Zend\Filter\Encrypt(array(
      'adapter' => 'openssl',
      'private' => '/path/to/mykey/private.pem'
   ));

   // of course you can also give the public keys at initiation
   $filter->setPublicKey(array(
      '/public/key/path/first.pem',
      '/public/key/path/second.pem'
   ));

.. note::

   Note that the ``OpenSSL`` adapter will not work when you do not provide valid keys.

When you want to encode also the keys, then you have to provide a passphrase with the ``setPassphrase()`` method.
When you want to decode content which was encoded with a passphrase you will not only need the public key, but also
the passphrase to decode the encrypted key.

.. code-block:: php
   :linenos:

   // Use openssl and provide a private key
   $filter = new Zend\Filter\Encrypt(array(
      'adapter' => 'openssl',
      'private' => '/path/to/mykey/private.pem'
   ));

   // of course you can also give the public keys at initiation
   $filter->setPublicKey(array(
      '/public/key/path/first.pem',
      '/public/key/path/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

At last, when you use OpenSSL you need to give the receiver the encrypted content, the passphrase when have
provided one, and the envelope keys for decryption.

This means for you, that you have to get the envelope keys after the encryption with the ``getEnvelopeKey()``
method.

So our complete example for encrypting content with ``OpenSSL`` look like this.

.. code-block:: php
   :linenos:

   // Use openssl and provide a private key
   $filter = new Zend\Filter\Encrypt(array(
      'adapter' => 'openssl',
      'private' => '/path/to/mykey/private.pem'
   ));

   // of course you can also give the public keys at initiation
   $filter->setPublicKey(array(
      '/public/key/path/first.pem',
      '/public/key/path/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

   $encrypted = $filter->filter('text_to_be_encoded');
   $envelope  = $filter->getEnvelopeKey();
   print $encrypted;

   // For decryption look at the Decrypt filter

.. _zend.filter.set.encrypt.openssl.simplified:

.. rubric:: Simplified usage with Openssl

As seen before, you need to get the envelope key to be able to decrypt the previous encrypted value. This can be
very annoying when you work with multiple values.

To have a simplified usage you can set the ``package`` option to ``TRUE``. The default value is ``FALSE``.

.. code-block:: php
   :linenos:

   // Use openssl and provide a private key
   $filter = new Zend\Filter\Encrypt(array(
      'adapter' => 'openssl',
      'private' => '/path/to/mykey/private.pem',
      'public'  => '/public/key/path/public.pem',
      'package' => true
   ));

   $encrypted = $filter->filter('text_to_be_encoded');
   print $encrypted;

   // For decryption look at the Decrypt filter

Now the returned value contains the encrypted value and the envelope. You don't need to get them after the
compression. But, and this is the negative aspect of this feature, the encrypted value can now only be decrypted by
using ``Zend\Filter\Encrypt``.

.. _zend.filter.set.encrypt.openssl.compressed:

.. rubric:: Compressing Content

Based on the original value, the encrypted value can be a very large string. To reduce the value
``Zend\Filter\Encrypt`` allows the usage of compression.

The ``compression`` option can either be set to the name of a compression adapter, or to an array which sets all
wished options for the compression adapter.

.. code-block:: php
   :linenos:

   // Use basic compression adapter
   $filter1 = new Zend\Filter\Encrypt(array(
      'adapter'     => 'openssl',
      'private'     => '/path/to/mykey/private.pem',
      'public'      => '/public/key/path/public.pem',
      'package'     => true,
      'compression' => 'bz2'
   ));

   // Use basic compression adapter
   $filter2 = new Zend\Filter\Encrypt(array(
      'adapter'     => 'openssl',
      'private'     => '/path/to/mykey/private.pem',
      'public'      => '/public/key/path/public.pem',
      'package'     => true,
      'compression' => array('adapter' => 'zip', 'target' => '\usr\tmp\tmp.zip')
   ));

.. note::

   **Decryption with same settings**

   When you want to decrypt a value which is additionally compressed, then you need to set the same compression
   settings for decryption as for encryption. Otherwise the decryption will fail.

.. _zend.filter.set.encrypt.openssldecrypt:

.. rubric:: Decryption with OpenSSL

Decryption with ``OpenSSL`` is as simple as encryption. But you need to have all data from the person who encrypted
the content. See the following example:

.. code-block:: php
   :linenos:

   // Use openssl and provide a private key
   $filter = new Zend\Filter\Decrypt(array(
      'adapter' => 'openssl',
      'private' => '/path/to/mykey/private.pem'
   ));

   // of course you can also give the envelope keys at initiation
   $filter->setEnvelopeKey(array(
      '/key/from/encoder/first.pem',
      '/key/from/encoder/second.pem'
   ));

.. note::

   Note that the ``OpenSSL`` adapter will not work when you do not provide valid keys.

Optionally it could be necessary to provide the passphrase for decrypting the keys themself by using the
``setPassphrase()`` method.

.. code-block:: php
   :linenos:

   // Use openssl and provide a private key
   $filter = new Zend\Filter\Decrypt(array(
      'adapter' => 'openssl',
      'private' => '/path/to/mykey/private.pem'
   ));

   // of course you can also give the envelope keys at initiation
   $filter->setEnvelopeKey(array(
      '/key/from/encoder/first.pem',
      '/key/from/encoder/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

At last, decode the content. Our complete example for decrypting the previously encrypted content looks like this.

.. code-block:: php
   :linenos:

   // Use openssl and provide a private key
   $filter = new Zend\Filter\Decrypt(array(
      'adapter' => 'openssl',
      'private' => '/path/to/mykey/private.pem'
   ));

   // of course you can also give the envelope keys at initiation
   $filter->setEnvelopeKey(array(
      '/key/from/encoder/first.pem',
      '/key/from/encoder/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

   $decrypted = $filter->filter('encoded_text_normally_unreadable');
   print $decrypted;



.. _`Mcrypt`: http://php.net/mcrypt
.. _`PHP's mcrypt modes`: http://php.net/manual/en/mcrypt.constants.php
