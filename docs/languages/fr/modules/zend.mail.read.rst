.. EN-Revision: none
.. _zend.mail.read:

Lire des émail
==============

``Zend_Mail`` peut lire des émail provenant de différents stockages locaux ou distants. Tous bénéficient de la
même *API* pour compter et extraire les messages, certains implémentent des interfaces additionnelles pour des
fonctionnalités moins communes. Pour une vue d'ensemble des fonctionnalités des stockages implémentés voir la
table suivante.

.. _zend.mail.read.table-1:

.. table:: Vue d'ensemble des fonctionnalités de lecture d'émail

   +----------------------------+-----+-------+-------+-------+
   |Fonctionnalité              |Mbox |Maildir|Pop3   |IMAP   |
   +============================+=====+=======+=======+=======+
   |Type de stockage            |local|local  |distant|distant|
   +----------------------------+-----+-------+-------+-------+
   |Extraction des messages     |Oui  |Oui    |Oui    |Oui    |
   +----------------------------+-----+-------+-------+-------+
   |Extraction des parties mimes|émulé|émulé  |émulé  |émulé  |
   +----------------------------+-----+-------+-------+-------+
   |Dossiers                    |Oui  |Oui    |Non    |Oui    |
   +----------------------------+-----+-------+-------+-------+
   |Créer des messages/dossiers |Non  |A faire|Non    |A faire|
   +----------------------------+-----+-------+-------+-------+
   |Flags                       |Non  |Oui    |Non    |Oui    |
   +----------------------------+-----+-------+-------+-------+
   |Quota                       |Non  |Oui    |Non    |Non    |
   +----------------------------+-----+-------+-------+-------+

.. _zend.mail.read-example:

Exemple simple avec Pop3
------------------------

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'localhost',
                                            'user'     => 'test',
                                            'password' => 'test'));

   echo $mail->countMessages() . " messages trouvés\n";
   foreach ($mail as $message) {
       echo "Mail from '{$message->from}': {$message->subject}\n";
   }

.. _zend.mail.read-open-local:

Ouvrir un stockage local
------------------------

Mbox et Maildir sont les deux formats supportés pour le stockage local des émail, tous les deux dans leurs
formats le plus simple.

Si vous voulez lire un fichier Mbox, vous devez juste donner le nom du fichier au constructeur de
``Zend_Mail_Storage_Mbox``:

.. code-block:: php
   :linenos:

   $mail =
       new Zend_Mail_Storage_Mbox(array('filename' => '/home/test/mail/inbox'));

Maildir est très similaire mais nécessite un nom de dossier :

.. code-block:: php
   :linenos:

   $mail =
       new Zend_Mail_Storage_Maildir(array('dirname' => '/home/test/mail/'));

Ces deux constructeurs lèvent une exception ``Zend_Mail_Exception`` si le stockage ne peut pas être lu.

.. _zend.mail.read-open-remote:

Ouvrir un stockage distant
--------------------------

Pour les stockages distants les deux protocoles les plus populaires sont supportés : Pop3 et Imap. Les deux
nécessitent au moins un hôte et un utilisateur pour se connecter et s'identifier. Le mot de passe par défaut est
une chaîne vide et le port par défaut celui donné dans la *RFC* du protocole.

.. code-block:: php
   :linenos:

   // connexion à Pop3
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'exemple.com'
                                            'user'     => 'test',
                                            'password' => 'test'));

   // connexion à Imap
   $mail = new Zend_Mail_Storage_Imap(array('host'     => 'exemple.com'
                                            'user'     => 'test',
                                            'password' => 'test'));

   // exemple à un port non standard
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'exemple.com',
                                            'port'     => 1120
                                            'user'     => 'test',
                                            'password' => 'test'));

Pour ces deux stockages *SSL* et TLS sont supportés. Si vous utilisez *SSL* le port par défaut change comme
indiqué dans la *RFC*.

