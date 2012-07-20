.. _zend.service.slideshare:

Zend_Service_SlideShare
=======================

Die ``Zend_Service_SlideShare`` wird verwendet um mit dem `slideshare.net`_ Web Service für das Online-Hosten von
Slideshows zu interagieren. Mit dieser Komponente kann eine Slideshow die in dieser Website gehostet wird in einer
Website eingebettet und sogar neue Slideshows zum eigenen Account hochgeladen werden.

.. _zend.service.slideshare.basicusage:

Mit Zend_Service_SlideShare beginnen
------------------------------------

Um die ``Zend_Service_SlideShare`` Komponente zu verwenden muß zuerst ein Account auf den slideshare.net Servern
erstellt werden (mehr Informationen können `hier`_ gefunden werden) um einen *API* Schlüssel, Benutzername,
Passwort und einen geteilten geheimen Wert zu erhalten -- diese werden alle benötigt um die
``Zend_Service_SlideShare`` Komponente zu verwenden.

Sobald ein Account erstellt wurde, kann die ``Zend_Service_SlideShare`` Komponente verwendet werden durch die
Erstellung eines ``Zend_Service_SlideShare`` Objektes und dem anbieten dieser Werte wie anbei gezeigt:

.. code-block:: php
   :linenos:

   // Erstellt eine neue Instanz der Komponente
   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

.. _zend.service.slideshare.slideshowobj:

Das SlideShow Objekt
--------------------

Alle Slideshows in der ``Zend_Service_SlideShare`` werden repräsentiert durch die Verwendung des
``Zend_Service_SlideShare_SlideShow`` Objektes (sowohl beim Empfangen als auch beim Hochladen neuer Slideshows).
Zur Referenz ist eine Pseudo-Code Version dieser Klasse anbei zu sehen.

.. code-block:: php
   :linenos:

   class Zend_Service_SlideShare_SlideShow {

       /**
        * Empfängt den Ort der Slideshow
        */
       public function getLocation() {
           return $this->_location;
       }

       /**
        * Erhält das Transcript für die Slideshow
        */
       public function getTranscript() {
           return $this->_transcript;
       }

       /**
        * Fügt ein Tag zu der Slideshow hinzu
        */
       public function addTag($tag) {
           $this->_tags[] = (string)$tag;
           return $this;
       }

       /**
        * Setzt die Tags für die Slideshow
        */
       public function setTags(Array $tags) {
           $this->_tags = $tags;
           return $this;
       }

       /**
        * Erhält alle Tags die mit der Slideshow assoziiert sind
        */
       public function getTags() {
           return $this->_tags;
       }

       /**
        * Setzt den Dateinamen im Lokalen Filesystem der Slideshow
        * (für das Hochladen einer neuen Slideshow)
        */
       public function setFilename($file) {
           $this->_slideShowFilename = (string)$file;
           return $this;
       }

       /**
        * Empfängt den Dateinamen auf dem lokalen Dateisystem der Slideshow
        * die hochgeladen werden soll
        */
       public function getFilename() {
           return $this->_slideShowFilename;
       }

       /**
        * Empfängt die ID für die Slideshow
        */
       public function getId() {
           return $this->_slideShowId;
       }

       /**
        * Empfängt den eingebetteten HTML Code für die Slideshow
        */
       public function getEmbedCode() {
           return $this->_embedCode;
       }

       /**
        * Empfängt die Thumbnail URi für die Slideshow
        */
       public function getThumbnailUrl() {
           return $this->_thumbnailUrl;
       }

       /**
        * Setzt den Titel für die Slideshow
        */
       public function setTitle($title) {
           $this->_title = (string)$title;
           return $this;
       }

       /**
        * Empfängt den Titel der Slideshow
        */
       public function getTitle() {
           return $this->_title;
       }

       /**
        * Setzt die Beschreibung für die Slideshow
        */
       public function setDescription($desc) {
           $this->_description = (string)$desc;
           return $this;
       }

       /**
        * Empfängt die Beschreibung der Slideshow
        */
       public function getDescription() {
           return $this->_description;
       }

       /**
        * Erhält den nummerischen Status der Slideshow auf dem Server
        */
       public function getStatus() {
           return $this->_status;
       }

       /**
        * Erhält die textuelle Beschreibung des Status der Slideshow
        * auf dem Server
        */
       public function getStatusDescription() {
           return $this->_statusDescription;
       }

       /**
        * Erhält den permanenten Link der Slideshow
        */
       public function getPermaLink() {
           return $this->_permalink;
       }

       /**
        * Erhält die Anzahl der Aufrufe der Slideshow
        */
       public function getNumViews() {
           return $this->_numViews;
       }
   }

.. note::

   Die obige Pseudo-Klasse zeigt nur die Methoden welche von End-Benutzer Entwicklern verwendet werden sollten.
   Andere vorhandene Methoden sind intern für die Komponente.

Wenn die ``Zend_Service_SlideShare`` Komponente verwendet wird, wird diese Daten Klasse sehr oft verwendet um
nachzusehen oder neue Slideshows zu oder von einem Webservice hinzuzufügen.

