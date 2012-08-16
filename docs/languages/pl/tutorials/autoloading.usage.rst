.. EN-Revision: none
.. _learning.autoloading.usage:

Podstawowe użycie autoloadera
=============================

Po krótkim opisie samej idei autoloadera jak i konwencji oraz celi związanych z jego implementacją w Zend
Framework można przejść do opisu użycia ``Zend_Loader_Autoloader``.

W najprostszym przypadku należy dołączyć plik z definicją klasy i uzyskać dostęp do obiektu.
``Zend_Loader_Autoloader`` jest singletonem (co jest uwarunkowane autoloaderem *SPL*, który jest pojedynczym
zasobem) więc do uzyskania jego instancji należy użyć metody ``getInstance()``.

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   Zend_Loader_Autoloader::getInstance();

Domyślnie spowoduje to automatyczne dołączanie dowolnych klas zawierających prefiks przestrzeni nazw "Zend\_"
oraz "ZendX\_" pod warunkiem, że znajdują się w katalogu zawartym w ``include_path``.

Co się dzieje w przypadku gdy wymagane jest użycie innych przestrzeni nazw? Najlepszym i najłatwiejszym sposobem
jest wywołanie metody ``registerNamespace()``. Można do niej przekazać pojedynczy prefiks przestrzeni nazw lub
ich całą tablicę:

.. code-block:: php
   :linenos:

   require_once 'Zend/Loader/Autoloader.php';
   $loader = Zend_Loader_Autoloader::getInstance();
   $loader->registerNamespace('Foo_');
   $loader->registerNamespace(array('Foo_', 'Bar_'));

Alternatywnie można skonfigurować ``Zend_Loader_Autoloader`` aby działał jako autoloader awaryjny ("fallback"
autoloader). To oznacza, że będzie próbował działać dla każdej używanej klasy niezależnie od jej prefiksu
przestrzeni nazw.

.. code-block:: php
   :linenos:

   $loader->setFallbackAutoloader(true);

.. warning::

   **Nie należy używać autoloadera awaryjnego**

   Użycie ``Zend_Loader_Autoloader`` jako autoloadera awaryjnego może być kuszące ale nie jest rekomendowane.

   Wewnętrznie ``Zend_Loader_Autoloader`` używa ``Zend_Loader::loadClass()`` do dołączania definicji klas. Ta
   metoda używa ``include()`` do załadowania danego pliku z klasą. Funkcja ``include()`` zwraca wartość
   ``FALSE`` w przypadku niepowodzenia a dodatkowo wysyła błąd ostrzeżenia *PHP* co może prowadzić do
   następujących konsekwencji:

   - Jeśli włączona jest opcja ``display_errors`` to ostrzeżenie zostanie dołączone do wyniku działania
     funkcji.

   - W zależności od wybranego poziomu opcji ``error_reporting`` może powodować bałagan w logach.

   Istnieje możliwość wyłączenia wyświetlania komunikatów błędów przez autoloader (opisana w dokumentacji
   ``Zend_Loader_Autoloader``) ale należy pamiętać iż działa to tylko w przypadku włączenia opcji
   ``display_errors``. Plik z logami błędów i tak będzie przechowywał wszystkie komunikaty. Z tego powodu
   zalecane jest używanie prefiksów przestrzeni nazw i powiadomienie o nich autoloadera.

.. note::

   **Prefiksy przestrzeni nazw a przestrzenie nazw PHP**

   W momencie powstawania tego dokumentu istnieje stabilna wersja *PHP* 5.3. Od tego wydania *PHP* oficjalnie
   oferuje pełne wsparcie dla przestrzeni nazw.

   Zend Framework uprzedził *PHP* 5.3 pod tym względem. Wewnątrz dokumentacji Zend Framework, jeśli jest mowa o
   "przestrzeniach nazw" to odnosi się to do prefiksów klas wskazujących na aplikację, twórcę lub firmę. Dla
   przykładu, wszystkie nazwy klas w Zend Framework mają prefiks "Zend\_" - to jest "przestrzeń nazw" używana
   przez firmę Zend.

   Planowane jest wprowadzenie obsługi natywnych przestrzeni nazw *PHP* do autoloadera w przyszłych wersjach Zend
   Framework. Będzie to możliwe od wersji 2.0.0.

Jeśli deweloper posiada własny autoloader (np. pochodzący z innej biblioteki, która jest używana równolegle),
który powinien zostać użyty z Zend Framework to można to uczynić za pomocą metod klasy
``Zend_Loader_Autoloader`` o nazwach ``pushAutoloader()`` oraz ``unshiftAutoloader()``. Powyższe metody dopiszą
podane funkcje do listy autoloaderów (która jest uruchamiana przed wewnętrznymi mechanizmami Zend Framework)
odpowiednio na koniec bądź na początek. Takie podejście oferuje następujące korzyści:

- Każda z tych metod przyjmuje drugi, opcjonalny argument - prefiks przestrzeni nazw. Można go użyć do
  wskazania aby podany autoloader był używany jedynie do dołączania klas zawierających podany prefiks. Jeśli
  dana klasa go nie posiada to autoloader nie zostanie uruchomiony - takie podejście może znacznie zwiększyć
  wydajność.

- Jeśli zajdzie potrzeba manipulowania rejestrem funkcji ``spl_autoload()``, każdy autoloader, który stanowi
  odwołanie do metody klasy może powodować problemy. Dzieje się tak ponieważ funkcja
  ``spl_autoload_functions()`` nie zwraca tych samych instancji obiektów (tylko ich kopie).
  ``Zend_Loader_Autoloader`` nie posiada takich wad.

W powyższy sposób można użyć każdego poprawnego odwołania do funkcji *PHP*

.. code-block:: php
   :linenos:

   // Dołączenie funkcji 'my_autoloader', która zajmuje się klasami
   // z prefiksem 'My_' na koniec listy autoloaderów
   $loader->pushAutoloader('my_autoloader', 'My_');

   // Dołączenie statycznej metody Foo_Loader::autoload(), która zajmuje
   // się klasami z prefiksem 'Foo_' na początek listy autoloaderów
   $loader->unshiftAutoloader(array('Foo_Loader', 'autoload'), 'Foo_');


