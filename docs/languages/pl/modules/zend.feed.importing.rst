.. _zend.feed.importing:

Importowanie kanałów informacyjnych
===================================

*Zend_Feed* pozwala programistom bardzo łatwo odbierać wiadomości z kanałów informacyjnych. Jeśli znasz adres
URI kanału, w prosty sposób użyj metody *Zend_Feed::import()*:

.. code-block::
   :linenos:

   $feed = Zend_Feed::import('http://feeds.example.com/feedName');


Możesz także użyć *Zend_Feed* do pobrania zawartości kanału z pliku lub z łańcucha znaków PHP:

.. code-block::
   :linenos:

   // importowanie kanału z pliku tekstowego
   $feedFromFile = Zend_Feed::importFile('feed.xml');

   // importowanie kanału z łańcucha znaków PHP
   $feedFromPHP = Zend_Feed::importString($feedString);


We wszystkich powyższych przykładach w razie powodzenia operacji zwracany jest obiekt klasy rozszerzającej
*Zend_Feed_Abstract*, zależenie od typu kanału. Jeśli zostały odebrane dane RSS za pomocą jednej z powyższych
metod importu, wtedy będzie zwrócony obiekt *Zend_Feed_Rss*. Z drugiej strony, gdy będą importowane dane
kanału Atom, zwrócony zostanie obiekt *Zend_Feed_Atom*. Metody importu w razie niepowodzenia wyrzucają wyjątek
*Zend_Feed_Exception*, czyli na przykład wtedy gdy nie jest możliwe odczytanie kanału lub gdy dane są błędne.

.. _zend.feed.importing.custom:

Własne kanały
-------------

*Zend_Feed* pozwala programistom na bardzo łatwe tworzenie własnych kanałów. Musisz jedynie utworzyć tablicę
i zaimportować ją za pomocą Zend_Feed. Ta tablica może być zaimportowana za pomocą metody
*Zend_Feed::importArray()* lub *Zend_Feed::importBuilder()*. W tym drugim przypadku tablica zostanie utworzona w
locie, przez własne źródło danych implementujące interfejs *Zend_Feed_Builder_Interface*.

.. _zend.feed.importing.custom.importarray:

Importowanie własnej tablicy
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block::
   :linenos:

   // importowanie kanału z tablicy
   $atomFeedFromArray = Zend_Feed::importArray($array);

   // poniższy kod odpowiada kodowi powyżej;
   // domyślnie zwracana jest instancja Zend_Feed_Atom
   $atomFeedFromArray = Zend_Feed::importArray($array, 'atom');

   // importowanie kanału rss z tablicy
   $rssFeedFromArray = Zend_Feed::importArray($array, 'rss');


Format tablicy musi zgadzać się z taką strukturą:

