.. EN-Revision: none
.. _zend.filter.set.compress:

Compression et décompression
============================

Ces deux filtres sont capables de compresser et décompresser des chaines, des fichiers ou des dossiers. Ils
utilisent des adaptateurs dans ce but et supportent les formats suivants:

- **Bz2**

- **Gz**

- **Lzf**

- **Rar**

- **Tar**

- **Zip**

Chaque format de compression possède des caractéristiques propres et ils s'utilisent tous d'une manière commune.
Seules leurs options vont différer ainsi que les types de compressions qu'ils offrent (algorithmes, fichiers,
chaines et dossiers)

.. _zend.filter.set.compress.generic:

Les bases
---------

Pour créer un filtre de compression vous devez sélectionner le format que vous désirez. La description suivante
utilisera l'adaptateur **Bz2**. Les détails des autres adaptateurs seront précisés plus tard dans la section
suivante.

Les deux filtres (compression et décompression) sont identiques lorsqu'ils utilisent le même adaptateur.
Simplement ``Zend\Filter\Compress`` est utilisé pour les opérations de compression alors que
``Zend\Filter\Decompress`` est utilisé pour la décompression.

Par exemple, si nous voulons compresser une chaine nous devons instancier ``Zend\Filter\Compress`` et indiquer un
adaptateur.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Compress('Bz2');

Les adaptateurs se spécifient donc dans le constructeur.

Il est aussi possible de passer des options sous forme de tableau ou d'objet ``Zend_Config``. Si vous souhaitez
préciser des options, vous devez alors au minimum indiquer la clé "adapter". Les clés "options" ou
"adapterOptions" peuvent ensuite être utilisées et doivent représenter un tableau.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'blocksize' => 8,
       ),
   ));

.. note::

   **Adaptateur de compression par défaut**

   Lorsque vous ne précisez aucun adaptateur, **Gz** sera utilisé par défaut.

Concernant la décompression, le principe est exactement identique.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Decompress('Bz2');

Pour récupérer une chaine compressée, il faut indiquer la chaine originale. La valeur "filtrée" récupérée
sera alors la chaine compressée, tout simplement.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress('Bz2');
   $compressed = $filter->filter('Uncompressed string');
   // Retourne la chaine compressée

La décompression suit exactement le même principe.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Decompress('Bz2');
   $compressed = $filter->filter('Compressed string');
   // Retourne la chaine décompressée

.. note::

   **Note sur la compression de chaines**

   Tous les adaptateurs ne supportent pas la compression de chaines. Les formats tels que **Rar** ne savent que
   traiter des fichiers ou des répertoires. Pour les détails, consultez la documentation relative à l'adaptateur
   en question.

.. _zend.filter.set.compress.archive:

Créer une archive
-----------------

Créer une archive fonctionne quasiment de la même manière que la compression d'une chaine. Cependant dans ce
cas, nous devons préciser une options supplémentaire indiquant le nom de l'archive à créer.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'archive' => 'filename.bz2',
       ),
   ));
   $compressed = $filter->filter('Uncompressed string');
   // Retourne true en cas de succès et crée le fichier d'archive

Dans l'exemple ci-dessus, la chaine est compressée puis retournée dans une archive.

.. note::

   **Les archives existantes seront écrasées**

   Si l'archive existe déja, elle sera écrasée.

Si vous souhaitez compresser un fichier, vous devez fournir son chemin.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'archive' => 'filename.bz2'
       ),
   ));
   $compressed = $filter->filter('C:\temp\compressme.txt');
   // Retourne true en cas de succès et crée le fichier d'archive

Il est aussi possible de préciser le nom d'un dossier plutôt que d'un fichier. Dans ce cas, tout le dossier sera
compressé, récursivement.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Compress(array(
       'adapter' => 'Bz2',
       'options' => array(
           'archive' => 'filename.bz2'
       ),
   ));
   $compressed = $filter->filter('C:\temp\somedir');
   // Retourne true en cas de succès et crée le fichier d'archive

.. note::

   **Ne compressez pas un dossier trop gros ou trop profond**

   Vous ne devriez jamais tenter de compresser un dossier trop gros ou trop profond, comme par exemple une
   partition complète. Une telle opération s'avère très longue et très couteuse en ressources ce qui peut
   provoquer des problèmes sur votre serveur.

.. _zend.filter.set.compress.decompress:

Décompresser une archive
------------------------

Décompresser une archive s'éxecute d'une manière sensiblement identique à la compression. Vous devez passer le
paramètre ``archive`` ou préciser le nom du fichier.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Decompress('Bz2');
   $compressed = $filter->filter('filename.bz2');
   // Retourne true en cas de succès et décompresse le fichier d'archive

Certains adaptateurs permettent la décompression d'une archive dans un dossier cible, dans ce cas le paramètre
``target`` permet de l'indiquer.

.. code-block:: php
   :linenos:

   $filter     = new Zend\Filter\Decompress(array(
       'adapter' => 'Zip',
       'options' => array(
           'target' => 'C:\temp',
       )
   ));
   $compressed = $filter->filter('filename.zip');
   // Retourne true en cas de succès et décompresse le fichier d'archive
   // dans le dossier spécifié

.. note::

   **Les dossiers de cible doivent exister**

   Lorsque vous souhaitez décompresser une archive dans un dossier cible, vérifiez bien que celui-ci existe
   déja.

