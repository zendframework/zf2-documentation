.. EN-Revision: none
.. _zend.gdata.books:

Die Buchsuche Daten API verwenden
=================================

Die Buchsuche Daten *API* von Google erlaubt Client Anwendungen Inhalte von Buchsuchen zu sehen und in der Form von
Google Daten *API* Feeds zu aktualisieren.

Die Client Anwendung kann die Buchsuche Daten *API* verwenden um Volltextsuchen nach Büchern durchzuführen und um
Standardinformationen von Büchern zu erhalten, diese zu bewerten und zu kommentieren. Man kann auch individuelle
`Sammlungen von Benutzerbibliotheken und öffentlichen Kommentaren`_. Letztendlich kann eine Anwendung
authentifizierte Anfragen abschicken um es Benutzern zu ermöglichen Bibliothekssammlungen zu erstellen, zu
modifizieren, zu bewerten, zu benennen, zu kommentieren und andere Accountspezifische Dinge zu erlauben.

Für weitere Informationen über die Buchsuche Daten *API* referieren Sie bitte zum offiziellen `PHP Developer's
Guide`_ auf code.google.com.

.. _zend.gdata.books.authentication:

Beim Buchsuche Service authentifizieren
---------------------------------------

Man kann sowohl auf öffentliche als auch private Feeds zugreifen indem man die Buchsuche Daten *API* verwendet.
Öffentliche Feeds benötigen keine Authentifizierung, aber man kann Sie nur lesen. Wenn man Benutzerbibliotheken
verändern oder bewerden will, oder Label hinzufügen will muß der eigene Client authentifiziert werden bevor man
private Feeds anfragt. Er kann sich authentifizieren indem einer von zwei Möglichkeiten verwendet wird: AuthSub
Proxy Authentifizierung oder ClientLogin Benutzername/Passwort Authentifizierung. Bitte referieren Sie zum
`Authentifizierungs Kapitel im PHP Developer Guide`_ für weitere Details.

.. _zend.gdata.books.searching_for_books:

Nach Büchern suchen
-------------------

Die Buchsuche Daten *API* bietet eine Anzahl an Feeds die Sammlungen von Büchern auflisten.

Die am meisten übliche Aktion ist das empfangen von Bücherlisten die einer Suchanfrage entsprechen. Um das zu tun
muß ein ``VolumeQuery`` Objekt erstellt und an die ``Books::getVolumeFeed()`` Methode übergeben werden.

Um zum Beispiel eine Schlüsselwortabfrage, mit einem Filter auf der Sichtbarkeit um die Ergebnisse auf partielle
oder komplette sichtbare Bücher zu gegrenzen, durchzuführen müssen die ``setMinViewability()`` und ``()``
Methoden des ``VolumeQuery`` Objekts verwendet werden. Der folgende Codeschnipsel zeigt Titel und Sichtbarkeit
aller Volumes deren Metadaten oder Texte dem Suchbegriff "domino" entsprechen:

.. code-block:: php
   :linenos:

   $books = new Zend_Gdata_Books();
   $query = $books->newVolumeQuery();

   $query->setQuery('domino');
   $query->setMinViewability('partial_view');

   $feed = $books->getVolumeFeed($query);

   foreach ($feed as $entry) {
       echo $entry->getVolumeId();
       echo $entry->getTitle();
       echo $entry->getViewability();
   }

Die ``Query`` Klasse, und Subklassen wie ``VolumeQuery``, sind dafür zuständig das Feed *URL* erzeugt werden. Der
VolumeQuery der vorher gezeigt wurde erzeugt eine *URL* die der folgenden entspricht:

.. code-block:: php
   :linenos:

   http://www.google.com/books/feeds/volumes?q=keyword&min-viewability=partial

Beachte: Da die Ergebnisse von Buchsuchen öffentlich sind, können Buchsuche Abfragen ohne Authentifizierung
durchgeführt werden.

Hier sind einige der üblichsten ``VolumeQuery`` Methoden für das Setzen von Suchparametern:

``setQuery()``: Spezifiziert einen Suchabfragebegriff. Buchsuchen durchsuchen alle Metadaten der Bücher und des
kompletten Textes nach Büchern die dem Begriff entsprechen. Buchmetadaten enthalten Titel, Schlüsselwörter,
Beschreibungen, Namen von Autoren, und Untertitel. Es ist zu beachten das alle Leerzeichen, Hochkomma oder andere
Punktierungen im Parameterwert *URL*-escaped werden müssen. (Verwende ein Plus (**+**) für ein Leerzeichen.) Um
nach einer exakten Phrase zu suchen muß die Phrase in Hochkomma eingeschlossen werden. Um zum Beispiel nach einem
Buch zu suchen das der Phrase "spy plane" entspricht, muß der ``q`` Parameter auf ``%22spy+plane%22`` gesetzt
werden. Man kann jede der `zusätzlichen Suchoperatoren`_ verwenden die von der Buchsuche unterstützt werden. Zum
Beispiel gibt ``jane+austen+-inauthor:austen`` Entsprechungen zurück die Jane Austen erwähnen (aber nicht von Ihr
geschrieben wurden).

``setStartIndex()``: Spezifiziert den Index des ersten passenden Ergebnisses das im Ergebnisset enthalten sein
sollte. Dieser Parameter verwendet einen eins-basierenden Index, was bedeutet dass das erste Ergebnis 1 ist, das
zweite Ergebnis 2 und so weiter. Dieser Parameter arbeitet in Verbindung mit dem max-results Parameter um
festzustellen welche Ergebnisse zurückzugeben sind. Um zum Beispiel das dritte Set von 10er Ergebnissen zu
erhalten, 21-30-set, muß der ``start-index`` Parameter auf **21** und der max-results Parameter auf **10** gesetzt
werden. Es ist zu beachten dass dies kein genereller Cursor Mechanismus ist. Wenn man zuerst eine Abfrage mit
``?start-index=1&max-results=10`` und anschließend eine andere Anfrage mit ``?start-index=11&max-results=10``,
kann der Service nicht garantieren das die Ergebnisse äquivalent sind, weil zwischen den zwei Anfragen
Einfügungen oder Löschungen durchgeführt worden sein können.

``setMaxResults()``: Spezifiziert die maximale Anzahl an Ergebnissen die im Ergebnisset enthalten sein sollen.
Dieser Parameter arbeitet in Verbindung mit dem start-index Parameter um festzustellen welche Ergebnisse
zurückgegeben werden sollen. Der Standardwert dieses Parameters ist **10** und der Maximalwert ist **20**.

``setMinViewability()``: Erlaubt es Ergebnisse entsprechend dem `Status der Sichtbarkeit`_ der Bücher zu filtern.
Dieser Parameter akzeptiert einen von drei Werten: **'none'** (der Standardwert, der alle passenden Bücher
zurückgibt Unabhängigkeit von der Sichtbarkeit), **'partial_view'** (was nur Bücher zurückgibt die der Benutzer
komplett oder teilweise sehen kann), oder **'full_view'** (was nur Bücher zurückgibt die der Benutzer in Ihrer
Komplettheit sehen kann).

.. _zend.gdata.books.partner_restrict:

Partner Co-Branded Suche
^^^^^^^^^^^^^^^^^^^^^^^^

Die Google Buchsuche bietet eine `Co-Branded Suche`_ an, die Inhaltspartner erlaubt Volltextsuchen Ihrer Bücher
von deren Webseite anzubieten.

Wenn man ein Partner ist der eine Co-Branded Suche durchführen will indem die Buchsuche Daten *API* verwendet
wird, kann man das tun indem die Feed *URL* von vorher so angepasst wird das Sie auf die eigene Co-Branded
Suchimplementation zeigt. Wenn zum Beispiel, eine Co-Branded Suche unter der folgenden *URL* vorhanden ist:

.. code-block:: php
   :linenos:

   http://www.google.com/books/p/PARTNER_COBRAND_ID?q=ball

kann man die gleichen Ergebnisse erhalten indem die Buchsuche Daten *API* mit der folgenden *URL* verwendet wird:

.. code-block:: php
   :linenos:

   http://www.google.com/books/feeds/p/PARTNER_COBRAND_ID/volumes?q=ball+-soccer

