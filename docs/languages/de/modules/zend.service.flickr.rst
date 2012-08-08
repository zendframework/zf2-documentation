.. EN-Revision: none
.. _zend.service.flickr:

Zend_Service_Flickr
===================

.. _zend.service.flickr.introduction:

Einführung
----------

``Zend_Service_Flickr`` ist eine einfache *API* um den Flickr REST Web Service zu nutzen. Für die Benutzung des
Flickr Web Service, benötigt man einen *API* Schlüssel. Um diesen Schlüssel zu bekommen und für weitergehende
Informationen über den Flickr REST Web Service besuchen Sie bitte die `Flickr API Dokumentation`_.

Im folgenden Bespiel benutzen wir die ``tagSearch()`` Methode um Photos zu suchen welche "php" im Tag haben.

.. _zend.service.flickr.introduction.example-1:

.. rubric:: Simple Flickr Photo Suche

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');
   $results = $flickr->tagSearch("php");

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. note::

   **Optionale Parameter**

   ``tagSearch()`` aktepziert als optionalen zweiten Parameter ein Array mit Optionen.

.. _zend.service.flickr.finding-users:

Bilder und Informationen von Flickr Benutzern finden
----------------------------------------------------

``Zend_Service_Flickr`` stellt verschiedene unterschiedliche Wege zur Verfügung um Informationen von Flickr
Benutzern zu bekommen:

- ``userSearch()``: Akzeptiert ein String Abfrage von mit Leerzeichen getrennten Tags und als optionalen zweiten
  Parameter ein Array mit Such Optionen. Zurückgegeben wird ein Set von Photos als
  ``Zend_Service_Flickr_ResultSet`` Objekt.

- ``getIdByUsername()``: Gibt die Benutzer ID als String zurück, welcher mit dem übergebenen String des
  Benutzernamens verknüpft ist.

- ``getIdByEmail()``: Gibt die Benutzer ID als String zurück, welcher mit dem übergebenen String der Email
  Adresse verknüpft ist.

.. _zend.service.flickr.finding-users.example-1:

.. rubric:: Finden von öffentlichen Photos eines Flickr Benutzers durch seine E-Mail Adresse

In diesem Beispiel haben wir die E-Mail adresse eines Flickr Benutzers und wir holen uns die öffentlichen Photos
eines Benutzer durch Verwendung der ``userSearch()`` Methode:

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');
   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }

.. _zend.service.flickr.grouppoolgetphotos:

Photos in einem Gruppenpool finden
----------------------------------

``Zend_Service_Flickr`` erlaubt es Photos eines Gruppenpools basierend auf der ID zu empfangen. Hierfür kann die
``groupPoolGetPhotos()`` Methode verwendet werden:

.. _zend.service.flickr.grouppoolgetphotos.example-1:

.. rubric:: Empfangen von Photos aus einem Gruppenpool durch die Gruppen ID

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

       $results = $flickr->groupPoolGetPhotos($groupId);

       foreach ($results as $result) {
           echo $result->title . '<br />';
       }

.. note::

   **Optionale Parameter**

   ``groupPoolGetPhotos()`` akzeptiert einen optionalen zweiten Parameter als ein Array von Optionen.

.. _zend.service.flickr.getimagedetails:

Empfangen von Details zu Bildern durch Flickr
---------------------------------------------

``Zend_Service_Flickr`` erlaubt es schnell und einfach an Details zu Bilders zu kommen, basieren auf einer
übergebenen ID des Bildes. Einfach durch benutzen der ``getImageDetails()`` Methode, wie im folgenden Beispiel:

.. _zend.service.flickr.getimagedetails.example-1:

.. rubric:: Empfangen von Details zu Bildern durch Flickr

