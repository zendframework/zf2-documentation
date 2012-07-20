.. _zend.view.helpers.initial.inlinescript:

InlineScript Helfer
===================

Das *HTML* **<script>** Element wird verwendet um entweder Clientseitige Skriptelemente Inline zu ermöglichen oder
um eine entfernte Ressource zu verlinken die Clientseitigen Skriptcode enthält. Der ``InlineScript`` Helfer
erlaubt es beides zu managen. Er ist von :ref:`HeadScript <zend.view.helpers.initial.headscript>` abgeleitet und
jede Methode dieses Helfers ist vorhanden; trotzdem, sollte die ``inlineScript()`` Methode statt ``headScript()``
verwendet werden.

.. note::

   **InlineScript für HTML Body Skripte verwenden**

   ``InlineScript``, sollte verwendet werden wenn man Skripte im *HTML* **body** inkludieren will. Skripte am Ende
   des Dokuments zu platzieren ist eine gute Praxis um das Versenden von Seiten schneller zu machen, speziell wen
   3rd Party Analyse Skripte verwendet werden.

   Einige JS Bibliotheken müssen im *HTML* **head**; für diese Skripte sollte :ref:`HeadScript
   <zend.view.helpers.initial.headscript>` verwendet werden.