Um eine alternative *URL* zu spezifizieren wenn ein Volume Feed abgefragt wird, kann ein extra Parameter an
``newVolumeQuery()`` übergeben werden

.. code-block:: php
   :linenos:

   $query =
       $books->newVolumeQuery('http://www.google.com/books/p/PARTNER_COBRAND_ID');

Für zusätzliche Informationen oder Support, sehen Sie in unser `Partner Help Center`_.

.. _zend.gdata.books.community_features:

Übliche Features verwenden
--------------------------

.. _zend.gdata.books.adding_ratings:

Eine Bewertung hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^^

Ein Benutzer kann einem Buch eine Bewertung hinzufügen. Die Buchsuche verwendet eie 1-5 Bewertungssystem in dem 1
die geringste Bewertung ist. Benutzer können Ihre Bewertungen nicht aktualisieren oder löschen.

Um eine Bewertung hinzuzufügen, muß ein ``Rating`` an ``VolumeEntry`` hinzugefügt werden und an den
Anmerkungsfeed gesendet werden. Im unten gezeigten Beispiel starten wir von einem leeren ``VolumeEntry`` Objekt.

.. code-block:: php
   :linenos:

   $entry = new Zend_Gdata_Books_VolumeEntry();
   $entry->setId(new Zend_Gdata_App_Extension_Id(VOLUME_ID));
   $entry->setRating(new Zend_Gdata_Extension_Rating(3, 1, 5, 1));
   $books->insertVolume($entry, Zend_Gdata_Books::MY_ANNOTATION_FEED_URI);

.. _zend.gdata.books.reviews:

Reviews
^^^^^^^

Zusätzlich zu Bewertungen, können authentifizierte Benutzer Reviews übermitteln oder Ihre eigenen Reviews
bearbeiten. Für Informationen darüber wie vorher übermittelte Reviews angefragt werden können, siehe `Empfangen
von Anmerkungen`_.

.. _zend.gdata.books.adding_review:

Eine Review hinzufügen
^^^^^^^^^^^^^^^^^^^^^^

Um eine Review hinzuzufügen, muß man ein ``Review`` Objekt an ``VolumeEntry`` übergeben und es an den
Anmerkungsfeed übertragen. Im unteren Beispiel starten wir von einem bestehenden ``VolumeEntry`` Objekt.

.. code-block:: php
   :linenos:

   $annotationUrl = $entry->getAnnotationLink()->href;
   $review        = new Zend_Gdata_Books_Extension_Review();

   $review->setText("Dieses Buch ist aufregend!");
   $entry->setReview($review);
   $books->insertVolume($entry, $annotationUrl);

.. _zend.gdata.books.editing_review:

Eine Review bearbeiten
^^^^^^^^^^^^^^^^^^^^^^

Um eine bestehende Review zu aktualisieren muß man zuerst die Review die bearbeitet werden soll empfangen, diese
modifizieren, und dann an den Anmerkungsfeed übertragen.

.. code-block:: php
   :linenos:

   $entryUrl = $entry->getId()->getText();
   $review   = new Zend_Gdata_Books_Extension_Review();

   $review->setText("Dieses Buch ist leider nicht sehr gut!");
   $entry->setReview($review);
   $books->updateVolume($entry, $entryUrl);

.. _zend.gdata.books.labels:

Labels
^^^^^^

Die Buchsuche Daten *API* kann verwendet werden um Volumes mit Label über Schlüsselwörtern zu versehen. Ein
Benutzer kann diese übertragen, empfangen und verändern. Siehe `Anmerkungen empfangen`_ dafür wie vorher
übertragene Label gelesen werden können.

.. _zend.gdata.books.submitting_labels:

Ein Set von Label übermitteln
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um Label zu übermitteln muß ein ``Category`` Objekt mit dem Schema ``LABELS_SCHEME`` an ``VolumeEntry``
hinzugefügt und an den Anmerkungsfeed übergeben werden.

.. code-block:: php
   :linenos:

   $annotationUrl = $entry->getAnnotationLink()->href;
   $category      = new Zend_Gdata_App_Extension_Category(
       'rated',
       'http://schemas.google.com/books/2008/labels');
   $entry->setCategory(array($category));
   $books->insertVolume($entry, Zend_Gdata_Books::MY_ANNOTATION_FEED_URI);