Sobald man eine Flickr Bild ID hat, ist es eine einfache Angelegenheit, Informationen über ein Bild zu bekommen:

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');
   $image = $flickr->getImageDetails($imageId);

   echo "Bild ID $imageId ist $image->width x $image->height Pixel groß.<br />\n";
   echo "<a href=\"$image->clickUri\">Klicken für das Bild</a>\n";

.. _zend.service.flickr.classes:

Zend_Service_Flickr Ergebnis Klassen
------------------------------------

Die folgenden Klassen werden durch ``tagSearch()`` und ``userSearch()`` zurückgegeben:



   - :ref:`Zend_Service_Flickr_ResultSet <zend.service.flickr.classes.resultset>`

   - :ref:`Zend_Service_Flickr_Result <zend.service.flickr.classes.result>`

   - :ref:`Zend_Service_Flickr_Image <zend.service.flickr.classes.image>`



.. _zend.service.flickr.classes.resultset:

Zend_Service_Flickr_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Repräsentiert ein Set von Ergebnissen von einer Flickr Suche.

.. note::

   Implementiert das ``SeekableIterator`` Interface für einfache Iteration (z.B. benutzen von ``foreach()``),
   sowie einen direkten Zugriff auf ein spezielles Ergebnis durch Benutzen von ``seek()``.

.. _zend.service.flickr.classes.resultset.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.flickr.classes.resultset.properties.table-1:

.. table:: Zend_Service_Flickr_ResultSet Eigenschaften

   +---------------------+---+----------------------------------------------------+
   |Name                 |Typ|Beschreibung                                        |
   +=====================+===+====================================================+
   |totalResultsAvailable|int|Gesamt Anzahl aller gefundenen Ergebnisse           |
   +---------------------+---+----------------------------------------------------+
   |totalResultsReturned |int|Gesamt Anzahl der zurückgegebenen Ergebnisse        |
   +---------------------+---+----------------------------------------------------+
   |firstResultPosition  |int|Das Offset im Gesamtergebnis für dieses Ergebnis Set|
   +---------------------+---+----------------------------------------------------+

.. _zend.service.flickr.classes.resultset.totalResults:

Zend_Service_Flickr_ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


Gibt die Gesamt Anzahl der Ergebnisse für dieses Ergebnis Set zurück.

:ref:`Zurück zur Liste der Klassen <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.result:

Zend_Service_Flickr_Result
^^^^^^^^^^^^^^^^^^^^^^^^^^

Ein einzelnes Bild Ergebnis von einer Flickr Suche

.. _zend.service.flickr.classes.result.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.flickr.classes.result.properties.table-1:

.. table:: Zend_Service_Flickr_Result Eigenschaften

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
   |Square    |Zend_Service_Flickr_Image|Ein 75x75 Thumbnail des Bildes.                                      |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Thumbnail |Zend_Service_Flickr_Image|Ein 100 Pixel Thumbnail des Bildes.                                  |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Small     |Zend_Service_Flickr_Image|Eine 240 Pixel Version des Bildes.                                   |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Medium    |Zend_Service_Flickr_Image|Eine 500 Pixel Version des Bildes.                                   |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Large     |Zend_Service_Flickr_Image|Eine 640 Pixel Version des Bildes.                                   |
   +----------+-------------------------+---------------------------------------------------------------------+
   |Original  |Zend_Service_Flickr_Image|Das Original Bild.                                                   |
   +----------+-------------------------+---------------------------------------------------------------------+

:ref:`Zurück zur Liste der Klassen <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.image:

Zend_Service_Flickr_Image
^^^^^^^^^^^^^^^^^^^^^^^^^

Repräsentiert ein Bild welches durch eine Flickr Suche zurückgegeben wird.

.. _zend.service.flickr.classes.image.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.flickr.classes.image.properties.table-1:

.. table:: Zend_Service_Flickr_Image Eigenschaften

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

:ref:`Zurück zur Liste der Klassen <zend.service.flickr.classes>`



.. _`Flickr API Dokumentation`: http://www.flickr.com/services/api/
