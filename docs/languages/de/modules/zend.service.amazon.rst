.. EN-Revision: none
.. _zend.service.amazon:

Zend_Service_Amazon
===================

.. _zend.service.amazon.introduction:

Einführung
----------

``Zend_Service_Amazon`` ist eine einfach *API* für die Benutzung des Amazon Web Services. ``Zend_Service_Amazon``
hat 2 *API*\ s: eine traditionellere welche Amazon's eigener *API* folgt, und eine simplere "Abfrage *API*" um
sogar komplexe Suchabfragen einfachst machen zu können.

``Zend_Service_Amazon`` erlaubt es Entwicklern, Informationen von allen Amazon.com Web Seiten durch das Amazon Web
Services *API* zu empfangen. Beispiele beinhalten:



   - Informationen speichern, wie Bilder, Beschreibungen, Preise uvm.

   - Kunden und Editorial Reviews

   - Ähnliche Produkte und Zubehör

   - Amazon.com Angebote

   - ListMania Liste



Um ``Zend_Service_Amazon`` benutzen zu können, benötigt man einen Amazon Entwickler *API* Schlüssel sowie einen
geheimen Schlüssel. Um den Schlüssel zu bekommen und für weiter führende Informationen besuchen Sie bitte die
`Amazon Web Service`_ Web Seite. Seit dem 15. August 2009 kann man die Amazon Produkt Advertising *API* über
``Zend_Service_Amazon`` nur dann verwenden wenn man einen zusätzlichen geheimen Schlüssel spezifiziert.

.. note::

   **Achtung**

   Der eigene Amazon Entwickler *API* und der geheime Schlüssel sind mit der eigenen Amazon Identität verknüpft.
   Deswegen sollte man darauf achten das die Schlüssel privat bleibt.

.. _zend.service.amazon.introduction.example.itemsearch:

.. rubric:: Suchen in Amazon mit der traditionellen API

In diesem Beispiel suchen wir nach *PHP* Büchern bei Amazon, blättern durch die Resultate und Drucken diese aus.

.. code-block:: php
   :linenos:

   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zend.service.amazon.introduction.example.query_api:

.. rubric:: Suchen in Amazon mit der Abfrage API

Hier suchen wir auch nach *PHP* Büchern bei Amazon. Aber wir verwenden stattdessen die Abfrage *API*, welche das
Fluent Interface Design Pattern verwendet.

.. code-block:: php
   :linenos:

   $query = new Zend_Service_Amazon_Query('AMAZON_API_KEY',
                                          'US',
                                          'AMAZON_SECRET_KEY');
   $query->category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zend.service.amazon.countrycodes:

Ländercodes
-----------

Standardmäßig verbindet sich ``Zend_Service_Amazon`` zum Amazon Web Service der Vereinigten Staaten ("*US*"). Um
sich zu einem anderen Land zu verbinden, muß einfach der entsprechende String des Landercodes als zweiter
Parameter an den Konstruktor übergeben werden:

.. _zend.service.amazon.countrycodes.example.country_code:

.. rubric:: Auswahl eines Amazon Web Service Landes

.. code-block:: php
   :linenos:

   // Zu Amazon in Japan verbinden
   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'JP', 'AMAZON_SECRET_KEY');

.. note::

   **Ländercodes**

   Gültige Ländercodes sind: *CA*, *DE*, *FR*, *JP*, *UK*, and *US*.

.. _zend.service.amazon.itemlookup:

Betrachten eines speziellen Teils bei Amazon durch ASIN
-------------------------------------------------------

Die ``itemLookup()`` Methode ermöglicht es ein bestimmtes Teil bei Amazon zu erhalten wenn der *ASIN* bekannt ist.

.. _zend.service.amazon.itemlookup.example.asin:

.. rubric:: Betrachten eines speziellen Teils bei Amazon durch ASIN

.. code-block:: php
   :linenos:

   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $item = $amazon->itemLookup('B0000A432X');

Die ``itemLookup()`` Methode akzeptiert auch einen optionalen zweiten Parameter für die Handhabung der
Suchoptionen. Für komplette Details, inklusive einer Liste der möglichen Optionen sehen Sie bitte in die
`relevante Amazon Dokumentation`_.

.. note::

   **Bildinformationen**

   Um Bildinformationen für deine Suchergebnisse zu erhalten, musst du die *ResponseGroup* Option auf *Medium*
   oder *Large* setzen.

