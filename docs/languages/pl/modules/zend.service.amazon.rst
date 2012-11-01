.. EN-Revision: none
.. _zend.service.amazon:

Zend\Service\Amazon
===================

.. _zend.service.amazon.introduction:

Wprowadzenie
------------

*Zend\Service\Amazon* jest prostym API do użycia z web serwisami Amazon. *Zend\Service\Amazon* ma dwa API:
bardziej tradycyjne, które jest oparte na własnym API serwisu Amazon, oraz prostsze API zapytań do łatwego
tworzenia nawet skomplikowanych zapytań wyszukiwania.

*Zend\Service\Amazon* pozwala programistom odbierać informacje dostępne na stronach Amazon.com bezpośrednio za
pomocą API web serwisów Amazon. Przykłady zawierają:

   - Informacje o przedmiotach, takie jak obrazki, opisy, cenniki i inne

   - Recenzje klientów i redaktorów

   - Podobne produkty i akcesoria

   - Oferty Amazon.com

   - Listy ListMania



Aby użyć *Zend\Service\Amazon*, musisz posiadać klucz API programisty Amazon. Aby otrzymać klucz i zdobyć
więcej informacji odwiedź stronę `Amazon Web Services`_.

.. note::

   **Uwaga**

   Twój klucz do API serwisu Amazon jest połączony z twoją tożsamością w Amazon, więc staraj się
   przechowywać twój klucz API bezpiecznie.

.. _zend.service.amazon.introduction.example.itemsearch:

.. rubric:: Przeszukiwanie Amazon używając tradycyjnego API

W tym przykładzie, szukamy książek o PHP w Amazon i przechodzimy przez nie w pętli, wyświetlając je.

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach ($results as $result) {
       echo $result->Title .'<br />';
   }


.. _zend.service.amazon.introduction.example.query_api:

.. rubric:: Przeszukiwanie Amazon używając API zapytań

Tutaj także szukamy książek o PHP w Amazon, ale zamiast tradycyjnego API używamy API zapytań, które jest
stworzone w oparciu o projektowy wzorzec płynnych interfejsów.

.. code-block:: php
   :linenos:

   $query = new Zend\Service_Amazon\Query('AMAZON_API_KEY');
   $query->category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }


.. _zend.service.amazon.countrycodes:

Kody państw
-----------

Domyślnie, *Zend\Service\Amazon* łączy się z web serwisem Amazon w Stanach Zjednoczonych ("*US*"). Aby
połączyć się z innym krajem, w prosty sposób podaj kod odpowiedniego państwa jako drugi parametr
konstruktora:

.. _zend.service.amazon.countrycodes.example.country_code:

.. rubric:: Wybierania państwa web serwisu Amazon

.. code-block:: php
   :linenos:

   // Łączenie się z Amazon w Japonii
   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY', 'JP');


.. note::

   **Kody państw**

   Poprawne kody państw: *CA*, *DE*, *FR*, *JP*, *UK*, oraz *US*.

.. _zend.service.amazon.itemlookup:

Szukanie specyficznego przedmiotu w Amazon na podstawie ASIN
------------------------------------------------------------

Metoda *itemLookup()* zapewnia możliwość pobrania informacji o konkretnym przedmiocie, którego ASIN jest znany.

.. _zend.service.amazon.itemlookup.example.asin:

.. rubric:: Szukanie specyficznego przedmiotu w Amazon na podstawie ASIN

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY');
   $item = $amazon->itemLookup('B0000A432X');


Metoda *itemLookup()* także akceptuje opcjonalny drugi parametr do obsługi opcji wyszukiwania. Aby poznać pełne
informacje, włączając w to listę dostępnych opcji odwiedź `dokumentację Amazon`_.

.. note::

   **Informacje o zdjęciach**

   Aby odebrać informacje o zdjęciach dla twoich wyników wyszukiwania, musisz ustawić opcję *ResponseGroup* na
   *Medium* lub *Large*.

.. _zend.service.amazon.itemsearch:

Wykonywanie wyszukiwań przedmiotów Amazon
-----------------------------------------

Wyszukiwanie przedmiotów oparte na różnych dostępnych kryteriach jest przeprowadzane za pomocą metody
*itemSearch()*, tak jak w poniższym przykładzie:

.. _zend.service.amazon.itemsearch.example.basic:

.. rubric:: Wykonywanie wyszukiwań przedmiotów Amazon

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach($results as $result) {
       echo $result->Title .'<br />';
   }


.. _zend.service.amazon.itemsearch.example.responsegroup:

.. rubric:: Użycie opcji *ResponseGroup*

Opcja *ResponseGroup* używana jest do konfigurowania informacji jakie mają być zwracane w odpowiedzi.

.. code-block:: php
   :linenos:

   $amazon = new Zend\Service\Amazon('AMAZON_API_KEY');
   $results = $amazon->itemSearch(array(
       'SearchIndex'   => 'Books',
       'Keywords'      => 'php',
       'ResponseGroup' => 'Small,ItemAttributes,Images,SalesRank,Reviews,' .
                          'EditorialReview,Similarities,ListmaniaLists'
       ));
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }


Metoda *itemSearch()* akceptuje jeden parametr w postaci tablicy do obsługi opcji wyszukiwania. Aby poznać
wszystkie szczegóły włączając w to listę dostępnych opcji, proszę zobacz `dokumentację Amazon`_

.. tip::

   Klasa :ref:`Zend\Service_Amazon\Query <zend.service.amazon.query>` jest nakładką na tę metodę ułatwiającą
   tworzenie zapytań wyszukiwania.

.. _zend.service.amazon.query:

Użycie alternatywnego API zapytań
---------------------------------

.. _zend.service.amazon.query.introduction:

Wprowadzenie
^^^^^^^^^^^^

*Zend\Service_Amazon\Query* zapewnia alternatywne API do użycia z web serwisami Amazon. Alternatywne API używa
wzorca projektowego płynnych interfejsów. Oznacza to, że wszystkie wywołania mogą być przeprowadzone przez
łańcuchowe wywołania metod. (np. *$obj->method()->method2($arg)*)

API *Zend\Service_Amazon\Query* używa przeładowania w celu łatwego ustawiania wyszukiwania przedmiotów i
pozwala na wyszukiwanie na podstawie określonych kryteriów. Każda z opcji jest udostępniana jako wywołanie
metody, a każdy argument metody odpowiada wartości opcji o tej nazwie:

.. _zend.service.amazon.query.introduction.example.basic:

.. rubric:: Przeszukiwanie serwisu Amazon używając alternatywnego API zapytań

W tym przykładzie alternatywne API zapytań używane jest jako płynny interfejs służący do określania opcji i
odpowiadającym im wartościom:

.. code-block:: php
   :linenos:

   require_once 'Zend/Service/Amazon/Query.php';
   $query = new Zend\Service_Amazon\Query('MY_API_KEY');
   $query->Category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title .'<br />';
   }


To ustawia opcję *Category* na "Books" oraz *Keywords* na "PHP".

Aby uzyskać więcej informacji o dostępnych opcjach, proszę odwiedź `dokumentację Amazon`_.

.. _zend.service.amazon.classes:

Klasy Zend\Service\Amazon
-------------------------

Poniższe klasy są zwracane przez metody :ref:`Zend\Service\Amazon::itemLookup() <zend.service.amazon.itemlookup>`
oraz :ref:`Zend\Service\Amazon::itemSearch() <zend.service.amazon.itemsearch>`:

   - :ref:`Zend\Service_Amazon\Item <zend.service.amazon.classes.item>`

   - :ref:`Zend\Service_Amazon\Image <zend.service.amazon.classes.image>`

   - :ref:`Zend\Service_Amazon\ResultSet <zend.service.amazon.classes.resultset>`

   - :ref:`Zend\Service_Amazon\OfferSet <zend.service.amazon.classes.offerset>`

   - :ref:`Zend\Service_Amazon\Offer <zend.service.amazon.classes.offer>`

   - :ref:`Zend\Service_Amazon\SimilarProduct <zend.service.amazon.classes.similarproduct>`

   - :ref:`Zend\Service_Amazon\Accessories <zend.service.amazon.classes.accessories>`

   - :ref:`Zend\Service_Amazon\CustomerReview <zend.service.amazon.classes.customerreview>`

   - :ref:`Zend\Service_Amazon\EditorialReview <zend.service.amazon.classes.editorialreview>`

   - :ref:`Zend\Service_Amazon\ListMania <zend.service.amazon.classes.listmania>`



