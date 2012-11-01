.. EN-Revision: none
.. _zend.file.transfer.introduction:

Zend\File\Transfer
==================

``Zend\File\Transfer`` permet aux développeurs de contrôler l'upload de fichiers mais aussi le téléchargement.
Il vous permet d'utiliser les validateurs incorporés pour le traitement de fichier et même la possibilité de
changer les fichiers avec des filtres. ``Zend\File\Transfer`` fonctionne avec des adaptateurs ce qui vous permet
d'utiliser la même *API* pour différents protocoles de transfert *HTTP*, FTP, WEBDAV et plus encore.

.. note::

   **Limitation**

   L'implémentation actuelle de ``Zend\File\Transfer`` est limitée aux uploads de type *HTTP* Post. Le
   téléchargement de fichiers et les autres adaptateurs seront ajoutés dans les prochaines versions. Les
   méthodes non implémentées pour le moment lèveront une exception. Donc réellement vous devriez directement
   utiliser une instance de ``Zend\File\Transfer\Adapter\Http``. Ceci changera dans le futur, dès qu'il existera
   des adaptateurs disponibles.

.. note::

   **Formulaires**

   Quand vous utilisez ``Zend_Form`` vous devriez lire et suivre les exemples décrits dans le chapitre
   ``Zend_Form`` et ne pas utiliser manuellement ``Zend\File\Transfer``. Mais les informations que vous pourrez
   lire dans le présent chapitre vous seront malgré tout utile, même si vous ne l'utilisez pas directement.
   Toutes les considérations, descriptions et solutions sont les mêmes quand vous utilisez ``Zend\File\Transfer``
   au travers de ``Zend_Form``.

L'utilisation de ``Zend\File\Transfer`` est assez simple. Il consiste en deux parties. Le formulaire *HTTP* qui
réalise l'upload, et la gestion des fichiers uploadés avec ``Zend\File\Transfer``. Regardez l'exemple suivant :

.. _zend.file.transfer.introduction.example:

.. rubric:: Formulaire simple d'upload de fichier

Cet exemple illustre un upload de fichier basique avec ``Zend\File\Transfer``. La première partie est le
formulaire. Dans notre exemple, il n'y a qu'un seul fichier que nous souhaitons uploadé.

.. code-block:: php
   :linenos:

   <form enctype="multipart/form-data" action="/file/upload" method="POST">
       <input type="hidden" name="MAX_FILE_SIZE" value="100000" />
           Choose a file to upload:
           <input name="uploadedfile" type="file" />
           <br />
       <input type="submit" value="Upload File" />
   </form>

Notez que vous devriez utiliser :ref:`Zend\Form_Element\File <zend.form.standardElements.file>` par simplicité
plutôt que de créer le HTML manuellement.

L'étape suivante est de créer le récepteur de l'upload. Dans notre exemple le récepteur est "*/file/upload*".
Donc nous créons le contrôleur *file* avec l'action *upload*.

.. code-block:: php
   :linenos:

   $adapter = new Zend\File\Transfer\Adapter\Http();

   $adapter->setDestination('C:\temp');

   if (!$adapter->receive()) {
       $messages = $adapter->getMessages();
       echo implode("\n", $messages);
   }

Comme vous le voyez, l'utilisation la plus simple est de définir une destination avec la méthode *setDestination*
et d'appeler la méthode ``receive()``. S'il apparaît des erreurs au cours de l'upload, alors vous les
récupérerez grâce à une exception qui sera retournée.

.. note::

   **Attention**

   Maintenez à l'esprit qu'il s'agit de l'utilisation la plus simple. Vous **ne devez jamais** utiliser cet
   exemple en environnement de production car il causerait de graves problèmes de sécurité. Vous devez toujours
   utiliser des validateurs pour accroître la sécurité.

.. _zend.file.transfer.introduction.adapters:

Adaptateurs supportés par Zend\File\Transfer
--------------------------------------------

