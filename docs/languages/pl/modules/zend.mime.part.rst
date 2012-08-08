.. EN-Revision: none
.. _zend.mime.part:

Zend_Mime_Part
==============

.. _zend.mime.part.introduction:

Wprowadzenie
------------

Ta klasa reprezentuje pojedynczą część wiadomości MIME. Zawiera ona aktualną zawartość części wiadomości
oraz informacje o jej kodowaniu, typie oraz o oryginalej nazwie pliku. Dostarcza ona metody do generowania
łańcuchów znaków z przechowywanych danych. Obiekty *Zend_Mime_Part* mogą być dodane do
:ref:`Zend_Mime_Message <zend.mime.message>` aby zebrać kompletną wieloczęściową wiadomość.

.. _zend.mime.part.instantiation:

Tworzenie instancji
-------------------

Obiekt *Zend_Mime_Part* jest tworzony z łańcuchem znaków zawierającym część wiadomości podanym jako
parametr konstruktora. Domyślny typ to OCTET-STREAM, a kodowanie to 8Bit. Po utworzeniu obiektu *Zend_Mime_Part*,
jego podstawowe atrybuty mogą być zmienione bezpośrednio:

.. code-block:: php
   :linenos:

   public $type = ZMime::TYPE_OCTETSTREAM;
   public $encoding = ZMime::ENCODING_8BIT;
   public $id;
   public $disposition;
   public $filename;
   public $description;
   public $charset;


.. _zend.mime.part.methods:

Metody do renderowania części wiadomości do łańcucha znaków
-----------------------------------------------------------

*getContent()* zwraca zawartość MimePart zakodowaną jako łańcuch znaków przy użyciu kodowania określonego w
atrybucie $encoding. Poprawne wartości to ZMime::ENCODING_*. Konwersje zestawów znaków nie są przeprowadzane.

*getHeaders()* zwraca nagłówki Mime dla zawartości MimePart wygenerowane na podstawie informacji zawartych w
publicznie dostępnych atrybutach. Przed wywołaniem tej metody, atrybuty obiektu muszą być poprawnie
zdefiniowane.

   - *$charset* musi określać aktualny zestaw znaków zawartości, jeśli jest ona typu tekstowego (Text lub
     HTML).

   - *$id* może być ustawiony aby identyfikować obrazy wstawione bezpośrfednio w kodzie wiadomości HTML.

   - *$filename* zawiera nazwę pliku która będzie mu nadana gdy będzie on ściągany.

   - *$disposition* określa czy plik powinien być traktowany jako załącznik, czy powinien być użyty
     bezpośrednio w wiadomości HTML.

   - *$description* jest używane jedynie dla celów informacyjnych.




