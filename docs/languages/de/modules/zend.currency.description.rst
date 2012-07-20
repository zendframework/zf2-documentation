.. _zend.currency.description:

Was macht eine Währung aus?
===========================

Eine Währung besteht aus verschiedenen Informationen. Einem Namen, einer Abkürzung und einem Zeichen. Jeder
dieser Werte könnte relevant sein um dargestellt zu werden, aber immer nur einer zur selben Zeit. Es würde keine
gute Praxis sein etwas wie "USD 1.000 $" anzuzeigen.

Hierfür unterstützt ``Zend_Currency`` die Definition der Währungsinformation welche dargestellt werden soll. Die
folgenden Konstanten können verwendet werden:

.. _zend.currency.description.table-1:

.. table:: Dargestellte Informationen für eine Währung

   +-------------+--------------------------------------------------------------------------------------------------------------------------------+
   |Konstante    |Beschreibung                                                                                                                    |
   +=============+================================================================================================================================+
   |NO_SYMBOL    |Es wird gar keine Darstellung einer Währung angezeigt                                                                           |
   +-------------+--------------------------------------------------------------------------------------------------------------------------------+
   |USE_SYMBOL   |Das Währungssymbol wird dargestellt. Für US Dollar wäre dies '$'                                                                |
   +-------------+--------------------------------------------------------------------------------------------------------------------------------+
   |USE_SHORTNAME|Die Abkürzung für diese Währung wird dargestellt. Für US Dollar wäre dies 'USD'. Die meisten Abkürzungen bestehen aus 3 Zeichen.|
   +-------------+--------------------------------------------------------------------------------------------------------------------------------+
   |USE_NAME     |Der komplette Name für diese Währung wird dargestellt. Für US Dollar wäre der komplette Name "US Dollar"                        |
   +-------------+--------------------------------------------------------------------------------------------------------------------------------+

.. _zend.currency.description.example-1:

.. rubric:: Auswahl der Währungsbeschreibung

Angenommen unser Client setzt wieder "en_US" als Gebietsschema. Wenn keine Option verwendet wird könnte der
zurückgegebene Wert wie folgt aussehen:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value' => 100,
       )
   );

   print $currency; // Könnte '$ 100' zurückgeben

Durch Angabe der richtigen Option kann definiert werden welche Information dargestellt werden soll.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'   => 100,
           'display' => Zend_Currency::USE_SHORTNAME,
       )
   );

   print $currency; // Könnte 'USD 100' zurückgeben

Ohne Angabe von ``display`` wird das Währungssymbol für die Darstellung des Objekts verwendet. Wen die Währung
kein Symbol hat wird die Abkürzung als Ersatz verwendet.

.. note::

   **Nicht alle Währungen haben Symbole**

   Man sollte beachten das nicht alle Währungen standardmäßige Währungssymbole haben. Das bedeutet, wenn es
   kein Standardsymbol gibt, und das Symbol als dargestellt setzt, wird man überhaupt keine dargestellte Währung
   haben, da das Symbol ein leerer String ist.

Manchmal ist es notwendig die Standardinformationen zu ändern. Man kann jede der drei Währungsinformationen
unabhängig setzen indem die richtige Option angegeben wird. Siehe das folgende Beispiel.

.. _zend.currency.description.example-2:

.. rubric:: Verändern der Beschreibung einer Währung

Angenommen unser Client hat wieder mal "en_US" als Gebietsschema gesetzt. Aber jetzt wollen sie nicht die
Standardeinstellungen verwenden sondern unsere eigene Beschreibung setzen. Das kann einfach durch Angabe der
richtigen Option durchgeführt werden:

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value' => 100,
           'name'  => 'Dollar',
       )
   );

   print $currency; // Könnte 'Dollar 100' zurückgeben

Man kann auch ein Symbol oder eine Abkürzung selbst setzen.

.. code-block:: php
   :linenos:

   $currency = new Zend_Currency(
       array(
           'value'    => 100,
           'symbol' => '$$$',
       )
   );

   print $currency; // Könnte '$$$ 100' zurückgeben

.. note::

   **Einstellungen für die automatische Anzeige**

   Wenn man einen Namen, eine Abkürzung oder ein Symbol selbst setzt, dann werden diese neuen Informationen
   automatisch gesetzt und dargestellt. Diese Vereinfachung verhindert das man die richtige ``display`` Option
   angeben muss wenn eine Information gesetzt wird.

   Wenn man also die Option ``sign`` verwendet kann man ``display`` unterdrücken und muss diese nicht auf
   '``USE_SYMBOL``' setzen.


