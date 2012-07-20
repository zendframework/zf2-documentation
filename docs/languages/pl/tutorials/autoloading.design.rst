.. _learning.autoloading.design:

Cele i budowa
=============

.. _learning.autoloading.design.naming:

Konwencja nazewnictwa klas
--------------------------

Aby zrozumieć autoloader w Zend Framework, należy najpierw zrozumieć połączenie pomiędzy nazwami klas a ich
plikami.

Budując Zend Framework zapożyczono ideę organizacji klas z biblioteki `PEAR`_. Według niej relacja klas do
plików wynosi 1:1. W skrócie: aby odnaleźć ścieżkę do odpowiedniego pliku znak podkreślenia ("\_") w
nazwach klas jest zastępowany znakiem oddzielenia katalogu a następnie dodawane jest rozszerzenie "``.php``".
Przykładowo, klasa "``Foo_Bar_Baz``" odpowiadałaby ścieżce dostępu "``Foo/Bar/Baz.php``". Dodatkowo
respektowane są ustawienia zmiennej konfiguracyjnej *PHP*-``include_path``, dzięki czemu możliwe jest użycie
``include()`` oraz ``require()`` i wyszukanie pliku wg. ścieżki względnej do katalogów w ``include_path``.

Dodatkowo, podobnie jak *PEAR* oraz `projekt PHP`_ praktykowane i zalecane jest użycie w kodzie prefiksów
charakterystycznych dla projektu lub producenta. To oznacza, że wszystkie klasy powinny dzielić jeden wspólny
prefiks. Przykładowo, wszystkie klasy w Zend Framework mają prefiks "Zend\_". Taka konwencja chroni przed
kolizjami nazw. W ramach Zend Framework przybiera to nazwę prefiksu przestrzeni nazw. Należy zachować
ostrożność aby nie pomylić tego z natywną obsługą przestrzeni nazw w *PHP*.

Zend Framework podąża za tymi wskazówkami wewnętrznie ale nasze standardy zachęcają do ich stosowania także
w kodzie aplikacji, innych bibliotek itp.

.. _learning.autoloading.design.autoloader:

Konwencja nazewnictwa i budowa autoloadera
------------------------------------------

Obsługa autoloadera w Zend Framework udostępniona głównie poprzez ``Zend_Loader_Autoloader`` charakteryzuje
się poniższymi celami i elementami budowy:

- **Zapewnia przeszukiwanie przestrzeni nazw**. Jeśli prefiks przestrzeni nazw klasy nie znajduje się na liście
  zarejestrowanych przestrzeni - od razu zwracana jest wartość ``FALSE``. Dzięki temu może nastąpić szybsze
  przełączenie do ewentualnego kolejnego

- **Umożliwienie działania autoloadera jako ostatniej instancji**. W przypadku, gdy zespół programistów jest w
  dużym stopniu rozproszony lub lista respektowanych prefiksów przestrzeni nazw jest zmienna, autoloader powinien
  zachować swoją funkcjonalność w taki sposób, żeby możliwe było użycie każdego prefiksu przestrzeni
  nazw. Trzeba zwrócić uwagę na fakt, iż takie zachowanie nie jest zalecane i może prowadzić do
  niepotrzebnego wydłużenia procesu wyszukania pliku.

- **Umożliwienie włączaniania i wyłączania raportowania błędów**. Twórcy ZF - jak i większa część
  społeczności *PHP*- uważają, że zapobieganie raportowaniu błędów jest złym pomysłem. Jest kosztowne i
  powoduje ukrycie realnych problemów aplikacji. Domyślnie opcja ta powinna być wyłączona ale jeśli deweloper
  **chce** ją włączyć to jest to umożliwione.

- **Umożliwienie skonfigurowania własnych funkcji oferujących funkcjonalność autoloadera**. Część
  deweloperów nie będzie chciała używać ``Zend_Loader::loadClass()`` jednocześnie nie rezygnując z
  mechanizmów Zend Framework. Klasa ``Zend_Loader_Autoloader`` umożliwia wyszczególnienie alternatywnej funkcji
  oferującej taką samą funkcjonalność.

- **Umożliwienie manipulacji łańcuchem funkcji autoload w SPL**. Celem tego założenia jest pozwolenie na
  określenie przez dewelopera dodatkowych funkcji oferujących funkcjonalność autoloadera - np. dla funkcje
  ładujące zasoby dla klas, które nie mają relacji 1:1 z plikami - aby były zarejestrowane przed lub po
  domyślnym mechanizmie autoloadera Zend Framework.



.. _`PEAR`: http://pear.php.net/
.. _`projekt PHP`: http://php.net/userlandnaming.tips