.. _zend.service.amazon.itemsearch:

Suchen nach Teilen bei Amazon
-----------------------------

Das Suchen nach Teilen, basierend auf den unterschiedlichen möglichen Kriterien ist einfach gehalten durch
benutzen der ``itemSearch()`` Methode wie im folgenden Beispiel:

.. _zend.service.amazon.itemsearch.example.basic:

.. rubric:: Suchen nach Teilen bei Amazon

.. code-block:: php
   :linenos:

   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

.. _zend.service.amazon.itemsearch.example.responsegroup:

.. rubric:: Verwenden der ResponseGroup Option

Die *ResponseGroup* Option wird verwendet um die spezielle Information zu kontrollieren die in der Antwort
zurückgegeben wird.

.. code-block:: php
   :linenos:

   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $results = $amazon->itemSearch(array(
       'SearchIndex'   => 'Books',
       'Keywords'      => 'php',
       'ResponseGroup' => 'Small,ItemAttributes,Images,SalesRank,Reviews,' .
                          'EditorialReview,Similarities,ListmaniaLists'
       ));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

Die ``itemSearch()`` Methode akzeptiert einen einzelnen Parameter als Array für die Handhabung der Suchoptionen.
Für komplette Details, inklusive eine Liste der möglichen Optionen sehen Sie bitte in die `relevante Amazon
Dokumentation`_

.. tip::

   Die :ref:`Zend_Service_Amazon_Query <zend.service.amazon.query>` Klasse ist ein einfach zu benutzender Wrapper
   für diese Methode.

.. _zend.service.amazon.query:

Benutzen der alternativen Abfrage API
-------------------------------------

.. _zend.service.amazon.query.introduction:

Einführung
^^^^^^^^^^

``Zend_Service_Amazon_Query`` bietet eine alternative *API* für die Benutzung der Amazon Web Services. Die
alternative *API* benutzt das Fluent Interface Pattern. Das bedeutet, alle Aufrufe können durchgeführt werden
durch Benutzen von verketteten Methoden Aufrufen. (z.B., *$obj->method()->method2($arg)*)

Die ``Zend_Service_Amazon_Query`` *API* benutzt Überladung um einfachst eine Teile Suche zu realisieren, und
ermöglicht es, basierend auf den spezifizierten Kriterien, zu suchen. Jede der Optionen wird als Methoden Aufruf
angeboten, und jedes Methoden Argument korrespondiert mit dem beschriebenen Options Wert:

.. _zend.service.amazon.query.introduction.example.basic:

.. rubric:: Suchen in Amazon durch Benutzen der alternativen Abfrage API

In diesem Beispiel wird die alternative Abfrage *API* als Fluent Interface benutzt um Optionen und Ihre Werte
festzulegen:

.. code-block:: php
   :linenos:

   $query = new Zend_Service_Amazon_Query('MY_API_KEY', 'US', 'AMAZON_SECRET_KEY');
   $query->Category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }

Das setzt die Option *Category* auf "Books" und *Keywords* auf "PHP".

Für weitere Informationen über die möglichen Optionen, sehen Sie bitte in die `relevante Amazon Dokumentation`_.

.. _zend.service.amazon.classes:

Zend_Service_Amazon Klassen
---------------------------

Die folgenden klassen werden alle zurückgegeben durch :ref:`Zend_Service_Amazon::itemLookup()
<zend.service.amazon.itemlookup>` und :ref:`Zend_Service_Amazon::itemSearch() <zend.service.amazon.itemsearch>`:



   - :ref:`Zend_Service_Amazon_Item <zend.service.amazon.classes.item>`

   - :ref:`Zend_Service_Amazon_Image <zend.service.amazon.classes.image>`

   - :ref:`Zend_Service_Amazon_ResultSet <zend.service.amazon.classes.resultset>`

   - :ref:`Zend_Service_Amazon_OfferSet <zend.service.amazon.classes.offerset>`

   - :ref:`Zend_Service_Amazon_Offer <zend.service.amazon.classes.offer>`

   - :ref:`Zend_Service_Amazon_SimilarProduct <zend.service.amazon.classes.similarproduct>`

   - :ref:`Zend_Service_Amazon_Accessories <zend.service.amazon.classes.accessories>`

   - :ref:`Zend_Service_Amazon_CustomerReview <zend.service.amazon.classes.customerreview>`

   - :ref:`Zend_Service_Amazon_EditorialReview <zend.service.amazon.classes.editorialreview>`

   - :ref:`Zend_Service_Amazon_ListMania <zend.service.amazon.classes.listmania>`



