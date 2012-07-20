.. _zend.config.theory_of_operation:

Zasady działania
================

Dane konfiguracyjne są przekazywane do konstruktora *Zend_Config* w postaci asocjacyjnej tablicy, która może
być wielowymiarowa, po to, aby obsłużyć dane zorganizowane w różny sposób, od prostych po specyficzne.
Konkretny adapter posiada funkcjonalność przystosowującą przechowywane dane konfiguracyjne do wygenerowania
tablicy asocjacyjnej dla konstruktora *Zend_Config*. Skrypt użytkownika może przekazać taką tablicę
bezpośrednio do konstruktora *Zend_Config*, nie używając klasy adaptera, since it may be appropriate to do so in
certain situations.

Each configuration data array value becomes a property of the *Zend_Config* object. The key is used as the property
name. If a value is itself an array, then the resulting object property is created as a new *Zend_Config* object,
loaded with the array data. This occurs recursively, such that a hierarchy of configuration data may be created
with any number of levels.

Klasa *Zend_Config* implementuje interfejsy *Countable* oraz *Iterator* w celu zapewnienia łatwego dostępu do
danych konfiguracyjnych. Dzięki temu można użyć funkcji `count()`_ oraz składni PHP takiej jak `foreach`_ na
obiektach *Zend_Config*.

Domyślnie dane konfiguracyjne dostępne poprzez *Zend_Config* są tylko do odczytu, i próba przypisania (np.,
*$config->database->host = 'example.com'*) spowoduje wyrzucenie wyjątku. Te domyślne zachowanie może być
zmienione poprzez konstruktor, aby pozwolić na modyfikację wartości danych konfiguracyjnych. Dodatkowo, jeśli
modyfikacje są dozwolone, klasa *Zend_Config* obsługuje usuwanie wartości danych konfiguracyjnych (np.
*unset($config->database->host);*).

   .. note::

      Jest ważne, aby nie mylić modyfikacji danych konfiguracyjnych w pamięci z zapisywaniem danych
      konfiguracyjnych do konkretnych środków przechowywania. Narzędzia do tworzenia i modyfikowania danych
      konfiguracyjnych dla rożnych środków przechowywania są poza zakresem klasy *Zend_Config*. Są dostępne
      zewnętrzne rozwiązania open source służące do tworzenia oraz modyfikowania danych konfiguracyjnych dla
      różnych środków przechowywania.



Klasy adapterów dziedziczą z klasy *Zend_Config* więc wykorzystują ich funkconalność.

Rodzina klas *Zend_Config* pozwala na zorganizowanie danych konfiguracyjnych w sekcje. Obiekty adapterów
*Zend_Config* mogą załadować jedną określoną sekcję, wiele określonych sekcji lub wszystkie sekcje (gdy
żadna nie jest określona).

Klasy adapterów *Zend_Config* wspierają model pojedynczego dziedziczenia, w którym jedna sekcja danych
konfiguracyjnych może dziedziczyć z innej sekcji. Jest to zapewnione w celu zredukowania lub wyeliminowania
potrzeby duplikowania danych konfiguracyjnych z różnych powodów. Sekcja dziedzicząca może nadpisać wartości,
które dziedziczy z sekcji rodzica. Tak jak w dziedziczeniu klas PHP, sekcja może dziedziczyć z sekcji rodzica,
która może dziedziczyć z innej sekcji rodzica i tak dalej, ale wielokrotne dziedziczenie (np., sekcja C
dziedzicząca bezpośrednio z sekcji A oraz B) nie jest obsługiwane.

Jeśli masz dwa obiekty *Zend_Config*, możesz je połączyć w jeden pojedynczy obiekt używając metody
*merge()*. Na przykład, mając obiekt $config oraz $localConfig, możesz dołączyć obiekt $localConfig do
$config używając metody *$config->merge($localConfig);*. Dane z obiektu $localConfig nadpiszą dane o tej samej
nazwie znajdujące się w obiekcie $config.



.. _`count()`: http://php.net/count
.. _`foreach`: http://php.net/foreach
