.. _zend.feed.consuming-rss:

Odbieranie danych z kanału informacyjnego RSS
=============================================

Odczytywanie kanału RSS jest tak proste jak utworzenie obiektu *Zend_Feed_Rss* z adresem URL kanału przekazanym
do konstruktora:

.. code-block:: php
   :linenos:

   $channel = new Zend_Feed_Rss('http://rss.example.com/channelName');


Jeśli wystąpi jakiś błąd podczas obróbki danych pochodzących z kanału, zostanie wyrzucony wyjątek
*Zend_Feed_Exception*.

Kiedy już masz obiekt kanału informacyjnego, możesz łatwo uzyskać dostęp do standardowych właściwości
kanału RSS bezpośrednio na obiekcie:

.. code-block:: php
   :linenos:

   echo $channel->title();


Zwróć uwagę na składnie funkcji. *Zend_Feed* używa konwencji traktującej właściwości jak obiekt XML gdy
próbujemy uzyskać do nich dostęp za pomocą składni "getter" (*$obj->property*) i jako łańcuch znaków gdy
próbujemy uzyskać dostęp jak do metody (*$obj->property()*). To pozwala na pełny dostęp do danych tekstowych
przy jednoczesnym dostępie do wszystkich niższych składników.

Jeśli właściwości kanału mają atrybuty, są one dostępne przy użyciu składni tablic PHP:

.. code-block:: php
   :linenos:

   echo $channel->category['domain'];


Since XML attributes cannot have children, method syntax is not necessary for accessing attribute values.

Najczęściej będziesz chciał przejść pętlą po danych kanału i zrobić coś z jego wpisami. Klasa
*Zend_Feed_Abstract* implementuje wbudowany w PHP interfejs *Iterator*, więc wyświetlenie wszystkich tytułów
artykułów z kanału jest bardzo proste:

.. code-block:: php
   :linenos:

   foreach ($channel as $item) {
       echo $item->title() . "\n";
   }


Jeśli nie jesteś obeznany z RSS, poniżej znajdziesz opis podstawowych składników, które możesz znaleść w
kanale RSS i w jego indywidualnych elementach (wpisach).

Wymagane składniki kanału:



   - *title*- Nazwa kanału

   - *link*- Adres URL strony internetowej odpowiadającej kanałowi

   - *description*- Opis kanału



Opcjonalne składniki kanału:



   - *pubDate*- Data publikacji zawartości, format RFC 822 format

   - *language*- Język kanału

   - *category*- Jedna lub więcej kategorii do których należy kanał



Elementy RSS *<item>* nie mają wymaganych składników, jednak albo składnik *title* albo *description* musi
istnieć w elemencie.

Składniki elementu kanału:



   - *title*- Tytuł elementu

   - *link*- Adres URL elementu

   - *description*- Opis elementu

   - *author*- Adres email autora elementu

   - *category*- Jedna lub więcej kategorii do których należy element

   - *comments*- Adres URL komentarzy do tego elementu

   - *pubDate*- Data publikacji elementu, w formacie RFC 822



W twoim kodzie zawsze możesz sprawdzić czy element nie jest pusty za pomocą:

.. code-block:: php
   :linenos:

   if ($item->propname()) {
       // ... kontynuuj.
   }


Jeśli zamiast tego użyjesz *$item->propname*, zawsze dostaniesz pusty obiekt który zostanie skonwertowany do
wartości *TRUE*, więc test zawiedzie.

Więcej informacji dostępnych jest w oficjalnej specyfikacji RSS 2.0: `http://blogs.law.harvard.edu/tech/rss`_



.. _`http://blogs.law.harvard.edu/tech/rss`: http://blogs.law.harvard.edu/tech/rss