.. code-block::
   :linenos:

   array(
         'title'       => 'tytuł kanału', //wymagane
         'link'        => 'adres url kanału', //wymagane
         'lastUpdate'  => 'data aktualizacji w postaci uniksowego znacznika czasu', // opcjonalne
         'published'   => 'data publikacji w postaci uniksowego znacznika czasu', //opcjonalne
         'charset'     => 'zestaw znaków dla danych tekstowych', // wymagane
         'description' => 'krótki opis kanału', //opcjonalne
         'author'      => 'autor kanału', //opcjonalne
         'email'       => 'adres email autora', //opcjonalne
         'webmaster'   =>     // opcjonalne, ignorowane jeśli używany jest atom
                          'adres osoby odpowiedzialnej' .
                          'za sprawy techniczne'
         'copyright'   => 'informacje o prawach autorskich', //opcjonalne
         'image'       => 'adres obrazka', //opcjonalne
         'generator'   => 'generator', // opcjonalne
         'language'    => 'język w jakim publikowany jest kanał', // opcjonalne
         'ttl'         =>     // opcjonalne, ignorowane jeśli używany jest atom
                          'na jak długo, w minutach, kanał może' .
                          'być buforowany przed odświeżeniem',
         'rating'      =>     // opcjonalne, ignorowane jeśli używany jest atom
                          'Ocena PICS dla kanału.',
         'cloud'       => array(
                                'domain'            => 'domena usługi cloud, np. rpc.sys.com' // wymagane
                                'port'              => 'port usługi to' // opcjonalne, domyślnie wartość 80
                                'path'              => 'ścieżka usługi cloud, np. /RPC2' //wymagane
                                'registerProcedure' => 'procedura do wywołania, np. myCloud.rssPleaseNotify' // wymagane
                                'protocol'          => 'protokół do użycia, np. soap lub xml-rpc' // wymagane
                                ), // dane usługi cloud umożliwiającej powiadamianie użytkowników o zmianach // opcjonalne, ignorowane jeśli używany jest atom
         'textInput'   => array(
                                'title'       => 'etykieta przycisku wysyłającego treść pola tekstowego' // wymagane,
                                'description' => 'wyjaśnienie przeznaczenia pola tekstowego' // wymagane
                                'name'        => 'nazwa obiektu pola tekstowego' // wymagane
                                'link'        => 'adres URL skryptu CGI który przetwarza wysłaną treść' // wymagane
                                ) // pole tekstowe które może być wyświetlone wraz z kanałem // opcjonalne, ignorowane jeśli używany jest atom
         'skipHours'   => array(
                                'godzina do pominięcia w formacie 24 godzinnym', // np. 13 (1pm)
                                // do 24 wierszy których wartościami mogą być numery między 0 a 23
                                ) // Wskazówka mówiąca agregatorom które godziny mogą pominąć // opcjonalne, ignorowane jeśli używany jest atom
         'skipDays '   => array(
                                'dzień do pominięcia', // np. Monday
                                // do 7 wierszy, których wartościami mogą być Monday, Tuesday, Wednesday, Thursday, Friday, Saturday lub Sunday
                                ) // Wskazówka mówiąca agregatorom które dni mogą pominąć // opcjonalne, ignorowane jeśli używany jest atom
         'itunes'      => array(
                                'author'       => 'nazwa artysty' // opcjonalne, domyślnie wartość z pola author
                                'owner'        => array(
                                                        'name' => 'nazwa właściciela' // opcjonalne, domyślnie wartość z głównego pola author
                                                        'email' => 'adres email właściciela' // opcjonalne, domyślnie wartość z głównego pola email
                                                        ) // właściciel podcasta // opcjonalne
                                'image'        => 'obrazek albumu/podcasta' // opcjonalne, domyślnie wartość z głownego pola image
                                'subtitle'     => 'krótki opis' // opcjonalne, domyślnie wartość z głownego pola description
                                'summary'      => 'dłuższy opis' // opcjonalne, domyślnie wartość z głownego pola description
                                'block'        => 'zapobiega przed pojawieniem się epizodu (yes|no)' // opcjonalne
                                'category'     => array(
                                                        array('main' => 'głowna kategoria', // wymagane
                                                              'sub'  => 'podkategoria' // opcjonalne
                                                              ),
                                                        // do 3 wierszy
                                                        ) // 'Dane kategorii w iTunes Music Store Browse' // wymagane
                                'explicit'     => 'znaczek kontroli rodzicielskiej (yes|no|clean)' // opcjonalne
                                'keywords'     => 'lista maksymalnie 12 słów kluczowych oddzielonych przecinkami' // opcjonalne
                                'new-feed-url' => 'używane aby poinformować iTunes o nowym adresie URL kanału' // opcjonalne
                                ) // Dane rozszerzenia Itunes // opcjonalne, ignorowane jeśli używany jest atom
         'entries'     => array(
                                array(
                                      'title'        => 'tytuł wpisu z kanału', //wymagane
                                      'link'         => 'adres do wpisu z kanału', //wymagane
                                      'description'  => 'krótka wersja wpisu z kanału', // jedynie tekst, bez html, wymagane
                                      'guid'         => 'identyfikator artykułu, jeśli nie podany, zostanie użyta wartość z pola link', //opcjonalne
                                      'content'      => 'długa wersja', // może zawierać html, opcjonalne
                                      'lastUpdate'   => 'data publikacji w postaci uniksowego znacznika czasu', // opcjonalne
                                      'comments'     => 'strona komentarzy powiązanych z wpisem w kanale', // opcjonalne
                                      'commentRss'   => 'adres kanału z powiązanymi komentarzami', // opcjonalne
                                      'source'       => array(
                                                              'title' => 'tytuł oryginalnego źródła' // wymagane,
                                                              'url' => 'adres oryginalnego źródła' // wymagane
                                                              ) // oryginalne źródło wpisu z kanału // opcjonalne
                                      'category'     => array(
                                                              array(
                                                                    'term' => 'etykieta pierwszej kategorii' // wymagane,
                                                                    'scheme' => 'adres identyfikujący schemat kategoryzowania' // opcjonalne
                                                                    ),
                                                              array(
                                                                    // dane dla kolejnej kategorii itd.
                                                                    )
                                                              ) // lista powiązanych kategorii // opcjonalne
                                      'enclosure'    => array(
                                                              array(
                                                                    'url' => 'adres powiązanego załącznika' // wymagane
                                                                    'type' => 'typ mime załącznika' // opcjonalne
                                                                    'length' => 'długość załącznika w bajtach' // opcjonalne
                                                                    ),
                                                              array(
                                                                    // dane drugiego załącznika itd.
                                                                    )
                                                              ) // lista załączników dla wpisu kanału // opcjonalne
                                      ),
                                array(
                                      // dane dla drugiego wpisu itd.
                                      )
                                )
          );


