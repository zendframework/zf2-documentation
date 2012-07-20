.. _zend.file.transfer.validators:

Validateurs pour Zend_File_Transfer
===================================

``Zend_File_Transfer`` est fourni avec de multiples validateurs liés qui doivent être utiliser pour accroître la
sécurité et prévenir les attaques possibles. Notez que les validateurs ne sont bons que si vous les utilisez.
Tous les validateurs qui sont fournis avec ``Zend_File_Transfer`` peuvent être trouvés avec le composant
``Zend_Validator`` et sont nommés ``Zend_Validate_File_*``. Les validateurs suivants sont actuellement
disponibles :

- *Count*\  : ce validateur vérifie le nombre de fichiers. Il est possible de définir un minimum et un maximum
  et une erreur sera lancée s'ils sont dépassés.

- *Crc32*\  : ce validateur vérifie la valeur de hachage crc32 du contenu d'un fichier. Il est basé sur le
  validateur *Hash* et en simplifiant son utilisation par le support unique du Crc32.

- *ExcludeExtension*\  : ce validateur vérifie l'extension des fichiers. Il lancera une erreur quand un fichier
  aura une extension non souhaitée. Ainsi vous pouvez empêcher la validation de certaines extensions.

- *ExcludeMimeType*\  : ce validateur vérifie le type *MIME* des fichiers. Il est aussi capable de valider un
  groupe de type *MIME* et générera une erreur quand le type *MIME* d'un fichier donné correspond.

- *Exists*\  : ce validateur vérifie l'existence des fichiers. Il lancera une erreur quand un fichier n'existera
  pas.

- *Extension*\  : ce validateur vérifie l'extension des fichiers. Il lancera une erreur quand un fichier n'aura
  pas l'extension définie.

- *FilesSize*\  : ce validateur vérifie la taille complète de tous les fichiers à valider. Il conserve en
  mémoire la taille de tous les fichiers chargés et lance une erreur quand la somme de tous les fichiers dépasse
  la taille définie. Il est aussi possible de définir une taille minimum et maximum.

- *ImageSize*\  : ce validateur vérifie la taille des images. Il valide la largeur et la hauteur et permet de
  paramétrer à la fois une valeur minimum et maximum.

- *IsCompressed*\  : ce validateur vérifie si le fichier est compressé. Il est basé sur le validateur
  *MimeType* et valide les archives compressées comme zip ou arc. Vous pouvez aussi limiter à des types
  d'archives particuliers.

- *IsImage*\  : ce validateur vérifie si un fichier est une image. Il est basé sur le validateur *MimeType* et
  valide les images comme jpg ou gif. Vous pouvez aussi limiter à des types d'images particuliers.

- *Hash*\  : ce validateur vérifie la valeur de hachage md5 du contenu d'un fichier. Il supporte de multiples
  algorithmes.

- *Md5*\  : ce validateur vérifie la valeur de hachage md5 du contenu d'un fichier. Il est basé sur le
  validateur *Hash* et en simplifiant son utilisation par le support unique du Md5.

- *MimeType*\  : ce validateur vérifie le type *MIME* des fichiers. Il est aussi capable de valider des groupes
  de type *MIME* et de générer une erreur quand le type *MIME* d'un fichier donné ne correspond pas.

- *NotExists*\  : ce validateur vérifie l'existence des fichiers. Il lancera une erreur quand un fichier existera
  déjà.

- *Sha1*\  : ce validateur vérifie la valeur de hachage sha1 du contenu d'un fichier. Il est basé sur le
  validateur *Hash* et en simplifiant son utilisation par le support unique du Sha1.

- *Size*\  : ce validateur permet de valider la taille d'un fichier en particulier. Il est possible de définir un
  minimum et un maximum et une erreur sera lancée s'ils sont dépassés.

- *Upload*\  : ce validateur est interne, il vérifie si l'upload a produit une erreur. Vous ne devez pas le
  paramétrer, il est automatiquement activé par *Zend_File_Transfer* lui-même. Vous pouvez donc oublier ce
  validateur. Il faut juste savoir qu'il existe.

- *WordCount*\  : ce validateur est capable de vérifier le nombre de mots à l'intérieur du fichier. Il permet
  de définir des valeurs minimum et maximum et émettra une erreur si l'un ou l'autre des seuils est dépassé.

.. _zend.file.transfer.validators.usage:

Utiliser les validateurs avec Zend_File_Transfer
------------------------------------------------

L'utilisation des validateurs est assez simple. Il existe de multiples méthodes pour ajouter et manipuler les
validateurs.