.. _zend.service.slideshare.getslideshow:

Empfangen einer einzelnen Slideshow
-----------------------------------

Die einfachste Verwendung der ``Zend_Service_SlideShare`` Komponente ist der Empfang einer einzelnen Slideshow
durch die Slideshow ID die von der slideshare.net Anwendung angeboten wird und kann durch den Aufruf der
``getSlideShow()`` auf einem ``Zend_Service_SlideShare`` Objekt und der Verwendung des resultierenden
``Zend_Service_SlideShare_SlideShow`` Objektes wie gezeigt durchgeführt werden.

.. code-block:: php
   :linenos:

   // Erstellt eine neue Instanz der Komponente
   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

   $slideshow = $ss->getSlideShow(123456);

   print "Slide Show Titel: {$slideshow->getTitle()}<br/>\n";
   print "Anzahl an Besuchen: {$slideshow->getNumViews()}<br/>\n";

.. _zend.service.slideshare.getslideshowlist:

Empfangen von Gruppen von Slideshows
------------------------------------

Wenn die spezielle ID einer Slideshow die einen interessiert und die man empfangen will nicht kennt, kann man auch
Gruppen von Slideshows empfangen durch Verwendung einer der drei Methoden:

- **Slideshows von einem speziellen Account**

  Slideshows können von einem speziellen Account empfangen werden durch Verwendung der
  ``getSlideShowsByUsername()`` Methode und der Angabe des Benutzernamens von dem die Slideshow empfangen werden
  soll

- **Slideshows mit einem speziellen Tag**

  Slideshows können empfangen werden wenn Sie ein oder mehrere spezielle Tags enthalten durch die Verwendung der
  ``getSlideShowsByTag()`` Methode und der Angabe von ein oder mehreren Tags welche der Slideshow zugeordnet sein
  müssen um Sie zu empfangen

- **Slideshows durch Gruppen**

  Man kann Slideshows empfangen welche Mitglied einer speziellen Gruppe sind durch Verwendung der
  ``getSlideShowsByGroup()`` Methode und der Angabe des Namens der Gruppe welcher die Slideshow angehören muß um
  Sie zu Empfangen

Jede der obigen Methoden des Empfangens mehrerer Slideshows zeigt das ein ähnlicher Ansatz verwendet wird. Ein
Beispiel der Verwendung jeder Methode wird anbei gezeigt:

.. code-block:: php
   :linenos:

   // Erstellt eine neue Instanz der Komponente
   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');

   $starting_offset = 0;
   $limit = 10;

   // Empfängt die ersten 10 jeden Typs
   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);
   $ss_tags = $ss->getSlideShowsByTag('zend', $starting_offset, $limit);
   $ss_group = $ss->getSlideShowsByGroup('mygroup', $starting_offset, $limit);

   // Durch die Slideshows iterieren
   foreach($ss_user as $slideshow) {
      print "Slide Show Titel: {$slideshow->getTitle}<br/>\n";
   }

.. _zend.service.slideshare.caching:

Zend_Service_SlideShare Caching Policy
--------------------------------------

Standardmäßig cached ``Zend_Service_SlideShare`` jede Anfrage an den Webservice automatisch in das Dateisystem
(Standardpfad ``/tmp``) für 12 Stunden. Wenn man das Verhalten ändern will, muß eine eigenes :ref:`Zend_Cache
<zend.cache>` Objekt durch Verwendung der ``setCacheObject()`` Methode angegeben werden wie anbei gezeigt:

.. code-block:: php
   :linenos:

   $frontendOptions = array(
                           'lifetime' => 7200,
                           'automatic_serialization' => true);
   $backendOptions  = array(
                           'cache_dir' => '/webtmp/');

   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');
   $ss->setCacheObject($cache);

   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);

.. _zend.service.slideshare.httpclient:

Das Verhalten des HTTP Clients ändern
-------------------------------------

Wenn das Verhalten des *HTTP* Clients, aus welchen Gründen auch immer, geändert werden soll wenn eine Anfrage an
den Webservice durchgeführt wird, kann das durch die Erstellung einer eigenen Instanz eines ``Zend_Http_Client``
Objektes durchgeführt werden (siehe :ref:`Zend_Http <zend.http>`). Das ist zum Beispiel nützlich wenn es
gewünscht ist das Timeout für die Verbindung auf etwas anderes als den Standardwert zu setzen wie anbei gezeigt:

.. code-block:: php
   :linenos:

   $client = new Zend_Http_Client();
   $client->setConfig(array('timeout' => 5));

   $ss = new Zend_Service_SlideShare('APIKEY',
                                     'SHAREDSECRET',
                                     'USERNAME',
                                     'PASSWORD');
   $ss->setHttpClient($client);
   $ss_user = $ss->getSlideShowsByUser('username', $starting_offset, $limit);



.. _`slideshare.net`: http://www.slideshare.net/
.. _`hier`: http://www.slideshare.net/developers/
