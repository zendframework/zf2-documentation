.. _zend.service.amazon:

Zend_Service_Amazon
===================

.. _zend.service.amazon.introduction:

Inleiding
---------

*Zend_Service_Amazon* is een eenvoudige API om Amazon webservices te gebruiken. *Zend_Service_Amazon* heeft twee
APIs: een meer traditionele die Amazons eigen API volgt, en een eenvoudigere "Query API" om nog meer complexe
zoekqueries gemakkelijk op te bouwen.

*Zend_Service_Amazon* staat ontwikkelaars toe om informatie die door Amazon.com web sites worden verstrekt direct
op te vragen via de Amazon Web Services API. Voorbeelden:

   - Item informatie opvragen, zoals beelden, beschrijvingen, prijzen, en meer

   - Klant- en uitgeversrecensies

   - Gelijksoortige producten en accessoires

   - Amazon.com aanbiedingen

   - ListMania lijsten



Om *Zend_Service_Amazon* te gebruiken dien je een Amazon developer API key moeten hebben. Om die te verkrijgen, en
voor meer informatie, kan je terecht op de `Amazon Web Services`_ website.

.. note::

   Je Amazon developer API key is aan je Amazon identiteit verbonden, neem dus de nodige maatregelen om je key te
   beveiligen en privé te houden.

.. rubric:: Amazon doorzoeken met de traditionele API

In dit voorbeeld zoeken we naar PHP boeken op Amazon en doorlopen we de resultaten door ze uit te printen.

.. code-block:: php
   :linenos:
   <?php
   require_once 'Zend/Service/Amazon.php';
   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY&');
   $response = $amazon->itemSearch(array('SearchIndex' => 'Books', 'Keywords' => 'php'));
   foreach ($response as $r) {
       echo $r->Title .'<br />';
   }
   ?>
.. rubric:: Amazon doorzoeken met de Query API

Hier zoeken we ook naar PHP boeken op Amazon, maar we gebruiken de Query API, die lijkt op het Fluent Interface
ontwerp patroon.

.. code-block:: php
   :linenos:
   <?php
   require_once 'Zend/Service/Amazon/Query.php';
   $query = new Zend_Service_Amazon_Query('AMAZON_API_KEY');
   $query->category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title .'<br />';
   }
   ?>
.. _zend.service.amazon.countrycodes:

Landcodes
---------

Standaard maakt *Zend_Service_Amazon* een verbinding met de Amazon web service in de Verenigde Staten ("*US*"). Om
verbinding te maken met een ander land geef je eenvoudigweg de landcode van dit land op als de tweede parameter van
de constructor:

.. rubric:: Een Amazon Web Service land kiezen

.. code-block:: php
   :linenos:
   <?php
   // Verbind met Amazon in Frankrijk
   require_once 'Zend/Service/Amazon.php';
   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'FR');
   ?>
.. note::

   Geldige landcodes zijn: *CA*, *DE*, *FR*, *JP*, *UK*, en *US*.

.. _zend.service.amazon.itemlookup:

Een specifiek item opzoeken met ASIN code
-----------------------------------------

De *itemLookup()* methode biedt de mogelijkheid om een specifiek Amazon item op te halen als de ASIN bekend is.

.. rubric:: Een specifiek Amazon item ophalen per ASIN

.. code-block:: php
   :linenos:
   <?php
   require_once 'Zend/Service/Amazon.php';
   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY');
   $item = $amazon->itemLookup('B0000A432X');
   ?>
De *itemLookup()* methode aanvaardt ook een optionele tweede parameter om zoekopties af te handelen. Voor alle
details, inclusief een lijst van beschikbare opties, zie de `relevante Amazon documentatie`_.

   .. note::

      Om informatie over de beelden te verkrijgen voor je zoekresultaten, moet je de optie *ResponseGroup* tot
      *Medium* of *Large* zetten.



.. _zend.service.amazon.itemsearch:

Amazon Item zoekopdrachten uitvoeren
------------------------------------

Het zoeken naar items gebaseerd op een van de verschillende voorhande criteria wordt eenvoudig gemaakt door de
*itemSearch()* methode, zoals in het volgende voorbeeld:

.. rubric:: Uitvoeren van Amazon Item Zoekopdrachten

.. code-block:: php
   :linenos:
   <?php
   require_once 'Zend/Service/Amazon.php';
   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY');
   $response = $amazon->itemSearch(array('SearchIndex' => 'Books', 'Keywords' => 'php'));
   foreach($response as $r) {
       echo $r->Title .'<br />';
   }
   ?>
