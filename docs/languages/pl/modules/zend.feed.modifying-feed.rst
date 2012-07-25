.. _zend.feed.modifying-feed:

Modyfikacja kanału oraz struktury wpisów
========================================

Naturalna składnia *Zend_Feed* pozwala na konstruowanie oraz modyfikowanie kanałów i wpisów tak samo jak na
odczytywanie ich. Możesz łatwo zamienić nowy lub zmodyfikowany obiekt spowrotem do poprawnego XML aby zapisać
go do pliku lub wysłać na serwer.

.. _zend.feed.modifying-feed.example.modifying:

.. rubric:: Modyfikacja istniejącego wpisu

.. code-block:: php
   :linenos:

   $feed = new Zend_Feed_Atom('http://atom.example.com/feed/1');
   $entry = $feed->current();

   $entry->title = 'To jest nowy tytuł';
   $entry->author->email = 'my_email@example.com';

   echo $entry->saveXML();


To wyświetli pełną (dołączając prolog *<?xml ... >*) reprezentację XML nowego wpisu, dołączając potrzebne
przestrzenie nazw XML.

Zauważ, że powyższy przykład będzie działał nawet gdy istniejący wpis nie posiada znacznika autora
(author). Możesz użyć tyle ile chcesz poziomów dostępu *->* zanim dokonasz przypisania; wszystkie pośrednie
poziomy zostaną automatycznie utworzone gdy będzie to potrzebne.

Jeśli chcesz użyć innej przestrzeni nazw niż *atom:*, *rss:*, lub *osrss:* w swoim wpisie, musisz
zarejestrować przestrzeń nazw w *Zend_Feed* używając metody *Zend_Feed::registerNamespace()*. Gdy modyfikujesz
istniejący element, będzie on zawsze zachowywał oryginalną przestrzeń nazw. Gdy dodajesz nowy element, będzie
on utworzony w domyślnej przestrzeni nazw jeśli nie określisz precyzyjnie innej przestrzeni.

.. _zend.feed.modifying-feed.example.creating:

.. rubric:: Tworzenie wpisu Atom z elementami własnej przestrzeni nazw

.. code-block:: php
   :linenos:

   $entry = new Zend_Feed_Entry_Atom();
   // id w Atom jest zawsze nadane przez serwer
   $entry->title = 'mój własny wpis';
   $entry->author->name = 'Przykładowy autor';
   $entry->author->email = 'me@example.com';

   // Teraz własna część
   Zend_Feed::registerNamespace('myns', 'http://www.example.com/myns/1.0');

   $entry->{'myns:myelement_one'} = 'pierwsza własna część';
   $entry->{'myns:container_elt'}->part1 = 'pierwsza zagnieżdżona część';
   $entry->{'myns:container_elt'}->part2 = 'druga zagnieżdżona część';

   echo $entry->saveXML();



