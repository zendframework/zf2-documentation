.. EN-Revision: none
.. _zend.cache.backends:

Backendy Zend_Cache
===================

.. _zend.cache.backends.file:

Zend_Cache_Backend_File
-----------------------

Ten backend przechowuje rekordy bufora w plikach (w wybranym katalogu).

Dostępne opcje to:

.. _zend.cache.backends.file.table:

.. table:: Opcje backendu File

   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Opcja                     |Typ danych|Domyślna wartość|Opis                                                                                                                                                                                                                                                                                                                                     |
   +==========================+==========+================+=========================================================================================================================================================================================================================================================================================================================================+
   |cache_dir                 |String    |'/tmp/'         |Katalog w którym mają być przechowywane pliki bufora.                                                                                                                                                                                                                                                                                    |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_locking              |Boolean   |TRUE            |Włącza / wyłącza file_locking: Może zapobiec uszkodzeniu bufora, ale nie ma to znaczenia w serwerach wielowątkowych lub systemach NFS.                                                                                                                                                                                                   |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control              |Boolean   |TRUE            |Włącza / wyłącza kontrolę odczytu: jeśli włączona, klucz kontrolny jest załączany w pliku bufora i ten klucz jest porównywany z tym obliczonym podczas odczytywania bufora.                                                                                                                                                              |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |read_control_type         |String    |'crc32'         |Typ kontroli odczytu (tylko jeśli kontrola odczytu jest włączona). Dostępne wartości to: 'md5' (najlepszy, ale najwolniejszy), 'crc32' (odrobinę mniej bezpieczny, ale szybszy, lepszy wybór), 'adler32' (nowy wybór, szybszy niż crc32), 'strlen' tylko dla testu długości (najszybszy).                                                |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashed_directory_level    |Integer   |0               |Poziom haszowanej struktury katalogów: 0 oznacza "brak haszowanej struktury", 1 oznacza "jeden poziom katalogów", 2 oznacza "dwa poziomy"... Ta opcja może przyspieszyć buforowanie tylko wtedy gdy masz tysiące plików bufora. Tylko specyficzne testy pomogą Ci wybrać perfekcyjną wartość. Możliwe, że 1 lub 2 jest dobre na początek.|
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |hashed_directory_umask    |Integer   |0700            |Maska Umask dla haszowanej struktury katalogów.                                                                                                                                                                                                                                                                                          |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |file_name_prefix          |String    |'zend_cache'    |przedrostek dla plików bufora ; bądź naprawdę ostrożny z tą opcją, ponieważ zbyt prosta wartość w katalogu systemowego bufora (jak np. /tmp) może spowodować niechciane działania podczas czyszczenia bufora.                                                                                                                            |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |cache_file_umask          |Integer   |0700            |maska umask dla plików bufora                                                                                                                                                                                                                                                                                                            |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |metatadatas_array_max_size|Integer   |100             |wewnętrzny maksymalny rozmiar tablicy danych meta (nie zmieniaj tej wartości jeśli nie jesteś do końca pewien co robisz)                                                                                                                                                                                                                 |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.sqlite:

Zend_Cache_Backend_Sqlite
-------------------------

Ten backend przechowuje rekordy bufora w bazie SQLite.

Dostępne opcje to:

.. _zend.cache.backends.sqlite.table:

.. table:: Opcje backendu Sqlite

   +---------------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Opcja                            |Typ danych|Domyślna wartość|Opis                                                                                                                                                                                                                                                                                                                                                                                                               |
   +=================================+==========+================+===================================================================================================================================================================================================================================================================================================================================================================================================================+
   |cache_db_complete_path (wymagana)|String    |NULL            |Kompletna ścieżka (wraz z nazwą pliku) bazy danych SQLite                                                                                                                                                                                                                                                                                                                                                          |
   +---------------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |automatic_vacuum_factor          |int       |10              |Włącza / ustawia proces automatycznego czyszczenia Proces automatycznego czyszczenia defragmentuje plik bazy (i zmniejsza jego rozmiar) gdy wywoływane są metody clean() lub delete(): 0 oznacza brak automatycznego czyszczenia ; 1 oznacza systematyczne czyszczenie (gdy wywoływane są metody delete() lub clean()) ; x (integer) > 1 => automatyczne czyszczenie losow 1 raz na x wywołań clean() lub delete().|
   +---------------------------------+----------+----------------+-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.memcached:

