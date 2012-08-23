.. EN-Revision: none
.. _zend.service.flickr:

Zend_Service_Flickr
===================

.. _zend.service.flickr.introduction:

Wprowadzenie do przeszukiwania Flickr
-------------------------------------

*Zend_Service_Flickr* jest prostym API do użycia z serwisem Flickr REST Web Service. W celu użycia web serwisów
Flickr, musisz posiadać klucz API. Aby zdoby klucz i uzyskać więcej informacji o Flickr REST Web Service,
odwiedź `dokumentację Flickr API`_.

W poniższym przykladzie, używamy metody *tagSearch()* do wyszukiwania zdjęć zawierających etykietę "php".

.. _zend.service.flickr.introduction.example-1:

.. rubric:: Proste wyszukiwanie zdjęć Flickr

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $results = $flickr->tagSearch("php");

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }


.. note::

   **Opcjonalny parametr**

   Metoda *tagSearch()* akceptuje tablicę opcji jako opcjonalny drugi parametr.

.. _zend.service.flickr.finding-users:

Wyszukiwanie zdjęć użytkowników Flickr i informacji o nich
----------------------------------------------------------

Klasa *Zend_Service_Flickr* zapewnia kilka możliwości pobierania informacji o użytkownikach serwisu Flickr:

- *userSearch()*: akceptuje w parametrze treść zapytania w postaci etykiet oddzielonych spacją oraz tablicę
  opcji wyszukiwania jako opcjonalny drugi parametr, a zwraca zestaw zdjęć jako obiekt
  *Zend_Service_Flickr_ResultSet*.

- *getIdByUsername()*: Zwraca ID użytkownika powiązane z podaną nazwą użytkownika.

- *getIdByEmail()*:Zwraca ID użytkownika powiązane z podanym adresem email.

.. _zend.service.flickr.finding-users.example-1:

.. rubric:: Wyszukiwanie publicznych zdjęć użytkownika serwisu Flickr na podstawie adresu e-mail

W tym przykładzie, posiadamy adres e-mail użytkownika serwisu Flickr i szukamy publicznych zdjęć użytkownika
używając metody *userSearch()*:

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $results = $flickr->userSearch($userEmail);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }


.. _zend.service.flickr.grouppoolgetphotos:

Wyszukiwanie zdjęć w Group Pool
-------------------------------

Klasa *Zend_Service_Flickr* pozwala na pobieranie zdjęć grupy w oparciu o jej ID. Użyj metody
*groupPoolGetPhotos()*:

.. _zend.service.flickr.grouppoolgetphotos.example-1:

.. rubric:: Pobieranie zdjęć z Group Pool na podstawie ID grupy:

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $results = $flickr->groupPoolGetPhotos($groupId);

   foreach ($results as $result) {
       echo $result->title . '<br />';
   }


.. note::

   **Opcjonalny parametr**

   Metoda *groupPoolGetPhotos()* akceptuje opcjonalny drugi parametr będący tablicą opcji.

.. _zend.service.flickr.getimagedetails:

Pobieranie szczegółów zdjęcia Flickr
------------------------------------

*Zend_Service_Flickr* ułatwia pobieranie informacji o zdjęciu na podstawie podanego ID zdjęcia. Po prostu użyj
metody *getImageDetails()*, tak jak w poniższym przykładzie:

.. _zend.service.flickr.getimagedetails.example-1:

.. rubric:: Pobieranie szczegółów zdjęcia Flickr

Jeśli posiadasz ID zdjęcia Flickr, pobranie informacji o zdjęciu jest bardzo proste:

.. code-block:: php
   :linenos:

   $flickr = new Zend_Service_Flickr('MY_API_KEY');

   $image = $flickr->getImageDetails($imageId);

   echo "Obrazek o ID $imageId ma rozmiar $image->width x $image->height pikseli.<br />\n";
   echo "<a href=\"$image->clickUri\">Click for Image</a>\n";


.. _zend.service.flickr.classes:

Klasy wyników Zend_Service_Flickr
---------------------------------

Poniższe klasy są zwracane przez metody *tagSearch()* oraz *userSearch()*:

   - :ref:`Zend_Service_Flickr_ResultSet <zend.service.flickr.classes.resultset>`

   - :ref:`Zend_Service_Flickr_Result <zend.service.flickr.classes.result>`

   - :ref:`Zend_Service_Flickr_Image <zend.service.flickr.classes.image>`



.. _zend.service.flickr.classes.resultset:

Zend_Service_Flickr_ResultSet
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Reprezentuje zestaw wyników wysuzkiwania Flickr.

.. note::

   Implementuje interfejs *SeekableIterator* dla łatwej iteracji (np., używając *foreach*), tak samo jak i dla
   bezpośredniego dostępu do specyficznego wyniku używając metody *seek()*.

.. _zend.service.flickr.classes.resultset.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.flickr.classes.resultset.properties.table-1:

.. table:: Właściwości Zend_Service_Flickr_ResultSet

   +---------------------+---+-------------------------------------------------------+
   |Nazwa                |Typ|Opis                                                   |
   +=====================+===+=======================================================+
   |totalResultsAvailable|int|Całkowita ilość dostępnych wyników wyszukiwania        |
   +---------------------+---+-------------------------------------------------------+
   |totalResultsReturned |int|Całkowita ilość zwróconych wyników wyszukiwania        |
   +---------------------+---+-------------------------------------------------------+
   |firstResultPosition  |int|Pozycja obecnego zestawu wyników we wszystkich wynikach|
   +---------------------+---+-------------------------------------------------------+

.. _zend.service.flickr.classes.resultset.totalResults:

Zend_Service_Flickr_ResultSet::totalResults()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

int:``totalResults()``


Zwraca całkowitą ilość wyników w tym zestawie wyników wyszukiwania.

:ref:`Powrót do listy klas <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.result:

Zend_Service_Flickr_Result
^^^^^^^^^^^^^^^^^^^^^^^^^^

Pojedynczy wynik wyszukiwania zdjęcia w serwisie Flickr

.. _zend.service.flickr.classes.result.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.flickr.classes.result.properties.table-1:

.. table:: Właściwości Zend_Service_Flickr_Result

   +----------+-------------------------+------------------------------------------------------------------------------+
   |Nazwa     |Typ                      |Opis                                                                          |
   +==========+=========================+==============================================================================+
   |id        |string                   |ID zdjęcia                                                                    |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |owner     |string                   |Identyfikator NSID właściciela zdjęcia.                                       |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |secret    |string                   |Klucz używany w konstrukcji URL.                                              |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |server    |string                   |Nazwa serwera używana w konstrukcji URL.                                      |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |title     |string                   |Tytuł zdjęcia.                                                                |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |ispublic  |string                   |Czy zdjęcie jest publiczne.                                                   |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |isfriend  |string                   |Czy zdjęcie jest dla Ciebie widoczne ponieważ jesteś przyjacielem właściciela.|
   +----------+-------------------------+------------------------------------------------------------------------------+
   |isfamily  |string                   |Czy zdjęcie jest dla Ciebie widoczne ponieważ jesteś rodziną właściciela.     |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |license   |string                   |Licencja pod jaką dostępne jest zdjęcie.                                      |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |dateupload|string                   |Data wgrania zdjęcia.                                                         |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |datetaken |string                   |Data zrobienia zdjęcia.                                                       |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |ownername |string                   |Wyświetlana nazwa użytkownika.                                                |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |iconserver|string                   |Serwer używany przy dołączaniu adresów URL ikon.                              |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |Square    |Zend_Service_Flickr_Image|Miniaturka zdjęcia o wielkości 75x75.                                         |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |Thumbnail |Zend_Service_Flickr_Image|Miniaturka zdjęcia o wielkości 100 pikseli.                                   |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |Small     |Zend_Service_Flickr_Image|Wersja zdjęcia o wielkości 240 pikseli.                                       |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |Medium    |Zend_Service_Flickr_Image|Wersja zdjęcia o wielkości 500 pikseli.                                       |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |Large     |Zend_Service_Flickr_Image|Wersja zdjęcia o wielkości 640 pikseli.                                       |
   +----------+-------------------------+------------------------------------------------------------------------------+
   |Original  |Zend_Service_Flickr_Image|Oryginalne zdjęcie.                                                           |
   +----------+-------------------------+------------------------------------------------------------------------------+

:ref:`Powrót do listy klas <zend.service.flickr.classes>`

.. _zend.service.flickr.classes.image:

Zend_Service_Flickr_Image
^^^^^^^^^^^^^^^^^^^^^^^^^

Reprezentuje zdjęcie zwrócone przez wyszukiwanie Flickr.

.. _zend.service.flickr.classes.image.properties:

Właściwości
^^^^^^^^^^^

.. _zend.service.flickr.classes.image.properties.table-1:

.. table:: Właściwości Zend_Service_Flickr_Image

   +--------+------+--------------------------------------------------+
   |Nazwa   |Typ   |Opis                                              |
   +========+======+==================================================+
   |uri     |string|Adres URI oryginalnego zdjęcia                    |
   +--------+------+--------------------------------------------------+
   |clickUri|string|Klikalny adres URI (np. strony Flickr) dla zdjęcia|
   +--------+------+--------------------------------------------------+
   |width   |int   |Szerokość zdjęcia                                 |
   +--------+------+--------------------------------------------------+
   |height  |int   |Wysokość zdjęcia                                  |
   +--------+------+--------------------------------------------------+

:ref:`Powrót do listy klas <zend.service.flickr.classes>`



.. _`dokumentację Flickr API`: http://www.flickr.com/services/api/