``Zend\File\Transfer`` est construit pour supporter différents adaptateurs et différentes directions. Il est
conçu pour permettre l'upload, le téléchargement et même l'envoi bidirectionnel (upload avec un adaptateur et
télécharge avec un autre adaptateur en même temps) de fichiers.

.. _zend.file.transfer.introduction.options:

Options de Zend\File\Transfer
-----------------------------

``Zend\File\Transfer`` et ses adaptateurs supportent plusieurs options. Vous pouvez paramétrer toutes les options
soit en les fournissant au constructeur, ou en utilisant ``setOptions($options)``. ``getOptions()`` retournera les
options actuellement paramétrées. Ci-dessous, vous trouverez la liste des options supportées :

- *ignoreNoFile*: si cette option vaut ``TRUE``, tous les validateurs ignoreront le fait que le fichier à été
  uploadé ou non par le formulaire. Cette option vaut par défaut ``FALSE``, ce qui lance une erreur indiquant que
  le fichier n'a pas été fourni.

.. _zend.file.transfer.introduction.checking:

Vérification des fichiers
-------------------------

``Zend\File\Transfer`` possède plusieurs méthodes qui permettent de vérifier suivant différentes
considérations. Ceci est particulièrement utile quand vous devez travailler avec des fichiers qui ont été
uploadés.

- ``isValid($files = null)``: cette méthode vérifie si le(s) fichier(s) est(sont) valide(s), en se basant sur les
  validateurs affectés à chacun de ces fichiers. Si aucun fichier n'est fourni, tous les fichiers seront
  vérifiés. Notez que cette méthode sera appelée en dernier quand les fichiers seront reçus.

- ``isUploaded($files = null)``: cette méthode vérifie si le(s) fichier(s) fourni(s) a (ont) été uploadé(s)
  par l'utilisateur. Ceci est utile si vous avez défini que certains fichiers sont optionnels. Si aucun fichier
  n'est fourni, tous les fichiers seront vérifiés.

- ``isReceived($files = null)``: cette méthode vérifie si le(s) fichier(s) fourni(s) a (ont) bien été reçu(s).
  Si aucun fichier n'est fourni, tous les fichiers seront vérifiés.

.. _zend.file.transfer.introduction.checking.example:

.. rubric:: Vérification de fichiers

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();

   // Retourne toutes les informations connues sur le fichier
   $files = $upload->getFileInfo();

   foreach ($files as $file => $info) {
       // Fichier uploadé ?
       if (!$upload->isUploaded($file)) {
           print "Pourquoi n'avez-vous pas uploadé ce fichier ?";
           continue;
       }

       // Les validateurs sont-ils OK ?
       if (!$upload->isValid($file)) {
           print "Désolé mais $file ne correspond à ce que nous attendons";
           continue;
       }
   }

   $upload->receive();

.. _zend.file.transfer.introduction.informations:

Informations complémentaires sur les fichiers
---------------------------------------------

``Zend\File\Transfer`` peut fournir de multiples informations complémentaires sur les fichiers. Les méthodes
suivantes sont disponibles :

- ``getFileName($file = null, $path = true)``: cette méthode retourne le vrai nom de fichier d'un fichier
  transféré.

- ``getFileInfo($file = null)``: cette méthode retourne tous les informations internes concernant un fichier
  transféré donné.

- *getFileSize($file = null)*: cette méthode retourne la taille réelle d'un fichier transféré donné.

- *getHash($hash = 'crc32', $files = null)*: cette méthode retourne la valeur de hachage du contenu d'un fichier
  transféré donné.

- ``getMimeType($files = null)``: cette méthode retourne le type *MIME* d'un fichier transféré donné.

``getFileName()`` accepte le nom d'un élément entant que premier paramètre. Si aucun n'est fourni, tous les
fichiers connus seront retournées sous la forme d'un tableau. Si le fichier est un "multifile", vous le
récupérerez aussi sous la forme d'un tableau. S'il n'y a qu'un seul fichier alors une chaîne sera retournée.