.. _zend.gdata.books.retrieving_annotations:

Empfangen von Anmerkungen: Reviews, Bewertungen und Label
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Buchsuche Daten *API* kann verwendet werden um Anmerkungen zu empfangen die von einen angegebenen Benutzer
übermittelt wurden. Anmerkungen enthalten Reviews, Bewertungen und Label. Um irgendwelche Anmerkungen von
Benutzern zu empfangen muß eine nicht authentifizierte Anfrage gesendet werden die die BenutzerID des Benutzers
enthält. Um die Anmerkungen des authentifizierten Benutzers zu empfangen muß der Wert **me** als BenutzerID
verwendet werden.

.. code-block:: php
   :linenos:

   $feed = $books->getVolumeFeed(
               'http://www.google.com/books/feeds/users/USER_ID/volumes');
   <i>(oder)</i>
   $feed = $books->getUserAnnotationFeed();

   // Gibt Titel und Bewertungswerte aus
   foreach ($feed as $entry) {
       foreach ($feed->getTitles() as $title) {
           echo $title;
       }
       if ($entry->getRating()) {
           echo 'Bewertung: ' . $entry->getRating()->getAverage();
       }
   }

Für eine Liste an unterstützten Abfrageparametern, kann man in das Kapitel `Abfrageparameter`_ sehen.

.. _zend.gdata.books.deleting_annotations:

Anmerkungen löschen
^^^^^^^^^^^^^^^^^^^

Wenn man einen Anmerkungseintrag empfängt der Bewertungen, Reviews und/oder Label enthält können alle
Anmerkungen entfernt werden indem ``deleteVolume()`` an diesem Eintrag aufgerufen wird.

.. code-block:: php
   :linenos:

   $books->deleteVolume($entry);

.. _zend.gdata.books.sharing_with_my_library:

Büchersammlungen und My Library
-------------------------------

Die Google Buchsuche bietet eine Anzahl von Benutzerspezifischen Buchsammlungen, jede mit Ihrem eigenen Feed.

The wichtigste Sammlung ist die My Library des Benutzers, welche die Bücher repräsentiert die sich der Benutzer
merken, organisieren und mit anderen Teilen will. Das ist die Sammlung die der Benutzer sieht wenn er auf seine
oder ihre `My Library Seite`_ zugreift.

.. _zend.gdata.books.retrieving_books_in_library:

Bücher auf der Benutzerbibliothek erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die folgenden Kapitel beschreiben wie eine Liste von Büchern von der Bibliothek eines Benutzers, mit oder ohne
Abfrageparameter, empfangen werden können.

Man kann den öffentlichen Feed einer Buchsuche ohne Authentifizierung abfragen.

.. _zend.gdata.books.retrieving_all_books_in_library:

Alle Bücher in einer Benutzerbibliothek empfangen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um alle Bücher eines Benutzers zu empfangen muß eine Anfrage an den My Library Feed gesendet werden. Um die
Bibliothek des authentifizierten Benutzers zu erhalten muß **me** statt der ``USER_ID`` verwendet werden.

.. code-block:: php
   :linenos:

   $feed = $books->getUserLibraryFeed();

Es ist zu beachten das es sein kann das der Feed nicht alle Bücher des Benutzers enthält, weil es ein
Standardlimit der Anzahl der zurückgegebenen Ergebnisse gibt. Für weitere Information siehe den ``max-results``
Abfrageparameter in `Suchen nach Büchern`_.

.. _zend.gdata.books.retrieving_books_in_library_with_query:

Nach Büchern in einer Benutzerbibliothek suchen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Genauso wie man `über alle Bücher suchen kann`_, kann man auch eine Volltextsuche über die Bücher in einer
Benutzerbibliothek durchführen. Um das zu tun müssen einfach die betreffenden Parameter am ``VolumeQuery`` Objekt
gesetzt werden.

Zum Beispiel gibt die folgende Abfrage alle Bücher in der eigenen Bibliothek zurück die das Word "Bär"
enthalten:

.. code-block:: php
   :linenos:

   $query = $books->newVolumeQuery(
       'http://www.google.com/books/feeds/users/' .
       'USER_ID/collections/library/volumes');
   $query->setQuery('Bär');
   $feed = $books->getVolumeFeed($query);

Für eine Liste von unterstützten Abfrageparametern können Sie in das Kapitel `Abfrageparameter`_ sehen.
Zusätzlich kann nach Büchern gesucht werden die `von einem Benutzer gelabelt wurden`_:

.. code-block:: php
   :linenos:

   $query = $books->newVolumeQuery(
       'http://www.google.com/books/feeds/users/' .
       'USER_ID/collections/library/volumes');
   $query->setCategory(
   $query->setCategory('favorites');
   $feed = $books->getVolumeFeed($query);

.. _zend.gdata.books.updating_library:

Bücher in einer Benutzerbibliothek aktualisieren
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Buchsuche Daten *API* kann dazu verwendet werden um ein Buch einer Benutzerbibliothek hinzuzufügen oder es aus
Ihr zu entfernen. Bewertungen, Reviews und Label sind über alle Sammlungen eines Benutzers gültig, und können
deswegen bearbeitet werden indem der Anmerkungsfeed verwendet wird (siehe `Verwendung üblicher Features`_).

.. _zend.gdata.books.library_book_add:

Ein Buch zu einer Bibliothek hinzufügen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Nach der Authentifizierung können Bucher zur aktuellen Benutzerbibliothek hinzugefügt werden.

Man kann entweder einen Eintrag von Null auf erstellen wenn man die Volume ID weiß, oder einen Eintrag einfügen
wenn von irgendeinem Feed gelesen wird.

Das folgende Beispiel erstellt einen neuen Eintrag und fügt Ihn der Bibliothek hinzu:

.. code-block:: php
   :linenos:

   $entry = new Zend_Gdata_Books_VolumeEntry();
   $entry->setId(new Zend_Gdata_App_Extension_Id(VOLUME_ID));
   $books->insertVolume(
       $entry,
       Zend_Gdata_Books::MY_LIBRARY_FEED_URI
   );

Das folgende Beispiel fügt ein bestehendes ``VolumeEntry`` Objekt in der Bibliothek hinzu:

.. code-block:: php
   :linenos:

   $books->insertVolume(
       $entry,
       Zend_Gdata_Books::MY_LIBRARY_FEED_URI
   );

.. _zend.gdata.books.library_book_remove:

Ein Buch von einer Bibliothek entfernen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um ein Buch von einer Benutzerbibliothek zu entfernen, muß ``deleteVolume()`` auf dem ``VolumeEntry`` Objekt
aufgerufen werden.

.. code-block:: php
   :linenos:

   $books->deleteVolume($entry);



.. _`Sammlungen von Benutzerbibliotheken und öffentlichen Kommentaren`: http://books.google.com/googlebooks/mylibrary/
.. _`PHP Developer's Guide`: http://code.google.com/apis/books/gdata/developers_guide_php.html
.. _`Authentifizierungs Kapitel im PHP Developer Guide`: http://code.google.com/apis/books/gdata/developers_guide_php.html#Authentication
.. _`zusätzlichen Suchoperatoren`: http://books.google.com/advanced_book_search
.. _`Status der Sichtbarkeit`: http://code.google.com/apis/books/docs/dynamic-links.html#terminology
.. _`Co-Branded Suche`: http://books.google.com/support/partner/bin/answer.py?hl=en&answer=65113
.. _`Partner Help Center`: http://books.google.com/support/partner/
.. _`Empfangen von Anmerkungen`: #zend.gdata.books.retrieving_annotations
.. _`Anmerkungen empfangen`: #zend.gdata.books.retrieving_annotations
.. _`Abfrageparameter`: #zend.gdata.books.query_pParameters
.. _`My Library Seite`: http://books.google.com/books?op=library
.. _`Suchen nach Büchern`: #zend.gdata.books.searching_for_books
.. _`über alle Bücher suchen kann`: #zend.gdata.books.searching_for_books
.. _`von einem Benutzer gelabelt wurden`: #zend.gdata.books.labels
.. _`Verwendung üblicher Features`: #zend.gdata.books.community_features
