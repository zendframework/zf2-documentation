.. EN-Revision: none
.. _zend.validate.set.date:

Date
====

``Zend\Validate\Date`` erlaubt es zu prüfen ob ein angegebener Wert ein Datum enthält. Diese Prüfung prüft auch
lokalisierte Eingaben.

.. _zend.validate.set.date.options:

Unterstützte Optionen für Zend\Validate\Date
--------------------------------------------

Die folgenden Optionen werden für ``Zend\Validate\Date`` unterstützt:

- **format**: Setzt das Format welches verwendet wird um das Datum zu schreiben.

- **locale**: Setzt das Gebietsschema welches verwendet wird um Datumswerte zu prüfen.

.. _zend.validate.set.date.basic:

Standardmäßige Datumsprüfung
----------------------------

Der einfachste Weg um ein Datum zu prüfen ist die Verwendung des Standardmäßigen Datumsformats. Dieses wird
verwendet wenn kein Gebietsschema und kein Format angegeben werden.

.. code-block:: .validator.
   :linenos:

   $validator = new Zend\Validate\Date();

   $validator->isValid('2000-10-10');   // Gibt true zurück
   $validator->isValid('10.10.2000'); // Gibt false zurück

Das standardmäßige Datumsformat für ``Zend\Validate\Date`` ist 'yyyy-MM-dd'.

.. _zend.validate.set.date.formats:

Selbst definierte Datumsprüfung
-------------------------------

``Zend\Validate\Date`` unterstützt auch selbst definierte Datumsformate. Wenn man solch ein Datum prüfen will
muss man die Option ``format`` verwenden.

.. code-block:: .validator.
   :linenos:

   $validator = new Zend\Validate\Date(array('format' => 'yyyy'));

   $validator->isValid('2010'); // Gibt true zurück
   $validator->isValid('May');  // Gibt false zurück

Natürlich kann man ``format`` und ``locale`` kombinieren. In diesem Fall kann man lokalisierte Monats- oder
Tagesnamen verwenden.

.. code-block:: .validator.
   :linenos:

   $validator = new Zend\Validate\Date(array('format' => 'yyyy MMMM', 'locale' => 'de'));

   $validator->isValid('2010 Dezember'); // Gibt true zurück
   $validator->isValid('2010 June');     // Gibt false zurück


