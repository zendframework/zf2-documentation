.. _zend.debug.dumping:

Wyświetlanie informacji o zmiennych
===================================

Statyczna metoda *Zend_Debug::dump()* wyświetla lub zwraca informacje o wyrażeniu. Ta prosta technika usuwania
błędów jest często używana, ponieważ jest łatwa w użyciu, nie wymaga inicjowania, użycia specjalnych
narzędzi czy środowiska testowego.

.. _zend.debug.dumping.example:

.. rubric:: Przykład użycia metody dump()

.. code-block:: php
   :linenos:

   Zend_Debug::dump($var, $label=null, $echo=true);


Argument *$var* określa wyrażenie lub zmienną, na temat której metoda *Zend_Debug::dump()* ma wyświetlić
informacje.

Argument *$label* jest łańcuchem znaków, który zostanie dołączony na początku wyniku użycia metody
*Zend_Debug::dump()*. Użycie takich etykiet może być użyteczne na przykład wtedy, gdy wyświetlasz informacje
o wielu zmiennych na jednym ekranie.

Wartość logiczna argumentu *$echo* określa czy wynik użycia metody *Zend_Debug::dump()* ma być wyświetlony,
czy nie. Jeśli ma wartość *true*, wynik jest wyświetlony. Niezależnie od wartości tego argumentu, metoda na
koniec zwraca wynik.

Użyteczna może być informacja o tym, że metoda *Zend_Debug::dump()* używa funkcji PHP `var_dump()`_. Jeśli
dane wyjsciowe mają być wyświetlone w przeglądarce, to w wyniku zwróconym przez wywołanie metody *var_dump()*
znaki specjalne cytowane są za pomocą funkcji `htmlspecialchars()`_, a cały wynik zostaje objęty znacznikami
(X)HTML *<pre>*.

.. tip::

   **Usuwanie błędów za pomocą Zend_Log**

   Użycie metody *Zend_Debug::dump()* jest najlepsze do doraźnego usuwania błędów podczas tworzenia
   oprogramowania. Możesz dodać kod, aby wyświetlić informacje o zmiennej, a potem szybko go usunąć.

   Zapoznaj się także z komponentem :ref:`Zend_Log <zend.log.overview>` jeśli chcesz aby kod służący do
   usuwania błędów był umieszczony w aplikacji na stałe. Na przykład, możesz użyć poziomu raportowania
   błędów *DEBUG* i obiektu *Zend_Log_Writer_Stream*, aby wyświetlać łańcuchy znaków zwracane przez metodę
   *Zend_Debug::dump()*.



.. _`var_dump()`: http://php.net/var_dump
.. _`htmlspecialchars()`: http://php.net/htmlspecialchars