Par défaut les noms de fichier sont retournés avec leur chemin d'accès complet. Si vous souhaitez seulement le
nom de fichier sans le chemin, vous pouvez paramétrer le second paramètre ``$path`` à ``FALSE`` ce qui tronquera
le chemin.

.. _zend.file.transfer.introduction.informations.example1:

.. rubric:: Récupération du nom de fichier

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();
   $upload->receive();

   // Retourne le nom de fichier pour tous les fichiers
   $names = $upload->getFileName();

   // Retourne le nom de fichier de l'élément de formulaire "foo"
   $names = $upload->getFileName('foo');

.. note::

   Notez que le nom de fichier peut changer quand vous recevez le fichier. Ceci est du au fait qu'après la
   réception, tous les filtres sot appliqués. Donc vous ne devriez appeler ``getFileName()`` qu'après avoir
   reçu les fichiers.

``getFileSize()`` retourne par défaut la taille réelle d'un fichier en notation SI ce qui signifie que vous
récupérerez *2kB* au lieu de ``2048``. Si vous voulez la taille brute, utilisez l'option *useByteString* à
``FALSE``.

.. _zend.file.transfer.introduction.informations.example.getfilesize:

.. rubric:: Récupération de la taille de fichier

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();
   $upload->receive();

   // Retourne les tailles de tous les fichiers sous la forme
   // d'un tableau si plus d'un fichier a été uploadé
   $size = $upload->getFileSize();

   // Bascule de la notation SI vers une taille brute
   $upload->setOption(array('useByteString' => false));
   $size = $upload->getFileSize();

.. note::

   **Client given filesize**

   Note that the filesize which is given by the client is not seen as save input. Therefor the real size of the
   file will be detected and returned instead of the filesize sent by the client.

``getHash()`` accepte le nom de l'algorithme de hachage en tant que premier paramètre. Pour avoir une liste des
algorithmes connus, regardez `la méthode hash_algos de PHP`_. Si vous ne fournissez aucun algorithme, celui par
défaut sera *crc32*.

.. _zend.file.transfer.introduction.informations.example2:

.. rubric:: Récupération d'un hash de fichier

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();
   $upload->receive();

   // Retourne le hachage de fichier pour tous les fichiers sous la forme
   // d'un tableau si plusieurs fichiers sont fournis
   $hash = $upload->getHash('md5');

   // Retourne le hachage de l'élément de formulaire "foo"
   $names = $upload->getHash('crc32', 'foo');

.. note::

   **Valeur retournée**

   Notez que si un fichier ou un élément de formulaire donné contient plus d'un fichier, la valeur retournée
   sera un tableau.

``getMimeType()`` retourne le type *MIME* d'un fichier. Si plus d'un fichier a été uploadé, elle retourne un
tableau, sinon c'est une chaîne.

.. _zend.file.transfer.introduction.informations.getmimetype:

.. rubric:: Récupération du type MIME de fichier

.. code-block:: php
   :linenos:

   $upload = new Zend\File\Transfer();
   $upload->receive();

   $mime = $upload->getMimeType();

   // Retourne le type MIME pour l'élément de formulaire "foo"
   $names = $upload->getMimeType('foo');

.. note::

   **Client given mimetype**

   Note that the mimetype which is given by the client is not seen as save input. Therefor the real mimetype of the
   file will be detected and returned instead of the mimetype sent by the client.

.. warning::

   **Exception possible**

   Notez que cette méthode utilise l'extension fileinfo si elle est disponible. Si elle n'est pas trouvé, elle
   utilise l'extension mimemagic. Quand aucune extension n'est fournie, une exception est levée.

.. warning::

   **Original data within $_FILES**

   Due to security reasons also the original data within $_FILES will be overridden as soon as
   ``Zend\File\Transfer`` is initiated. When you want to omit this behaviour and have the original data simply set
   the ``detectInfos`` option to ``FALSE`` at initiation.

   This option will have no effect after you initiated ``Zend\File\Transfer``.

