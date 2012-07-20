.. _zend.feed.consuming-atom:

Odbieranie danych z kanału informacyjnego Atom
==============================================

*Zend_Feed_Atom* jest używany w prawie taki sam sposób jak *Zend_Feed_Rss*. Zapewnia taki sam dostęp do
właściwości samego kanału i taką samą iterację po wpisach w kanale. Główną różnicą jest sama struktura
protokołu Atom. Atom jest następcą RSS; jest bardziej uogólnionym protokołem i jest zaprojektowany aby
łatwiej radzić sobie z kanałami, które ukazują cała swoją zawartość wewnątrz pliku RSS dzieląc
standardowy tag RSS *description* na dwa elementy, *summary* oraz *content*.

.. _zend.feed.consuming-atom.example.usage:

.. rubric:: Podstawowe użycie kanału Atom

Odczytywanie kanału Atom i wyświetlenie pól *title* i *summary* dla każdego z wpisów:

.. code-block::
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/');
   echo 'Kanał zawiera ' . $feed->count() . ' wpisów.' . "\n\n";
   foreach ($feed as $entry) {
       echo 'Tytuł: ' . $entry->title() . "\n";
       echo 'Opis: ' . $entry->summary() . "\n\n";
   }


W kanałach Atom możesz się spodziewać następujących właściwości:



   - *title*- Tytuł kanału, taki sam jak tytuł kanału RSS.

   - *id*- Każdy arkusz i wpis mają unikalny identyfikator.

   - *link*- Arkusze mogą mieć wiele odnośników, które są rozróżnianie za pomocą atrybutu *type*.

     Odpowiednikiem odnośnika kanału RSS byłby odnośnik o typie *type="text/html"*. Jeśli odnośnik kieruje do
     alternatywnej wersji zawartości arkusza, może on otrzymać atrybut *rel="alternate"*.

   - *subtitle*- Opis arkusza odpowiadający opisowi kanału RSS.

     *author->name()*- Nazwa autora arkusza.

     *author->email()*- Adres email autora arkusza.



Składniki wpisu kanału Atom:



   - *id*- Unikalny identyfikator wpisu.

   - *title*- Tytuł wpisu, taki sam jak tytuł w RSS

   - *link*- Odnośnik do innego formatu lub do alternatywnej wersji wpisu.

   - *summary*- Podsumowanie zawartości wpisu.

   - *content*- Cała zawartość wpisu; może być pominięta jeśli arkusz zawiera tylko skróty informacji.

   - *author*- z pod-tagami *name* oraz *email* jak w arkuszach RSS

   - *published*- data publikacji wpisu w formacie RFC 3339.

   - *updated*- data ostatniej aktualizacji wpisu w formacie RFC 3339.



Więcej informacji o Atom znajdziesz na stronie `http://www.atomenabled.org/`_.



.. _`http://www.atomenabled.org/`: http://www.atomenabled.org/
