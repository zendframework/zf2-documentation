.. EN-Revision: none
.. _zend.view.helpers.initial.doctype:

Doctype Helfer
==============

Gültige *HTML* und *XHTML* Dokumente sollten eine ``DOCTYPE`` Deklaration enthalten. Neben der Schwierigkeit sich
diese zu merken, können Sie auch beeinflussen wie bestimmte Elemente im Dokument dargestellt werden sollen (zum
Beispiel, CDATA Kommentierung in **<script>** und **<style>** Elementen.

Der ``Doctype`` Helfer erlaubt die Spezifikation von einem der folgenden Typen:

- ``XHTML11``

- ``XHTML1_STRICT``

- ``XHTML1_TRANSITIONAL``

- ``XHTML_BASIC1``

- ``XHTML1_FRAMESET``

- ``HTML4_STRICT``

- ``HTML4_LOOSE``

- ``HTML4_FRAMESET``

- ``HTML5``

Es kann auch ein eigener DocType spezifiziert werden solange dieser richtig formatiert ist.

Der ``Doctype`` Helfer ist eine konkrete Implementation des :ref:`Platzhalter Helfers
<zend.view.helpers.initial.placeholder>`.

.. _zend.view.helpers.initial.doctype.basicusage:

.. rubric:: Grundsätzliche Verwendung des Doctype Helfers

Der Doctype kann jederzeit spezifiziert werden. Trotzdem werden Helfer die vom Doctype abhängen, diesen erst
erkennen wenn er gesetzt wurde, sodas der einfachste Weg darin besteht Ihn in der Bootstrap zu spezifizieren:

.. code-block:: php
   :linenos:

   $doctypeHelper = new Zend\View\Helper\Doctype();
   $doctypeHelper->doctype('XHTML1_STRICT');

Und Ihn dann am Beginn des Layout Scripts ausgeben:

.. code-block:: php
   :linenos:

   <?php echo $this->doctype() ?>

.. _zend.view.helpers.initial.doctype.retrieving:

.. rubric:: Empfangen des Doctypes

Wenn man den Doctype wissen will, kann einfach ``getDoctype()`` auf dem Objekt aufgerufen werden, welches vom
aufgerufenen Helfer zurückgegeben wird.

.. code-block:: php
   :linenos:

   $doctype = $view->doctype()->getDoctype();

Typischerweise wird man einfach wissen wollen, ob der Doctype *XHTML* ist oder nicht; hierfür ist die
``isXhtml()`` Methode ausreichend:

.. code-block:: php
   :linenos:

   if ($view->doctype()->isXhtml()) {
       // etwas anderes machen
   }

Man kann auch prüfen ob der Doctype ein *HTML5* Dokument repräsentiert

.. code-block:: php
   :linenos:

   if ($view->doctype()->isHtml5()) {
       // etwas anderes machen
   }


