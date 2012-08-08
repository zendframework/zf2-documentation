.. EN-Revision: none
.. _zend.view.helpers.initial.json:

Helper JSON
===========

Przy tworzeniu widoków które zwracają obiekt JSON trzeba ustawić odpowiedni nagłówek. Tym właśnie się
zajmuje helper JSON, a dodatkowo domyślnie wyłącza layouty (jeżeli są aktywne).

Helper JSON ustawia następujący nagłówek

.. code-block:: php
   :linenos:

   Content-Type: application/json


Większość bibliotek Ajaxowych szuka tego nagłowka podczas parsowania odpowiedzi aby ustalić jak obsłużyć
zawartość.

Użycie helpera jest następujące:

.. code-block:: php
   :linenos:

   <?= $this->json($this->data) ?>



