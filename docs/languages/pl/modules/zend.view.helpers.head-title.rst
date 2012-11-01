.. EN-Revision: none
.. _zend.view.helpers.initial.headtitle:

Helper HeadTitle
================

Element HTML *<title>* jest używany w celu ustawienia tytułu dla dokumentu HTML. Helper *HeadTitle* pozwala na
ustawianie tytułu i przechowywanie go w celu póżniejszego pobrania i wyświetlenia.

Helper *HeadTitle* jest implementacją :ref:`helpera Placeholder <zend.view.helpers.initial.placeholder>`.
Nadpisuje metodę *toString()* aby wygenerować element *<title>*, a także dodaje metodę *headTitle()* do
szybkiego i łatwego ustawiania elementów tytułu. Sygnaturą tej metody jest *headTitle($title, $setType =
'APPEND')*; domyślnie wartość jest dołączana na koniec stosu, ale możesz także określić opcję 'PREPEND'
(umieszczenie na początku stosu) lub 'SET' (zastąpienie stosu).

.. _zend.view.helpers.initial.headtitle.basicusage:

.. rubric:: Podstawowe użycie helpera HeadTitle

Możesz określić tytuł w dowolnym momencie. Najczęściej będzie tak, że ustawisz segmenty dla poszczególnych
części aplikacji: strony, kontrolera, akcji i prawdopodobnie zasobu.

.. code-block:: php
   :linenos:

   // ustawienie nazwy kontrolera oraz akcji jako segmentów tytułu:
   $request = Zend\Controller\Front::getInstance()->getRequest();
   $this->headTitle($request->getActionName())
        ->headTitle($request->getControllerName());

   // ustawienie nazwy strony w tytule; najczęściej skryptu layoutu:
   $this->headTitle('Zend Framework');

   // ustawienie odgranicznika dla segmentów
   $this->headTitle()->setSeparator(' / ');


Kiedy jesteś juz gotowy aby wyświetlić tytuł, możesz to zrobić w swoim pliku layoutu:

.. code-block:: php
   :linenos:

   <!-- wyświetla <action> / <controller> / Zend Framework -->
   <?= $this->headTitle() ?>


