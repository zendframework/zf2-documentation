.. EN-Revision: none
.. _zendservice.flickr:

ZendService\Flickr\Flickr
===================

.. _zendservice.flickr.introduction:

Einführung
----------

``ZendService\Flickr\Flickr`` ist eine einfache *API* um den Flickr REST Web Service zu nutzen. Für die Benutzung des
Flickr Web Service, benötigt man einen *API* Schlüssel. Um diesen Schlüssel zu bekommen und für weitergehende
Informationen über den Flickr REST Web Service besuchen Sie bitte die `Flickr API Dokumentation`_.

Im folgenden Bespiel benutzen wir die ``tagSearch()`` Methode um Photos zu suchen welche "php" im Tag haben.

.. _zendservice.flickr.introduction.example-1:

.. rubric:: Simple Flickr Photo Suche

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MY_API_KEY');
   $results = $flickr->tagSearch("php");

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. note::

   **Optionale Parameter**

   ``tagSearch()`` aktepziert als optionalen zweiten Parameter ein Array mit Optionen.

.. _zendservice.flickr.finding-users:

Bilder und Informationen von Flickr Benutzern finden
----------------------------------------------------

``ZendService\Flickr\Flickr`` stellt verschiedene unterschiedliche Wege zur Verfügung um Informationen von Flickr
Benutzern zu bekommen:

- ``userSearch()``: Akzeptiert ein String Abfrage von mit Leerzeichen getrennten Tags und als optionalen zweiten
  Parameter ein Array mit Such Optionen. Zurückgegeben wird ein Set von Photos als
  ``ZendService\Flickr\ResultSet`` Objekt.

- ``getIdByUsername()``: Gibt die Benutzer ID als String zurück, welcher mit dem übergebenen String des
  Benutzernamens verknüpft ist.

- ``getIdByEmail()``: Gibt die Benutzer ID als String zurück, welcher mit dem übergebenen String der Email
  Adresse verknüpft ist.

.. _zendservice.flickr.finding-users.example-1:

.. rubric:: Finden von öffentlichen Photos eines Flickr Benutzers durch seine E-Mail Adresse

In diesem Beispiel haben wir die E-Mail adresse eines Flickr Benutzers und wir holen uns die öffentlichen Photos
eines Benutzer durch Verwendung der ``userSearch()`` Methode:

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MY_API_KEY');
   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. _zendservice.flickr.grouppoolgetphotos:

Photos in einem Gruppenpool finden
----------------------------------

``ZendService\Flickr\Flickr`` erlaubt es Photos eines Gruppenpools basierend auf der ID zu empfangen. Hierfür kann die
``groupPoolGetPhotos()`` Methode verwendet werden:

.. _zendservice.flickr.grouppoolgetphotos.example-1:

.. rubric:: Empfangen von Photos aus einem Gruppenpool durch die Gruppen ID

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MY_API_KEY');

       $results = $flickr->groupPoolGetPhotos($groupId);

       foreach ($results as $result) {
           echo $result->title . '<br />';
       }

.. note::

   **Optionale Parameter**

   ``groupPoolGetPhotos()`` akzeptiert einen optionalen zweiten Parameter als ein Array von Optionen.

.. _zendservice.flickr.getimagedetails:

Empfangen von Details zu Bildern durch Flickr
---------------------------------------------

``ZendService\Flickr\Flickr`` erlaubt es schnell und einfach an Details zu Bilders zu kommen, basieren auf einer
übergebenen ID des Bildes. Einfach durch benutzen der ``getImageDetails()`` Methode, wie im folgenden Beispiel:

.. _zendservice.flickr.getimagedetails.example-1:

.. rubric:: Empfangen von Details zu Bildern durch Flickr

Sobald man eine Flickr Bild ID hat, ist es eine einfache Angelegenheit, Informationen über ein Bild zu bekommen:

.. code-block:: php
   :linenos:

   $flickr = new ZendService\Flickr\Flickr('MY_API_KEY');
   $image = $flickr->getImageDetails($imageId);

   echo "Bild ID $imageId ist $image->width x $image->height Pixel groß.<br />\n";
   echo "<a href=\"$image->clickUri\">Klicken für das Bild</a>\n";

.. _zendservice.flickr.classes:

ZendService\Flickr\Flickr Ergebnis Klassen
------------------------------------

Die folgenden Klassen werden durch ``tagSearch()`` und ``userSearch()`` zurückgegeben:



   - :ref:`ZendService\Flickr\ResultSet <zendservice.flickr.classes.resultset>`

   - :ref:`ZendService\Flickr\Result <zendservice.flickr.classes.result>`

   - :ref:`ZendService\Flickr\Image <zendservice.flickr.classes.image>`



.. _zendservice.flickr.classes.resultset:

ZendService\Flickr\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Repräsentiert ein Set von Ergebnissen von einer Flickr Suche.

.. note::

   Implementiert das ``SeekableIterator`` Interface für einfache Iteration (z.B. benutzen von ``foreach()``),
   sowie einen direkten Zugriff auf ein spezielles Ergebnis durch Benutzen von ``seek()``.

.. _zendservice.flickr.classes.resultset.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zendservice.flickr.classes.resultset.properties.table-1:

.. table:: ZendService\Flickr\ResultSet Eigenschaften

   +---------------------+---+----------------------------------------------------+
   |Name                 |Typ|Beschreibung                                        |
   +=====================+===+====================================================+
   |totalResultsAvailable|int|Gesamt Anzahl aller gefundenen Ergebnisse           |
   +---------------------+---+----------------------------------------------------+
   |totalResultsReturned |int|Gesamt Anzahl der zurückgegebenen Ergebnisse        |
   +---------------------+---+----------------------------------------------------+
   |firstResultPosition  |int|Das Offset im Gesamtergebnis für dieses Ergebnis Set|
   +---------------------+---+----------------------------------------------------+

.. _zendservice.flickr.classes.resultset.totalResults:

ZendService\Flickr\ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


Gibt die Gesamt Anzahl der Ergebnisse für dieses Ergebnis Set zurück.

:ref:`Zurück zur Liste der Klassen <zendservice.flickr.classes>`

.. _zendservice.flickr.classes.result:

ZendService\Flickr\Result
^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein einzelnes Bild Ergebnis von einer Flickr Suche

.. _zendservice.flickr.classes.result.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zendservice.flickr.classes.result.properties.table-1:

.. table:: ZendService\Flickr\Result Eigenschaften

   +----------+-------------------------+---------------------------------------------------------------------+
   |Name      |Typ                      |Beschreibung                                                         |
   +==========+=========================+=====================================================================+
   |id        |string                   |Image ID                                                             |
   +----------+-------------------------+---------------------------------------------------------------------+
   |owner     |string                   |Die NSID des Eigentümers des Photos.                                 |
   +----------+-------------------------+---------------------------------------------------------------------+
   |secret    |string                   |Ein Schlüssel welcher beim URL Aufbau benutzt wird.                  |
   +----------+-------------------------+---------------------------------------------------------------------+
   |server    |string                   |Der Servername welcher beim URL Aufbau benutzt wird.                 |
   +----------+-------------------------+---------------------------------------------------------------------+
   |title     |string                   |Die Überschrift des Bildes.                                          |
   +----------+-------------------------+---------------------------------------------------------------------+
   |ispublic  |string                   |Ist das Bild öffentlich ?                                            |
   +----------+-------------------------+---------------------------------------------------------------------+
   |isfriend  |string                   |Das Bild ist sichtbar, weil man ein Freund des Eigentümers ist.      |
   +----------+-------------------------+---------------------------------------------------------------------+
   |isfamily  |string                   |Das Bild ist sichtbar, weil man Familienmitglied des Eigentümers ist.|
   +----------+-------------------------+---------------------------------------------------------------------+
   |license   |string                   |Die Lizenz des Bildes ist erreichbar unter.                          |
   +----------+-------------------------+---------------------------------------------------------------------+
   |dateupload|string                   |Das Datum an dem das Bild hochgeladen wurde.                         |
   +----------+-------------------------+---------------------------------------------------------------------+
   |datetaken |string                   |Das Datum an dem das Bild gemacht wurde.                             |
   +----------+-------------------------+---------------------------------------------------------------------+
   |ownername |string                   |Der Bildschirmname des Eigentümers.                                  |
   +----------+-------------------------+---------------------------------------------------------------------+
   |iconserver|string                   |Der Server welcher benutzt wurde um die Icon URL zu erstellen.       |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Square    |ZendService\Flickr\Image|Ein 75x75 Thumbnail des Bildes.                                      |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Thumbnail |ZendService\Flickr\Image|Ein 100 Pixel Thumbnail des Bildes.                                  |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Small     |ZendService\Flickr\Image|Eine 240 Pixel Version des Bildes.                                   |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Medium    |ZendService\Flickr\Image|Eine 500 Pixel Version des Bildes.                                   |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Large     |ZendService\Flickr\Image|Eine 640 Pixel Version des Bildes.                                   |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Original  |ZendService\Flickr\Image|Das Original Bild.                                                   |
   +----------+-------------------------+---------------------------------------------------------------------+

:ref:`Zurück zur Liste der Klassen <zendservice.flickr.classes>`

.. _zendservice.flickr.classes.image:

ZendService\Flickr\Image
^^^^^^^^^^^^^^^^^^^^^^^^^

Repräsentiert ein Bild welches durch eine Flickr Suche zurückgegeben wird.

.. _zendservice.flickr.classes.image.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zendservice.flickr.classes.image.properties.table-1:

.. table:: ZendService\Flickr\Image Eigenschaften

   +--------+------+--------------------------------------------------+
   |Name    |Typ   |Beschreibung                                      |
   +========+======+==================================================+
   |uri     |string|URI des Original Bildes                           |
   +--------+------+--------------------------------------------------+
   |clickUri|string|Klickbare URI (z.B. die Flickr Seite) für das Bild|
   +--------+------+--------------------------------------------------+
   |width   |int   |Breite des Bildes                                 |
   +--------+------+--------------------------------------------------+
   |height  |int   |Höhe des Bildes                                   |
   +--------+------+--------------------------------------------------+

:ref:`Zurück zur Liste der Klassen <zendservice.flickr.classes>`



.. _`Flickr API Dokumentation`: http://www.flickr.com/services/api/
