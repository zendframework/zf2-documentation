.. _zend.config.introduction:

Wprowadzenie
============

Klasa *Zend_Config* została stworzona aby uprościć użycie danych konfiguracyjnych w aplikacjach. Dostarcza ona
interfejs bazujący na właściwościach obiektów służący do odczytywania danych konfiguracyjnych wewnątrz
kodu aplikacji. Dane konfiguracyjne mogą  pochodzić z różnego rodzaju źródeł, w których dane
konfiguracyjne są przechowywane hierarchiczne. Obecnie *Zend_Config* dostarcza klasy obsługujące dane
konfiguracyjne przechowywane w plikach tekstowych: :ref:`Zend_Config_Ini <zend.config.adapters.ini>`, oraz
:ref:`Zend_Config_Xml <zend.config.adapters.xml>`.

.. _zend.config.introduction.example.using:

.. rubric:: Użycie Zend_Config

Normalnie jest tak, że użytkownicy użyliby jednej z klas adaptera, takiej jak :ref:`Zend_Config_Ini
<zend.config.adapters.ini>` czy :ref:`Zend_Config_Xml <zend.config.adapters.xml>`, ale dane konfiguracyjne mogą
być też dostępne w tablicy PHP. Można w prosty sposób przekazać tablicę do konstruktora *Zend_Config* w celu
uzyskania obiektu zawierającego dane konfiguracyjne:

.. code-block::
   :linenos:

   // Tablica danych konfiguracyjnych
   $configArray = array(
       'webhost'  => 'www.example.com',
       'database' => array(
           'adapter' => 'pdo_mysql',
           'params'  => array(
               'host'     => 'db.example.com',
               'username' => 'dbuser',
               'password' => 'secret',
               'dbname'   => 'mydatabase'
           )
       )
   );

   // Tworzy obiekt konfiguracji na podstawie danych konfiguracyjnych
   $config = new Zend_Config($configArray);

   // Wyświetlenie wpisu z konfiguracji (wynikiem jest 'www.example.com')
   echo $config->webhost;

   // Użycie danych konfiguracyjnych w celu połączenia się z bazą danych
   $db = Zend_Db::factory($config->database->adapter,
                          $config->database->params->toArray());

   // Alternartywne użycie: przekazanie obiektu Zend_Config.
   // Metoda kklasy Zend_Db wie jak zinterpretować dane.
   $db = Zend_Db::factory($config->database);


Jak zostało pokazane w powyższym przykładzie, klasa *Zend_Config* zapewnia składnię zagnieżdżonych
właściwości obiektów w celu uzyskania dostępu do danych konfiguracyjnych przekazanych do konstruktora.

Oprócz zorientowanego obiektowo dostępu do wartości klasa *Zend_Config* posiada także metodę *get()*
umożliwiającą zwrócenie podanej domyślnej wartości jeśli element nie istnieje. Na przykład:

.. code-block::
   :linenos:

   $host = $config->database->get('host', 'localhost');


.. _zend.config.introduction.example.file.php:

.. rubric:: Użycie Zend_Config z plikiem konfiguracyjnym PHP

Często wskazane może być użycie do konfiguracji zwykłego pliku PHP. Poniższy kod pokazuje w jak łatwy
sposób można to zrobić:

.. code-block::
   :linenos:

   return array(
       'webhost'  => 'www.example.com',
       'database' => array(
           'adapter' => 'pdo_mysql',
           'params'  => array(
               'host'     => 'db.example.com',
               'username' => 'dbuser',
               'password' => 'secret',
               'dbname'   => 'mydatabase'
           )
       )
   );


.. code-block::
   :linenos:

   // Załadowanie konfiguracji
   $config = new Zend_Config(require 'config.php');

   // Wyświetlenie danych konfiguracyjnych (powoduje wyświetlenie 'www.example.com')
   echo $config->webhost;