.. _zend.service.amazon.classes.item:

Zend_Service_Amazon_Item
^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Amazon_Item`` ist ein Klassen Typ der benutzt wird um ein Amazon Teil darzustellen welches durch das
Web Service zurück gegeben wird. Es enthält alle Attribute des Teils wie z.B. Titel, Beschreibung, Reviews, usw.

.. _zend.service.amazon.classes.item.asxml:

Zend_Service_Amazon_Item::asXML()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

string:``asXML()``


Gibt das original *XML* für dieses Teil zurück

.. _zend.service.amazon.classes.item.properties:

Eigenschaften
^^^^^^^^^^^^^

``Zend_Service_Amazon_Item`` hat eine Anzahl an Eigenschaften welche eine direkte Beziehung zu Ihren Standard
Amazon *API* Gegenstücken haben.

.. _zend.service.amazon.classes.item.properties.table-1:

.. table:: Zend_Service_Amazon_Item Eigenschaften

   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |Name            |Typ                         |Beschreibung                                                                                    |
   +================+============================+================================================================================================+
   |ASIN            |string                      |Amazon Teil ID                                                                                  |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |DetailPageURL   |string                      |URL zur Detailseite des Teils                                                                   |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |SalesRank       |int                         |Verkaufs Rang des Teils                                                                         |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |SmallImage      |Zend_Service_Amazon_Image   |Kleines Bild des Tiles                                                                          |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |MediumImage     |Zend_Service_Amazon_Image   |Mittleres Bild des Teils                                                                        |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |LargeImage      |Zend_Service_Amazon_Image   |Großes Bild des Teils                                                                           |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |Subjects        |array                       |Inhalte des Teils                                                                               |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |Offers          |Zend_Service_Amazon_OfferSet|Summe der Angebote und Angebote für dieses Teil                                                 |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |CustomerReviews |array                       |Kunden Reviews dargestellt als Array von Zend_Service_Amazon_CustomerReview Objekten            |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |EditorialReviews|array                       |Editorial Reviews dargestellt als Array von Zend_Service_Amazon_EditorialReview Objekten        |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |SimilarProducts |array                       |Ähnliche Produkte dargestellt als Array von Zend_Service_Amazon_SimilarProduct Objekten         |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |Accessories     |array                       |Zubehör für dieses Teil dargestellt als Array von Zend_Service_Amazon_Accessories Objekten      |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |Tracks          |array                       |Ein Array mit Track Nummern und Namen für Musik CDs und DVDs                                    |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |ListmaniaLists  |array                       |Passende Listmania Liste für diese Teil, als Array von Zend_Service_Amazon_ListmainList Objekten|
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+
   |PromotionalTag  |string                      |Promotion Tag des Teils                                                                         |
   +----------------+----------------------------+------------------------------------------------------------------------------------------------+

:ref:`Zurück zur Liste der Klassen <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.image:

Zend_Service_Amazon_Image
^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Amazon_Image`` repräsentiert ein entferntes Bild für ein Produkt.

.. _zend.service.amazon.classes.image.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.amazon.classes.image.properties.table-1:

.. table:: Zend_Service_Amazon_Image Eigenschaften

   +------+--------+-------------------------------+
   |Name  |Typ     |Beschreibung                   |
   +======+========+===============================+
   |Url   |Zend_Uri|Entfernte URL für das Bild     |
   +------+--------+-------------------------------+
   |Height|int     |Die Höhe des Bildes als Pixel  |
   +------+--------+-------------------------------+
   |Width |int     |Die Breite des Bildes als Pixel|
   +------+--------+-------------------------------+

:ref:`Zurück zur Liste der Klassen <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.resultset:

Zend_Service_Amazon_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Zend_Service_Amazon_ResultSet`` Objekte werden zurückgegeben durch :ref:`Zend_Service_Amazon::itemSearch()
<zend.service.amazon.itemsearch>` und erlauben es, die vielfach zurück gelieferten Resultate, einfachst zu
Handhaben.

.. note::

   **SeekableIterator**

   Implementiert den *SeekableIterator* für einfach Iteration (z.B. benutzen von *foreach*), sowie direkten
   Zugriff auf ein Spezielles Resultat mit ``seek()``.

.. _zend.service.amazon.classes.resultset.totalresults:

Zend_Service_Amazon_ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``
Liefert die Gesamtanzahl der Resultate welche die Suche zurückgegeben hat

:ref:`Zurück zur Liste der Klassen <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offerset:

Zend_Service_Amazon_OfferSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Jedes Resultat welches durch :ref:`Zend_Service_Amazon::itemSearch() <zend.service.amazon.itemsearch>` und
:ref:`Zend_Service_Amazon::itemLookup() <zend.service.amazon.itemlookup>` zurückgegeben wird beinhaltet ein
``Zend_Service_Amazon_OfferSet`` Objekt durch welches Preisinformationen für das Teil empfangen werden können.

.. _zend.service.amazon.classes.offerset.parameters:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.amazon.classes.offerset.parameters.table-1:

.. table:: Zend_Service_Amazon_OfferSet Properties

   +----------------------+------+------------------------------------------------------------------+
   |Name                  |Typ   |Beschreibung                                                      |
   +======================+======+==================================================================+
   |LowestNewPrice        |int   |Niedrigster Preis des Teiles als "Neuwert"                        |
   +----------------------+------+------------------------------------------------------------------+
   |LowestNewPriceCurrency|string|Die Währung für LowestNewPrice                                    |
   +----------------------+------+------------------------------------------------------------------+
   |LowestOldPrice        |int   |Niedrigster Preis des Teiles als "Gebrauchtwert"                  |
   +----------------------+------+------------------------------------------------------------------+
   |LowestOldPriceCurrency|string|Die Währung für LowestOldPrice                                    |
   +----------------------+------+------------------------------------------------------------------+
   |TotalNew              |int   |Erhältliche Gesamtanzahl dieses Teils mit "Neuwert"               |
   +----------------------+------+------------------------------------------------------------------+
   |TotalUsed             |int   |Erhältliche Gesamtanzahl dieses Teils mit "Gebrauchtwert"         |
   +----------------------+------+------------------------------------------------------------------+
   |TotalCollectible      |int   |Erhältliche Gesamtanzahl dieses Teils die "Sammelbar" sind        |
   +----------------------+------+------------------------------------------------------------------+
   |TotalRefurbished      |int   |Erhältliche Gesamtanzahl dieses Teils die "Wiederhergestellt" sind|
   +----------------------+------+------------------------------------------------------------------+
   |Offers                |array |Ein Array von Zend_Service_Amazon_Offer Objekten.                 |
   +----------------------+------+------------------------------------------------------------------+

:ref:`Zurück zur Liste der Klassen <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offer:

Zend_Service_Amazon_Offer
^^^^^^^^^^^^^^^^^^^^^^^^^

Jedes Angebot für ein Teil wird als ``Zend_Service_Amazon_Offer`` Objekt zurück gegeben.

.. _zend.service.amazon.classes.offer.properties:

Zend_Service_Amazon_Offer Eigenschaften
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.service.amazon.classes.offer.properties.table-1:

.. table:: Eigenschaften

   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+
   |Name                           |Typ    |Beschreibung                                                                                                 |
   +===============================+=======+=============================================================================================================+
   |MerchantId                     |string |Amazon ID des Anbieters                                                                                      |
   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+
   |MerchantName                   |string |Der Amazon Name des Anbieters. Benötigt die Option ResponseGroup auf OfferFull um Empfangen werden zu können.|
   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+
   |GlancePage                     |string |URL einer Seite mit einer Zusammenfassung des Anbieters                                                      |
   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+
   |Condition                      |string |Kondition des Teils                                                                                          |
   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+
   |OfferListingId                 |string |ID der Angebots Liste                                                                                        |
   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+
   |Price                          |int    |Preis für das Teil                                                                                           |
   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+
   |CurrencyCode                   |string |Währungscode des Preises für das Teil                                                                        |
   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+
   |Availability                   |string |Erhältlichkeit des Teils                                                                                     |
   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+
   |IsEligibleForSuperSaverShipping|boolean|Ob das Teil erhältlich ist für Super Sicheren Versand oder nicht                                             |
   +-------------------------------+-------+-------------------------------------------------------------------------------------------------------------+

