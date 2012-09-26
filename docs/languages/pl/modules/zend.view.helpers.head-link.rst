.. EN-Revision: none
.. _zend.view.helpers.initial.headlink:

Helper HeadLink
===============

Element HTML *<link>* jest używany do dołączania różnego rodzaju zasobów do dokumentu html: arkuszy stylów,
kanałów informacyjnych, ikon, adresów trackback i wielu innych. Helper *HeadLink* zapewnia prosty interfejs
służący do tworzenia i łączenia tych elementów, a następnie do wyświetlenia ich później w skrypcie
layoutu.

Helper *HeadLink* posiada specjalne metody do dodawania arkuszy stylów:

- *appendStylesheet($href, $media, $conditionalStylesheet)*

- *offsetSetStylesheet($index, $href, $media, $conditionalStylesheet)*

- *prependStylesheet($href, $media, $conditionalStylesheet)*

- *setStylesheet($href, $media, $conditionalStylesheet)*

Domyślną wartością zmiennej *$media* jest 'screen', jednak możemy nadać jej inną poprawną wartość.
Zmienna *$conditionalStylesheet* jest wartością logiczną określającą czy podczas renderowania powinien
zostać dodany specjalny komentarz zapobiegający ładowaniu arkusza stylów na określonych platformach.

Dodatkowo helper *HeadLink* posiada specjalne metody do obsługi łącz 'alternate':

- *appendAlternate($href, $type, $title)*

- *offsetSetAlternate($index, $href, $type, $title)*

- *prependAlternate($href, $type, $title)*

- *setAlternate($href, $type, $title)*

Metoda *headLink()* helpera pozwala na określenie wszystkich potrzebnych atrybutów elementu *<link>*, a także
pozwala określić jego umiejscowienie -- czy nowy element ma zastąpić wszystkie istniejące, dołączyć go na
koniec lub na początek stosu.

Helper *HeadLink* jest implementacją :ref:`helpera Placeholder <zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.headlink.basicusage:

.. rubric:: Proste użycie helpera HeadLink

Możesz użyć helpera *headLink* w dowolnym momencie. Najczęściej będziesz określał globalne łącza w pliku
layoutu, a łącza specyficzne dla aplikacji w skryptach widoków. W skrypcie layoutu wyświetlisz na koniec
wszystkie łącza w sekcji <head>.

.. code-block:: php
   :linenos:

   <?php // ustawianie łącz w skrypcie widoku:
   $this
       ->headLink(
           array(
               'rel' => 'favicon',
               'href' => '/img/favicon.ico',
           ),
           'PREPEND'
       )
       ->appendStylesheet('/styles/basic.css')
       ->prependStylesheet(
           '/styles/moz.css',
           'screen',
           true,
           array(
               'id' => 'my_stylesheet',
           )
       )
   ;
   ?>
   <?php // generowaie łącz: ?>
   <?= $this->headLink() ?>