.. code-block:: php
   :linenos:

   // exemples pour Zend_Mail_Storage_Pop3,
   // identique à Zend_Mail_Storage_Imap

   // utiliser SSL avec un port différent
   // (par défaut 995 pour Pop3 et 993 pour Imap)
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'exemple.com'
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'SSL'));

   // utiliser TLS
   $mail = new Zend_Mail_Storage_Pop3(array('host'     => 'exemple.com'
                                            'user'     => 'test',
                                            'password' => 'test',
                                            'ssl'      => 'TLS'));

Les deux constructeurs peuvent lever une exception ``Zend_Mail_Exception`` ou ``Zend_Mail_Protocol_Exception``\
(étendant ``Zend_Mail_Exception``), en fonction du type de l'erreur.

.. _zend.mail.read-fetching:

Extraire des messages et autres méthodes simples
------------------------------------------------

Dès que vous avez ouvert l'accès, les messages peuvent être extraits. Vous devez fournir un numéro de message,
qui est un compteur qui démarre à 1 pour le premier message. Pour extraire le message vous utilisez la méthode
``getMessage()``:

.. code-block:: php
   :linenos:

   $message = $mail->getMessage($numeroDeMessage);

L'accès sous forme de tableau est aussi supporté, mais cet méthode d'accès ne supporte pas les paramètres
additionnels qui aurait pu être ajouté à ``getMessage()``. Tant que vous n'en n'avez pas besoin et que vous
pouvez vivre avec les valeurs par défaut, vous pouvez utiliser :

.. code-block:: php
   :linenos:

   $message = $mail[$numeroDeMessage];

Pour itérer tous les messages, l'interface *Iterator* est implémentée :

.. code-block:: php
   :linenos:

   foreach ($mail as $numeroDeMessage => $message) {
       // faire qqch ...
   }

Pour compter les messages dans le stockage, vous pouvez soit utiliser la méthode ``countMessages()`` ou utiliser
l'accès de type tableau :

.. code-block:: php
   :linenos:

   // par méthode
   $maxMessage = $mail->countMessages();

   // type tableau
   $maxMessage = count($mail);

Pour supprimer un mail vous pouvez utiliser la méthode ``removeMessage()`` ou l'accès de type tableau :

.. code-block:: php
   :linenos:

   // méthode
   $mail->removeMessage($numeroDeMessage);

   // type tableau
   unset($mail[$messageNum]);

.. _zend.mail.read-message:

Travailler avec les messages
----------------------------

Après avoir extrait les messages avec ``getMessage()`` vous voulez extraire les en-têtes, le contenu ou une
partie d'un message multipart. Tous les en-têtes peuvent être accédés via les propriétés ou la méthode
``getHeader()`` si vous voulez plus de contrôle ou avoir accès à des en-têtes peu communs. Les noms des
en-têtes gérés en interne avec une casse minuscule, ainsi la casse du nom de l'en-tête importe peu. En outre
les en-têtes avec un tiret-bas peuvent être écrit avec la `notation Camel`_. Si aucun en-tête n'est trouvé
pour les deux notations, une exception est levée. Pour éviter ceci, la méthode ``headerExists()`` peut être
utilisée pour vérifier l'existence d'un en-tête.

.. code-block:: php
   :linenos:

   // récupérer l'objet message
   $message = $mail->getMessage(1);

   // afficher le sujet du message
   echo $message->subject . "\n";

   // récupérer l'en-tête content-type
   $type = $message->contentType;

   // vérifier si CC est spécifié :
   if( isset($message->cc) ) { // ou $message->headerExists('cc');
       $cc = $message->cc;
   }

Si vous avez plusieurs en-têtes avec le même nom, par exemple les en-têtes "Received", vous pourriez les vouloir
sous la forme d'un tableau plutôt qu'en tant que chaîne. Ceci est possible avec la méthode ``getHeader()``.

