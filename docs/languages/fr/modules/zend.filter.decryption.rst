.. _zend.filter.set.decrypt:

Decrypt
=======

Ce filtre va décrypter toute chaine grâce aux paramètres utilisés. Des adaptateurs sont utilisés. Actuellement
des aptateurs existent pour les extensions *Mcrypt* et *OpenSSL* de php.

Pour plus de détails sur l'encryptage de contenu, voyez le filtre *Encrypt*. La documentation de celui-ci couvre
les bases en matière de cryptage, nous n'aborderons ici que les méthodes utilisées pour le décryptage.

.. _zend.filter.set.decrypt.mcrypt:

Décryptage avec Mcrypt
----------------------

Pour décrypter une données cryptées avec *Mcrypt*, vous avez besoin des paramètres utilisés pour encrypter,
ainsi que du vecteur.

Si vous n'aviez pas passé de vecteur spécifique à l'encryptage, alors vous devriez récupérer le vecteur
utilisé grâce à la méthode ``getVector()``. Sans ce vecteur, aucun décryptage de la données originale n'est
possible.

Le décryptage s'effectue aussi simplement que l'encryptage.

.. code-block:: php
   :linenos:

   // Utilisation des paramètres blowfish par défaut
   $filter = new Zend_Filter_Decrypt('myencryptionkey');

   // Utilisation du vecteur utilisé lors de l'encryptage
   $filter->setVector('myvector');

   $decrypted = $filter->filter('texte_encodé_non_lisible');
   print $decrypted;

.. note::

   Si l'extension mcrypt n'est pas présente dans votre environement, une exception sera levée.

.. note::

   Vos paramètres sont vérifiés à la création de l'instance ou à l'appel de setEncryption(). Si mcrypt
   détecte des problèmes avec ces paramètres, une exception sera levée.

.. _zend.filter.set.decrypt.openssl:

Decryptage avec OpenSSL
-----------------------

Le décryptage avec *OpenSSL* est aussi simple que l'encryptage. Mais vous aurez besoin de toutes les données
concernant la personne ayant crypté la donnée de référence.

Pour décrypter avec *OpenSSL* vous devez posséder:

- **private**: votre clé privée. Ce peut être un nom de fichier ou juste le contenu de ce fichier : la clé.

- **envelope**: la clé enveloppe cryptée de l'utilisateur qui a crypté le document. Un chemin de fichier ou une
  chaine peuvent être utilisés. Lorsque l'option ``package`` est paramétrée, vous pouvez omettre ce paramètre.

- **package**: si la clé enveloppe a été empaqueté avec la valeur encryptée. Par défaut vaut ``FALSE``.

.. code-block:: php
   :linenos:

   // Utilise OpenSSL avec une clé spécifiée
   $filter = new Zend_Filter_Decrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // Passage des clés enveloppe
   $filter->setEnvelopeKey(array(
       '/key/from/encoder/first.pem',
       '/key/from/encoder/second.pem'
   ));

.. note::

   L'adaptateur *OpenSSL* ne fonctionnera pas avec des clés non valides.

Optionnellement il peut être nécessaire de passer la passphrase pour décrypter les clés elles-mêmes. Utilisez
alors ``setPassphrase()``.

.. code-block:: php
   :linenos:

   // Utilise OpenSSL avec une clé spécifiée
   $filter = new Zend_Filter_Decrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // Passage des clés enveloppe
   $filter->setEnvelopeKey(array(
       '/key/from/encoder/first.pem',
       '/key/from/encoder/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

Enfin, décryptez le contenu. Voici l'exemple complet:

.. code-block:: php
   :linenos:

   // Utilise OpenSSL avec une clé spécifiée
   $filter = new Zend_Filter_Decrypt(array(
       'adapter' => 'openssl',
       'private' => '/path/to/mykey/private.pem'
   ));

   // Passage des clés enveloppe
   $filter->setEnvelopeKey(array(
       '/key/from/encoder/first.pem',
       '/key/from/encoder/second.pem'
   ));
   $filter->setPassphrase('mypassphrase');

   $decrypted = $filter->filter('texte_encodé_illisible');
   print $decrypted;