Zend_Cache_Backend_Memcached
----------------------------

Ten backend przechowuje rekordy bufora w serwerze memcached. `memcached`_ jest systemem buforowania w pamięci
rozdzielonej o wysokiej wydajności. Aby użyć tego backendu, potrzebujesz działającego serwera memcached oraz
`rozszerzenia PECL memcache`_.

Bądź odstrożny: w tym backendzie nie są obecnie obsługiwane etykiety, tak samo jak argument
"doNotTestCacheValidity=true".

Dostępne opcje to:

.. _zend.cache.backends.memcached.table:

.. table:: Opcje backendu Memcached

   +-------------+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Opcja        |Typ danych|Domyślna wartość                                                                                                                                                              |Opis                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +=============+==========+==============================================================================================================================================================================+===============================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================================+
   |servers      |Array     |array(array('host' => 'localhost', 'port' => 11211, 'persistent' => true, 'weight' => 1, 'timeout' => 5, 'retry_interval' => 15, 'status' => true, 'failure_callback' => '' ))|Tablica serwerów memcached ; każdy serwer memcached jest opisany przez asocjacyjną tablicę : 'host' => (string) : nazwa serwera memcached, 'port' => (int) : port serwera memcached, 'persistent' => (bool) : używać czy nie używać stałych połączeń do tego serwera memcached, 'weight' => (int) : waga serwera memcached, 'timeout' => (int) : timeout serwera memcached, 'retry_interval' => (int) : przerwa między ponowieniami, 'status' => (bool) : status serwera memcached, 'failure_callback' => (callback) : opcja failure_callback serwera memcached|
   +-------------+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |compression  |Boolean   |FALSE                                                                                                                                                                         |wartość true jeśli chcesz użyć kompresji w locie                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
   +-------------+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |compatibility|Boolean   |FALSE                                                                                                                                                                         |wartość true jeśli użyć trybu zgodności ze starymi serwerami/rozszerzeniami memcache                                                                                                                                                                                                                                                                                                                                                                                                                                                                           |
   +-------------+----------+------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.apc:

Zend_Cache_Backend_Apc
----------------------

Ten backend przechowuje rekordy bufora we współdzielonej pamięci za pomocą rozszerzenia `APC`_ (Alternatywny
bufor PHP), które oczywiście jest wymagane jeśli chcemy użyć tego backendu.

Bądź odstrożny: w tym backendzie nie są obecnie obsługiwane etykiety, tak samo jak argument
"doNotTestCacheValidity=true".

Ten backend nie ma żadnych opcji.

.. _zend.cache.backends.xcache:

Zend_Cache_Backend_Xcache
-------------------------

Ten backend przechowuje rekordy buforu we współdzielonej pamięci za pomocą rozszerzenia `XCache`_ (które
oczywiście jest potrzebne aby móc używać tego backendu).

Bądź ostrożny : ten backend obecnie nie obsługuje etykiet, podobnie jak opcji "doNotTestCacheValidity=true".

Dostępne opcje to:

.. _zend.cache.backends.xcache.table:

.. table:: Opcje backendu Xcache

   +--------+----------+----------------+---------------------------------------------------------------------------+
   |Opcja   |Typ danych|Domyślna wartość|Opis                                                                       |
   +========+==========+================+===========================================================================+
   |user    |string    |NULL            |xcache.admin.user, konieczna dla metody clean()                            |
   +--------+----------+----------------+---------------------------------------------------------------------------+
   |password|string    |NULL            |xcache.admin.pass (w czystej postaci, nie MD5), koieczna dla metody clean()|
   +--------+----------+----------------+---------------------------------------------------------------------------+

.. _zend.cache.backends.platform:

Zend_Cache_Backend_ZendPlatform
-------------------------------

Ten backend używa API produktu `Zend Platform`_ do buforowania zawartości. Oczywiście aby użyć tego backendu,
musisz mieć zainstalowaną aplikację Zend Platform.

Ten backend obsługuje etykiety, ale nie obsługuje trybu ``CLEANING_MODE_NOT_MATCHING_TAG`` czyszczenia bufora.

