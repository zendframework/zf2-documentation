.. EN-Revision: none
.. _zend.service.delicious:

Zend\Service\Delicious
======================

.. _zend.service.delicious.introduction:

Einführung
----------

``Zend\Service\Delicious`` ist eine simple *API*, um die *XML*- und *JSON*-Webservices von `del.icio.us`_ nutzen zu
können. Diese Komponente bietet Lese- und Schreibzugriff auf Beiträge bei del.icio.us, sofern man die nötigen
Zugrffisrechte vorweist.

.. _zend.service.delicious.introduction.getAllPosts:

.. rubric:: Alle Beiträge abrufen

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');
   $posts = $delicious->getAllPosts();

   foreach ($posts as $post) {
       echo "--\n";
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

.. _zend.service.delicious.retrieving_posts:

Beiträge abrufen
----------------

``Zend\Service\Delicious`` bietet drei Möglichkeiten, um Beiträge von del.icio.us abzurufen: ``getPosts()``,
``getRecentPosts()`` und ``getAllPosts()``. Jede dieser Methoden liefert eine Instanz der Klasse
``Zend\Service\Delicious\PostList``, welche die abgerufenen Beiträge beinhaltet.

.. code-block:: php
   :linenos:

   /**
    * Beiträge werden je nach Parametern geladen. Ist kein Datum oder
    * kein URL gegeben, so wird standardmäßig das aktuelleste Datum
    * verwendet.
    *
    * @param string $tag Optionaler Filter nach einem bestimmten tag
    * @param Zend_Date $dt Optionaler Filter nach Datum
    * @param string $url Optionaler Filter nach URL
    * @return Zend\Service\Delicious\PostList
    */
   public function getPosts($tag = null, $dt = null, $url = null);

   /**
    * Die letzten x Beiträge abrufen.
    *
    * @param string $tag   Optionaler Filter nach einem bestimmten tag
    * @param string $count Maximale Anzahl der Beiträge, die
    *                      zurückgeliefert werden (standardmäßig 15)
    * @return Zend\Service\Delicious\PostList
    */
   public function getRecentPosts($tag = null, $count = 15);

   /**
    * Alle Beiträge abrufen
    *
    * @param string $tag Optionaler Filter nach einem bestimmten tag
    * @return Zend\Service\Delicious\PostList
    */
   public function getAllPosts($tag = null);

.. _zend.service.delicious.postlist:

Zend\Service\Delicious\PostList
-------------------------------

Instanzen dieser Klasse werden von den Methoden ``getPosts()``, ``getAllPosts()``, ``getRecentPosts()`` und
``getUserPosts()`` der Klasse ``Zend\Service\Delicious`` zurückgegeben.

Für den leichteren Zugriff implementiert diese Klasse die Interfaces *Countable*, *Iterator* and *ArrayAccess*.

.. _zend.service.delicious.postlist.accessing_post_lists:

.. rubric:: Zugriff auf Beitragslisten

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');
   $posts = $delicious->getAllPosts();

   // Beiträge zählen
   echo count($posts);

   // Iteration über die Beitragsliste
   foreach ($posts as $post) {
       echo "--\n";
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

   // speziellen Beitrag über Arrayzugriff erhalten
   echo $posts[0]->getTitle();

.. note::

   Die Methoden ``ArrayAccess::offsetSet()`` und ``ArrayAccess::offsetUnset()`` werfen in dieser Implementierung
   Ausnahmen (Exceptions). Dadurch werfen Codes, wie z.B. *unset($posts[0]);* oder *$posts[0] = 'A';* Exceptions,
   da nur Leserechte für die Eigenschaften bestehen.

Beitragslisten-Objekte haben zwei integrierte Filter-Möglichkenten. Die Listen können nach Tags und nach *URL*\ s
gefiltert werden.

.. _zend.service.delicious.postlist.example.withTags:

.. rubric:: Eine Beitragsliste nach gewissen tags filtern

Beiträge mit speziellen tags können durch die Methode ``withTags()`` aus der Liste herausgefiltert werden. Der
Einfachheit halber, kann die Methode ``withTag()`` verwendet werden, wenn nur nach einem einzigen tag gefiltert
werden soll.

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');
   $posts = $delicious->getAllPosts();

   // Alle Beiträge ausgeben, denen die tags "php" und "zend" zugeordnet sind
   foreach ($posts->withTags(array('php', 'zend')) as $post) {
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

.. _zend.service.delicious.postlist.example.byUrl:

.. rubric:: Eine Beitragsliste nach URLs filtern

Beiträge können mit Hilfe der Methode ``withUrl()`` nach einer speziellen *URL* gefiltert werden indem ein
passender regulärer Ausdruck spezifiziert wird.

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');
   $posts = $delicious->getAllPosts();

   // Beiträge ausgeben, deren URL "/help/" enthält
   foreach ($posts->withUrl('/help/') as $post) {
       echo "Title: {$post->getTitle()}\n";
       echo "Url: {$post->getUrl()}\n";
   }

.. _zend.service.delicious.editing_posts:

Das Bearbeiten von Beiträgen
----------------------------

.. _zend.service.delicious.editing_posts.post_editing:

.. rubric:: Beiträge bearbeiten

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');
   $posts = $delicious->getPosts();

   // Titel setzen
   $posts[0]->setTitle('New title');
   // Änderungen speichern
   $posts[0]->save();

.. _zend.service.delicious.editing_posts.method_call_chaining:

.. rubric:: Verkettung von Methodenaufrufen

Jede set-Methode gibt das Beitragsobjekt zurück, so dass man die Methodenaufrufe verketten kann.

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');
   $posts = $delicious->getPosts();

   $posts[0]->setTitle('New title')
            ->setNotes('New notes')
            ->save();

.. _zend.service.delicious.deleting_posts:

Das Löschen von Beiträgen
-------------------------

Es existieren zwei Wege, um einen Beitrag zu löschen. Zum Einen explizit über den Beitrags-*URL* oder zum Anderen
durch den Aufruf der Methode ``delete()`` mit dem Objekt, welches den zu löschenden Beitrag repräsentiert.

.. _zend.service.delicious.deleting_posts.deleting_posts:

.. rubric:: Beiträge löschen

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');

   // Explizites Löschen eines Beitrags über einen URL
   $delicious->deletePost('http://framework.zend.com');

   // Löschen eines Beitrags über den Aufruf der delete()-Methode
   $posts = $delicious->getPosts();
   $posts[0]->delete();

   // eine alternative Anwendung von deletePost()
   $delicious->deletePost($posts[0]->getUrl());

.. _zend.service.delicious.adding_posts:

Das Hinzufügen von neuen Beiträgen
----------------------------------

Um einen Beitrag hinzuzufügen, muss zu Beginn die Methode ``createNewPost()`` aufgerufen werden, welche eine
Instanz der Klasse ``Zend\Service\Delicious\Post`` zurückgibt. Danach kann mit Hilfe des erhaltenen Objekts der
Beitrag verändert werden. Nach der Änderung muss die ``save()``-Methode aufgerufen werden, damit die Änderungen
in die del.icio.us-Datenbank übernommen werden.

.. _zend.service.delicious.adding_posts.adding_a_post:

.. rubric:: Einen Beitrag hinzufügen

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');

   // Neuen Beitrag erstellen, ändern und abspeichern
   // (Verkettung der Methodenaufrufe)
   $delicious->createNewPost('Zend Framework', 'http://framework.zend.com')
             ->setNotes('Zend Framework Homepage')
             ->save();

   // Neuen Beitrag erstellen, ändern und abspeichern (ohne Verkettung)
   $newPost = $delicious->createNewPost('Zend Framework',
                                        'http://framework.zend.com');
   $newPost->setNotes('Zend Framework Homepage');
   $newPost->save();

.. _zend.service.delicious.tags:

Tags
----

.. _zend.service.delicious.tags.tags:

.. rubric:: Tags

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');

   // Abrufen aller tags
   print_r($delicious->getTags());

   // Umbenennen des tags "ZF" zu "Zend Framework"
   $delicious->renameTag('ZF', 'zendFramework');

.. _zend.service.delicious.bundles:

Bundles
-------

.. _zend.service.delicious.bundles.example:

.. rubric:: Bundles

.. code-block:: php
   :linenos:

   $delicious = new Zend\Service\Delicious('username', 'password');

   // get all bundles
   print_r($delicious->getBundles());

   // delete bundle someBundle
   $delicious->deleteBundle('someBundle');

   // add bundle
   $delicious->addBundle('newBundle', array('tag1', 'tag2'));

.. _zend.service.delicious.public_data:

Öffentliche Daten
-----------------

Die del.icio.us webservice *API* ermöglicht den Zugriff auf die öffentlichen Daten aller Nutzer.

.. _zend.service.delicious.public_data.functions_for_retrieving_public_data:

.. table:: Methoden, um öffentliche Daten abzurufen

   +----------------+----------------------------------------------+-------------------------------+
   |Name            |Beschreibung                                  |Rückgabewert                   |
   +================+==============================================+===============================+
   |getUserFans()   |Liefert die Fans eines Nutzers                |Array                          |
   +----------------+----------------------------------------------+-------------------------------+
   |getUserNetwork()|Liefert das Netzwerk eines Nutzers            |Array                          |
   +----------------+----------------------------------------------+-------------------------------+
   |getUserPosts()  |Liefert alle Beiträge eines Nutzers           |Zend\Service\Delicious\PostList|
   +----------------+----------------------------------------------+-------------------------------+
   |getUserTags()   |Liefert alle tags, die der Nutzer vergeben hat|Array                          |
   +----------------+----------------------------------------------+-------------------------------+

.. note::

   Sollten nur diese Methoden verwendet werden, ist dem Konstruktor der Klasse ``Zend\Service\Delicious`` bei der
   Instanzierung kein Nutzername in Kombination mit dem entsprechenden Passwort zu übergeben.

.. _zend.service.delicious.public_data.retrieving_public_data:

.. rubric:: öffentliche Daten auslesen

.. code-block:: php
   :linenos:

   // Nutzername und Passwort werden nicht benötigt
   $delicious = new Zend\Service\Delicious();

   // Laden der Fans eines Nutzers
   print_r($delicious->getUserFans('someUser'));

   // Laden des Netzwerks eines Nutzers
   print_r($delicious->getUserNetwork('someUser'));

   // Laden der vergebenen tags eines Nutzers
   print_r($delicious->getUserTags('someUser'));

.. _zend.service.delicious.public_data.posts:

Öffentliche Beiträge
^^^^^^^^^^^^^^^^^^^^

Wenn öffentliche Beiträge über die Methode ``getUserPosts()`` bezogen werden wird ein
``Zend\Service\Delicious\PostList`` Objekt zurückgegeben, welches die einzelnen Beiträge in einer Liste von
``Zend\Service\Delicious\SimplePost``-Objekten speichert. Diese Objekte enthalten Basisinformationen über den
Beitrag, wie z.B. den *URL*, den Titel, die Notizen und Tags.

.. _zend.service.delicious.public_data.posts.SimplePost_methods:

.. table:: Methoden der Klasse Zend\Service\Delicious\SimplePost

   +----------+-----------------------------------------+------------+
   |Name      |Beschreibung                             |Rückgabewert|
   +==========+=========================================+============+
   |getNotes()|Liefert die Beschreibung zu einem Beitrag|String      |
   +----------+-----------------------------------------+------------+
   |getTags() |Liefert die tags zu einem Beitrag        |Array       |
   +----------+-----------------------------------------+------------+
   |getTitle()|Liefert den Titel eines Beitrags         |String      |
   +----------+-----------------------------------------+------------+
   |getUrl()  |Liefert den URL eines Beitrags           |String      |
   +----------+-----------------------------------------+------------+

.. _zend.service.delicious.httpclient:

HTTP client
-----------

``Zend\Service\Delicious`` verwendet die Klasse ``Zend\Rest\Client``, um *HTTP*-Request an den del.icio.us
Webservice zu schicken. Um einzustellen, welchen *HTTP* Client ``Zend\Service\Delicious`` verwenden soll, muss der
*HTTP* Client der Klasse ``Zend\Rest\Client`` geändert werden.

.. _zend.service.delicious.httpclient.changing:

.. rubric:: Veränderung des HTTP clients der Klasse Zend\Rest\Client

.. code-block:: php
   :linenos:

   $myHttpClient = new My_Http_Client();
   Zend\Rest\Client::setHttpClient($myHttpClient);

Sollte man mehr als einen Request mit ``Zend\Service\Delicious`` senden, ist es sinnvoll den *HTTP* Client so zu
konfigurieren, dass die Verbindungen offen gehalten werden, um die Geschwindigkeit der Requests zu erhöhen.

.. _zend.service.delicious.httpclient.keepalive:

.. rubric:: Konifguration des HTTP clients, so dass Verbindungen geöffnet bleiben

.. code-block:: php
   :linenos:

   Zend\Rest\Client::getHttpClient()->setConfig(array(
           'keepalive' => true
   ));

.. note::

   Bei der Instanzierung eines ``Zend\Service\Delicious`` Objekts wird der *SSL* Transport der Klasse
   ``Zend\Rest\Client`` auf *'ssl'* anstatt auf *'ssl2'* gesetzt, da del.icio.us einige Probleme mit *'ssl2'* hat.
   So kann es vorkommen, dass die Vervollständigung eines Request sehr lange (um die zwei Sekunden) dauert.



.. _`del.icio.us`: http://del.icio.us
