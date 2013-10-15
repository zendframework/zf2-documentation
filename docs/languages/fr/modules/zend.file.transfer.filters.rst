.. EN-Revision: none
.. _zend.file.transfer.filters:

Filtres pour Zend\File\Transfer
===============================

``Zend\File\Transfer`` est fourni avec de multiples filtres qui peuvent être utilisés pour réaliser différentes
tâches qui doivent être réalisées souvent sur les fichier. Notez que tout filtre est appliqué après la
validation. De plus les filtres de fichiers se comportent légèrement différemment des autres filtres. Ils
retourneront toujours le nom de fichier et non le contenu modifié (ce qui serait une mauvaise idée en travaillant
avec un fichier d'1Go par exemple). Tous les filtres fournis avec ``Zend\File\Transfer`` peuvent être trouvés
dans le composant ``Zend_Filter`` et sont nommés ``Zend\Filter\File\*``. Les filtres suivants sont actuellement
disponibles :

- *Decrypt*\  : ce filtre peut décrypter un fichier.

- *Encrypt*\  : ce filtre peut crypter un fichier.

- *LowerCase*\  : ce filtre peut mettre en minuscule le contenu d'un fichier texte.

- *Rename*\  : ce filtre peut renommer les fichiers, changer leur localisation et même forcer l'écrasement de
  fichiers existants.

- *UpperCase*\  : ce filtre peut mettre en majuscule le contenu d'un fichier texte.

.. _zend.file.transfer.filters.usage:

Utiliser les filtres avec Zend\File\Transfer
--------------------------------------------

L'utilisation des filtres est assez simple. Il existe de multiples méthodes pour ajouter et manipuler les filtres.

- ``addFilter($filter, $options = null, $files = null)``\  : ajoute le filtre à la pile des filtres
  (optionnellement seul le(s) fichier(s) spécifié(s)). ``$filter`` peut être soit une instance d'un filtre
  réel, ou un nom court spécifiant le filtre (par exemple, "Rename").

- ``addFilters(array $filters, $files = null)``\  : ajoute les filtres à la pile des filtres. Chaque entrée peut
  être soit une paire type/options, ou un tableau avec la clé "filtre" spécifiant le filtre (tous les autres
  options seront considérées comme des options du filtre au moment de l'instanciation).

- ``setFilters(array $filters, $files = null)``\  : surcharge les filtres existants avec les filtres spécifiés.
  Les filtres doivent respecter la même syntaxe ``addFilters()``.

- ``hasFilter($name)``\  : indique si le filtre est enregistré.

- ``getFilter($name)``\  : retourne un filtre préalablement enregistré.

- ``getFilters($files = null)``\  : retourne les filtres enregistrés ; si ``$files`` est fourni, retourne les
  filtres pour ce fichier en particulier ou pour tous les fichiers.

- ``removeFilter($name)``\  : enlève le filtre préalablement enregistré.

- ``clearFilters()``\  : efface tous les filtres.

.. _zend.file.transfer.filters.usage.example:

.. rubric:: Ajouter les filtres au fichier transféré

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Paramètre un dossier de destination
   $upload->addFilter('Rename', 'C:\image\uploads');

   // Paramètre un nouveau dossier de destination
   // et surcharge pour les fichiers existants
   $upload->addFilter('Rename', array('target' => 'C:\picture\uploads', 'overwrite' => true));

.. _zend.file.transfer.filters.usage.exampletwo:

.. rubric:: Limiter les filtres à des fichiers uniques

``addFilter()``, ``addFilters()``, and ``setFilters()`` accepte chacun un argument final ``$files``. Cet argument
peut être utilisé pour spécifier un fichier en particulier ou un tableau de fichiers sur lequel appliqué le
filtre donné.

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Paramètre un nouveau dossier de destination et
   // le limite seulement à "file2"
   $upload->addFilter('Rename', 'C:\image\uploads', 'file2');

Généralement vous devriez simplement utiliser la méthode ``addFilters()``, qui peut être appelée plusieurs
fois.

.. _zend.file.transfer.filters.usage.examplemultiple:

.. rubric:: Ajouter des filtres multiples

Souvent il est plus simple d'appeler plusieurs fois ``addFilter()``: un appel pour chaque filtre. Ceci améliore
aussi la lisibilité et rend votre code plus maintenable. Comme toutes les méthodes fournissent un interface
fluide, vous pouvez enchaîner les appels comme montré ci-dessous :

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Renommer différemment chacun des fichiers
   $upload->addFilter('Rename', 'file1', 'C:\picture\newjpg')
          ->addFilter('Rename', 'file2', 'C:\picture\newgif');

.. note::

   Notez que même si l'ajout du même filtre plusieurs fois est autorisé, faire ceci peut entraîner des
   problèmes si vous utilisez différentes options pour le même filtre.

.. _zend.file.transfer.filters.decrypt:

Filtre Decrypt
--------------

Le filtre *Decrypt* permet de décrypter un fichier crypté.

Ce filtre se sert de ``Zend\Filter\Decrypt``. Il supporte les extensions *PHP* *Mcrypt* et *OpenSSL*. Reportez vous
à la section associée pour voir les détails des possibilités d'options pour le décryptage et connaître les
options supportées.

Ce filtre supporte une option additionnelle qui peut être utilisée pour sauvegarder le fichier décrypté avec un
autre nom de fichier. Spécifiez l'option *filename* pour changer le nom de fichier dans lequel le fichier
décrypté sera stocké. Si vous supprimez cette option le fichier décrypté écrasera le fichier chiffré
original.

.. _zend.file.transfer.filters.decrypt.example1:

.. rubric:: Utiliser le filtre Decrypt avec Mcrypt

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Adds a filter to decrypt the uploaded encrypted file
   // with mcrypt and the key mykey
   $upload->addFilter('Decrypt',
       array('adapter' => 'mcrypt', 'key' => 'mykey'));

.. _zend.file.transfer.filters.decrypt.example2:

.. rubric:: Utiliser le filtre Decrypt avec OpenSSL

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Adds a filter to decrypt the uploaded encrypted file
   // with openssl and the provided keys
   $upload->addFilter('Decrypt',
       array('adapter' => 'openssl',
             'private' => '/path/to/privatekey.pem',
             'envelope' => '/path/to/envelopekey.pem'));

.. _zend.file.transfer.filters.encrypt:

Filtre Encrypt
--------------

Le filtre *Encrypt* permet de crypter un fichier.

Ce filtre se sert de ``Zend\Filter\Encrypt``. Il supporte les extensions *PHP* *Mcrypt* et *OpenSSL*. Reportez vous
à la section associée pour voir les détails des possibilités d'options pour le chiffrement et connaître les
options supportées.

Ce filtre supporte une option additionnelle qui peut être utilisée pour sauvegarder le fichier chiffré avec un
autre nom de fichier. Spécifiez l'option *filename* pour changer le nom de fichier dans lequel le fichier chiffré
sera stocké. Si vous supprimez cette option le fichier chiffré écrasera le fichier original.

.. _zend.file.transfer.filters.encrypt.example1:

.. rubric:: Utiliser le filtre Encrypt avec Mcrypt

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Adds a filter to encrypt the uploaded file
   // with mcrypt and the key mykey
   $upload->addFilter('Encrypt',
       array('adapter' => 'mcrypt', 'key' => 'mykey'));

.. _zend.file.transfer.filters.encrypt.example2:

.. rubric:: Utiliser le filtre Encrypt avec OpenSSL

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Adds a filter to encrypt the uploaded file
   // with openssl and the provided keys
   $upload->addFilter('Encrypt',
       array('adapter' => 'openssl',
             'public' => '/path/to/publickey.pem'));

.. _zend.file.transfer.filters.lowercase:

Filtre LowerCase
----------------

Le filtre *LowerCase* vous permet de mettre en minuscule le contenu d'un fichier. Vous devriez utiliser ce filtre
seulement sur les fichiers texte.

Lors de l'initialisation vous pouvez fournir qui sera utilisée en tant qu'encodage. Ou vous pouvez utiliser la
méthode ``setEncoding()`` pour le paramétrer plus tard.

.. _zend.file.transfer.filters.lowercase.example:

.. rubric:: Utiliser le filtre LowerCase

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('MimeType', 'text');

   // Ajoute un filtre pour mettre en minuscule les fichiers texte uploadés
   $upload->addFilter('LowerCase');

   // Ajoute un filtre pour mettre en minuscule seulement le fichier uploadé "uploadfile1"
   $upload->addFilter('LowerCase', null, 'uploadfile1');

   // Ajoute un filtre pour mettre en minuscule avec un encodage ISO-8859-1
   $upload->addFilter('LowerCase', 'ISO-8859-1');

.. note::

   Notez que les options du filtre LowerCase sont optionnelles, vous devez fournir un ``NULL`` en second paramètre
   quand vous souhaitez limiter le filtre à un fichier unique.

.. _zend.file.transfer.filters.rename:

Filtre Rename
-------------

Le filtre *Rename* vous permet de changer le dossier de destination du fichier uploadé, de changer le nom de
fichier et aussi d'écraser des fichiers existants. Il supporte les options suivantes :

- *source*: le nom et le dossier de l'ancien fichier qui doit être renommé.

- *target*: le nouveau dossier ou nom du fichier.

- *overwrite*: paramètre si l'ancien fichier écrase le nouveau fichier s'il existe déjà. La valeur par défaut
  est ``FALSE``.

De plus vous pouvez utiliser la méthode ``setFile()`` pour paramétrer des fichiers, ce qui effacera ceux
précédemment paramétrés, ``addFile()`` pour ajouter un nouveau fichier à ceux déjà présent, et
``getFile()`` pour récupérer les fichiers actuellement paramétrés. Pour simplifier les choses, ce filtre
accepte de multiples notations et ces méthodes et constructeur comprennent les mêmes notations.

.. _zend.file.transfer.filters.rename.example:

.. rubric:: Utiliser le filtre Rename

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();

   // Paramètre un nouveau dossier pour tous les fichiers
   $upload->addFilter('Rename', 'C:\mypics\new');

   // Paramètre un nouveau dossier seulement pour uploadfile1
   $upload->addFilter('Rename', 'C:\mypics\newgifs', 'uploadfile1');

Vous pouvez utiliser différentes notations. Ci-dessous vous trouverez une table fournissant la description et le
but des notations supportées. Notez que quand vous utilisez l'"Adapter" ou le "Form Element", vous ne pourrez pas
utiliser toutes les notations décrites.

.. _zend.file.transfer.filters.rename.notations:

.. table:: Notations différentes du filtre "Rename" et leurs significations

   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |notation                                                                                       |description                                                                                                                                                                                                                 |
   +===============================================================================================+============================================================================================================================================================================================================================+
   |addFile('C:\\uploads')                                                                         |Spécifie un nouveau dossier pour tous les fichiers quand la chaîne est un dossier. Notez que vous aurez une exception si le fichier existe déjà, voir le paramètre d'écrasement.                                            |
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile('C:\\uploads\\file.ext')                                                               |Spécifie un nouveau dossier et un nom de fichier pour tous les fichiers quand la chaîne n'est pas un dossier. Notez que vous aurez une exception si le fichier existe déjà, voir le paramètre d'écrasement.                 |
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile('C:\\uploads\\file.ext', 'overwrite' => true)                                          |Spécifie un nouveau dossier et un nom de fichier pour tous les fichiers quand la chaîne n'est pas un dossier et écrase le fichier existant si celui-ci existe. Notez que vous aurez pas de notification en cas d'écrasement.|
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile(array('source' => 'C:\\temp\\uploads', 'target' => 'C:\\uploads'))                     |Spécifie un nouveau dossier pour tous les fichiers qui sont présent dans l'ancien dossier quand la chaîne est un dossier. Notez que vous aurez une exception si le fichier existe déjà, voir le paramètre d'écrasement.     |
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |addFile(array('source' => 'C:\\temp\\uploads', 'target' => 'C:\\uploads', 'overwrite' => true))|Spécifie un nouveau dossier pour tous les fichiers qui sont présent dans l'ancien dossier quand la chaîne est un dossier. Notez que vous aurez pas de notification en cas d'écrasement.                                     |
   +-----------------------------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.file.transfer.filters.uppercase:

Filtre UpperCase
----------------

Le filtre *UpperCase* vous permet de mettre en minuscule le contenu d'un fichier. Vous devriez utiliser ce filtre
seulement sur les fichiers texte.

Lors de l'initialisation vous pouvez fournir qui sera utilisée en tant qu'encodage. Ou vous pouvez utiliser la
méthode ``setEncoding()`` pour le paramétrer plus tard.

.. _zend.file.transfer.filters.uppercase.example:

.. rubric:: Utiliser le filtre UpperCase

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('MimeType', 'text');

   // Ajoute un filtre pour mettre en majuscule les fichiers textes uploadés
   $upload->addFilter('UpperCase');

   // Ajoute un filtre pour mettre en majuscule seulement le fichier uploadé "uploadfile1"
   $upload->addFilter('UpperCase', null, 'uploadfile1');

   // Ajoute un filtre pour mettre en majuscule avec un encodage ISO-8859-1
   $upload->addFilter('UpperCase', 'ISO-8859-1');

.. note::

   Notez que les options du filtre UpperCase sont optionnelles, vous devez fournir un ``NULL`` en second paramètre
   quand vous souhaitez limiter le filtre à un fichier unique.