Gdy określasz nazwę tego backendu podczas użycia metody ``Zend_Cache::factory()``, wstaw pomiędzy słowami
'Zend' oraz 'Platform' jeden z dozwolonych separatorów wyrazów -- '-', '.', ' ', lub '\_':

.. code-block:: php
   :linenos:

   $cache = Zend_Cache::factory('Core', 'Zend Platform');

Ten backend nie ma żadnych opcji.

.. _zend.cache.backends.twolevels:

Zend_Cache_Backend_TwoLevels
----------------------------

Ten backend jest backendem hybrydowym. PRzechowuje on rekordu buforu w dwóch innych backendach : w szybkim (ale
ograniczonym) jak Apc, Memcache... i w wolnym takim jak File, Sqlite...

Ten backend będzie wykorzystywał parametr oznaczający priorytet (podany na poziomie frontendu podczas
zapisywania rekordu) oraz parametr oznaczający ilość miejsca do użycia przez szybki backend w celu
zoptymalizowania użycia tych dwóch backendów.

Dostępne opcje to :

.. _zend.cache.backends.twolevels.table:

.. table:: Opcje backendu TwoLevels

   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Opcja                     |Typ danych|Domyślna wartość|Opis                                                                                                                                                                                                 |
   +==========================+==========+================+=====================================================================================================================================================================================================+
   |slow_backend              |String    |File            |nazwa backendu "wolnego"                                                                                                                                                                             |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend              |String    |Apc             |nazwa backendu "szybkiego"                                                                                                                                                                           |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_options      |Array     |array()         |opcje backendu "wolnego"                                                                                                                                                                             |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_options      |Array     |array()         |opcje backendu "szybkiego"                                                                                                                                                                           |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_custom_naming|Boolean   |FALSE           |jeśli ma wartość true, argument slow_backend jest używany jako kompletna nazwa klasy ; jeśli ma wartość false, argument jest traktowany jako klasa z przedrostkiem "Zend_Cache_Backend_[...]"        |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_custom_naming|Boolean   |FALSE           |jeśli ma wartość true, argument fast_backend argument jest używany jako kompletna nazwa klasy; jeśli ma wartość false, argument jest traktowany jako klasa z przedrostkiem "Zend_Cache_Backend_[...]"|
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |slow_backend_autoload     |Boolean   |FALSE           |jeśli ma wartość true, dla wolnego backendu nie będzie wywoływana funkcja require_once (użyteczne tylko dla własnych backendów)                                                                      |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |fast_backend_autoload     |Boolean   |FALSE           |jeśli ma wartość true, dla szybkiego backendu nie będzie wywoływana funkcja require_once (użyteczne tylko dla własnych backendów)                                                                    |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |auto_refresh_fast_cache   |Boolean   |TRUE            |jeśli ma wartość true, bufor z szybkiego backendu zostanie automatycznie odświeżony gdy rekord bufora istnieje                                                                                       |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |stats_update_factor       |Integer   |10              |włącza / ustawia procent wypełnienia szybkiego backendu (podczas zapisywania rekordu w buforze, obliczenie procentu wypełnienia raz na x wywołan zapisywania bufora)                                 |
   +--------------------------+----------+----------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

.. _zend.cache.backends.zendserver:

Zend_Cache_Backend_ZendServer_Disk oraz Zend_Cache_Backend_ZendServer_ShMem
---------------------------------------------------------------------------

Te backendy przechowują rekordu bufora używając metod buforowania serwera `Zend Server`_.

Bądź ostrożny: te backendy nie obsługują opcji "etykiet" oraz argumentu "doNotTestCacheValidity=true".

Te backendy działają tylko w środowisku Zend Server dla stron działających w oparciu o HTTP(S) i nie
działają dla skryptów konsoli.

Te backendy nie posiadaja opcji.



.. _`memcached`: http://www.danga.com/memcached/
.. _`rozszerzenia PECL memcache`: http://pecl.php.net/package/memcache
.. _`APC`: http://pecl.php.net/package/APC
.. _`XCache`: http://xcache.lighttpd.net/
.. _`Zend Platform`: http://www.zend.com/products/platform
.. _`Zend Server`: http://www.zend.com/en/products/server/downloads-all?zfs=zf_download