.. _zend.filter.set.compress.bz2:

Adaptateur Bz2
--------------

L'adaptateur Bz2 peut compresser et décompresser:

- Chaines

- Fichiers

- Dossiers

Cet adaptateur utilise l'extension *PHP* Bz2.

Pour personnaliser la compression, cet adaptateur utilise les options suivantes:

- **Archive**: Précise l'archive à utiliser ou à créer.

- **Blocksize**: Précise la taille des blocs. Des valeurs de '0' à '9' sont permises. La valeur par défaut est
  '4'.

Toutes les options peuvent être passées à l'instanciation ou en utilisant des méthodes. Par exemple pour la
tailles des blocs, ``getBlocksize()`` et ``setBlocksize()``. La méthode ``setOptions()`` est aussi présente, elle
accepte un tableau

.. _zend.filter.set.compress.gz:

Adaptateur Gz
-------------

L'adaptateur Bz2 peut compresser et décompresser:

- Chaines

- Fichiers

- Dossiers

Cet adaptateur utilise l'extension *PHP* Zlib.

Pour personnaliser la compression, cet adaptateur utilise les options suivantes:

- **Archive**: L'archive à créer ou à utiliser.

- **Level**: Niveau de compression. Des valeurs de '0' à '9' sont utilisables, par défaut : '9'.

- **Mode**: Il existe deux modes supportés : 'compress' et 'deflate'. La valeur par défaut est 'compress'.

Toutes les options peuvent être passées en constructeur ou en utilisant des méthodes. Par exemple, pour l'option
'Level', ``getLevel()`` et ``setLevel()``. La méthode ``setOptions()`` est aussi présente et accepte un tableau.

.. _zend.filter.set.compress.lzf:

Adaptateur Lzf
--------------

L'adaptateur Lzf peut compresser et décompresser:

- Chaines

.. note::

   **Lzf ne supporte que les chaines de caractères**

   Lzf ne supporte pas les fichiers et les dossiers.

Cet adaptateur utilise l'extension *PHP*\ Lzf.

Il n'existe pas d'options pour personnaliser cet adaptateur.

.. _zend.filter.set.compress.rar:

Adaptateur Rar
--------------

L'adaptateur Rar peut compresser et décompresser:

- Fichiers

- Dossiers

.. note::

   **Rar ne supporte pas les chaines de caractères**

   L'adaptateur Rar ne supporte pas les chaines de caractères

Cet adaptateur utilise l'extension *PHP* Rar.

.. note::

   **Compression Rar non supportée**

   Des restrictions du format Rar ne permettent pas la compression gratuite. Si vous souhaitez compresser avec cet
   adaptateur, vous devrez passer une fonction de callback qui utilisera un algorithme ou fera appel à un
   programme externe.

Cet adaptateur accepte les options suivantes:

- **Archive**: Précise l'archive à créer ou à utiliser.

- **Callback**: Une fonction de callback fournissant des services de compression à l'adaptateur.

- **Password**: Le mot de passe à utiliser éventuellement en cas de décompression.

- **Target**: La cible vers laquelle les fichiers décompressés seront écrits.

Toutes les options peuvent être passées au constructeurs ou via des méthodes. Par exemple, pour l'option
'Target', ``getTarget()`` et ``setTarget()``.La méthode ``setOptions()`` est aussi disponible et accepte un
tableau.

.. _zend.filter.set.compress.tar:

Tar Adapter
-----------

L'adaptateur Tar peut compresser et décompresser:

- Fichiers

- Dossiers

.. note::

   **Tar ne supporte pas les chaines de caractères**

   L'adaptateur Tar ne supporte pas les chaines de caractères

Cet adaptateur utilise le paquet *PEAR* ``Archive_Tar``.

Cet adaptateur accepte les options suivantes:

- **Archive**: Précise l'archive à utiliser ou à créer.

- **Mode**: Mode de compression. Les modes supportés sont 'null' qui signifie pas de compression, 'Gz' qui
  utilisera l'extension *PHP* Zlib et 'Bz2' qui utilisera l'extension *PHP*\ Bz2. La valeur par défaut est 'null'.

- **Target**: La cible vers laquelle les fichier décompressés seront écrits.

Toutes les options peuvent être passées au constructeurs ou via des méthodes. Par exemple, pour l'option
'Target', ``getTarget()`` et ``setTarget()``.La méthode ``setOptions()`` est aussi disponible et accepte un
tableau.

.. note::

   **Utilisation avec des dossiers**

   La compression des dossiers avec Tar utilise le chemin complet comme nom de fichier.

.. _zend.filter.set.compress.zip:

Adaptateur Zip
--------------

L'adaptateur Zip peut compresser et décompresser:

- Chaines

- Fichiers

- Dossiers

.. note::

   **Zip ne supporte pas la décompression vers des chaines**

   L'adaptateur Zip ne supporte pas la décompression vers des chaines. Un fichier sera systématiquement crée.

Cet adaptateur utilise l'extension *PHP* ``Zip``.

Les options suivantes sont supportées :

- **Archive**: Précise l'archive qui sera utilisée ou créee.

- **Target**: La cible vers laquelle décompresser.

Toutes les options peuvent être passées au constructeurs ou via des méthodes. Par exemple, pour l'option
'Target', ``getTarget()`` et ``setTarget()``.La méthode ``setOptions()`` est aussi disponible et accepte un
tableau.


