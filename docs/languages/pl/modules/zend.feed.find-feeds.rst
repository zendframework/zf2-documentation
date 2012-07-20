.. _zend.feed.findFeeds:

Odbieranie kanałów informacyjnych ze stron internetowych
========================================================

Strony internetowe często zawierają tagi *<link>*, które odwołują się do kanałów informacyjnych
odpowiadających danej stronie. *Zend_Feed* pozwala odebrać wszystkie kanały informacyjne do których odwołuje
się dana strona za pomocą wywołania prostej metody:

.. code-block::
   :linenos:

   $feedArray = Zend_Feed::findFeeds('http://www.example.com/news.html');


Tutaj metoda *findFeeds()* zwraca tablicę obiektów *Zend_Feed_Abstract* do których na stronie news.html są
odniesienia w postaci *<link>*. Zależenie od typu każdego z kanałów, każdy z wpisów w tablicy *$feedArray*
może być instancją obiektu *Zend_Feed_Rss* lub *Zend_Feed_Atom*. *Zend_Feed* wyrzucu wyjątek
*Zend_Feed_Exception* w razie niepowodzenia, na przykład gdy otrzyma w odpowiedzi kod HTTP 404 lub gdy dane
kanału będą nieprawidłowe.


