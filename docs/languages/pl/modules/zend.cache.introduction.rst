.. EN-Revision: none
.. _zend.cache.introduction:

Wprowadzenie
============

``Zend_Cache`` zapewnia ogólny sposób buforowania danych.

Buforowanie w Zend Framework jest przeprowadzane przez frontendy, a rekordy bufora są przechowywane za pomocą
backendów (**File**, **Sqlite**, **Memcache**...) przy użyciu uniwersalnego systemu identyfikatorów ID oraz
etykiet. Używając ich, łatwe jest kasowanie specyficznych typów rekordów (na przykład: "usuń wszystkie
rekordy bufora oznaczone podaną etykietą").

Jądro modułu (``Zend_Cache_Core``) jest proste, uniwersalne i konfigurowalne. Obecnie, dla twoich specyficznych
potrzeb dostępne są frontendy rozszerzające ``Zend_Cache_Core`` na przykład: **Output**, **File**, **Function**
oraz **Class**.

.. _zend.cache.introduction.example-1:

.. rubric:: Pobieranie frontendu za pomocą Zend_Cache::factory()

``Zend_Cache::factory()`` tworzy instancję odpowiedniego obiektu łączy je razem. W tym pierwszym przykładzie
użyjemy frontendu **Core** wraz z backendem **File**.

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 7200, // okres ważności bufora 2 godziny
      'automatic_serialization' => true
   );

   $backendOptions = array(
       'cache_dir' => './tmp/' // Katalog w którym mają być składowane pliku bufora
   );

   // pobieranie obiektu Zend_Cache_Core
   $cache = Zend_Cache::factory('Core',
                                'File',
                                $frontendOptions,
                                $backendOptions);

.. note::

   **Frontendy i backendy składające się z wielu słów**

   Niektóre frontendy i backendy są nazwane przy użyciu wielu słów, na przykład 'ZendPlatform'. Gdy
   określamy ich nazwę w metodzie fabryki, oddzielamy wyrazy używając separatora wyrazów takiego jak spacja ('
   '), myślnik ('-') lub kropka ('.').

.. _zend.cache.introduction.example-2:

.. rubric:: Buforowanie wyniku zapytania do bazy danych

Teraz gdy mamy frontend, możemy buforować dowolny typ danych (włączyliśmy serializację). Na przykład,
możemy buforować wynik bardzo obciążającego zapytania do bazy danych. Kiedy jest buforowane, nie ma nawet
potrzeby aby łączyć się z bazą; rekordy są pobierane z bufora, a następnie odserializowane.

.. code-block:: php
   :linenos:

   // obiekt $cache zainicjalizowany jak w poprzednim przykładzie

   // sprawdzamy czy bufor istnieje:
   if(!$result = $cache->load('myresult')) {

       // bufor nie istnieje; łączymy się z bazą

       $db = Zend_Db::factory( [...] );

       $result = $db->fetchAll('SELECT * FROM huge_table');

       $cache->save($result, 'myresult');

   } else {

       // bufor istnieje! dajmy o tym znać
       echo "To pochodzi z bufora!\n\n";

   }

   print_r($result);

.. _zend.cache.introduction.example-3:

.. rubric:: Buforowanie danych wyjściowych przy użyciu frontendu ``Zend_Cache``

Sekcje w których chcemy buforować dane wyjściowe oznaczamy dodając pewną warunkową logikę, ograniczającą
sekcję za pomocą metod ``start()`` oraz ``end()`` (to odpowiada pierwszemu przykładowi i jest główną
strategią buforowania).

Wewnątrz wyświetlaj dane jak zawsze - wszystkie dane wyjściowe będą buforowane aż do napotkania metody
``end()``. Podczas następnego wywołania, cała sekcja będzie ominięta, a użyte zostaną dane z bufora. (tak
długo jak rekord bufora jest prawidłowy).

.. code-block:: php
   :linenos:

   $frontendOptions = array(
      'lifetime' => 30,                   // okres ważności bufora 30 sekund
      'automatic_serialization' => false  // to i tak jest domyślna wartość
   );

   $backendOptions = array('cache_dir' => './tmp/');

   $cache = Zend_Cache::factory('Output',
                                'File',
                                $frontendOptions,
                                $backendOptions);

   // przekazujemy unikalny identyfikator do metody start()
   if(!$cache->start('mypage')) {
       // wyświetlamy jak zawsze:

       echo 'Witajcie! ';
       echo 'To jest buforowane ('.time().') ';

       $cache->end(); // dane wyjściowe są zapisywane i wysyłane do przeglądarki
   }

   echo 'To nie jest nigdy buforowane ('.time().').';

Zauważ, że wyświetlamy rezultat funkcji ``time()`` dwa razy; jest to coś dynamicznego, aby zademenstrować
przeznaczenie. Spróbuj uruchomić to i odświeżyć kilka razy; zauważysz, że pierwsza liczba się nie zmienia,
a druga za każdym razem jest inna. Tak jest ponieważ pierwsza liczba była wyświetlona w sekcji buforowanej
więc została zapisana. Po upływie pół minuty (ustawiliśmy okres ważności bufora na 30 sekund) powinny
ponownie się zgadzać ponieważ bufor wygasł -- i został zapisany ponownie. Powinieneś to sprawdzić w swojej
przeglądarce lub w konsoli.

.. note::

   Kiedy używasz Zend_Cache, zwracaj uwagę na ważny identyfikator bufora (przekazany do metod ``save()`` oraz
   ``start()``). Musi być unikalny dla każdego zasobu, który buforujesz, inaczej nie powiązane buforowane
   rekordy mogą się nawzajem ścierać, lub gorzej, jeden może wyświetlić się w miejscu drugiego.


