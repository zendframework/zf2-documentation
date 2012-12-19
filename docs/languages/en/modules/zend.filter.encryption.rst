.. _zend.filter.set.encrypt:

Encrypt and Decrypt
-------------------

These filters allow to encrypt and decrypt any given string. Therefor they make use of Adapters. Actually there are
adapters for the ``Mcrypt`` and ``OpenSSL`` extensions from *PHP*.

.. _zend.filter.set.encrypt.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\Encrypt`` and ``Zend\Filter\Decrypt``:

- **adapter**: This sets the encryption adapter which should be used

- **algorithm**: Only ``MCrypt``. The algorithm which has to be used. It should be one of the algorithm ciphers
  which can be found under `PHP's mcrypt ciphers`_. If not set it defaults to ``blowfish``.

- **algorithm_directory**: Only ``MCrypt``. The directory where the algorithm can be found. If not set it defaults
  to the path set within the mcrypt extension.

- **compression**: If the encrypted value should be compressed. Default is no compression.

- **envelope**: Only ``OpenSSL``. The encrypted envelope key from the user who encrypted the content. You can
  either provide the path and filename of the key file, or just the content of the key file itself. When the
  ``package`` option has been set, then you can omit this parameter.

- **key**: Only ``MCrypt``. The encryption key with which the input will be encrypted. You need the same key for
  decryption.

- **mode**: Only ``MCrypt``. The encryption mode which has to be used. It should be one of the modes which can be
  found under `PHP's mcrypt modes`_. If not set it defaults to 'cbc'.

- **mode_directory**: Only ``MCrypt``. The directory where the mode can be found. If not set it defaults to the
  path set within the ``Mcrypt`` extension.

- **package**: Only ``OpenSSL``. If the envelope key should be packed with the encrypted value. Default is
  ``FALSE``.

- **private**: Only ``OpenSSL``. Your private key which will be used for encrypting the content. Also the private
  key can be either a filename with path of the key file, or just the content of the key file itself.

- **public**: Only ``OpenSSL``. The public key of the user whom you want to provide the encrpted content. You can
  give multiple public keys by using an array. You can eigther provide the path and filename of the key file, or
  just the content of the key file itself.

- **salt**: Only ``MCrypt``. If the key should be used as salt value. The key used for encryption will then itself
  also be encrypted. Default is ``FALSE``.

- **vector**: Only ``MCrypt``. The initialization vector which shall be used. If not set it will be a random
  vector.

.. _zend.filter.set.encrypt.adapterusage:

.. rubric:: Adapter Usage

As these two encryption methodologies work completely different, also the usage of the adapters differ. You have to
select the adapter you want to use when initiating the filter.

.. code-block:: php
   :linenos:

   // Use the Mcrypt adapter
   $filter1 = new Zend\Filter\Encrypt(array('adapter' => 'mcrypt'));

   // Use the OpenSSL adapter
   $filter2 = new Zend\Filter\Encrypt(array('adapter' => 'openssl'));

To set another adapter you can also use ``setAdapter()``, and the ``getAdapter()`` method to receive the actual set
adapter.

.. code-block:: php
   :linenos:

   // Use the Mcrypt adapter
   $filter = new Zend\Filter\Encrypt();
   $filter->setAdapter('openssl');

.. note::

   When you do not supply the ``adapter`` option or do not use ``setAdapter()``, then the ``Mcrypt`` adapter will
   be used per default.

.. _zend.filter.set.encrypt.mcrypt:

.. rubric:: Encryption with Mcrypt

When you have installed the ``Mcrypt`` extension you can use the ``Mcrypt`` adapter. If you provide a string
instead of an array of options, this string will be used as key.

You can get and set the encryption values also afterwards with the ``getEncryption()`` and ``setEncryption()``
methods.

.. note::

   Note that you will get an exception if the mcrypt extension is not available in your environment.

.. note::

   You should also note that all settings which be checked when you create the instance or when you call
   ``setEncryption()``. If mcrypt detects problem with your settings an exception will be thrown.

You can get or set the encryption vector by calling ``getVector()`` and ``setVector()``. A given string will be
truncated or padded to the needed vector size of the used algorithm.

.. note::

   Note that when you are not using an own vector, you must get the vector and store it. Otherwise you will not be
   able to decode the encoded string.

.. code-block:: php
   :linenos:

   // Use the default blowfish settings
   $filter = new Zend\Filter\Encrypt('myencryptionkey');

   // Set a own vector, otherwise you must call getVector()
   // and store this vector for later decryption
   $filter->setVector('myvector');
   // $filter->getVector();

   $encrypted = $filter->filter('text_to_be_encoded');
   print $encrypted;

   // For decryption look at the Decrypt filter

.. _zend.filter.set.encrypt.mcryptdecrypt:

.. rubric:: Decryption with Mcrypt

For decrypting content which was previously encrypted with ``Mcrypt`` you need to have the options with which the
encryption has been called.

There is one eminent difference for you. When you did not provide a vector at encryption you need to get it after
you encrypted the content by using the ``getVector()`` method on the encryption filter. Without the correct vector
you will not be able to decrypt the content.

As soon as you have provided all options decryption is as simple as encryption.

.. code-block:: php
   :linenos:

   // Use the default blowfish settings
   $filter = new Zend\Filter\Decrypt('myencryptionkey');

   // Set the vector with which the content was encrypted
   $filter->setVector('myvector');

   $decrypted = $filter->filter('encoded_text_normally_unreadable');
   print $decrypted;

.. note::

   Note that you will get an exception if the mcrypt extension is not available in your environment.

.. note::

   You should also note that all settings which be checked when you create the instance or when you call
   ``setEncryption()``. If mcrypt detects problem with your settings an exception will be thrown.

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

The ``compression`` option can eighter be set to the name of a compression adapter, or to an array which sets all
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



.. _`PHP's mcrypt ciphers`: http://php.net/mcrypt
.. _`PHP's mcrypt modes`: http://php.net/mcrypt