.. _zend.service.amazon.classes.item:

Zend\Service_Amazon\Item
^^^^^^^^^^^^^^^^^^^^^^^^

*Zend\Service_Amazon\Item* jest typem klasy używanej dp reprezentowania przedmiotu Amazon zwracanego przez web
serwis. Zawiera ona wszystkie atrybuty przedmiotu, włączając w to tytuł, opis, recenzje itd.

.. _zend.service.amazon.classes.item.asxml:

Zend\Service_Amazon\Item::asXML()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

string:``asXML()``


Zwraca oryginalną treść XML dla przedmiotu

.. _zend.service.amazon.classes.item.properties:

Właściwości
^^^^^^^^^^^

*Zend\Service_Amazon\Item* posiada właściwości bezpośrednio związane ze standardowymi częściami Amazon API.

.. _zend.service.amazon.classes.item.properties.table-1:

.. table:: Właściwości Zend\Service_Amazon\Item

   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Nazwa           |Typ                         |Opis                                                                                          |
   +================+============================+==============================================================================================+
   |ASIN            |string                      |ID przedmiotu w Amazon                                                                        |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |DetailPageURL   |string                      |Adres URL strony ze szczegółowymi informacjami o przedmiocie                                  |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |SalesRank       |int                         |Ranking sprzedaży dla przedmiotu                                                              |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |SmallImage      |Zend\Service_Amazon\Image   |Małe zdjęcie przedmiotu                                                                       |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |MediumImage     |Zend\Service_Amazon\Image   |Średnie zdjęcie przedmiotu                                                                    |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |LargeImage      |Zend\Service_Amazon\Image   |Duże zdjęcie przedmiotu                                                                       |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Subjects        |array                       |Tematy przedmiotów                                                                            |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Offers          |Zend\Service_Amazon\OfferSet|Podsumowanie ofert oraz oferty dla przedmiotu                                                 |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |CustomerReviews |array                       |Recenzje klientów reprezentowane jako tablica obiektów Zend\Service_Amazon\CustomerReview     |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |EditorialReviews|array                       |Recenzje redaktorów reprezentowane jako tablica obiektów Zend\Service_Amazon\EditorialReview  |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |SimilarProducts |array                       |Podobne produkty reprezentowane jako tablica obiektów Zend\Service_Amazon\SimilarProduct      |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Accessories     |array                       |Akcesoria dla przedmiotu reprezentowane jako tablica obiektów Zend\Service_Amazon\Accessories |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Tracks          |array                       |Tablica numerów i nazw utworów dla muzycznych płyt CD oraz DVD                                |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |ListmaniaLists  |array                       |Listy Listmania powiązane z przedmiotem jako tablica obiektó∑ Zend\Service_Amazon\ListmainList|
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |PromotionalTag  |string                      |Etykieta promocyjna przedmiotu                                                                |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.image:

Zend\Service_Amazon\Image
^^^^^^^^^^^^^^^^^^^^^^^^^

*Zend\Service_Amazon\Image* reprezentuje zdalny obraz dla produktu.

.. _zend.service.amazon.classes.image.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.image.properties.table-1:

.. table:: Właściwości Zend\Service_Amazon\Image

   +------+--------+-----------------------------+
   |Nazwa |Typ     |Opis                         |
   +======+========+=============================+
   |Url   |Zend_Uri|Zdalny adres URL obrazka     |
   +------+--------+-----------------------------+
   |Height|int     |Wysokość obrazka w pikselach |
   +------+--------+-----------------------------+
   |Width |int     |Szerokość obrazka w pikselach|
   +------+--------+-----------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.resultset:

Zend\Service_Amazon\ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Obiekty *Zend\Service_Amazon\ResultSet* są zwracane przez metodę :ref:`Zend\Service\Amazon::itemSearch()
<zend.service.amazon.itemsearch>` i pozwalają ci na łatwą obsługę wielu zwróconych wyników wyszukiwania.