:ref:`Zurück zur Liste der Klassen <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.similarproduct:

Zend_Service_Amazon_SimilarProduct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bei der Suche nach Teilen gibt Amazon auch eine Liste an ähnlichen Produkten zurück, welche dem Suchenden
empfohlen werden. Jedes dieser Produkte wird als ``Zend_Service_Amazon_SimilarProduct`` Objekt zurückgegeben.

Jedes Objekt enthält die Informationen welche es erlauben eine Subanfrage zu machen, um die kompletten
Informationen zu diesem Teil zu bekommen.

.. _zend.service.amazon.classes.similarproduct.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.amazon.classes.similarproduct.properties.table-1:

.. table:: Zend_Service_Amazon_SimilarProduct Eigenschaften

   +-----+------+----------------------------------------+
   |Name |Typ   |Beschreibung                            |
   +=====+======+========================================+
   |ASIN |string|Eindeutige Amazon ID des Produkts (ASIN)|
   +-----+------+----------------------------------------+
   |Title|string|Produkt Überschrift                     |
   +-----+------+----------------------------------------+

:ref:`Zurück zur Liste der Klassen <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.accessories:

Zend_Service_Amazon_Accessories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zubehör für das zurückgegebene Teil werden als ``Zend_Service_Amazon_Accessories`` Objekte dargestellt.

.. _zend.service.amazon.classes.accessories.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.amazon.classes.accessories.properties.table-1:

.. table:: Zend_Service_Amazon_Accessories Eigenschaften

   +-----+------+----------------------------------------+
   |Name |Typ   |Beschreibung                            |
   +=====+======+========================================+
   |ASIN |string|Eindeutige Amazon ID des Produkts (ASIN)|
   +-----+------+----------------------------------------+
   |Title|string|Produkt Überschrift                     |
   +-----+------+----------------------------------------+

:ref:`Back to Class List <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.customerreview:

Zend_Service_Amazon_CustomerReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Jede Kunden Review wird als ``Zend_Service_Amazon_CustomerReview`` Objekt zurückgegeben.

.. _zend.service.amazon.classes.customerreview.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.amazon.classes.customerreview.properties.table-1:

.. table:: Zend_Service_Amazon_CustomerReview Eigenschaften

   +------------+------+------------------------------------+
   |Name        |Typ   |Beschreibung                        |
   +============+======+====================================+
   |Rating      |string|Bewertung des Teils                 |
   +------------+------+------------------------------------+
   |HelpfulVotes|string|Stimmen wie hilfreich die Review ist|
   +------------+------+------------------------------------+
   |CustomerId  |string|Kunden ID                           |
   +------------+------+------------------------------------+
   |TotalVotes  |string|Gesamtzahl der Stimmen              |
   +------------+------+------------------------------------+
   |Date        |string|Datum der Review                    |
   +------------+------+------------------------------------+
   |Summary     |string|Zusammenfassung der Review          |
   +------------+------+------------------------------------+
   |Content     |string|Inhalt der Review                   |
   +------------+------+------------------------------------+

:ref:`Zurück zur Liste der Klassen <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.editorialreview:

Zend_Service_Amazon_EditorialReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Jede Editorial review des Teils wird als ``Zend_Service_Amazon_EditorialReview`` Objekt zurückgegeben.

.. _zend.service.amazon.classes.editorialreview.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.amazon.classes.editorialreview.properties.table-1:

.. table:: Zend_Service_Amazon_EditorialReview Eigenschaften

   +-------+------+---------------------------+
   |Name   |Typ   |Beschreibung               |
   +=======+======+===========================+
   |Source |string|Quelle der Editorial Review|
   +-------+------+---------------------------+
   |Content|string|Inhalt des Reviews         |
   +-------+------+---------------------------+

:ref:`Zurück zur Liste der Klassen <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.listmania:

Zend_Service_Amazon_Listmania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Jedes List Mania List Ergebnis des Teils wird als ``Zend_Service_Amazon_Listmania`` Objekt zurückgegeben.

.. _zend.service.amazon.classes.listmania.properties:

Eigenschaften
^^^^^^^^^^^^^

.. _zend.service.amazon.classes.listmania.properties.table-1:

.. table:: Zend_Service_Amazon_Listmania Eigenschaften

   +--------+------+--------------+
   |Name    |Typ   |Beschreibung  |
   +========+======+==============+
   |ListId  |string|ID der Liste  |
   +--------+------+--------------+
   |ListName|string|Name der Liste|
   +--------+------+--------------+

:ref:`Zurück zur Liste der Klassen <zend.service.amazon.classes>`



.. _`Amazon Web Service`: http://aws.amazon.com/
.. _`relevante Amazon Dokumentation`: http://www.amazon.com/gp/aws/sdk/main.html/102-9041115-9057709?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation
