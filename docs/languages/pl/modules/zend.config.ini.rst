.. _zend.config.adapters.ini:

Zend_Config_Ini
===============

*Zend_Config_Ini* pozwala programistom przechowywać dane konfiguracyjne w znanym formacie INI a następnie
odczytywać je w aplikacji używając składni zagnieżdżonych właściwości obiektów. Format INI jest
wyspecjalizowany aby zapewnić możliwość zachowania hierarchi danych konfiguracyjnych a także możliwość
dziedziczenia pomiędzy sekcjami danych konfiguracyjnych. Hierarchia danych konfiguracyjnych jest uzyskiwana
poprzez oddzielenie kluczy za pomocą znaku kropki (*.*). Sekcja może rozszerzać lub dziedziczyć z innej sekcji
poprzez dodanie za nazwą sekcji znaku dwukropka (*:*) oraz nazwy sekcji, z której dane mają być dziedziczone.

.. note::

   **parse_ini_file**

   *Zend_Config_Ini* wykorzystuje funkcję PHP `parse_ini_file()`_. Proszę przejrzyj dokumentację tej funkcji aby
   znać jej specyficzne zachowania, które dziedziczy *Zend_Config_Ini*, takie jak to w jaki sposób są
   obsługiwane specjalne wartości takie jak *true*, *false*, *yes*, *no*, oraz *null*.

.. note::

   **Separator kluczy**

   Domyślnie separatorem kluczy jest znak kropki (*.*). Może on być jednak zmieniony przez zmianę klucza
   *'nestSeparator'* z tablicy *$options* podczas tworzenia obiektu *Zend_Config_Ini*. Na przykład:

      .. code-block::
         :linenos:

         $options['nestSeparator'] = ':';
         $config = new Zend_Config_Ini('/path/to/config.ini',
                                       'staging',
                                       $options);




.. _zend.config.adapters.ini.example.using:

.. rubric:: Użycie Zend_Config_Ini

Ten przykład pokazuje podstawowe użycie klasy *Zend_Config_Ini* do ładowania danych konfiguracyjnych z pliku
INI. W tym przykładzie znajdują się dane konfiguracyjne zarówno dla systemu produkcyjnego jak i dla systemu
rozbudowywanego. Z tego względu, że dane konfiguracyjne systemu rozbudowywanego są bardzo podobne do tych dla
systemu produkcyjnego, sekcja systemu rozbudowywanego dziedziczy po sekcji systemu produkcyjnego. W tym przypadku
decyzja jest dowolna i mogłoby to być zrobione odwrotnie, z sekcją systemu produkcyjnego dziedziczącą po
sekcji systemu rozbudowywanego, chociaż nie może to być przykładem dla bardziej złożonych sytuacji.
Załóżmy, że poniższe dane konfiguracyjne znajdują się w pliku */path/to/config.ini*:

.. code-block::
   :linenos:

   ; Podstawowe dane konfiguracyjne
   [production]
   webhost                  = www.example.com
   database.adapter         = pdo_mysql
   database.params.host     = db.example.com
   database.params.username = dbuser
   database.params.password = secret
   database.params.dbname   = dbname

   ; Konfiguracja aplikacji rozbudowywanej dziedziczy z podstawowej
   ; konfiguracji, a niektóre wartości są nadpisywane
   [staging : production]
   database.params.host     = dev.example.com
   database.params.username = devuser
   database.params.password = devsecret


Następnie załóżmy, że programista aplikacji potrzebuje danych konfiguracyjnych aplikacji rozbudowywanej z
pliku INI. Prostą  sprawą jest załadowanie tych danych określając plik INI oraz sekcję dla aplikacji
rozbudowywanej:

.. code-block::
   :linenos:

   $config = new Zend_Config_Ini('/path/to/config.ini', 'staging');

   echo $config->database->params->host; // wyświetla "dev.example.com"
   echo $config->database->params->dbname; // wyświetla "dbname"


.. note::

   .. _zend.config.adapters.ini.table:

   .. table:: Parametry konstruktora Zend_Config_Ini

      +----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |Parametr        |Opis                                                                                                                                                                                                                                                |
      +================+====================================================================================================================================================================================================================================================+
      |$filename       |Nazwa pliku INI do załadowania.                                                                                                                                                                                                                     |
      +----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$section        |Nazwa sekcji wewnątrz pliku ini, która ma być załadowana. Ustawienie wartości tego parametru na null spowoduje załadowanie wszystkich sekcji. Alternatywnie, możesz przekazać tablicę nazw sekcji aby załadować wiele sekcji.                       |
      +----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
      |$options = false|Tablica opcji. Obsługiwane są poniższe klucze: allowModifications: Ustaw na true aby umożliwić późniejszą modyfikację załadowanego pliku. Domyśłnie false nestSeparator: Ustaw znak jaki ma być użyty do oddzielania przestrzeni nazw. Domyślnie "."|
      +----------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+



.. _`parse_ini_file()`: http://php.net/parse_ini_file
