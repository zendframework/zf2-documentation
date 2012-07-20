.. _zend.service.amazon:

Zend_Service_Amazon
===================

.. _zend.service.amazon.introduction:

Wprowadzenie
------------

*Zend_Service_Amazon* jest prostym API do użycia z web serwisami Amazon. *Zend_Service_Amazon* ma dwa API:
bardziej tradycyjne, które jest oparte na własnym API serwisu Amazon, oraz prostsze API zapytań do łatwego
tworzenia nawet skomplikowanych zapytań wyszukiwania.

*Zend_Service_Amazon* pozwala programistom odbierać informacje dostępne na stronach Amazon.com bezpośrednio za
pomocą API web serwisów Amazon. Przykłady zawierają:

   - Informacje o przedmiotach, takie jak obrazki, opisy, cenniki i inne

   - Recenzje klientów i redaktorów

   - Podobne produkty i akcesoria

   - Oferty Amazon.com

   - Listy ListMania



Aby użyć *Zend_Service_Amazon*, musisz posiadać klucz API programisty Amazon. Aby otrzymać klucz i zdobyć
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

   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY');
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

   $query = new Zend_Service_Amazon_Query('AMAZON_API_KEY');
   $query->category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title . '<br />';
   }


.. _zend.service.amazon.countrycodes:

Kody państw
-----------

Domyślnie, *Zend_Service_Amazon* łączy się z web serwisem Amazon w Stanach Zjednoczonych ("*US*"). Aby
połączyć się z innym krajem, w prosty sposób podaj kod odpowiedniego państwa jako drugi parametr
konstruktora:

.. _zend.service.amazon.countrycodes.example.country_code:

.. rubric:: Wybierania państwa web serwisu Amazon

.. code-block:: php
   :linenos:

   // Łączenie się z Amazon w Japonii
   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY', 'JP');


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

   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY');
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

   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY');
   $results = $amazon->itemSearch(array('SearchIndex' => 'Books',
                                        'Keywords' => 'php'));
   foreach($results as $result) {
       echo $result->Title .'<br />';
   }


.. _zend.service.amazon.itemsearch.example.responsegroup:

.. rubric:: Użycie opcji *ResponseGroup*

Opcja *ResponseGroup* używana jest do konfigurowania informacji jakie mają być zwracane w odpowiedzi.

.. code-block::
   :linenos:

   $amazon = new Zend_Service_Amazon('AMAZON_API_KEY');
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

   Klasa :ref:`Zend_Service_Amazon_Query <zend.service.amazon.query>` jest nakładką na tę metodę ułatwiającą
   tworzenie zapytań wyszukiwania.

.. _zend.service.amazon.query:

Użycie alternatywnego API zapytań
---------------------------------

.. _zend.service.amazon.query.introduction:

Wprowadzenie
^^^^^^^^^^^^

*Zend_Service_Amazon_Query* zapewnia alternatywne API do użycia z web serwisami Amazon. Alternatywne API używa
wzorca projektowego płynnych interfejsów. Oznacza to, że wszystkie wywołania mogą być przeprowadzone przez
łańcuchowe wywołania metod. (np. *$obj->method()->method2($arg)*)

API *Zend_Service_Amazon_Query* używa przeładowania w celu łatwego ustawiania wyszukiwania przedmiotów i
pozwala na wyszukiwanie na podstawie określonych kryteriów. Każda z opcji jest udostępniana jako wywołanie
metody, a każdy argument metody odpowiada wartości opcji o tej nazwie:

.. _zend.service.amazon.query.introduction.example.basic:

.. rubric:: Przeszukiwanie serwisu Amazon używając alternatywnego API zapytań

W tym przykładzie alternatywne API zapytań używane jest jako płynny interfejs służący do określania opcji i
odpowiadającym im wartościom:

.. code-block:: php
   :linenos:

   require_once 'Zend/Service/Amazon/Query.php';
   $query = new Zend_Service_Amazon_Query('MY_API_KEY');
   $query->Category('Books')->Keywords('PHP');
   $results = $query->search();
   foreach ($results as $result) {
       echo $result->Title .'<br />';
   }


To ustawia opcję *Category* na "Books" oraz *Keywords* na "PHP".

