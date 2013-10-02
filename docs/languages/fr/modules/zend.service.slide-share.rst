.. EN-Revision: none
.. _zend.service.slideshare:

Zend\Service\SlideShare
=======================

Le composant ``Zend\Service\SlideShare`` est utilisé dans l'interaction avec les services Web de
`slideshare.net`_, plate-forme servant d'hébergement de diaporamas. Grâce à ce composant, vous pouvez intégrer
des diaporamas de Slideshare, dans votre propre site Web, ou même uploader des nouveaux diaporamas sur votre
compte Slideshare, depuis votre site Web.

.. _zend.service.slideshare.basicusage:

Démarrage avec Zend\Service\SlideShare
--------------------------------------

Pour utiliser ``Zend\Service\SlideShare``, vous devez créer au préalable un compte sur slideshare.net (plus
d'informations à ce sujet `ici`_), afin de recevoir votre clé d'API et votre login / mot de passe, indispensables
pour utiliser le service Web.

Une fois votre compte créé, vous pouvez utiliser ``Zend\Service\SlideShare`` en créant une instance de
``Zend\Service\SlideShare`` en lui passant vos identifiants :

.. code-block:: php
   :linenos:

   // Crée une instance du composant
   $ss = new Zend\Service\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

.. _zend.service.slideshare.slideshowobj:

L'objet SlideShow
-----------------

Chaque diaporama issu de ``Zend\Service\SlideShare`` est matérialisé par un objet
``Zend\Service_SlideShare\SlideShow`` (que ce soit pour uploader ou récupérer des diaporamas). Pour information,
voici un pseudo code de cette classe :

.. code-block:: php
   :linenos:

   class Zend\Service_SlideShare\SlideShow {

       /**
        * Récupère l'emplacement du diaporama
        */
       public function getLocation() {
           return $this->_location;
       }

       /**
        * Récupère la transcription du diaporama
        */
       public function getTranscript() {
           return $this->_transcript;
       }

       /**
        * Associe un mot-clé au diaporama
        */
       public function addTag($tag) {
           $this->_tags[] = (string) $tag;
           return $this;
       }

       /**
        * Associe des mots-clés au diaporama
        */
       public function setTags(Array $tags) {
           $this->_tags = $tags;
           return $this;
       }

       /**
        * Récupère tous les mots-clés associés au diaporama
        */
       public function getTags() {
           return $this->_tags;
       }

       /**
        * Règle le nom de fichier du diaporama dans le système
        * de fichiers local (pour l'upload d'un nouveau diaporama)
        */
       public function setFilename($file) {
           $this->_slideShowFilename = (string) $file;
           return $this;
       }

       /**
        * Rècupère le nom de fichier du diaporama dans le système
        * de fichiers local qui sera uploadé
        */
       public function getFilename() {
           return $this->_slideShowFilename;
       }

       /**
        * Récupère l'ID du diaporama
        */
       public function getId() {
           return $this->_slideShowId;
       }

       /**
        * Récupère le code HTML utilisé pour la projection du diaporama
        */
       public function getEmbedCode() {
           return $this->_embedCode;
       }

       /**
        * Récupère l'URI de la vignette du diaporama
        */
       public function getThumbnailUrl() {
           return $this->_thumbnailUrl;
       }

       /**
        * Règle le titre du diaporama
        */
       public function setTitle($title) {
           $this->_title = (string) $title;
           return $this;
       }

       /**
        * Récupère le titre du diaporama
        */
       public function getTitle() {
           return $this->_title;
       }

       /**
        * Régle la description du diaporama
        */
       public function setDescription($desc) {
           $this->_description = (string) $desc;
           return $this;
       }

       /**
        * Récupère la description du diaporama
        */
       public function getDescription() {
           return $this->_description;
       }

       /**
        * Récupère le statut (numérique) du diaporama sur le serveur
        */
       public function getStatus() {
           return $this->_status;
       }

       /**
        * Récupère la description textuelle du statut du diaporama
        * sur le serveur
        */
       public function getStatusDescription() {
           return $this->_statusDescription;
       }

       /**
        * Récupère le lien permanent du diaporama
        */
       public function getPermaLink() {
           return $this->_permalink;
       }

       /**
        * Récupère le nombre de diapositives que le diaporama comprend
        */
       public function getNumViews() {
           return $this->_numViews;
       }
   }

.. note::

   La classe présentée ci dessus ne montre que les méthodes qui sont sensées être utilisées par les
   développeurs. D'autres méthodes internes au composant existent.

Lors de l'utilisation de ``Zend\Service\SlideShare``, la classe de données Slideshow sera souvent utilisée pour
parcourir, ajouter, ou modifier des diaporamas.

.. _zend.service.slideshare.getslideshow:

Récupérer un diaporama simplement
---------------------------------

La manière la plus simple d'utiliser ``Zend\Service\SlideShare`` est la récupération d'un diaporama depuis son
ID, fournit par le service slideshare.net, ceci est effectué via la méthode ``getSlideShow()`` de l'objet
``Zend\Service\SlideShare``. Le résultat de cette méthode est un objet de type
``Zend\Service_SlideShare\SlideShow``.

.. code-block:: php
   :linenos:

   // Création d'une instance du composant
   $ss = new Zend\Service\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

   $slideshow = $ss->getSlideShow(123456);

   print "Titre du diaporama : {$slideshow->getTitle()}<br/>\n";
   print "Nombre de diapositives : {$slideshow->getNumViews()}<br/>\n";

.. _zend.service.slideshare.getslideshowlist:

Récupérer des groupes de diaporamas
-----------------------------------

Si vous ne connaissez pas l'ID spécifique d'un diaporama vous intéressant, il est possible de récupérer des
groupes de diaporamas, en utilisant une de ces trois méthodes :

- **Diaporamas depuis un compte spécifique**

  La méthode ``getSlideShowsByUsername()`` va retourner tous les diaporamas depuis un compte utilisateur.

- **Diaporamas contenant des tags spécifiques**

  La méthode *getSlideShowsByTag* va retourner un ensemble de diaporamas comportant certains tags (mots-clés).

- **Diaporamas depuis un groupe**

  La méthode *getSlideShowsByGroup* récupère tous les diaporamas d'un groupe donné.

Voici un exemple utilisant les méthodes décrites ci-dessus :

.. code-block:: php
   :linenos:

   // Crée une nouvelle instance du composant
   $ss = new Zend\Service\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

   $starting_offset = 0;
   $limit = 10;

   // Récupère les 10 premiers de chaque type
   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);
   $ss_tags = $ss->getSlideShowsByTag('zend', $starting_offset, $limit);
   $ss_group = $ss->getSlideShowsByGroup('mygroup', $starting_offset, $limit);

   // Itère sur les diaporamas
   foreach ($ss_user as $slideshow) {
      print "Titre du diaporama : {$slideshow->getTitle}<br/>\n";
   }

