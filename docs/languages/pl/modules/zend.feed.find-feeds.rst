.. EN-Revision: none
.. _zend.feed.findFeeds:

Odbieranie kanałów informacyjnych ze stron internetowych
========================================================

Strony internetowe często zawierają tagi *<link>*, które odwołują się do kanałów informacyjnych
odpowiadających danej stronie. *Zend_Feed* pozwala odebrać wszystkie kanały informacyjne do których odwołuje
się dana strona za pomocą wywołania prostej metody:

.. code-block:: php
   :linenos:

   $feedArray = Zend\Feed\Feed::findFeeds('http://www.example.com/news.html');


Tutaj metoda *findFeeds()* zwraca tablicę obiektów *Zend\Feed\Abstract* do których na stronie news.html są
odniesienia w postaci *<link>*. Zależenie od typu każdego z kanałów, każdy z wpisów w tablicy *$feedArray*
może być instancją obiektu *Zend\Feed\Rss* lub *Zend\Feed\Atom*. *Zend_Feed* wyrzucu wyjątek
*Zend\Feed\Exception* w razie niepowodzenia, na przykład gdy otrzyma w odpowiedzi kod HTTP 404 lub gdy dane
kanału będą nieprawidłowe.