Aby uzyskać więcej informacji o dostępnych opcjach, proszę odwiedź `dokumentację Amazon`_.

.. _zend.service.amazon.classes:

Klasy Zend_Service_Amazon
-------------------------

Poniższe klasy są zwracane przez metody :ref:`Zend_Service_Amazon::itemLookup() <zend.service.amazon.itemlookup>`
oraz :ref:`Zend_Service_Amazon::itemSearch() <zend.service.amazon.itemsearch>`:

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

*Zend_Service_Amazon_Item* jest typem klasy używanej dp reprezentowania przedmiotu Amazon zwracanego przez web
serwis. Zawiera ona wszystkie atrybuty przedmiotu, włączając w to tytuł, opis, recenzje itd.

.. _zend.service.amazon.classes.item.asxml:

Zend_Service_Amazon_Item::asXML()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

string:``asXML()``


Zwraca oryginalną treść XML dla przedmiotu

.. _zend.service.amazon.classes.item.properties:

Właściwości
^^^^^^^^^^^

*Zend_Service_Amazon_Item* posiada właściwości bezpośrednio związane ze standardowymi częściami Amazon API.

.. _zend.service.amazon.classes.item.properties.table-1:

.. table:: Właściwości Zend_Service_Amazon_Item

   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Nazwa           |Typ                         |Opis                                                                                          |
   +================+============================+==============================================================================================+
   |ASIN            |string                      |ID przedmiotu w Amazon                                                                        |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |DetailPageURL   |string                      |Adres URL strony ze szczegółowymi informacjami o przedmiocie                                  |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |SalesRank       |int                         |Ranking sprzedaży dla przedmiotu                                                              |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |SmallImage      |Zend_Service_Amazon_Image   |Małe zdjęcie przedmiotu                                                                       |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |MediumImage     |Zend_Service_Amazon_Image   |Średnie zdjęcie przedmiotu                                                                    |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |LargeImage      |Zend_Service_Amazon_Image   |Duże zdjęcie przedmiotu                                                                       |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Subjects        |array                       |Tematy przedmiotów                                                                            |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Offers          |Zend_Service_Amazon_OfferSet|Podsumowanie ofert oraz oferty dla przedmiotu                                                 |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |CustomerReviews |array                       |Recenzje klientów reprezentowane jako tablica obiektów Zend_Service_Amazon_CustomerReview     |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |EditorialReviews|array                       |Recenzje redaktorów reprezentowane jako tablica obiektów Zend_Service_Amazon_EditorialReview  |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |SimilarProducts |array                       |Podobne produkty reprezentowane jako tablica obiektów Zend_Service_Amazon_SimilarProduct      |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Accessories     |array                       |Akcesoria dla przedmiotu reprezentowane jako tablica obiektów Zend_Service_Amazon_Accessories |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |Tracks          |array                       |Tablica numerów i nazw utworów dla muzycznych płyt CD oraz DVD                                |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |ListmaniaLists  |array                       |Listy Listmania powiązane z przedmiotem jako tablica obiektó∑ Zend_Service_Amazon_ListmainList|
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+
   |PromotionalTag  |string                      |Etykieta promocyjna przedmiotu                                                                |
   +----------------+----------------------------+----------------------------------------------------------------------------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.image:

Zend_Service_Amazon_Image
^^^^^^^^^^^^^^^^^^^^^^^^^

*Zend_Service_Amazon_Image* reprezentuje zdalny obraz dla produktu.

.. _zend.service.amazon.classes.image.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.image.properties.table-1:

.. table:: Właściwości Zend_Service_Amazon_Image

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

Zend_Service_Amazon_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Obiekty *Zend_Service_Amazon_ResultSet* są zwracane przez metodę :ref:`Zend_Service_Amazon::itemSearch()
<zend.service.amazon.itemsearch>` i pozwalają ci na łatwą obsługę wielu zwróconych wyników wyszukiwania.

.. note::

   **SeekableIterator**

   Implementuje interfejs *SeekableIterator* dla łatwej iteracji (np. używając *foreach*), tak samo jak i dla
   bezpośredniego dostępu do specyficznego wyniku używając metody *seek()*.

.. _zend.service.amazon.classes.resultset.totalresults:

Zend_Service_Amazon_ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``
Zwraca całkowitą ilość wyników zwróconych przez wyszukiwanie

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offerset:

Zend_Service_Amazon_OfferSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Każdy wynik zwracany przez metody :ref:`Zend_Service_Amazon::itemSearch() <zend.service.amazon.itemsearch>` oraz
:ref:`Zend_Service_Amazon::itemLookup() <zend.service.amazon.itemlookup>` zawiera obiekt
*Zend_Service_Amazon_OfferSet* poprzez który dostępne są informacje o cenach dla przedmiotu.

.. _zend.service.amazon.classes.offerset.parameters:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.offerset.parameters.table-1:

.. table:: Właściwości Zend_Service_Amazon_OfferSet

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
   |Offers                |array |Tablica obiektów Zend_Service_Amazon_Offer.          |
   +----------------------+------+-----------------------------------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.offer:

Zend_Service_Amazon_Offer
^^^^^^^^^^^^^^^^^^^^^^^^^

Każda oferta dla przedmiotu jest zwracana jako obiekt *Zend_Service_Amazon_Offer*.

.. _zend.service.amazon.classes.offer.properties:

Właściwości Zend_Service_Amazon_Offer
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

Zend_Service_Amazon_SimilarProduct
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Kiedy wyszukujemy przedmiotów, Amazon także zwraca listę podobnych produktów, które także mogą odpowiadać
szukającemu. Każdy z nich jest zwracany jako obiekt *Zend_Service_Amazon_SimilarProduct*.

Każdy obiekt zawiera informacje pozwalające ci na przeprowadzenie kolejnego żądania w celu pobrania pełnych
informacji o przedmiocie.

.. _zend.service.amazon.classes.similarproduct.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.similarproduct.properties.table-1:

.. table:: Właściwości Zend_Service_Amazon_SimilarProduct

   +-----+------+---------------------------+
   |Nazwa|Typ   |Opis                       |
   +=====+======+===========================+
   |ASIN |string|Unikalny ID produktu (ASIN)|
   +-----+------+---------------------------+
   |Title|string|Tytuł produktu             |
   +-----+------+---------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.accessories:

Zend_Service_Amazon_Accessories
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Akcesoria dla zwróconego przedmiotu są reprezentowane jako obiekty *Zend_Service_Amazon_Accessories*

.. _zend.service.amazon.classes.accessories.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.accessories.properties.table-1:

.. table:: Właściwości Zend_Service_Amazon_Accessories

   +-----+------+----------------------------------+
   |Nazwa|Typ   |Opis                              |
   +=====+======+==================================+
   |ASIN |string|Unikalny ID produktu Amazon (ASIN)|
   +-----+------+----------------------------------+
   |Title|string|Tytuł produktu                    |
   +-----+------+----------------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.customerreview:

Zend_Service_Amazon_CustomerReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Każda recenzja klienta jest zwracana jako obiekt *Zend_Service_Amazon_CustomerReview*.

.. _zend.service.amazon.classes.customerreview.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.customerreview.properties.table-1:

.. table:: Właściwości Zend_Service_Amazon_CustomerReview

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

Zend_Service_Amazon_EditorialReview
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Każda recenzja redaktora jest zwracana jako obiekt *Zend_Service_Amazon_EditorialReview*

.. _zend.service.amazon.classes.editorialreview.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.editorialreview.properties.table-1:

.. table:: Właściwości Zend_Service_Amazon_EditorialReview

   +-------+------+-------------------------+
   |Nazwa  |Typ   |Opis                     |
   +=======+======+=========================+
   |Source |string|Źródło recenzji redaktora|
   +-------+------+-------------------------+
   |Content|string|Zawartość oceny          |
   +-------+------+-------------------------+

:ref:`Powrót do listy klas <zend.service.amazon.classes>`

.. _zend.service.amazon.classes.listmania:

Zend_Service_Amazon_Listmania
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wyniki wyszukiwania elementów List Mania są zwracane jako obiekty *Zend_Service_Amazon_Listmania*.

.. _zend.service.amazon.classes.listmania.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.amazon.classes.listmania.properties.table-1:

.. table:: Właściwości Zend_Service_Amazon_Listmania

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
