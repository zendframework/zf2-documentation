.. _zend.currency.position:

Wo ist die Währung?
===================

Die Position an welche das Währungssymbol oder der Namen angezeigt werden hängt vom Gebietsschema ab. Trotzdem
kann man, wenn das gewünscht ist, eigene Einstellungen definieren indem die Option ``display`` verwendet wird und
eine der folgenden Konstanten angegeben wird:

.. _zend.currency.position.table-1:

.. table:: Vorhadene Positionen für die Währung

   +---------+--------------------------------------------------------------------+
   |Konstante|Beschreibung                                                        |
   +=========+====================================================================+
   |STANDARD |Setzt die Standardposition wie Sie im Gebietsschema definiert ist   |
   +---------+--------------------------------------------------------------------+
   |RIGHT    |Zeigt die Darstellung der Währung an der rechten Seite des Wertes an|
   +---------+--------------------------------------------------------------------+
   |LEFT     |Zeigt die Darstellung der Währung an der linken Seite des Wertes an |
   +---------+--------------------------------------------------------------------+

.. _zend.currency.position.example-1:

.. rubric:: Setzen der Währungsposition

Angenommen der Client hat wieder mal "en_US" als Gebietsschema gesetzt. Wenn keine Option verwendet wird könnte
der Wert wie folgt aussehen:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value' => 100,
       )
   );

   print $currency; // Könnte '$ 100' zurückgeben

Bei Verwendung der Standardeinstellung würde die Währung (in unserem Fall $) also entweder links oder rechts vom
Wert dargestellt werden. Jetzt definieren wir eine fixe Position:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 100,
           'position' => Zend_Currency::RIGHT,
       )
   );

   print $currency; // Könnte '100 $' zurückgeben

Es ist zu beachten das im zweiten Codeabschnitt die Position von *USD* fixiert ist, unabhängig vom verwendeten
Gebietsschema oder der Währung.


