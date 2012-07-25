.. _zend.config.adapters.xml:

Zend_Config_Xml
===============

*Zend_Config_Xml* pozwala programistom przechowywać dane konfiguracyjne w prostym formacie XML a następnie
odczytywać je w aplikacji używając składni zagnieżdżonych właściwości obiektów. Nazwa głównego elementu
pliku XML jest nieistotna i może być dowolna. Pierwsze poziomy elementów XML odpowiadają sekcjom danych
konfiguracyjnych. Format XML obsługuje hierarchiczne zorganizowanie za pomocą zagnieżdżania elementów XML
wewnątrz elementów poziomu sekcji. Zawartość najbardziej zagnieżdżonego elementu XML odpowiada wartości
danej konfiguracyjnej. Dziedziczenie sekcji jest obsługiwane za pomocą specjalnego atrybutu XML nazwanego
*extends*, a wartość tego atrybutu odpowiada nazwie sekcji, której dane mają być odziedziczone przez
rozszerzającą sekcję.

.. note::

   **Zwracany typ**

   Dane konfiguracyjne odczytywane przez *Zend_Config_Xml* są zawsze zwracane jako łańcuchy znaków. Konwersja
   danych z łańcuchów znaków do innych typów leży w gestii programistów, którzy mogą dopasować to do
   własnych potrzeb.

.. _zend.config.adapters.xml.example.using:

.. rubric:: Użycie Zend_Config_Xml

Ten przykład pokazuje podstawowe użycie klasy *Zend_Config_Xml* do ładowania danych konfiguracyjnych z pliku
XML. W tym przykładzie znajdują się dane konfiguracyjne zarówno dla systemu produkcyjnego jak i dla systemu
rozbudowywanego. Z tego względu, że dane konfiguracyjne systemu rozbudowywanego są bardzo podobne do tych dla
systemu produkcyjnego, sekcja systemu rozbudowywanego dziedziczy po sekcji systemu produkcyjnego. W tym przypadku
decyzja jest dowolna i mogłoby to być zrobione odwrotnie, z sekcją systemu produkcyjnego dziedziczącą po
sekcji systemu rozbudowywanego, chociaż nie może to być przykładem dla bardziej złożonych sytuacji.
Załóżmy, że poniższe dane konfiguracyjne znajdują się w pliku */path/to/config.xml*:

.. code-block:: php
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter>pdo_mysql</adapter>
               <params>
                   <host>db.example.com</host>
                   <username>dbuser</username>
                   <password>secret</password>
                   <dbname>dbname</dbname>
               </params>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params>
                   <host>dev.example.com</host>
                   <username>devuser</username>
                   <password>devsecret</password>
               </params>
           </database>
       </staging>
   </configdata>


Następnie załóżmy, że programista aplikacji potrzebuje danych konfiguracyjnych aplikacji rozbudowywanej z
pliku XML. Prostą  sprawą jest załadowanie tych danych określając plik XML oraz sekcję dla aplikacji
rozbudowywanej:

.. code-block:: php
   :linenos:

   $config = new Zend_Config_Xml('/path/to/config.xml', 'staging');

   echo $config->database->params->host; // wyświetla "dev.example.com"
   echo $config->database->params->dbname; // wyświetla "dbname"


.. _zend.config.adapters.xml.example.attributes:

.. rubric:: Używanie atrybutów znaczników w Zend_Config_Xml

Komponent Zend_Config_Xml obsługuje także dwa inne sposoby definiowania elementów w pliku konfiguracyjnym. Oba
sposoby używają atrybutów. Z tego względu, że atrybuty *extends* oraz *value* są zastrzeżone (do
rozszerzania sekcji oraz do alternatywnego sposobu użycia atrybutów), nie mogą one być użyte. Pierwszym
sposobem użycia atrybutu jest dodanie go w elemencie rodzica. Zostanie on automatycznie przełożony jako element
dziecko:

.. code-block:: php
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production webhost="www.example.com">
           <database adapter="pdo_mysql">
               <params host="db.example.com" username="dbuser" password="secret" dbname="dbname"/>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params host="dev.example.com" username="devuser" password="devsecret"/>
           </database>
       </staging>
   </configdata>


Kolejny sposób tak naprawdę nie zmniejsza objętości pliku konfiguracyjnego, ale ułatwia zarządzanie nim,
ponieważ eliminuje konieczność pisania nazw znaczników podwójnie. Po prostu tworzysz pusty znacznik, który
zawiera swoją wartość wewnątrz atrybutu *value*:

.. code-block:: php
   :linenos:

   <?xml version="1.0"?>
   <configdata>
       <production>
           <webhost>www.example.com</webhost>
           <database>
               <adapter value="pdo_mysql"/>
               <params>
                   <host value="db.example.com"/>
                   <username value="dbuser"/>
                   <password value="secret"/>
                   <dbname value="dbname"/>
               </params>
           </database>
       </production>
       <staging extends="production">
           <database>
               <params>
                   <host value="dev.example.com"/>
                   <username value="devuser"/>
                   <password value="devsecret"/>
               </params>
           </database>
       </staging>
   </configdata>