- ``isValid($files = null)``\  : vérifie le(s) fichier(s) fourni(s) avec tout le jeu de validateurs paramétrés.
  ``$files`` peut être soit un vrai nom de fichier, soit des noms d'éléments de formulaire ou des noms de
  fichiers temporaires.

- *addValidator($validator, $breakChainOnFailure, $options = null, $files = null)*\  : ajoute le validateur à la
  pile des validateurs (optionnellement seul le(s) fichier(s) spécifié(s)). ``$validator`` peut être soit une
  instance d'un validateur réel, ou un nom court spécifiant le validateur (par exemple, "Count").

- ``addValidators(array $validators, $files = null)``\  : ajoute les validateurs à la pile des validateurs.
  Chaque entrée peut être soit une paire type/options, ou un tableau avec la clé "validator" spécifiant le
  validateur (tous les autres options seront considérées comme des options du validateur au moment de
  l'instanciation).

- ``setValidators(array $validators, $files = null)``\  : surcharge les validateurs existants avec les validateurs
  spécifiés. Les validateurs doivent respecter la même syntaxe que ``addValidators()``.

- ``hasValidator($name)``\  : indique si un validateur est enregistré.

- ``getValidator($name)``\  : retourne un validateur préalablement enregistré.

- ``getValidators($files = null)``\  : retourne les validateurs enregistrés ; si ``$files`` est fourni, retourne
  les validateurs pour ce fichier en particulier ou pour tous les fichiers.

- ``removeValidator($name)``\  : enlève le validateur préalablement enregistré.

- ``clearValidators()``\  : efface tous les validateurs.

.. _zend.file.transfer.validators.usage.example:

.. rubric:: Ajouter des validateurs au(x) fichier(s) transféré(s)

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Paramètre un poids de fichier de 20000 octets
   $upload->addValidator('Size', false, 20000);

   // Paramètre un poids de fichier de 20 octets minimum
   // et de 20000 octets maximum
   $upload->addValidator('Size', false, array('min' => 20, 'max' => 20000));

   // Paramètre un poids de fichier de 20 octets minimum et
   // de 20000 octets maximum et un nombre de fichiers en une seule étape
   $upload->setValidators(array(
       'Size'  => array('min' => 20, 'max' => 20000),
       'Count' => array('min' => 1, 'max' => 3),
   ));

.. _zend.file.transfer.validators.usage.exampletwo:

.. rubric:: Limiter les validateurs à des fichiers uniques

``addValidator()``, ``addValidators()``, et ``setValidators()`` accepte chacun un argument final ``$files``. Cet
argument peut être utilisé pour spécifier un fichier en particulier ou un tableau de fichiers sur lequel
appliqué le validateur donné.

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Paramètre un poids de fichier de 20000 octets et
   // limite celui-ci à 'file2'
   $upload->addValidator('Size', false, 20000, 'file2');

Généralement vous devriez simplement utiliser la méthode ``addValidators()``, qui peut être appelée plusieurs
fois.

.. _zend.file.transfer.validators.usage.examplemultiple:

.. rubric:: Ajouter des validateurs multiples

Souvent il est plus simple d'appeler plusieurs fois ``addValidator()``\  : un appel pour chaque validateur. Ceci
améliore aussi la lisibilité et rend votre code plus maintenable. Comme toutes les méthodes fournissent un
interface fluide, vous pouvez enchaîner les appels comme montré ci-dessous :

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Paramètre un poids de fichier de 20000 octets
   $upload->addValidator('Size', false, 20000)
          ->addValidator('Count', false, 2)
          ->addValidator('Filessize', false, 25000);

.. note::

   Notez que même si l'ajout du même validateur plusieurs fois est autorisé, faire ceci peut entraîner des
   problèmes si vous utilisez différentes options pour le même validateur.

Et pour finir vous pouvez tout simplement vérifier le(s) fichier(s) en appelant ``isValid()``.

.. _zend.file.transfer.validators.usage.exampleisvalid:

.. rubric:: Valider les fichiers

``isValid()`` accepte les fichiers uploadés ou télécharger, le nom de fichier temporaire et bien sûr le nom de
l'élément de formulaire. Si aucun paramètre ou ``NULL`` est fourni, tous les fichiers seront vérifiés.

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Paramètre un poids de fichier de 20000 octets
   $upload->addValidator('Size', false, 20000)
          ->addValidator('Count', false, 2)
          ->addValidator('Filessize', false, 25000);

   if (!$upload->isValid()) {
       print "Echec de validation";
   }

.. note::

   Notez que ``isValid()`` sera automatiquement appelé quand vous recevez les fichiers et qu'il n'a pas été
   appelé auparavant.

Quand une validation a échouée, c'est probablement intéressant d'avoir des informations sur les problèmes
rencontrés. A cette fin, vous pouvez utiliser la méthode ``getMessages()`` qui retourne tous les messages de
validation sous la forme d'un tableau, ``getErrors()`` qui retourne tous les codes d'erreurs et ``hasErrors()`` qui
retourne ``TRUE`` dès qu'une erreur de validation est rencontrée.

.. _zend.file.transfer.validators.count:

Validateur Count
----------------

Le validateur *Count* vérifie le nombre de fichiers fournis. Il supporte les clés d'options suivantes :

- *min*\  : paramètre le nombre minimum de fichiers à transférer.

  .. note::

     Attention : quand vous utilisez cette option vous devez donner le nombre minimum au moment où vous appelez
     ce validateur la première fois ; sinon vous aurez une erreur en retour.

  Avec cette option vous pouvez définir le nombre de fichiers que vous souhaitez recevoir.

- *max*\  : paramètre le nombre maximum de fichiers à transférer.

  Avec cette option vous pouvez limiter le nombre de fichiers que vous acceptez mais vous permet aussi de détecter
  une possible attaque quand plus de fichiers, que votre formulaire n'en définit, sont fournis.

Vous pouvez initialiser ce validateur avec une chaîne ou un entier, la valeur sera utilisée en tant que *max*.
Mais vous pouvez aussi utiliser les méthodes ``setMin()`` et ``setMax()`` pour paramétrer ces options plus tard
et ``getMin()`` et ``getMax()`` pour les récupérer.

.. _zend.file.transfer.validators.count.example:

.. rubric:: Utiliser le validateur Count

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limite le nombre de fichiers à 2 maximum
   $upload->addValidator('Count', false, 2);

   // Limite le nombre de fichiers à 5 maximum,
   // tout en obligeant au moins 1 fichier
   $upload->addValidator('Count', false, array('min' =>1, 'max' => 5));

.. note::

   Notez que ce validateur stocke le nombre de fichiers vérifiés en interne. Le fichier qui excédera le maximum
   sera retourné en tant qu'erreur.

.. _zend.file.transfer.validators.crc32:

Validateur Crc32
----------------

Le validateur *Crc32* vérifie le contenu du fichier transféré en le hachant. Ce validateur utilise l'extension
de hachage de *PHP* avec l'algorithme crc32. Il supporte les options suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Les valeurs seront
  utilisées pour vérifier la valeur de hachage.

  Vous pouvez paramétrer de multiples hachages en utilisant différentes clés. Chacun sera vérifié et seulement
  si tous échouent, la validation elle-même échouera.

.. _zend.file.transfer.validators.crc32.example:

.. rubric:: Utiliser le validateur Crc32

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Vérifie si le contenu d'un fichier uploadé correspond au hachage fourni
   $upload->addValidator('Crc32', false, '3b3652f');

   // Limite ce validateur à deux différents hachages
   $upload->addValidator('Crc32', false, array('3b3652f', 'e612b69'));

.. _zend.file.transfer.validators.excludeextension:

Validateur ExcludeExtension
---------------------------

Le validateur *ExcludeExtension* vérifie l'extension des fichiers fournis. Il supporte les options suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Les valeurs seront
  utilisées en tant qu'extensions à vérifier que le fichier n'utilise pas.

- *case*\  : paramètre une validation qui tient compte de la casse. Par défaut, ce n'est pas sensible à la
  casse. Notez que cette clé est utilisée pour toutes les extensions.

Ce validateur accepte des extensions multiples soit sous la forme d'une chaîne utilisant le caractère virgule
(",") comme séparateur ou sous la forme d'un tableau. Vous pouvez aussi utiliser les méthodes ``setExtension()``,
``addExtension()``, et ``getExtension()`` pour paramétrer et récupérer les extensions.

Dans certains cas, il est utile vérifier aussi la casse. A cette fin le constructeur autorise un second paramètre
``$case`` qui, s'il est réglé à ``TRUE``, validera l'extension en vérifiant aussi la casse.

.. _zend.file.transfer.validators.excludeextension.example:

.. rubric:: Utiliser le validateur ExcludeExtension

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Refuser les fichiers avec l'extension php ou exe
   $upload->addValidator('ExcludeExtension', false, 'php,exe');

   // Refuser les fichiers avec l'extension php ou exe en utilisant
   // la notation de type tableau
   $upload->addValidator('ExcludeExtension', false, array('php', 'exe'));

   // Vérifier aussi la casse
   $upload->addValidator('ExcludeExtension', false, array('php', 'exe', 'case' => true));

.. note::

   Notez que ce validateur ne vérifie que l'extension de fichier. Il ne vérifie pas le type *MIME* réel du
   fichier.

.. _zend.file.transfer.validators.excludemimetype:

Validateur ExcludeMimeType
--------------------------

Le validateur *ExcludeMimeType* vérifie le type *MIME* des fichiers transférés. Il supporte les options
suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Paramètre le type
  *MIME* à vérifier.

  Avec cette option vous pouvez définir le(s) type(s) *MIME* que vous souhaitez exclure.

- *headerCheck*\  : si spécifié à ``TRUE``, cette option va vérifier l'information *HTTP* concernant le type
  de fichier quand les extensions **fileInfo** ou **mimeMagic** ne seront pas trouvées. La valeur par défaut de
  cette option est ``FALSE``.

Ce validateur accepte des types *MIME* multiples soit sous la forme d'une chaîne utilisant le caractère virgule
(",") comme séparateur ou sous la forme d'un tableau. Vous pouvez aussi utiliser les méthodes ``setMimeType()``,
``addMimeType()``, et ``getMimeType()`` pour paramétrer et récupérer les types *MIME*.

.. _zend.file.transfer.validators.excludemimetype.example:

.. rubric:: Utiliser le validateur ExcludeMimeType

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Refuser le type MIME d'image gif pour tous les fichiers
   $upload->addValidator('ExcludeMimeType', false, 'image/gif');

   // Refuser le type MIME d'image gif et jpg pour tous les fichiers
   $upload->addValidator('ExcludeMimeType', false, array('image/gif', 'image/jpeg');

   // Refuser les types MIME du groupe image pour tous les fichiers
   $upload->addValidator('ExcludeMimeType', false, 'image');

L'exemple ci-dessus montre qu'il est aussi possible de limiter le type *MIME* accepté à un groupe de type *MIME*.
Pour refuser toutes les images utilisez simplement "image" en tant que type *MIME*. Ceci peut être appliqué à
tous les groupes de type *MIME* comme "image", "audio", "video", "text" et plus encore.

.. note::

   Notez que refuser un groupe de type *MIME* refusera tous les membres de ce groupe même si ce n'est pas votre
   intention. Par exemple quand vous refusez "image", vous refusez donc "image/jpeg" ou "image/vasa". Quand vous
   n'êtes pas sûr de vouloir refuser tous les types, vous devriez définir individuellement les types *MIME*
   plutôt que le groupe complet.

.. _zend.file.transfer.validators.exists:

Validateur Exists
-----------------

Le validateur *Exists* l'existence des fichiers fournis. Il supporte les options suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Vérifie si le fichier
  existe dans le dossier fourni.

Ce validateur accepte des extensions multiples soit sous la forme d'une chaîne utilisant le caractère virgule
(",") comme séparateur ou sous la forme d'un tableau. Vous pouvez aussi utiliser les méthodes ``setDirectory()``,
``addDirectory()``, et ``getDirectory()`` pour paramétrer et récupérer les extensions.

.. _zend.file.transfer.validators.exists.example:

.. rubric:: Utiliser le validateur Exists

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Ajoute le dossier temporaire à vérifier
   $upload->addValidator('Exists', false, '\temp');

   // Ajoute deux dossiers en utilsant la notation de type tableau
   $upload->addValidator('Exists',
                         false,
                         array('\home\images', '\home\uploads'));

.. note::

   Notez que ce validateur vérifie si le fichier existe dans tous les dossiers fournis. La validation échoue si
   le fichier est manquant dans l'un des dossiers.

.. _zend.file.transfer.validators.extension:

Validateur Extension
--------------------

Le validateur *Extension* vérifie l'=es extensions des fichiers qui ont été fournis. Il supporte les options
suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Paramètre l'extension
  à vérifier.

- *case*\  : paramètre une validation sensible à la casse. Par défaut, la validation n'est pas sensible à la
  casse. Notez que cette clé est utilisée pour toutes les extensions.

Ce validateur accepte des extensions multiples soit sous la forme d'une chaîne utilisant le caractère virgule
(",") comme séparateur ou sous la forme d'un tableau. Vous pouvez aussi utiliser les méthodes ``setExtension()``,
``addExtension()``, et ``getExtension()`` pour paramétrer et récupérer les extensions.

Dans certains cas, il est utile vérifier aussi la casse. A cette fin le constructeur autorise un second paramètre
``$case`` qui, s'il est réglé à ``TRUE``, validera l'extension en vérifiant aussi la casse.

.. _zend.file.transfer.validators.extension.example:

.. rubric:: Utiliser le validateur Extension

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limite les extensions à jpg et png
   $upload->addValidator('Extension', false, 'jpg,png');

   // Limite les extensions à jpg et png en utilisant
   // la notation de type tableau
   $upload->addValidator('Extension', false, array('jpg', 'png'));

   // Vérifie aussi la casse
   $upload->addValidator('Extension', false, array('mo', 'png', 'case' => true));
   if (!$upload->isValid('C:\temp\myfile.MO')) {
       print 'Non valide à cause de MO au lieu de mo';
   }

.. note::

   Notez que ce validateur ne vérifie que l'extension de fichier. Il ne vérifie pas le type *MIME* réel du
   fichier.

.. _zend.file.transfer.validators.filessize:

Validateur FilesSize
--------------------

Le validateur *FilesSize* vérifie le poids total de tous les fichiers transférés. Il supporte les options
suivantes :

- *min*\  : paramètre le poids minimum de tous les fichiers.

  Avec cette option vous pouvez définir le poids minimum de tous les fichiers que vous souhaitez transférer.

- *max*\  : paramètre le poids maximum de tous les fichiers.

  Avec cette option vous pouvez limiter le poids total des fichiers qui doivent être transférés, mais pas la
  taille individuelle de chaque fichier.

- *bytestring*\  : définit si un échec est retourné avec un taille plus facilement lisible pour l'utilisateur,
  ou avec une taille de fichier brute.

  Avec cette option vous pouvez en fait définir si l'utilisateur récupérera "10864" ou "10MB". La valeur par
  défaut est ``TRUE`` qui retournera "10MB".

Vous pouvez initialiser seulement avec une chaîne qui sera utilisée en tant que *max*. Mais vous pouvez aussi
utiliser les méthodes ``setMin()`` et ``setMax()`` pour paramétrer ces options plus tard et ``getMin()`` et
``getMax()`` pour les récupérer.

La taille elle-même est acceptée en notation SI comme sur la plupart des systèmes d'exploitation. Au lieu de
20000 octets (NdT. : "bytes" en anglais), vous pouvez utiliser **20kB**. Toutes les unités sont converties en
utilisant 1024 comme valeur de base. Les unités suivantes sont acceptées : *kB*, *MB*, *GB*, *TB*, *PB* et *EB*.
Comme mentionné précédemment vous devez noter que 1kB équivaut à 1024 octets.

.. _zend.file.transfer.validators.filessize.example:

.. rubric:: Utiliser le validateur FilesSize

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limite la taille de tous les fichiers à 40000 octets
   $upload->addValidator('FilesSize', false, 40000);

   // Limite la taille de tous les fichiers dans une plage de 10kB à 4MB
   $upload->addValidator('FilesSize', false, array('min' => '10kB',
                                                   'max' => '4MB'));

   // Comme ci-dessus, mais retourne la taille de fichier brute plutôt qu'une chaîne
   $upload->addValidator('FilesSize', false, array('min' => '10kB',
                                                   'max' => '4MB',
                                                   'bytestring' => false));

.. note::

   Notez que ce validateur stocke le poids des fichiers vérifiés en interne. Le fichier qui excédera le poids
   maximum sera retourné en tant qu'erreur.

.. _zend.file.transfer.validators.imagesize:

Validateur ImageSize
--------------------

Le validateur *ImageSize* vérifie la taille des images. Il supporte les options suivantes :

- *minheight*\  : paramètre la hauteur minimum d'une image.

- *maxheight*\  : paramètre la hauteur maximum d'une image.

- *minwidth*\  : paramètre la largeur minimum d'une image.

- *maxwidth*\  : paramètre la largeur maximum d'une image.

Vous pouvez aussi utiliser les méthodes ``setImageMin()`` et ``setImageMax()`` pour régler les valeurs minimum et
maximum plus tard et ``getMin()`` et ``getMax()`` pour les récupérer.

Par commodité, il existe aussi les méthodes *setImageWidth* et *setImageHeight* qui paramètrent la largeur et la
hauteur minimum et maximum. Bien sûr les méthodes associées *getImageWidth* et *getImageHeight* sont aussi
disponibles.

Pour désactiver la validation d'une dimension, ne paramétrez pas l'option correspondante.

.. _zend.file.transfer.validators.imagesize.example:

.. rubric:: Utiliser le validateur ImageSize

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limite la taille de l'image à une hauteur de 100 à 200 et
   // une largeur de 40 à 80 pixels
   $upload->addValidator('ImageSize',
                         false,
                         array('minwidth' => 40,
                               'maxwidth' => 80,
                               'minheight' => 100,
                               'maxheight' => 200);

   // Autre possibilité de réglage
   $upload->setImageWidth(array('minwidth' => 20, 'maxwidth' => 200));

.. _zend.file.transfer.validators.iscompressed:

Validateur IsCompressed
-----------------------

Le validateur *IsCompressed* vérifie si un fichier transféré est une archive compressée comme zip ou arc. Ce
validateur est basée sur le validateur *MimeType* et supportent les mêmes méthodes et options. Vous pouvez
limiter ce validateur à des types de compression particuliers avec les méthodes décrites ci-dessous.

.. _zend.file.transfer.validators.iscompressed.example:

.. rubric:: Utiliser le validateur IsCompressed

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Vérifie si un fichier uploadé est une archive compressée
   $upload->addValidator('IsCompressed', false);

   // Limite ce validateur aux fichiers zip seulement
   $upload->addValidator('IsCompressed', false, array('application/zip'));

   // Limite ce validateur aux fichiers zip mais avec la notation simplifiée
   $upload->addValidator('IsCompressed', false, 'zip');

.. note::

   Notez qu'il n'y a pas de vérification si vous paramétrez un type de fichier qui n'est pas un type de
   compression. Ainsi il est donc possible de définir que les fichiers gif sont acceptés par ce validateur même
   si ce n'est pas logique.

.. _zend.file.transfer.validators.isimage:

Validateur IsImage
------------------

Le validateur *IsImage* vérifie si un fichier transféré est une image comme gif ou jpeg. Ce validateur est
basée sur le validateur *MimeType* et supportent les mêmes méthodes et options. Vous pouvez limiter ce
validateur à des types d'image particuliers avec les méthodes décrites ci-dessous.

.. _zend.file.transfer.validators.isimage.example:

.. rubric:: Utiliser le validateur IsImage

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Vérifie si un fichier uploadé est une image
   $upload->addValidator('IsImage', false);

   // Limite ce validateur aux fichiers gif seulement
   $upload->addValidator('IsImage', false, array('application/gif'));

   // Limite ce validateur aux fichiers jpeg mais avec la notation simplifiée
   $upload->addValidator('IsImage', false, 'jpeg');

.. note::

   Notez qu'il n'y a pas de vérification si vous paramétrez un type de fichier qui n'est pas un type d'image.
   Ainsi il est donc possible de définir que les fichiers zip sont acceptés par ce validateur même si ce n'est
   pas logique.

.. _zend.file.transfer.validators.hash:

Validateur Hash
---------------

Le validateur *Hash* vérifie le contenu du fichier transféré en le hachant. Ce validateur utilise l'extension de
hachage de *PHP*. Il supporte les options suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Paramètre la valeur de
  hachage qui doit être vérifié.

  Vous pouvez paramétrer de multiples hachages en les fournissant sous la forme d'un tableau. Chacun sera
  vérifié et seulement si tous échouent, la validation elle-même échouera.

- *algorithm*\  : paramètre l'algorithme à utiliser pour hacher le contenu.

  Vous pouvez paramétrer de multiples algorithmes en utilisant la méthode ``addHash()`` plusieurs fois.

.. _zend.file.transfer.validators.hash.example:

.. rubric:: Utiliser le validateur Hash

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Vérifie si le contenu d'un fichier uploadé correspond au hachage fourni
   $upload->addValidator('Hash', false, '3b3652f');

   // Limite ce validateur à deux différents hachages
   $upload->addValidator('Hash', false, array('3b3652f', 'e612b69'));

   // Paramètre un algorithme différent pour effectuer le hachage
   $upload->addValidator('Hash', false, array('315b3cd8273d44912a7', 'algorithm' => 'md5'));

.. note::

   Ce validateur supporte environ 34 algorithmes de hachage différents. Les plus connus sont "crc32", "md5" and
   "sha1". Si vous souhaitez connaître les autres algorithmes, voyez `la méthode hash_algos de PHP`_.

.. _zend.file.transfer.validators.md5:

Validateur Md5
--------------

Le validateur *Md5* vérifie le contenu du fichier transféré en le hachant. Ce validateur utilise l'extension de
hachage de *PHP* avec l'algorithme md5. Il supporte les options suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Paramètre la valeur de
  hachage qui doit être vérifié.

  Vous pouvez paramétrer de multiples hachages en les fournissant sous la forme d'un tableau. Chacun sera
  vérifié et seulement si tous échouent, la validation elle-même échouera.

.. _zend.file.transfer.validators.md5.example:

.. rubric:: Utiliser le validateur Md5

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Vérifie si le contenu d'un fichier uploadé correspond au hachage fourni
   $upload->addValidator('Md5', false, '3b3652f336522365223');

   // Limite ce validateur à deux différents hachages
   $upload->addValidator('Md5', false, array('3b3652f336522365223', 'eb3365f3365ddc65365'));

.. _zend.file.transfer.validators.mimetype:

Validateur MimeType
-------------------

Le validateur *MimeType* vérifie le type *MIME* des fichiers transférés. Il supporte les options suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Paramètre le type
  *MIME* à contrôler.

  Avec cette option vous pouvez définir le type *MIME* des fichiers qui seront acceptés.

- *headerCheck*\  : si spécifié à ``TRUE``, cette option va vérifier l'information *HTTP* concernant le type
  de fichier quand les extensions **fileInfo** ou **mimeMagic** ne seront pas trouvées. La valeur par défaut de
  cette option est ``FALSE``.

- *magicfile*\  : le magicfile qui sera utilisé.

  Avec cette option vous pouvez définir le magicfile à utiliser. Quand il n'est pas utilisé ou vide, la
  constante ``MAGIC`` sera utilisée. Cette option est disponible à partir de la version 1.7.1 de Zend Framework.

Ce validateur accepte des types *MIME* multiples soit sous la forme d'une chaîne utilisant le caractère virgule
(",") comme séparateur ou sous la forme d'un tableau. Vous pouvez aussi utiliser les méthodes ``setMimeType()``,
``addMimeType()``, et ``getMimeType()`` pour paramétrer et récupérer les types *MIME*.

Vous pouvez aussi paramétrer le magicfile qui sera utilisé par fileinfo avec l'option *magicfile*. De plus il
existe les méthodes ``setMagicFile()`` et ``getMagicFile()`` qui permettent de paramétrer ou récupérer plus
tard le paramètre *magicfile*. Ces méthodes sont disponibles à partir de la version Zend Framework 1.7.1.

.. _zend.file.transfer.validators.mimetype.example:

.. rubric:: Utiliser le validateur MimeType

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limite le type MIME de tous les fichiers aux images gif
   $upload->addValidator('MimeType', false, 'image/gif');

   // Limite le type MIME de tous les fichiers aux images jpeg et gif
   $upload->adValidator('MimeType', false, array('image/gif', 'image/jpeg');

   // Limite le type MIME de tous les fichiers au groupe des images
   $upload->addValidator('MimeType', false, 'image');

   // Utilise un magicfile différent
   $upload->addValidator('MimeType', false, array('image', 'magicfile' => '/path/to/magicfile.mgx'));

L'exemple ci-dessus montre qu'il est aussi possible de limiter le type *MIME* accepté à un groupe de type *MIME*.
Pour autoriser toutes les images utilisez simplement "image" en tant que type *MIME*. Ceci peut être appliqué à
tous les groupes de type *MIME* comme "image", "audio", "video", "text" et plus encore.

.. note::

   Notez qu'autoriser un groupe de type *MIME* acceptera tous les membres de ce groupe même si votre application
   ne les supporte pas. Par exemple quand vous autorisez "image", vous autorisez donc "image/xpixmap" ou
   "image/vasa", ce qui peut être problématique. Quand vous n'êtes pas sûr que votre application supporte tous
   les types, vous devriez définir individuellement les types *MIME* plutôt que le groupe complet.

.. note::

   Ce composant utilise l'extension *fileinfo* si elle est disponible. Si ce n'est pas le cas, il utilisera alors
   la fonction *mime_content_type*. Et si l'appel de fonction échoue, il utilisera le type *MIME* fourni par
   *HTTP*.

   Vous devez cependant être averti de possibles problèmes de sécurité si, ni *fileinfo*, ni
   *mime_content_type* ne sont disponibles : le type *MIME* fourni pas *HTTP* n'étant pas sécurisé et pouvant
   être facilement manipulé.

.. _zend.file.transfer.validators.notexists:

Validateur NotExists
--------------------

Le validateur *NotExists* l'existence des fichiers fournis. Il supporte les options suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Vérifie si le fichier
  n'existe pas dans le dossier fourni.

Ce validateur accepte des extensions multiples soit sous la forme d'une chaîne utilisant le caractère virgule
(",") comme séparateur ou sous la forme d'un tableau. Vous pouvez aussi utiliser les méthodes ``setDirectory()``,
``addDirectory()``, et ``getDirectory()`` pour paramétrer et récupérer les extensions.

.. _zend.file.transfer.validators.notexists.example:

.. rubric:: Utiliser le validateur NotExists

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Ajoute le dossier temporaire à vérifier
   $upload->addValidator('NotExists', false, '\temp');

   // Ajoute deux dossiers en utilisant la notation de type tableau
   $upload->addValidator('NotExists',
                         false,
                         array('\home\images',
                               '\home\uploads'));

.. note::

   Notez que ce validateur vérifie si le fichier n'existe dans aucun des dossiers fournis. La validation échoue
   si le fichier existe dans l'un des dossiers.

.. _zend.file.transfer.validators.sha1:

Validateur Sha1
---------------

Le validateur *Sha1* vérifie le contenu du fichier transféré en le hachant. Ce validateur utilise l'extension de
hachage de *PHP* avec l'algorithme sha1. Il supporte les options suivantes :

- ***\  : vous pouvez paramétrer n'importe quelle clé ou utiliser un tableau numérique. Paramètre la valeur de
  hachage qui doit être vérifié.

  Vous pouvez paramétrer de multiples hachages en les fournissant sous la forme d'un tableau. Chacun sera
  vérifié et seulement si tous échouent, la validation elle-même échouera.

.. _zend.file.transfer.validators.sha1.example:

.. rubric:: Utiliser le validateur Sha1

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Vérifie si le contenu d'un fichier uploadé correspond au hachage fourni
   $upload->addValidator('Sha1', false, '3b3652f336522365223');

   // Limite ce validateur à deux différents hachages
   $upload->addValidator('Sha1', false, array('3b3652f336522365223', 'eb3365f3365ddc65365'));

.. _zend.file.transfer.validators.size:

Validateur Size
---------------

Le validateur *Size* vérifie le poids d'un fichier unique. Il supporte les options suivantes :

- *min*\  : paramètre le poids minimum du fichier.

- *max*\  : paramètre le poids maximum du fichier.

- *bytestring*\  : définit si un échec est retourné avec un taille plus facilement lisible pour l'utilisateur,
  ou avec une taille de fichier brute.

  Avec cette option vous pouvez en fait définir si l'utilisateur récupérera "10864" ou "10MB". La valeur par
  défaut est ``TRUE`` qui retournera "10MB".

Vous pouvez initialiser seulement avec une chaîne qui sera utilisée en tant que *max*. Mais vous pouvez aussi
utiliser les méthodes ``setMin()`` et ``setMax()`` pour paramétrer ces options plus tard et ``getMin()`` et
``getMax()`` pour les récupérer.

Quand seule une chaîne est fournie, elle est utilisée en tant que *max*. Mais vous pouvez aussi utiliser les
méthodes ``setMin()`` et ``setMax()`` pour paramétrer ces options plus tard et ``getMin()`` et ``getMax()`` pour
les récupérer.

La taille elle-même est acceptée en notation SI comme sur la plupart des systèmes d'exploitation. Au lieu de
20000 octets, vous pouvez utiliser **20kB**. Toutes les unités sont converties en utilisant 1024 comme valeur de
base. Les unités suivantes sont acceptées : *kB*, *MB*, *GB*, *TB*, *PB* et *EB*. Comme mentionné précédemment
vous devez noter que 1kB équivaut à 1024 octets.

.. _zend.file.transfer.validators.size.example:

.. rubric:: Utiliser le validateur Size

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limite la taille d'un fichier à 40000 octets
   $upload->addValidator('Size', false, 40000);

   // Limite la taille du fichier 'uploadfile' dans une plage de 10kB à 4MB
   // Additionally returns the plain number in case of an error instead of a userfriendly one
   $upload->addValidator('Size', false, array('min' => '10kB',
                                              'max' => '4MB',
                                              'bytestring' => false));

.. _zend.file.transfer.validators.wordcount:

Validateur WordCount
--------------------

Le validateur *WordCount* vérifie le nombre de mots à l'intérieur des fichiers fournis. Il supporte les options
suivantes :

- *min*\  : spécifie le nombre de mots minimum qui doivent être trouvés.

- *max*\  : spécifie le nombre de mots maximum qui doivent être trouvés.

Si vous initialisez ce validateur avec une chaîne ou un entier, la valeur sera utilisée en tant que *max*. Mais
vous pouvez aussi utiliser les méthodes ``setMin()`` et ``setMax()`` pour paramétrer ces options plus tard et
``getMin()`` et ``getMax()`` pour les récupérer.

.. _zend.file.transfer.validators.wordcount.example:

.. rubric:: Utiliser le validateur WordCount

.. code-block:: php
   :linenos:

   $upload = new Zend_File_Transfer();

   // Limite le nombre maximum de mots dans les fichiers à 2000
   $upload->addValidator('WordCount', false, 2000);

   // Limite le nombre de mots dans les fichiers entre un minimum de 1000
   // et un maximum de 5000 mots
   $upload->addValidator('WordCount', false, array('min' => 1000, 'max' => 5000));



.. _`la méthode hash_algos de PHP`: http://php.net/manual/fr/function.hash-algos.php
