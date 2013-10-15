.. EN-Revision: none
.. _zend.gdata.docs:

Verwenden der Google Dokumente Listen Daten API
===============================================

Die Google Dokumente Listen Daten *API* erlaubt es Client Anwendungen Dokumente zu Google Dokumente hochzuladen und
diese in der Form von Google Daten *API* ("GData") Feeds aufzulisten. Die Client Anwendung kann eine Liste von
Benutzer Dokumenten anfragen, und den Inhalt in einem existierenden Dokument abfragen.

Siehe `http://code.google.com/apis/documents/overview.html`_ für weitere Informationen über die Google Dokumente
Listen *API*.

.. _zend.gdata.docs.listdocuments:

Eine Liste von Dokumenten erhalten
----------------------------------

Man kann eine Liste von den Google Dokumenten für einen bestimmten Benutzer erhalten indem die
``getDocumentListFeed()`` Methode des Docs Services verwendet wird. Das Service gibt ein
``ZendGData\Docs\DocumentListFeed`` Objekt zurück das eine Liste von Dokumenten enthält die mit dem
authentifizierten Benutzer assoziiert sind.

.. code-block:: php
   :linenos:

   $service = ZendGData\Docs::AUTH_SERVICE_NAME;
   $client = ZendGData\ClientLogin::getHttpClient($user, $pass, $service);
   $docs = new ZendGData\Docs($client);
   $feed = $docs->getDocumentListFeed();

Das sich ergebende ``ZendGData\Docs\DocumentListFeed`` Objekt repräsentiert die Antwort des Servers. Dieser Feed
enthält eine Liste von ``ZendGData\Docs\DocumentListEntry`` Objekten (``$feed->entries``), wobei jeder von Ihnen
ein einzelnes Google Dokument repräsentiert.

.. _zend.gdata.docs.creating:

Ein Dokument hochladen
----------------------

Man kann ein neues Google Dokument erstellen indem ein Wortverarbeitungs Dokument, eine Tabellenkalkulation oder
eine Präsentation hochgeladen wird. Dieses Beispiel ist vom interaktiven Docs.php Beispiel welches mit der
Bibliothek kommt. Es demonstriert das Hochladen einer Datei und das Ausdrucken der Information über das Ergebnis
vom Server.

.. code-block:: php
   :linenos:

   /**
    * Ein spezielles Dokument hochladen
    *
    * @param ZendGData\Docs $docs Das Service Objekt das für die Kommunikation
    *                              mit dem Google Dokument Service verwendet wird
    * @param boolean $html True Wenn die Ausgabe für die Ausgabe in einem Web
    *                           Browser formatiert sein soll
    * @param string $originalFileName Der Name der Datei die hochgeladen werden
    *                                 soll. Der MIME-Typ dieser Datei wird von der
    *                                 Erweiterung des Dateinamens eruiert. Zum
    *                                 Beispiel wird test.csv als Komma geteilter
    *                                 Inhalt hochgeladen und in eine
    *                                 Tabellenkalkulation konvertiert
    * @param string $temporaryFileLocation (Optional) Die Datei in der die Daten
    *                                      für das Dokument gespeichert werden.
    *                                      Das wird verwendet wenn die Datei von
    *                                      der Maschine des Clients zum Server
    *                                      hochgeladen und in einer temporären
    *                                      Datei gespeichert wurde die keine
    *                                      Erweiterung hat. Wenn dieser Parameter
    *                                      null ist, wird die Datei von
    *                                      originalFileName gelesen.
    */
   function uploadDocument($docs, $html, $originalFileName,
                           $temporaryFileLocation) {
     $fileToUpload = $originalFileName;
     if ($temporaryFileLocation) {
       $fileToUpload = $temporaryFileLocation;
     }

     // Datei hochladen un in ein Google Dokument konvertieren Der originale
     // Dateiname wird als Titel des Dokuments verwendet und der MIME Typ wird
     // basieren auf der erweiterung des originalen Dateinamens eruiert.
     $newDocumentEntry = $docs->uploadFile($fileToUpload, $originalFileName,
         null, ZendGData\Docs::DOCUMENTS_LIST_FEED_URI);

     echo "Neuer Titel des Dokuments: ";

     if ($html) {
         // Die URL der HTML Ansicht dieses Dokuments finden.
         $alternateLink = '';
         foreach ($newDocumentEntry->link as $link) {
             if ($link->getRel() === 'alternate') {
                 $alternateLink = $link->getHref();
             }
         }
         // Den Titellink zum dokument auf docs.google.com erstellen.
         echo "<a href=\"$alternateLink\">\n";
     }
     echo $newDocumentEntry->title."\n";
     if ($html) {echo "</a>\n";}
   }

.. _zend.gdata.docs.queries:

Den Dokumenten Feed durchsuchen
-------------------------------

Die Dokumenten Liste kann durchsucht werden indem einer der `standardmäßigen Google Daten API Abfrageparameter`_
verwendet wird. Kategorien werden verwendet um den Typ des Dokuments das zurückgegeben wird (Wortverarbeitungs
Dokument, Tabellenkalkulation) einzuschränken. Detailiertere Informationen über Parameter die speziell in der
Dokumenten Liste vorhanden sind können in der `Dokumenten Listen Daten API Referenz Anleitung`_ gefunden werden.

.. _zend.gdata.docs.listwpdocuments:

Eine Liste von Wortverarbeitungs Dokumenten erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein Feed der alle Dokumente eines speziellen Typs enthält kann auch angefragt werden. Um zum Beispiel eine Liste
von eigenen Wortverarbeitungs Dokumenten zu sehen, würde man eine Kategorieanfrage wie folgt durchführen.

.. code-block:: php
   :linenos:

   $feed = $docs->getDocumentListFeed(
       'http://docs.google.com/feeds/documents/private/full/-/document');

.. _zend.gdata.docs.listspreadsheets:

Eine Liste von Tabellenkalkulationen erhalten
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um eine Liste aller eigenen Google Tabellenkalkulationen zu erhalten kann die folgende Abfrage verwendet werden:

.. code-block:: php
   :linenos:

   $feed = $docs->getDocumentListFeed(
       'http://docs.google.com/feeds/documents/private/full/-/spreadsheet');

.. _zend.gdata.docs.textquery:

Eine Textabfrage durchführen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Der Inhalt von Dokumenten kann durch Verwendung von ``ZendGData\Docs\Query`` in der Abfrage durchsucht werden. Ein
Abfrage Objekt kann verwendet werden um eine Abfrage *URI* zu erstellen, wobei der Suchbegriff als Parameter
übergeben wird. Hier ist eine Beispielmethode welche die Dokumenten Liste nach Dokumenten abfrage die den
Suchstring enthalten:

.. code-block:: php
   :linenos:

   $docsQuery = new ZendGData\Docs\Query();
   $docsQuery->setQuery($query);
   $feed = $client->getDocumentListFeed($docsQuery);



.. _`http://code.google.com/apis/documents/overview.html`: http://code.google.com/apis/documents/overview.html
.. _`standardmäßigen Google Daten API Abfrageparameter`: http://code.google.com/apis/gdata/reference.html#Queries
.. _`Dokumenten Listen Daten API Referenz Anleitung`: http://code.google.com/apis/documents/reference.html#Parameters
