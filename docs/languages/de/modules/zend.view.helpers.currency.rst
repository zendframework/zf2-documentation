.. _zend.view.helpers.initial.currency:

Currency Helfer
===============

Das anzeigen von lokalisierten Währungswerten ist eine übliche Aufgabe; der View Helfer ``Zend_Currency`` dient
dazu diese Aufgabe zu vereinfachen. Siehe auch die :ref:`Dokumentation von Zend_Currency
<zend.currency.introduction>` für Details über dieses Lokalisierungs-Feature. In diesem Abschnitt fokusieren wir
uns nur auf die Verwendung des View Helfers.

Es gibt verschiedene Wege um den **Currency** View Helfer zu initiieren:

- Registriert, über eine vorher in ``Zend_Registry`` registrierte Instanz:

- Im Nachhinein, über das Fluent Interface.

- Direkt, über Instanzierung der Klasse.

Eine registrierte Instanz von ``Zend_Currency`` ist der vorgeschlagene Weg für diesen Helfer. Wenn man dies macht
kann die Währung welche verwendet werden soll ausgewählt werden bevor der Adapter der Registry hinzugefügt wird.

Es gibt verschiedene Wege die gewünschte Währung auszuwählen. Erstens kann man einfach einen Währungs-String
übergeben; alternativ kann man ein Gebietsschema spezifizieren. Der vorgeschlagene Weg ist die Verwendung eines
Gebietsschemas, da diese Information automatisch erkannt und über den *HTTP* Client Header ausgewählt wird wenn
ein Benutzer auf die Anwendung zugreift. Und es stellt sicher das die angebotene Währung mit seinem Gebietsschema
übereinstimmt.

.. note::

   Wir sprechen von "Gebietsschemas" statt von "Sprachen" weil Sprachen, basierend auf der geographischen Region in
   welcher Sie verwendet werden, sehr unterschiedlich sein können. Zum Beispiel wird Englisch in unterschiedlichen
   Dialekten gesprochen: Brittisches Englisch, Amerikanisches Englisch, usw. Da eine Währung immer mit einem Land
   korreliert muss ein voll-qualifiziertes Gebietsschema angegeben werden. Dies bedeutet dass beides, sowohl die
   Sprache **als auch** die Region angegeben werden müssen. Deswegen sagen wir "Gebietsschema" statt "Sprache".

.. _zend.view.helpers.initial.currency.registered:

.. rubric:: Registrierte Instanz

Um eine registrierte Instanz zu verwenden muss einfach eine Instanz von ``Zend_Currency`` erstellt und in
``Zend_Registry`` registriert werden, wobei der Schlüssel ``Zend_Currency`` zu verwenden ist.

.. code-block:: php
   :linenos:

   // Unsere Beispielwährung
   $currency = new Zend_Currency('de_AT');
   Zend_Registry::set('Zend_Currency', $currency);

   // In der View
   echo $this->currency(1234.56);
   // Gibt '€ 1.234,56' zurück

Wenn man das Fluent Interface verwenden will, kann man auch eine Instanz in der View erstellen und den Helfer im
Nachhinein konfigurieren.

.. _zend.view.helpers.initial.currency.afterwards:

.. rubric:: In der View

Um das Fluent Interface zu verwenden muss eine Instanz von ``Zend_Currency`` erstellt, der Helfer ohne Parameter
aufgerufen, und dann die Methode ``setCurrency()`` aufgerufen werden.

.. code-block:: php
   :linenos:

   // In der View
   $currency = new Zend_Currency('de_AT');
   $this->currency()->setCurrency($currency)->currency(1234.56);
   // Gibt '€ 1.234,56' zurück

Wenn man den Helfer ohne ``Zend_View`` verwenden will kann man Ihn auch direkt verwenden.

.. _zend.view.helpers.initial.currency.directly.example-1:

.. rubric:: Direkte Verwendung

.. code-block:: php
   :linenos:

   // Unsere Beispielwährung
   $currency = new Zend_Currency('de_AT');

   // Den Helfer initiieren
   $helper = new Zend_View_Helper_Currency($currency);
   echo $helper->currency(1234.56); // Gibt '€ 1.234,56' zurück

Wie bereits gesehen wird die Methode ``currency()`` verwendet um den Währungs-String zurückzugeben. Sie muss nur
mit dem Wert aufgerufen werden den man als Währung angezeigt haben will. Sie akzeptiert auch einige Optionen
welche verwendet werden können um das Verhalten des Helfers bei der Ausgabe zu ändern.

.. _zend.view.helpers.initial.currency.directly.example-2:

.. rubric:: Direkte Verwendung

.. code-block:: php
   :linenos:

   // Unsere Beispielwährung
   $currency = new Zend_Currency('de_AT');

   // Den Helfer initiieren
   $helper = new Zend_View_Helper_Currency($currency);
   echo $helper->currency(1234.56); // Gibt '€ 1.234,56' zurück
   echo $helper->currency(1234.56, array('precision' => 1));
   // Gibt '€ 1.234,6' zurück

Für Details über die vorhandenen Optionen sollte man in ``Zend_Currency``'s ``toCurrency()`` Methode nachsehen.