.. code-block:: php
   :linenos:

   // récupérer l'en-tête comme une propriété - le résultat est toujours
   // une chaîne, avec de nouvelles lignes entre chaque occurence
   // dans le message
   $received = $message->received;

   // la même chose avec la méthode getHeader()
   $received = $message->getHeader('received', 'string');

   // ou mieux un tableau avec une entrée pour chaque occurence
   $received = $message->getHeader('received', 'array');
   foreach ($received as $line) {
       // faire qqch
   }

   // si vous ne définissez pas de format vous récupérerez la représentation
   // interne (chaîne pour en-têtes uniques, tableau pour en-têtes multiples
   $received = $message->getHeader('received');
   if (is_string($received)) {
       // seulement un en-tête received trouvé dans le message
   }

La méthode ``getHeaders()`` retourne tous les headers sous forme de tableau avec des clés en minuscules et des
valeurs en tant que tableau pour des en-têtes multiples ou une chaîne pour des en-têtes uniques.

.. code-block:: php
   :linenos:

   // récupère tous les en-têtes
   foreach ($message->getHeaders() as $name => $value) {
       if (is_string($value)) {
           echo "$name: $value\n";
           continue;
       }
       foreach ($value as $entry) {
           echo "$name: $entry\n";
       }
   }

Si vous n'avez pas de message de type multipart, extraire le contenu est facilité avec ``getContent()``. A la
différence des en-têtes, le contenu est seulement extrait en cas de besoin (alias late-fetch).

.. code-block:: php
   :linenos:

   // affiche le contenu du message
   echo '<pre>';
   echo $message->getContent();
   echo '</pre>';

Vérifier si un message est de type multipart est réalisé avec la méthode ``isMultipart()``. Si vous avez un
message de type multipart vous pouvez récupérer une instance de ``Zend_Mail_Part`` avec la méthode
``getPart()``. ``Zend_Mail_Part`` est la classe de base de ``Zend_Mail_Message``, donc vous avez les mêmes
méthodes : ``getHeader()``, ``getHeaders()``, ``getContent()``, ``getPart()``, *isMultipart* et les propriétés
pour les en-têtes.

.. code-block:: php
   :linenos:

   // récupérer la première partie non-multipart
   $part = $message;
   while ($part->isMultipart()) {
       $part = $message->getPart(1);
   }
   echo 'Le type de cette partie est '
      . strtok($part->contentType, ';')
      . "\n";
   echo "Contenu :\n";
   echo $part->getContent();

``Zend_Mail_Part`` implémente aussi *RecursiveIterator*, qui rend facile le scan de toutes les parties. Et pour un
affichage facile, il implémente de plus la méthode magique ``__toString()`` qui retourne le contenu.

.. code-block:: php
   :linenos:

   // affiche la première partie de type text/plain=
   $foundPart = null;
   foreach (new RecursiveIteratorIterator($mail->getMessage(1)) as $part) {
       try {
           if (strtok($part->contentType, ';') == 'text/plain') {
               $foundPart = $part;
               break;
           }
       } catch (Zend_Mail_Exception $e) {
           // ignore
       }
   }
   if (!$foundPart) {
       echo 'Aucune partie "plain text" trouvés';
   } else {
       echo "Partie \"plain text\" : \n" . $foundPart;
   }

.. _zend.mail.read-flags:

Vérifier les drapeaux ("flags")
-------------------------------

Maildir et IMAP supporte l'enregistrement de drapeaux. La classe ``Zend_Mail_Storage`` possède des constantes pour
tous les drapeaux maildir et IMAP connus, nommés ``Zend_Mail_Storage::FLAG_<nomdudrapeau>``. Pour vérifier les
drapeaux ``Zend_Mail_Message`` possède une méthode ``hasFlag()``. Avec ``getFlags()`` vous récupérez tous les
drapeaux existants.