De *itemSearch()* methode aanvaardt een enkele array array parameter om zoekopties af te handelen. Voor alle
details, inclusief een lijst van beschikbare opties, zie de `relevante Amazon documentatie`_

.. tip::

   De :ref:`Zend_Service_Amazon_Query <zend.service.amazon.query>` klasse is een gemakkelijk te gebruiken "wrapper"
   van deze methode.

.. _zend.service.amazon.query:

De Alternatieve Query API gebruiken
-----------------------------------

.. _zend.service.amazon.query.introduction:

Inleiding
^^^^^^^^^

*Zend_Service_Amazon_Query* bied een alternatieve API om de Amazon Web Service te gebruiken. De alternatieve API
gebruikt het Fluent Interface ontwerppatroon. Dus, alle oproepen kunnen gemaakt worden door aaneengeregen
methode-oproepen te maken. (bv: *$obj->method()->method2($arg)*)

De *Zend_Service_Amazon_Query* API gebruikt overloading om gemakkelijk een item zoekopdracht op te zetten en laat
je dan toe te zoeken op de gespecifieerde criteria. Elk van de opties is als een methode-oproep aangeboden, en elk
argument van een methode komt overeen met de benoemde waarde van de optie:

.. rubric:: Doorzoek Amazon met gebruik van de Alternatieve Query API

In dit voorbeeld wordt de alternatieve query API gebruikt als een Fluent Interface om opties en hun
respectievelijke waarden te specificeren:

.. code-block:: php
   :linenos:
   <?php
   require_once 'Zend/Service/Amazon/Query.php';
   $query = new Zend_Service_Amazon_Query('MY_API_KEY');
   $query->Category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title .'<br />';
   }
   ?>
Dit zet de optie *Category* tot "Books" en *Keywords* tot "PHP".

Voor meer informatie over de beschikbare opties verwijzen we je graag door naar de `relevante Amazon
documentatie`_.

.. _zend.service.amazon.classes:

Zend_Service_Amazon Klassen
---------------------------

De volgende klassen worden allemaal teruggegeven door :ref:`Zend_Service_Amazon::itemLookup()
<zend.service.amazon.itemlookup>` en :ref:`Zend_Service_Amazon::itemSearch() <zend.service.amazon.itemsearch>`:

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

*Zend_Service_Amazon_Item* is de typeklasse die gebruikt wordt om een Amazon item voor te stellen dat werd
teruggestuurd door de web service. Het omvat alle item eigenschappen, inclusief de titel, beschrijving, recensies
enz...

.. _zend.service.amazon.classes.item.asxml:

Zend_Service_Amazon_Item::asXML()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

string:``asXML()``


Geeft de oorspronkelijke XML van het item terug

.. _zend.service.amazon.classes.item.properties:

Eigenschappen
^^^^^^^^^^^^^

*Zend_Service_Amazon_Item* heeft een aantal eigenschappen die onmiddellijk verwant zijn aan hun Amazon API
tegenhangers.

.. table:: Zend_Service_Amazon_Item Eigenschappen

   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |Naam            |Type                        |Beschrijving                                                                                      |
   +================+============================+==================================================================================================+
   |ASIN            |string                      |Amazon Item ID                                                                                    |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |DetailPageURL   |string                      |URL naar de pagina met de details voor het item                                                   |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |SalesRank       |string                      |Verkoopsrang van het item                                                                         |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |SmallImage      |Zend_Service_Amazon_Image   |Klein beeld van het item                                                                          |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |MediumImage     |Zend_Service_Amazon_Image   |Medium beeld van het item                                                                         |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |LargeImage      |Zend_Service_Amazon_Image   |Groot beeld van het item                                                                          |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |Subjects        |array                       |Item onderwerpen                                                                                  |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |Offers          |Zend_Service_Amazon_OfferSet|Samenvatting van en aanbiedingen voor het item                                                    |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |CustomerReviews |array                       |Klantrecensies voorgesteld als een array van Zend_Service_Amazon_CustomerReview objecten          |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |EditorialReviews|array                       |Uitgeversrecensies voorgesteld als een array van Zend_Service_Amazon_EditorialReview objecten     |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |SimilarProducts |array                       |Gelijksoortige producten voorgesteld als een array van Zend_Service_Amazon_SimilarProduct objecten|
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |Accessories     |array                       |Accessoires voor het item voorgesteld als een array van Zend_Service_Amazon_Accessories objecten  |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |Tracks          |array                       |Een array van liedjes, nummers en namen voor muziek CDs en DVDs                                   |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |ListmaniaLists  |array                       |ListMania lijsten verwant met het item als een array van Zend_Service_Amazon_ListmainList objecten|
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+
   |PromotionalTag  |string                      |Item promotievlag                                                                                 |
   +----------------+----------------------------+--------------------------------------------------------------------------------------------------+

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.image:

Zend_Service_Amazon_Image
^^^^^^^^^^^^^^^^^^^^^^^^^

*Zend_Service_Amazon_Image* vetegenwoordigt een (remote) beeld voor een product.

.. _zend.service.amazon.classes.image.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Amazon_Image Eigenschappen

   +------+--------+----------------------------------+
   |Naam  |Type    |Beschrijving                      |
   +======+========+==================================+
   |Url   |Zend_Uri|Remote URL voor het beeld         |
   +------+--------+----------------------------------+
   |Height|int     |De hoogte van het beeld in pixels |
   +------+--------+----------------------------------+
   |Width |int     |De breedte van het beeld in pixels|
   +------+--------+----------------------------------+

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.resultset:

Zend_Service_Amazon_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

*Zend_Service_Amazon_ResultSet* objecten worden teruggestuurd door :ref:`Zend_Service_Amazon::itemSearch()
<zend.service.amazon.itemsearch>` en laten je toe gemakkelijk meervoudige resultaten verwerken.

.. note::

   Implementeert de *SeekableIterator* voor gemakkelijke iteratie (bijvoorbeeld door *foreach* te gebruiken)
   evenals onmiddellijke toegang tot een specifiek resultaat door *seek()* te gebruiken.

.. _zend.service.amazon.classes.resultset.totalresults:

Zend_Service_Amazon_ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``
Geeft het totaal aantal resultaten verkregen door de zoekopdracht

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offerset:

Zend_Service_Amazon_OfferSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Elk resultaat teruggegeven door :ref:`Zend_Service_Amazon::itemSearch() <zend.service.amazon.itemsearch>` en
:ref:`Zend_Service_Amazon::itemLookup() <zend.service.amazon.itemlookup>` bevat een *Zend_Service_Amazon_OfferSet*
object via welke prijsinformatie voor het item kan worden opgevraagd.

.. _zend.service.amazon.classes.offerset.parameters:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Amazon_OfferSet Eigenschappen

   +----------------------+------+----------------------------------------------------------+
   |Naam                  |Type  |Beschrijving                                              |
   +======================+======+==========================================================+
   |LowestNewPrice        |int   |Laagste prijs voor het item in "Nieuw" conditie           |
   +----------------------+------+----------------------------------------------------------+
   |LowestNewPriceCurrency|string|De munteenheid voor LowestNewPrice                        |
   +----------------------+------+----------------------------------------------------------+
   |LowestOldPrice        |int   |Laagste prijs voor het item in "Gebruikt" conditie        |
   +----------------------+------+----------------------------------------------------------+
   |LowestOldPriceCurrency|string|De munteenheid voor LowestOldPrice                        |
   +----------------------+------+----------------------------------------------------------+
   |TotalNew              |int   |Totaal aantal beschikbare items in "nieuw" conditie       |
   +----------------------+------+----------------------------------------------------------+
   |TotalUsed             |int   |Totaal aantal beschikbare items in "gebruikt" conditie    |
   +----------------------+------+----------------------------------------------------------+
   |TotalCollectible      |int   |Totaal aantal beschikbare items in "verzamelaars" conditie|
   +----------------------+------+----------------------------------------------------------+
   |TotalRefurbished      |int   |Totaal aantal beschikbare items in "gerenoveerd" conditie |
   +----------------------+------+----------------------------------------------------------+
   |Offers                |array |Een array van Zend_Service_Amazon_Offer objecten.         |
   +----------------------+------+----------------------------------------------------------+

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offer:

Zend_Service_Amazon_Offer
^^^^^^^^^^^^^^^^^^^^^^^^^

Elke aanbieding voor een item is een *Zend_Service_Amazon_Offer* object.

.. _zend.service.amazon.classes.offer.properties:

Zend_Service_Amazon_Offer Eigenschappen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. table:: Eigenschappen

   +-------------------------------+-------+----------------------------------------------------------------+
   |Naam                           |Type   |Beschrijving                                                    |
   +===============================+=======+================================================================+
   |MerchantId                     |string |Handelaars Amazon ID                                            |
   +-------------------------------+-------+----------------------------------------------------------------+
   |GlancePage                     |string |URL voor een pagina met een samenvatting van de handelaar       |
   +-------------------------------+-------+----------------------------------------------------------------+
   |Condition                      |string |conditie van het item                                           |
   +-------------------------------+-------+----------------------------------------------------------------+
   |OfferListingId                 |string |ID van de aanbiedingslijst                                      |
   +-------------------------------+-------+----------------------------------------------------------------+
   |Price                          |int    |Prijs van het item                                              |
   +-------------------------------+-------+----------------------------------------------------------------+
   |CurrencyCode                   |string |Munteenheid voor de prijs van het item                          |
   +-------------------------------+-------+----------------------------------------------------------------+
   |Availability                   |string |Beschikbaarheid van het item                                    |
   +-------------------------------+-------+----------------------------------------------------------------+
   |IsEligibleForSuperSaverShipping|boolean|Of het item in aanmerking komt voor Super Saver Shipping of niet|
   +-------------------------------+-------+----------------------------------------------------------------+

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.similarproduct:

Zend_Service_Amazon_SimilarProduct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wanneer je naar items zoekt geeft Amazon ook een lijst van gelijksoortige producten terug die de zoekende persoon
zouden kunnen interesseren. Elk van deze items is een *Zend_Service_Amazon_SimilarProduct* object.

Elk object bevat de informatie die je toelaat opeenvolgende verzoeken te maken om de volledige informatie van het
item te verkrijgen.

.. _zend.service.amazon.classes.similarproduct.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Amazon_SimilarProduct Eigenschappen

   +-----+------+---------------------------------------+
   |Naam |Type  |Beschrijving                           |
   +=====+======+=======================================+
   |ASIN |string|Amazon Uniek ID voor het product (ASIN)|
   +-----+------+---------------------------------------+
   |Title|string|Titel van het product                  |
   +-----+------+---------------------------------------+

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.accessories:

Zend_Service_Amazon_Accessories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Accessoires voor het teruggegeven item worden vertegenwoordigd door *Zend_Service_Amazon_Accessories* objecten

.. _zend.service.amazon.classes.accessories.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Amazon_Accessories Eigenschappen

   +-----+------+---------------------------------------+
   |Naam |Type  |Beschrijving                           |
   +=====+======+=======================================+
   |ASIN |string|Amazon Uniek ID voor het product (ASIN)|
   +-----+------+---------------------------------------+
   |Title|string|Titel van het product                  |
   +-----+------+---------------------------------------+

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.customerreview:

Zend_Service_Amazon_CustomerReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Elke klantrecensie wordt teruggegeven als een *Zend_Service_Amazon_CustomerReview* object.

.. _zend.service.amazon.classes.customerreview.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Amazon_CustomerReview Eigenschappen

   +------------+------+---------------------------------------+
   |Naam        |Type  |Beschrijving                           |
   +============+======+=======================================+
   |Rating      |string|Item classificatie                     |
   +------------+------+---------------------------------------+
   |HelpfulVotes|string|Stemmen over hoe helpvol de recensie is|
   +------------+------+---------------------------------------+
   |CustomerId  |string|Klant ID                               |
   +------------+------+---------------------------------------+
   |TotalVotes  |string|Totaal aantal stemmen                  |
   +------------+------+---------------------------------------+
   |Date        |string|Datum van de recensie                  |
   +------------+------+---------------------------------------+
   |Summary     |string|Recensie samenvatting                  |
   +------------+------+---------------------------------------+
   |Content     |string|Recensie inhoud                        |
   +------------+------+---------------------------------------+

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.editorialreview:

Zend_Service_Amazon_EditorialReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Elke uitgeversrecensie van een item is een *Zend_Service_Amazon_EditorialReview* object

.. _zend.service.amazon.classes.editorialreview.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Amazon_EditorialReview Eigenschappen

   +-------+------+-----------------------------+
   |Naam   |Type  |Beschrijving                 |
   +=======+======+=============================+
   |Source |string|Bron van de uitgeversrecensie|
   +-------+------+-----------------------------+
   |Content|string|Recensie inhoud              |
   +-------+------+-----------------------------+

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.listmania:

Zend_Service_Amazon_Listmania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Elke ListMania resultaatlijst is een *Zend_Service_Amazon_Listmania* object.

.. _zend.service.amazon.classes.listmania.properties:

Eigenschappen
^^^^^^^^^^^^^

.. table:: Zend_Service_Amazon_Listmania Eigenschappen

   +--------+------+------------+
   |Naam    |Type  |Beschrijving|
   +========+======+============+
   |ListId  |string|Lijst ID    |
   +--------+------+------------+
   |ListNaam|string|Lijstnaam   |
   +--------+------+------------+

:ref:`Terug naar de klasselijst <zend.service.amazon.classes>`



.. _`Amazon Web Services`: http://www.amazon.com/gp/aws/landing.html
.. _`relevante Amazon documentatie`: http://www.amazon.com/gp/aws/sdk/main.html/102-9041115-9057709?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation
