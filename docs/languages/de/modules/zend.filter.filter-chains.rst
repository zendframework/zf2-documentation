.. EN-Revision: none
.. _zend.filter.filter_chains:

Filter Ketten
=============

Oft müssen mehrere Filter auf Werte in einer speziellen Reihenfolge angewendet werden. Zum Beispiel, ein Login
Formular das einen Benutzernamen akzeptiert welcher nur kleingeschrieben und alphabetische Zeichen haben sollte.
``Zend_Filter`` bietet eine einfache Methode mit der Filter zusammengekettet werden können. Der folgende Code
zeigt wie eine Verkettung von zwei Filtern für das übermitteln eines Benutzernamens funktioniert:

.. code-block:: php
   :linenos:

   // Eine Filterkette erstellen und die Filter der Kette hinzufügen
   $filterChain = new Zend_Filter();
   $filterChain->addFilter(new Zend_Filter_Alpha())
               ->addFilter(new Zend_Filter_StringToLower());

   // Den Benutzernamen filtern
   $username = $filterChain->filter($_POST['username']);

Filter werden in der Reihenfolge ausgeführt in der Sie ``Zend_Filter`` hinzugefügt werden. Im obigen Beispiel
wird dem Benutzernamen zuerst jedes nicht-alphabetische Zeichen entfernt und anschließend jeder Großbuchstabe in
einen Kleinbuchstaben umgewandelt.

Jedes Objekt das ``Zend_Filter_Interface`` implementiert kann in einer Filterkette verwendet werden.

.. _zend.filter.filter_chains.order:

Ändern der Reihenfolge der Filterkette
--------------------------------------

Seit 1.10 unterstützt die ``Zend_Filter`` Kette auch das Ändern der Kette durch voranstellen oder anhängen von
Filtern. Zum Beispiel macht der nächste Code exakt das gleiche wie das andere Beispiel für die Filterkette des
Benutzernamens:

.. code-block:: php
   :linenos:

   // Eine Filterkette erstellen und die Filter der Kette hinzufügen
   $filterChain = new Zend_Filter();

   // Dieser Filter wird der Filterkette angehängt
   $filterChain->appendFilter(new Zend_Filter_StringToLower());

   // Dieser Filter wird am Beginn der Kette vorangestellt
   $filterChain->prependFilter(new Zend_Filter_Alpha());

   // Nach dem Benutzernamen filtern
   $username = $filterChain->filter($_POST['username']);