.. code-block:: php
   :linenos:

   // trouvé les messages non lus
   echo "Emails non lus :\n";
   foreach ($mail as $message) {
       if ($message->hasFlag(Zend_Mail_Storage::FLAG_SEEN)) {
           continue;
       }
       // marque les emails récents/nouveaux
       if ($message->hasFlag(Zend_Mail_Storage::FLAG_RECENT)) {
           echo '! ';
       } else {
           echo '  ';
       }
       echo $message->subject . "\n";
   }

   // vérifie les drapeaux connus
   $flags = $message->getFlags();
   echo "Le message est marqué comme : ";
   foreach ($flags as $flag) {
       switch ($flag) {
           case Zend_Mail_Storage::FLAG_ANSWERED:
               echo 'Réponse ';
               break;
           case Zend_Mail_Storage::FLAG_FLAGGED:
               echo 'Marqués ';
               break;

           // ...
           // vérifie d'autres drapeaux
           // ...

           default:
               echo $flag . '(drapeau inconnu) ';
       }
   }

Comme IMAP autorise les drapeaux définis par client ou l'utilisateur, vous pouvez obtenir ces drapeaux même s'ils
n'ont pas de constante dans ``Zend_Mail_Storage``. Au lieu de cela ils sont retournés comme une chaîne et peuvent
être vérifiés de la même manière avec ``hasFlag()``.

.. code-block:: php
   :linenos:

   // Vérifie le message avec les drapeaux $EstUnSpam, $SpamTeste
   if (!$message->hasFlag('$SpamTeste')) {
       echo 'ce message n\'est pas considéré comme un spam';
   } else if ($message->hasFlag('$EstUnSpam')) {
       echo 'ce message est un spam';
   } else {
       echo 'ce message est sûr';
   }

.. _zend.mail.read-folders:

Utiliser les dossiers
---------------------

Tous les stockages, excepté Pop3, supportent les dossiers, également appelés boîtes aux lettres. L'interface
implémentée par tous les stockages supportant les dossiers s'appelle ``Zend_Mail_Storage_Folder_Interface``. En
outre toutes ces classes ont un paramètre facultatif additionnel appelé *folder*, qui est le dossier choisi
après ouverture, dans le constructeur.

Pour les stockages locaux vous devez employer les classes séparées appelées ``Zend_Mail_Storage_Folder_Mbox`` ou
``Zend_Mail_Storage_Folder_Maildir``. Tous les deux ont besoin d'un paramètre nommé *dirname* avec le nom du
dossier de base. Le format pour le maildir est comme définie dans maildir++ (avec un point comme délimiteur par
défaut), Mbox est une hiérarchie de dossiers avec des fichiers Mbox. Si vous n'avez pas un dossier de Mbox
appelé INBOX dans votre dossier de base Mbox vous devez placer un autre dossier dans le constructeur.

``Zend_Mail_Storage_Imap`` supporte déjà des dossiers par défaut. Exemples pour ouvrir ces stockages :

.. code-block:: php
   :linenos:

   // mbox avec dossiers
   $mail = new Zend_Mail_Storage_Folder_Mbox(
               array('dirname' => '/home/test/mail/')
           );

   // mbox avec un dossier par défaut nommé INBOX, fontionne aussi
   // avec Zend_Mail_Storage_Folder_Maildir et Zend_Mail_Storage_Imap
   $mail = new Zend_Mail_Storage_Folder_Mbox(
               array('dirname' => '/home/test/mail/', 'folder'  => 'Archive')
           );

   // maildir avec dossiers
   $mail = new Zend_Mail_Storage_Folder_Maildir(
               array('dirname' => '/home/test/mail/')
           );

   // maildir avec deux-points comme délimiteur,
   // comme suggéré dans Maildir++
   $mail = new Zend_Mail_Storage_Folder_Maildir(
               array('dirname' => '/home/test/mail/', 'delim'   => ':')
           );

   // imap est le même avec ou sans dossier
   $mail = new Zend_Mail_Storage_Imap(array('host'     => 'example.com',
                                            'user'     => 'test',
                                            'password' => 'test'));