.. _zend.service.slideshare.caching:

Politique de cache de Zend\Service\SlideShare
---------------------------------------------

Par défaut, ``Zend\Service\SlideShare`` va mettre en cache toute requête concernant le service Web, dans le
système de fichier (par défaut : */tmp*), ceci pour une durée de 12 heures. Si vous voulez changer ce
comportement, vous devez passer votre propre objet :ref:` <zend.cache>` en utilisant la méthode *setCacheObject*:

.. code-block:: php
   :linenos:

   $frontendOptions = array(
                           'lifetime' => 7200,
                           'automatic_serialization' => true);
   $backendOptions  = array(
                           'cache_dir' => '/webtmp/');

   $cache = Zend\Cache\Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   $ss = new Zend\Service\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');
   $ss->setCacheObject($cache);

   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);

.. _zend.service.slideshare.httpclient:

Changer le comportement du client HTTP
--------------------------------------

Si pour une raison quelconque vous souhaitez changer le comportement de l'objet client *HTTP* utilisé pour
interroger le service Web, vous pouvez créer votre propre instance de ``Zend\Http\Client`` (voyez :ref:`
<zend.http>`). Ceci peut être utile par exemple pour spécifier un timeout ou toute autre chose :

.. code-block:: php
   :linenos:

   $client = new Zend\Http\Client();
   $client->setConfig(array('timeout' => 5));

   $ss = new Zend\Service\SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');
   $ss->setHttpClient($client);
   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);



.. _`slideshare.net`: http://www.slideshare.net/
.. _`ici`: http://www.slideshare.net/developers/