Odnośniki:

   - Specyfikacja RSS 2.0: `RSS 2.0`_

   - Specyfikacja Atom: `RFC 4287`_

   - Specyfikacja WFW: `Well Formed Web`_

   - Specyfikacja iTunes: `Specyfikacja Techniczna iTunes`_



.. _zend.feed.importing.custom.importbuilder:

Importowanie własnego źródła danych
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Możesz utworzyć instancję Zend_Feed z dowolnego źródła danych implementując interfejs
*Zend_Feed_Builder_Interface*. Aby użyć swojego obiektu za pomocą metody *Zend_Feed::importBuilder()* musisz po
prostu zaimplementować metody *getHeader()* oraz *getEntries()*. Jako przykład implementacji możesz użyć klasy
*Zend_Feed_Builder*, która przyjmuje tablicę jako argument konstruktora, przeprowadza pewną weryfikację, a
następnie może być użyta za pomocą metody *importBuilder()*. Metoda *getHeader()* musi zwracać instancję
klasy *Zend_Feed_Builder_Header*, a metoda *getEntries()* musi zwracać tablicę instancji klasy
*Zend_Feed_Builder_Entry*.

.. note::

   *Zend_Feed_Builder* jest konkretną implementacją pokazującą sposób użycia. Namawiamy użytkownika do
   napisania własnej klasy, implementującej interfejs *Zend_Feed_Builder_Interface*.

Oto przykład użycia metody *Zend_Feed::importBuilder()*:

.. code-block::
   :linenos:

   // importowanie kanału z własnego źródła
   $atomFeedFromArray =
       Zend_Feed::importBuilder(new Zend_Feed_Builder($array));

   // poniższy kod odpowiada kodowi powyżej;
   // domyślnie zwracana jest instancja Zend_Feed_Atom
   $atomFeedFromArray =
       Zend_Feed::importArray(new Zend_Feed_Builder($array), 'atom');

   // importowanie kanału rss z własnego źródła
   $rssFeedFromArray =
       Zend_Feed::importArray(new Zend_Feed_Builder($array), 'rss');


.. _zend.feed.importing.custom.dump:

Zrzucanie zawartości kanału
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Aby zrzucić zawartość instancji *Zend_Feed_Abstract*, możesz użyć metody *send()* lub *saveXml()*.

.. code-block::
   :linenos:


   assert($feed instanceof Zend_Feed_Abstract);

   // zrzuca kanał do standardowego wyjścia
   print $feed->saveXML();

   // wysyła nagłówki oraz zrzuca zawartość kanału
   $feed->send();




.. _`RSS 2.0`: http://blogs.law.harvard.edu/tech/rss
.. _`RFC 4287`: http://tools.ietf.org/html/rfc4287
.. _`Well Formed Web`: http://wellformedweb.org/news/wfw_namespace_elements
.. _`Specyfikacja Techniczna iTunes`: http://www.apple.com/itunes/store/podcaststechspecs.html
