.. _zend.feed.introduction:

Wprowadzenie
============

*Zend_Feed* zapewnia funkcjonalność umożliwiającą przetwarzanie kanałów informacyjnych RSS oraz Atom.
Zapewnia ona naturalną składnię umożliwiającą dostęp do elementów kanałów informacyjnych, ich atrybutów
oraz atrybutów samych wpisów. *Zend_Feed* daje także obszerne wsparcie w modyfikowaniu kanałów i struktury
wpisów w ten sam naturalny sposób i umożliwia zapisanie rezultatów jako XML. W przyszłości klasa ma zapewnić
obsługę protokołu publikowania Atom (Atom Publishing Protocol).

Programowo *Zend_Feed* składa się z bazowej klasy *Zend_Feed*, abstrakcyjnych klas *Zend_Feed_Abstract* oraz
*Zend_Feed_Entry_Abstract* reprezentujących kanały informacyjne i ich wpisy, specyficznych implementacji
kanałów i wpisów dla RSS i Atom, oraz z pomocników odpowiedzialnych za naturalną składnię.

W przykładzie poniżej pokazujemy prosty przykład odbierania danych RSS i zapisywania potrzebnych części danych
kanału do prostej tablicy PHP, która może być potem użyta do wyświetlenia danych, zapisania ich do bazy
danych itp.

.. note::

   **Bądż ostrożny**

   Wiele kanałów RSS ma dostępne różne właściwości samego kanału i jego elementów. Specyfikacja RSS
   umożliwia użycie wielu opcjonalnych parametrów, więc bądź ostrożny gdy będziesz pisał kod pracujący z
   RSS.

.. _zend.feed.introduction.example.rss:

.. rubric:: Użycie Zend_Feed do pobierania danych RSS

.. code-block::
   :linenos:

   // Ściągamy najnowsze nagłówki ze Slashdot
   try {
       $slashdotRss =
           Zend_Feed::import('http://rss.slashdot.org/Slashdot/slashdot');
   } catch (Zend_Feed_Exception $e) {
       // importowanie danych nie udało się
       echo "Exception caught importing feed: {$e->getMessage()}\n";
       exit;
   }

   // inicjalizacja tablicy z danymi kanału
   $channel = array(
       'title'       => $slashdotRss->title(),
       'link'        => $slashdotRss->link(),
       'description' => $slashdotRss->description(),
       'items'       => array()
       );

   // Pętla po każdym elemencie kanału i zapisanie potrzebnych danych
   foreach ($slashdotRss as $item) {
       $channel['items'][] = array(
           'title'       => $item->title(),
           'link'        => $item->link(),
           'description' => $item->description()
           );
   }