Avec la méthode ``getFolders($root = null)`` vous pouvez obtenir la hiérarchie des dossiers en commençant par le
dossier racine ou le dossier fourni. Elle est retournée comme instance de ``Zend_Mail_Storage_Folder``, qui
implémente *RecursiveIterator* et tous ses enfants sont également des instances de ``Zend_Mail_Storage_Folder``.
Chacune de ces instances à des noms locaux et globaux retournés par les méthodes ``getLocalName()`` et
``getGlobalName()``. Le nom global est le nom absolu du dossier racine (délimiteurs y compris), le nom local est
le nom dans le dossier parent.

.. _zend.mail.read-folders.table-1:

.. table:: Noms de dossiers

   +---------------+---------+
   |Nom global     |Nom local|
   +===============+=========+
   |/INBOX         |INBOX    |
   +---------------+---------+
   |/Archive/2005  |2005     |
   +---------------+---------+
   |List.ZF.General|General  |
   +---------------+---------+

Si vous employez l'itérateur, la clé de l'élément courant est le nom local. Le nom global est également
retourné par la méthode magique ``__toString()``. Quelques dossiers peuvent ne pas être sélectionnables, ce qui
veut dire qu'ils ne peuvent pas stocker des messages et les choisir entraînerait une erreur. Ceci peut être
vérifié avec la méthode ``isSelectable()``. Ainsi il est très facile de produire l'arbre entier dans une vue :

.. code-block:: php
   :linenos:

   $folders = new RecursiveIteratorIterator(
                       $this->mail->getFolders(),
                       RecursiveIteratorIterator::SELF_FIRST
                   );
   echo '<select name="folder">';
   foreach ($folders as $localName => $folder) {
       $localName = str_pad('', $folders->getDepth(), '-', STR_PAD_LEFT)
                  . $localName;
       echo '<option';
       if (!$folder->isSelectable()) {
           echo ' disabled="disabled"';
       }
       echo ' value="' . htmlspecialchars($folder) . '">'
           . htmlspecialchars($localName) . '</option>';
   }
   echo '</select>';

Les dossiers choisis courants sont retournés par la méthode ``getSelectedFolder()``. Changer de dossier est fait
avec la méthode ``selectFolder()``, qui a besoin du nom global comme paramètre. Si vous voulez éviter d'écrire
des délimiteurs vous pouvez également employer les propriétés d'une instance de ``Zend_Mail_Storage_Folder``:

.. code-block:: php
   :linenos:

   // selon votre stockage et ses réglages $rootFolder->Archive->2005
   // est la même chose que :
   //   /Archive/2005
   //  Archive:2005
   //  INBOX.Archive.2005
   //  ...
   $folder = $mail->getFolders()->Archive->2005;
   echo 'Le précédent dossier était '
      . $mail->getSelectedFolder()
      . "Le nouveau dossier est $folder\n";
   $mail->selectFolder($folder);

.. _zend.mail.read-advanced:

Utilisation avancée
-------------------

.. _zend.mail.read-advanced.noop:

Utiliser NOOP
^^^^^^^^^^^^^

Si vous employez un stockage distant et avez une longue tâche vous pourriez devoir maintenir la connexion
persistante par l'intermédiaire du noop :

.. code-block:: php
   :linenos:

   foreach ($mail as $message) {

       // faire qqch...

       $mail->noop(); // maintient la connexion

       // faire autre chose...

       $mail->noop(); // maintient la connexion
   }

.. _zend.mail.read-advanced.extending:

