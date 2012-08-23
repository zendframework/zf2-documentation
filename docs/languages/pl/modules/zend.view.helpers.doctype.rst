.. EN-Revision: none
.. _zend.view.helpers.initial.doctype:

Helper Doctype
==============

Poprawne dokumenty HTML oraz XHTML powinny zawierać deklarację typu dokumentu *DOCTYPE*. Oprócz tego, że
wszystkie rodzaje deklaracji trudno jest zapamiętać, to wyświetlanie niektórych elementów w dokumencie może
zależeć od jego typu (przykładowo, użycie CDATA w elementach *<script>* czy w elementach *<style>*).

Helper *Doctype* pozwala ci na określenie jedno z następujących typów:

- *XHTML11*

- *XHTML1_STRICT*

- *XHTML1_TRANSITIONAL*

- *XHTML1_FRAMESET*

- *XHTML_BASIC1*

- *HTML4_STRICT*

- *HTML4_LOOSE*

- *HTML4_FRAMESET*

Możesz określić także własny typ dokumentu o ile ma prawidłowy format.

Helper *Doctype* jest implementacją :ref:`helpera Placeholder <zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.doctype.basicusage:

.. rubric:: Podstawowe użycie helpera Doctype

Możesz określić typ dokumentu w dowolnej chwili. Jednak helpery których działania zależy od typu dokumentu
mogą sprawdzić ten typ tylko pod warunkiem że go wcześniej określisz, więc najlepiej będzie jak określisz
typ dokumentu w pliku uruchamiającym:

.. code-block:: php
   :linenos:

   $doctypeHelper = new Zend_View_Helper_Doctype();
   $doctypeHelper->doctype('XHTML1_STRICT');


I teraz wyświetl definicję typu dokumentu w swoim skrypcie layoutu:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>


.. _zend.view.helpers.initial.doctype.retrieving:

.. rubric:: Pobieranie typu dokumentu

Jeśli potrzebujesz sprawdzić typ dokumentu, możesz to zrobić wywołując metodę *getDoctype()* obiektu, który
jest zwracany po wywołaniu helpera.

.. code-block:: php
   :linenos:

   $doctype = $view->doctype()->getDoctype();


Najczęściej będzie potrzebował sprawdzić czy dany typ dokumentu jest typem XHTML czy nie; do tego wystarczy
metoda *isXhtml()*:

.. code-block:: php
   :linenos:

   if ($view->doctype()->isXhtml()) {
       // zrób coś w inny sposób
   }