.. _zend.file.transfer.introduction.uploadprogress:

Progress for file uploads
-------------------------

``Zend\File\Transfer`` can give you the actual state of a fileupload in progress. To use this feature you need
either the ``APC`` extension which is provided with most default *PHP* installations, or the *uploadprogress*
extension. Both extensions are detected and used automatically. To be able to get the progress you need to meet
some prerequisites.

First, you need to have either ``APC`` or *uploadprogress* to be enabled. Note that you can disable this feature of
``APC`` within your php.ini.

Second, you need to have the proper hidden fields added in the form which sends the files. When you use
``Zend\Form_Element\File`` this hidden fields are automatically added by ``Zend_Form``.

When the above two points are provided then you are able to get the actual progress of the file upload by using the
*getProgress* method. Actually there are 2 official ways to handle this.

.. _zend.file.transfer.introduction.uploadprogress.progressadapter:

Using a progressbar adapter
^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can use the convinient **Zend_ProgressBar** to get the actual progress and can display it in a simple manner to
your user.

To archive this, you have to add the wished **Zend\ProgressBar\Adapter** to ``getProgress()`` when you are calling
it the first time. For details about the right adapter to use, look into the chapter :ref:`Zend_ProgressBar
Standard Adapters <zend.progressbar.adapters>`.

.. _zend.file.transfer.introduction.uploadprogress.progressadapter.example1:

.. rubric:: Using the progressbar adapter to retrieve the actual state

.. code-block:: php
   :linenos:

   $adapter = new Zend\ProgressBar_Adapter\Console();
   $upload  = Zend\File\Transfer\Adapter\Http::getProgress($adapter);

   $upload = null;
   while (!$upload['done']) {
       $upload = Zend\File\Transfer\Adapter\Http:getProgress($upload);
   }

The complete handling is done by ``getProgress()`` for you in the background.

.. _zend.file.transfer.introduction.uploadprogress.manually:

Using getProgress() manually
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can also work manually with ``getProgress()`` without the usage of ``Zend_ProgressBar``.

Call ``getProgress()`` without settings. It will return you an array with several keys. They differ according to
the used *PHP* extension. But the following keys are given independently of the extension:

- **id**: The ID of this upload. This ID identifies the upload within the extension. It is filled automatically.
  You should never change or give this value yourself.

- **total**: The total filesize of the uploaded files in bytes as integer.

- **current**: The current uploaded filesize in bytes as integer.

- **rate**: The average upload speed in bytes per second as integer.

- **done**: Returns true when the upload is finished and false otherwise.

- **message**: The actual message. Eighter the progress as text in the form **10kB / 200kB**, or a helpful message
  in the case of a problem. Problems could be, that there is no upload in progress, that there was a failure while
  retrieving the data for the progress, or that the upload has been canceled.

- **progress**: This optional key takes a instance of Zend\ProgressBar\Adapter or Zend_ProgressBar and allows to
  get the actual upload state within a progressbar.

- **session**: This optional key takes the name of a session namespace which will be used within Zend_ProgressBar.
  When this key is not given it defaults to ``Zend\File\Transfer\Adapter\Http\ProgressBar``.

All other returned keys are provided directly from the extensions and will not be checked.

The following example shows a possible manual usage:

.. _zend.file.transfer.introduction.uploadprogress.manually.example1:

.. rubric:: Manual usage of the file progress

.. code-block:: php
   :linenos:

   $upload  = Zend\File\Transfer\Adapter\Http::getProgress();

   while (!$upload['done']) {
       $upload = Zend\File\Transfer\Adapter\Http:getProgress($upload);
       print "\nActual progress:".$upload['message'];
       // do whatever you need
   }



.. _`la méthode hash_algos de PHP`: http://php.net/manual/fr/function.hash-algos.php