Mettre en cache des instances
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Mail_Storage_Mbox``, ``Zend_Mail_Storage_Folder_Mbox``, ``Zend_Mail_Storage_Maildir`` et
``Zend_Mail_Storage_Folder_Maildir`` implémentant les méthodes magiques ``__sleep()`` et ``__wakeup()``, ce qui
veut dire qu'ils sont sérialisable. Ceci évite d'analyser les dossiers ou l'arbre des dossiers plus d'une fois.
L'inconvénient est que votre stockage de Mbox ou de Maildir ne doit pas changer. Quelques contrôles faciles sont
faits, comme ré-analyser le dossier courant de Mbox si le temps de modification change ou ré-analysé la
structure du dossier si un dossier a disparu (ce qui a toujours comme conséquence une erreur, mais vous pouvez
rechercher un autre dossier après). Il est meilleur si vous avez quelque chose comme un fichier de signal pour des
changements et la vérifiez avant d'employer l'instance caché.

.. code-block:: php
   :linenos:

   // il n'y a pas de gestionnaire spécifique de cache utilisé ici,
   // changer le code pour utiliser votre gestionnaire de cache
   $signal_file = '/home/test/.mail.last_change';
   $mbox_basedir = '/home/test/mail/';
   $cache_id = 'exemple de mail en cache ' . $mbox_basedir . $signal_file;

   $cache = new Your_Cache_Class();
   if (!$cache->isCached($cache_id) ||
       filemtime($signal_file) > $cache->getMTime($cache_id)) {
       $mail = new Zend_Mail_Storage_Folder_Pop3(
                   array('dirname' => $mbox_basedir)
               );
   } else {
       $mail = $cache->get($cache_id);
   }

   // faire qqch ...

   $cache->set($cache_id, $mail);

Étendre les classes de protocoles
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Les stockages distants utilisent deux classes : ``Zend_Mail_Storage_<NOM>`` et ``Zend_Mail_Protocol_<NOM>``. La
classe de protocole traduit les commandes et les réponses de protocole et issu de ou pour *PHP*, comme des
méthodes pour les commandes ou les variables avec différentes structures pour les données. L'autre/classe
principale met en application l'interface commune.

Si vous avez besoin de fonctionnalités additionnelles de protocole vous pouvez étendre la classe de protocole et
l'employer dans le constructeur de la classe principale. Supposer par exemple que nous devons joindre différents
ports avant que nous puissions nous relier à POP3.

.. code-block:: php
   :linenos:

   Zend_Loader::loadClass('Zend_Mail_Storage_Pop3');

   class Example_Mail_Exception extends Zend_Mail_Exception
   {}

   class Example_Mail_Protocol_Exception extends Zend_Mail_Protocol_Exception
   {}

   class Example_Mail_Protocol_Pop3_Knock extends Zend_Mail_Protocol_Pop3
   {
       private $host, $port;

       public function __construct($host, $port = null)
       {
           // pas d'auto-connexion dans cette classe
           $this->host = $host;
           $this->port = $port;
       }

       public function knock($port)
       {
           $sock = @fsockopen($this->host, $port);
           if ($sock) {
               fclose($sock);
           }
       }

       public function connect($host = null, $port = null, $ssl = false)
       {
           if ($host === null) {
               $host = $this->host;
           }
           if ($port === null) {
               $port = $this->port;
           }
           parent::connect($host, $port);
       }
   }

   class Example_Mail_Pop3_Knock extends Zend_Mail_Storage_Pop3
   {
       public function __construct(array $params)
       {
           // ... vérifier les $params ici ! ...
           $protocol =
               new Example_Mail_Protocol_Pop3_Knock($params['host']);

           // faire votre fonction "spéciale"
           foreach ((array)$params['knock_ports'] as $port) {
               $protocol->knock($port);
           }

           // récupérer l'état coorect
           $protocol->connect($params['host'], $params['port']);
           $protocol->login($params['user'], $params['password']);

           // initialise le parent
           parent::__construct($protocol);
       }
   }

   $mail = new Example_Mail_Pop3_Knock(
               array('host'        => 'localhost',
                                      'user'        => 'test',
                                      'password'    => 'test',
                                      'knock_ports' => array(1101,
                                                             1105,
                                                             1111))
           );

