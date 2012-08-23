.. EN-Revision: none
.. _zend.filter.set.encrypt:

Encrypt
=======

Ce filtre va crypter toute chaine avec les paramètres spécifiés. Des adaptateurs sont utilisés. Actuellement,
il existe des adaptateurs pour les extensions PHP *Mcrypt* et *OpenSSL*.

Comme ces deux méthodes d'encryptage sont très différentes, l'utilisation de leurs adaptateurs l'est aussi.

.. code-block:: php
   :linenos:

   // Utiliser Mcrypt
   $filter1 = new Zend_Filter_Encrypt(array('adapter' => 'mcrypt'));

   // Utiliser OpenSSL
   $filter2 = new Zend_Filter_Encrypt(array('adapter' => 'openssl'));

Les méthodes *setAdapter()* et *getAdapter()* existent aussi.

.. code-block:: php
   :linenos:

   // Utiliser Mcrypt
   $filter = new Zend_Filter_Encrypt();
   $filter->setAdapter('openssl');

.. note::

   Si vous ne précisez pas d'adaptateur, *Mcrypt* est utilisé par défaut.

.. _zend.filter.set.encrypt.mcrypt:

Cryptage avec Mcrypt
--------------------

Cet adaptateur nécessite la présence de l'extension PHP *Mcrypt*. Voici ses options:

- **key**: La clé d'encryptage. Cette même clé sera nécessaire pour le décryptage.

- **algorithm**: L'algorithme à utiliser pour le cryptage. Voyez `PHP's mcrypt ciphers`_. Si non précisé,
  *blowfish* sera utilisé par défaut.

- **algorithm_directory**: Le dossier dans lequel se trouve l'algorithme. Si non précisé, le dossier spécifié
  par l'extension mcrypt est alors utilisé.

- **mode**: Le mode de cryptage à utiliser. Un des `modes mcrypt`_ doit être utilisé. Par défaut, *cbc* est
  utilisé.

- **mode_directory**: Le dossier dans lequel se trouve le mode. Si non précisé, le dossier spécifié par
  l'extension mcrypt est alors utilisé.

- **vector**: Le vecteur d'initialisation à utiliser. Un vecteur aléatoire est utilisé si non précisé.

- **salt**: Si la clé doit être utilisé comme grain de sel. Dans ce cas la clé utilisée pour le cryptage sera
  elle même cryptée. Par défaut false : ce n'est pas le cas.

Si vous passez une chaine à la place d'un tableau pour la clé, celle-ci sera utilisée.

Les méthodes *getEncryption()* et *setEncryption()* sont aussi présentes.

.. note::

   Une exception sera levée si l'extension PHP mcrypt n'est pas disponible.

.. note::

   Notez aussi que tous vos paramètres utilisés à la création de l'instance ou avec setEncryption() vont être
   vérifiés. Si mcrypt détecte un problème, une exception sera levée.

*getVector()* et *setVector()* sont aussi disponibles si besoin. Une chaine passée sera mise à la taille du
vecteur pour être utilisée avec l'algorithme en cours.

.. note::

   Notez que si vous n'utilisez pas un vecteur spécifique, alors vous devrez le récupérer et le stocker. En
   effet, celui-ci est indispensable pour décoder la valeur dans le futur.

.. code-block:: php
   :linenos:

   // Utilise blowfish par défaut
   $filter = new Zend_Filter_Encrypt('myencryptionkey');

   // Affecte un vecteur précis.
   $filter->setVector('myvector');
   // $filter->getVector(); est nécessaire sinon, pour décoder la valeur plus tard

   $encrypted = $filter->filter('text_to_be_encoded');
   print $encrypted;

   // Pour le décryptage, voyez le code du filtre Decrypt

.. _zend.filter.set.encrypt.openssl:

Cryptage avec OpenSSL
---------------------

Lorsque vous avez installé l'extension PHP *OpenSSL*, vous pouvez utiliser l'adaptateur du même nom, dont voici
les options d'instanciation:

- **public**: La clé publique de l'utilisateur auquel vous voulez proposer du contenu crypté. Plusieurs clés
  peuvent être spécifiées via un tableau. Il est possible de préciser le contenu de la clé, ou alors un chemin
  vers une clé.

- **private**: Votre clé privée utilisée pour crypter le contenu. La encore la clé peut être précisée sous
  forme textuelle, ou alors un chemin vers un fichier contenant la clé.

*getPublicKey()* et *setPublicKey()* sont aussi présentes, ainsi que *getPrivateKey()* et *setPrivateKey()*.

.. code-block:: php
   :linenos:

   // Utiliser openssl
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // utilisation des méthodes
   $filter->setPublicKey(array(
       '/public/key/path/first.pem',
       '/public/key/path/second.pem'
   ));

.. note::

   Attention l'adaptateur *OpenSSL* ne fonctionnera pas si vous ne passez pas des clés valides.

Si vous souhaitez encoder aussi les clés, passez alors une passphrase via *setPassphrase()*. Attention, la
passphrase sera nécessaire pour décoder les clés.

.. code-block:: php
   :linenos:

   // Utilise openssl avec une clé privée
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // utilisation des méthodes pour specifier la clé publique
   $filter->setPublicKey(array(
       '/public/key/path/first.pem',
       '/public/key/path/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

Pour décrypter le document, la passphrase (si utilisée) et les clés enveloppe sont nécessaires.

Ceci signifie que vous devez appeler la méthode *getEnvelopeKey()* après le cryptage pour récupérer
l'enveloppe.

Voici donc un exemple complet de cryptage de données avec *OpenSSL*.

.. code-block:: php
   :linenos:

   // Utilisons openssl avec une clé privée
   $filter = new Zend_Filter_Encrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // Voici la clé publique
   $filter->setPublicKey(array(
       '/public/key/path/first.pem',
       '/public/key/path/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

   $encrypted = $filter->filter('text_to_be_encoded');
   $envelope  = $filter->getEnvelopeKey();
   print $encrypted;

   // Le décryptage est expliqué dans le filtre Decrypt



.. _`PHP's mcrypt ciphers`: http://php.net/mcrypt
.. _`modes mcrypt`: http://php.net/mcrypt
