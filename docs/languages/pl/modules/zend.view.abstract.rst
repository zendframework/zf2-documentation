.. _zend.view.abstract:

Zend_View_Abstract
==================

Klasa *Zend_View_Abstract* jest klasą bazową w oparciu o którą zbudowana jest klasa *Zend_View*; Klasa
*Zend_View* po prostu rozszerza ją i deklaruje implementację metody *_run()* (która jest wywoływana przez
metodę *render()*).

Wielu programistów potrzebuje rozszerzyć obiekt *Zend_View_Abstract* aby dodać własną funkcjonalność i
nieuniknione jest że napotykają problemy dotyczące projektu klasy, która posiada wiele prywatnych zmiennych.
Ten dokument ma wyjaśnić jakie przesłanki stały za decyzjami podjętymi podczas projektowania komponentu.

*Zend_View* jest czymś w rodzaju systemu szablonów używającego natywnej składni PHP. W rezultacie możliwe
jest użycie w skryptach widoków kodu PHP, a dodatkowo dziedziczą one zakres wywołującego je obiektu.

Dlatego ten drugi punkt jest tak ważny dla decyzji podejmowanych podczas projektowania. Wewnętrznie metoda
*Zend_View::_run()* wygląda tak:

.. code-block:: php
   :linenos:

   protected function _run()
   {
       include func_get_arg(0);
   }


Skrypty widoków mają dostęp do obecnego obiektu (*$this*), **i wszystkich metod oraz zmiennych tego obiektu**. Z
tego względu, że wiele operacji zależy od zmiennych prywatnych, mogłoby to spowodować problem: skrypty
widoków mogłyby wywołać te metody lub bezpośrednio zmodyfikować krytyczne zmienne. Wobraź sobie skrypt
nadpisujący w niezamierzony sposób zmienną *$_path* lub *$_file*-- wszystkie następne wywołania metody
*render()* lub helperów widoków przestałyby działać!

Na szczęście w PHP 5 może to być rozwiązane dzięki deklaracjom widoczności: prywatne zmienne nie są
dostępne przez obiekty rozszerzające daną klasę. Zostało to użyte w obecnym projekcie: z tego względu, że
klasa *Zend_View* **rozszerza** klasę *Zend_View_Abstract*, skrypty widoku są ograniczone tylko do metod i
zmiennych chronionych oraz publicznych obiektu *Zend_View_Abstract*-- efektywnie ograniczając akcje jakie można
przeprowadzić i pozwalając nam na zabezpiecznie krytycznych obszarów przed nadużyciami w skryptach widoków.