Comme vous voyez nous supposons toujours que nous sommes reliés, identifiés et, si supporté, un dossier est
choisi dans le constructeur de la classe principale. Ainsi si vous assignez votre propre classe de protocole vous
devez toujours vous assurer que c'est fait ou la prochaine méthode échouera si le serveur ne la permet pas dans
l'état actuel.

.. _zend.mail.read-advanced.quota:

Utilisation des Quotas (avant 1.5)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Mail_Storage_Writable_Maildir`` supporte les quotas Maildir++. Ceci est désactivé par défaut, mais il est
possible de l'utiliser manuellement, si la vérification automatique n'est pas souhaitée (ce qui veut dire que
``appendMessage()``, ``removeMessage()`` et ``copyMessage()`` ne vérifie pas et n'ajoute pas d'entrée dans le
fichier de contrôle de la taille du dossier de mails). Si vous l'activez une exception sera levée si vous tentez
d'écrire dans le dossier de mails et qu'il a déjà atteint son quota.

Il existe trois méthodes pour les quotas : ``getQuota()``, ``setQuota()`` et ``checkQuota()``:

.. code-block:: php
   :linenos:

   $mail = new Zend_Mail_Storage_Writable_Maildir(
               array('dirname' => '/home/test/mail/')
           );
   $mail->setQuota(true); // true pour activer, false pour désactiver
   echo 'La vérification du quota est maintenant ',
        $mail->getQuota() ? 'active' : 'inactive',
        "\n";
   // la vérification du quota peut être utilisée
   // si celle-ci est désactivée
   echo 'Vous êtes ',
        $mail->checkQuota() ? 'hors quota' : 'dans le quota',
        "\n";

``checkQuota()`` peut aussi retournée une réponse plus détaillée :

.. code-block:: php
   :linenos:

   $quota = $mail->checkQuota(true);
   echo 'Vous êtes ',
        $quota['over_quota'] ? 'hors quota' : 'dans le quota',
        "\n";
   echo 'Vous avez ',
        $quota['count'],
        ' de ',
        $quota['quota']['count'],
        ' messages et vous utilisez ';
   echo $quota['size'], ' de ', $quota['quota']['size'], ' octets';

Si vous voulez spécifier votre propre quota plutôt que d'utiliser celui spécifié dans le fichier de contrôle
de la taille du dossier de mails, vous pouvez le faire avec ``setQuota()``:

.. code-block:: php
   :linenos:

   // le nombre de messages et la taille en octet sont supportés,
   // l'ordre est important
   $quota = $mail->setQuota(array('size' => 10000, 'count' => 100));

Pour ajouter vos propres vérifications de quota, utilisez des caractères uniques en tant que clé et ils seront
préservés (mais évidemment non vérifié). Il est aussi possible d'étendre
``Zend_Mail_Storage_Writable_Maildir`` pour définir votre propre quota seulement si le fichier de contrôle de la
taille du dossier de mails est absent (qui peut se produire dans Maildir++) :

.. code-block:: php
   :linenos:

   class Exemple_Mail_Storage_Maildir extends Zend_Mail_Storage_Writable_Maildir {
       // getQuota est appelé avec $fromStorage = true
       // par la vérification de quota
       public function getQuota($fromStorage = false) {
           try {
               return parent::getQuota($fromStorage);
           } catch (Zend_Mail_Storage_Exception $e) {
               if (!$fromStorage) {
                   // Erreur inconnue
                   throw $e;
               }
               // le fichier de contrôle de la taille du dossier de mails
               // doit être absent

               list($count, $size) = get_un_autre_quota();
               return array('count' => $count, 'size' => $size);
           }
       }
   }



.. _`notation Camel`: http://en.wikipedia.org/wiki/CamelCase