.. note::

   **SeekableIterator**

   Implementuje interfejs *SeekableIterator* dla łatwej iteracji (np. używając *foreach*), tak samo jak i dla
   bezpośredniego dostępu do specyficznego wyniku używając metody *seek()*.

.. _zend.service.amazon.classes.resultset.totalresults:

Zend\Service_Amazon\ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``
Zwraca całkowitą ilość wyników zwróconych przez wyszukiwanie

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offerset:

Zend\Service_Amazon\OfferSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Każdy wynik zwracany przez metody :ref:`Zend\Service\Amazon::itemSearch() <zend.service.amazon.itemsearch>` oraz
:ref:`Zend\Service\Amazon::itemLookup() <zend.service.amazon.itemlookup>` zawiera obiekt
*Zend\Service_Amazon\OfferSet* poprzez który dostępne są informacje o cenach dla przedmiotu.

.. _zend.service.amazon.classes.offerset.parameters:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.offerset.parameters.table-1:

.. table:: Właściwości Zend\Service_Amazon\OfferSet

   +----------------------+------+-----------------------------------------------------+
   |Nazwa                 |Typ   |Opis                                                 |
   +======================+======+=====================================================+
   |LowestNewPrice        |int   |Najniższa cena dla nowego przedmiotu (stan "New")    |
   +----------------------+------+-----------------------------------------------------+
   |LowestNewPriceCurrency|string|Waluta dla LowestNewPrice                            |
   +----------------------+------+-----------------------------------------------------+
   |LowestOldPrice        |int   |Najniższa cena dla używanego przedmiotu (stan "Used")|
   +----------------------+------+-----------------------------------------------------+
   |LowestOldPriceCurrency|string|Waluta dla LowestOldPrice                            |
   +----------------------+------+-----------------------------------------------------+
   |TotalNew              |int   |Całkowita ilość przedmiotów o stanie "new"           |
   +----------------------+------+-----------------------------------------------------+
   |TotalUsed             |int   |Całkowita ilość przedmiotów o stanie "used"          |
   +----------------------+------+-----------------------------------------------------+
   |TotalCollectible      |int   |Całkowita ilość przedmiotów o stanie "collectible"   |
   +----------------------+------+-----------------------------------------------------+
   |TotalRefurbished      |int   |Całkowita ilość przedmiotów o stanie "refurbished"   |
   +----------------------+------+-----------------------------------------------------+
   |Offers                |array |Tablica obiektów Zend\Service_Amazon\Offer.          |
   +----------------------+------+-----------------------------------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offer:

Zend\Service_Amazon\Offer
^^^^^^^^^^^^^^^^^^^^^^^^^

Każda oferta dla przedmiotu jest zwracana jako obiekt *Zend\Service_Amazon\Offer*.

.. _zend.service.amazon.classes.offer.properties:

Właściwości Zend\Service_Amazon\Offer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _zend.service.amazon.classes.offer.properties.table-1:

.. table:: Właściwości

   +-------------------------------+-------+----------------------------------------------------------+
   |Nazwa                          |Typ    |Opis                                                      |
   +===============================+=======+==========================================================+
   |MerchantId                     |string |ID handlowca Amazon                                       |
   +-------------------------------+-------+----------------------------------------------------------+
   |GlancePage                     |string |Adres URL strony z podsumowaniem handlowca                |
   +-------------------------------+-------+----------------------------------------------------------+
   |Condition                      |string |Stan przedmiotu                                           |
   +-------------------------------+-------+----------------------------------------------------------+
   |OfferListingId                 |string |ID listy ofert                                            |
   +-------------------------------+-------+----------------------------------------------------------+
   |Price                          |int    |Cena za przedmiot                                         |
   +-------------------------------+-------+----------------------------------------------------------+
   |CurrencyCode                   |string |Kod waluty dla ceny przedmiotu                            |
   +-------------------------------+-------+----------------------------------------------------------+
   |Availability                   |string |Dostępność przedmiotu                                     |
   +-------------------------------+-------+----------------------------------------------------------+
   |IsEligibleForSuperSaverShipping|boolean|Czy przedmiot jest dostępny w Super Saver Shipping czy nie|
   +-------------------------------+-------+----------------------------------------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.similarproduct:

Zend\Service_Amazon\SimilarProduct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Kiedy wyszukujemy przedmiotów, Amazon także zwraca listę podobnych produktów, które także mogą odpowiadać
szukającemu. Każdy z nich jest zwracany jako obiekt *Zend\Service_Amazon\SimilarProduct*.

Każdy obiekt zawiera informacje pozwalające ci na przeprowadzenie kolejnego żądania w celu pobrania pełnych
informacji o przedmiocie.

.. _zend.service.amazon.classes.similarproduct.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.similarproduct.properties.table-1:

.. table:: Właściwości Zend\Service_Amazon\SimilarProduct

   +-----+------+---------------------------+
   |Nazwa|Typ   |Opis                       |
   +=====+======+===========================+
   |ASIN |string|Unikalny ID produktu (ASIN)|
   +-----+------+---------------------------+
   |Title|string|Tytuł produktu             |
   +-----+------+---------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.accessories:

Zend\Service_Amazon\Accessories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Akcesoria dla zwróconego przedmiotu są reprezentowane jako obiekty *Zend\Service_Amazon\Accessories*

.. _zend.service.amazon.classes.accessories.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.accessories.properties.table-1:

.. table:: Właściwości Zend\Service_Amazon\Accessories

   +-----+------+----------------------------------+
   |Nazwa|Typ   |Opis                              |
   +=====+======+==================================+
   |ASIN |string|Unikalny ID produktu Amazon (ASIN)|
   +-----+------+----------------------------------+
   |Title|string|Tytuł produktu                    |
   +-----+------+----------------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.customerreview:

Zend\Service_Amazon\CustomerReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Każda recenzja klienta jest zwracana jako obiekt *Zend\Service_Amazon\CustomerReview*.

.. _zend.service.amazon.classes.customerreview.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.customerreview.properties.table-1:

.. table:: Właściwości Zend\Service_Amazon\CustomerReview

   +------------+------+---------------------------------------------+
   |Nazwa       |Typ   |Opis                                         |
   +============+======+=============================================+
   |Rating      |string|Ocena przedmiotu                             |
   +------------+------+---------------------------------------------+
   |HelpfulVotes|string|Głosy mówiące o tym jak pomocna jest recenzja|
   +------------+------+---------------------------------------------+
   |CustomerId  |string|ID klienta                                   |
   +------------+------+---------------------------------------------+
   |TotalVotes  |string|Całkowiita ilość głosów                      |
   +------------+------+---------------------------------------------+
   |Date        |string|Data oceny                                   |
   +------------+------+---------------------------------------------+
   |Summary     |string|Podsumowanie oceny                           |
   +------------+------+---------------------------------------------+
   |Content     |string|Zawartość oceny                              |
   +------------+------+---------------------------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.editorialreview:

Zend\Service_Amazon\EditorialReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Każda recenzja redaktora jest zwracana jako obiekt *Zend\Service_Amazon\EditorialReview*

.. _zend.service.amazon.classes.editorialreview.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.editorialreview.properties.table-1:

.. table:: Właściwości Zend\Service_Amazon\EditorialReview

   +-------+------+-------------------------+
   |Nazwa  |Typ   |Opis                     |
   +=======+======+=========================+
   |Source |string|Źródło recenzji redaktora|
   +-------+------+-------------------------+
   |Content|string|Zawartość oceny          |
   +-------+------+-------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.listmania:

Zend\Service_Amazon\Listmania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wyniki wyszukiwania elementów List Mania są zwracane jako obiekty *Zend\Service_Amazon\Listmania*.

.. _zend.service.amazon.classes.listmania.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.listmania.properties.table-1:

.. table:: Właściwości Zend\Service_Amazon\Listmania

   +--------+------+-----------+
   |Nazwa   |Typ   |Opis       |
   +========+======+===========+
   |ListId  |string|ID listy   |
   +--------+------+-----------+
   |ListName|string|Nazwa listy|
   +--------+------+-----------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`



.. _`Amazon Web Services`: http://www.amazon.com/gp/aws/landing.html
.. _`dokumentację Amazon`: http://www.amazon.com/gp/aws/sdk/main.html/102-9041115-9057709?s=AWSEcommerceService&v=2011-08-01&p=ApiReference/ItemSearchOperation
