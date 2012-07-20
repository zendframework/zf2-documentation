.. _zend.validate.set.stringlength:

StringLength
============

Diese Prüfung erlaubt es zu prüfen ob ein angegebener String eine definierte Länge besitzt.

.. note::

   **Zend_Validate_StringLength unterstützt nur die Prüfung von Strings**

   Es ist zu beachten das ``Zend_Validate_StringLength`` nur die Prüfung von Strings unterstützt. Integer,
   Floats, Datumswerte oder Objekte können mit dieser Prüfung nicht überprüft werden.

.. _zend.validate.set.stringlength.options:

Unterstützte Optionen für Zend_Validate_StringLength
----------------------------------------------------

Die folgenden Optionen werden von ``Zend_Validate_StringLength`` unterstützt:

- **encoding**: Setzt die Kodierung von ``ICONV`` welche für den String verwendet wird.

- **min**: Setzt die erlaubte Mindestlänge für einen String.

- **max**: Setzt die erlaubte Maximallänge für einen String.

.. _zend.validate.set.stringlength.basic:

Standardverhalten für Zend_Validate_StringLength
------------------------------------------------

Standardmäßig prüft diese Prüfung ob ein Wert zwischen ``min`` und ``max`` ist. Aber für ``min`` ist der
Standardwert **0** und für ``max`` ist er **NULL**, was unlimitiert bedeutet.

Deshalb prüft diese Prüfung standardmäßig, ohne das eine Option angegeben wurde, nur ob die Eingabe ein String
ist.

.. _zend.validate.set.stringlength.maximum:

Die maximal erlaubte Länge eines String begrenzen
-------------------------------------------------

Um die maximal erlaubte Länge eines Strings zu begrenzen muss man die Eigenschaft ``max`` setzen. Sie akzeptiert
einen Integerwert als Eingabe.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(array('max' => 6));

   $validator->isValid("Test"); // Gibt true zurück
   $validator->isValid("Testing"); // Gibt false zurück

Man kann die maximal erlaubte Länge auch im Nachhinein setzen indem die ``setMax()`` Methode verwendet wird. Und
``getMax()`` um die aktuelle maximale Grenze zu erhalten.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength();
   $validator->setMax(6);

   $validator->isValid("Test"); // Gibt true zurück
   $validator->isValid("Testing"); // Gibt false zurück

.. _zend.validate.set.stringlength.minimum:

Die mindestens benötigte Länge eines Strings begrenzen
------------------------------------------------------

Um die mindestens benötigte Länge eines Strings zu begrenzen muss man die Eigenschaft ``min`` setzen. Sie
akzeptiert einen Integerwert als Eingabe.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(array('min' => 5));

   $validator->isValid("Test"); // Gibt false zurück
   $validator->isValid("Testing"); // Gibt true zurück

Man kann die mindestens benötigte Länge auch im Nachhinein setzen indem die ``setMin()`` Methode verwendet wird.
Und ``getMin()`` um die aktuelle Mindestgrenze zu erhalten.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength();
   $validator->setMin(5);

   $validator->isValid("Test"); // Gibt false zurück
   $validator->isValid("Testing"); // Gibt true zurück

.. _zend.validate.set.stringlength.both:

Einen String auf beiden Seiten begrenzen
----------------------------------------

Manchmal ist es notwendig einen String zu erhalten der eine maximal definierte Länge, aber auch eine Mindestlänge
hat. Wenn man, zum Beispiel, eine Textbox hat in welcher der Benutzer seinen Namen angeben kann, könnte man den
Namen auf maximal 30 Zeichen begrenzen. Aber man will auch sicher gehen das er seinen Namen angegeben hat. Deshalb
setzt man die zumindest benötigte Länge auf 3 Zeichen. Siehe das folgende Beispiel:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(array('min' => 3, 'max' => 30));

   $validator->isValid("."); // Gibt false zurück
   $validator->isValid("Test"); // Gibt true zurück
   $validator->isValid("Testing"); // Gibt true zurück

.. note::

   **Eine kleinere Maximalgrenze als die Mindestgrenze setzen**

   Wenn man versucht eine kleinere Maximalgrenze zu setzen als der aktuelle Mindestwert, oder eine größere
   Mindestgrenze als den aktuellen Maximalwert, dann wird eine Exception geworfen.

.. _zend.validate.set.stringlength.encoding:

Kodierung von Werten
--------------------

Strings verwenden immer eine Kodierung. Selbst wenn man keine explizite Kodierung verwendet, dann verwendet *PHP*
eine. Wenn die eigene Anwendung eine andere Kodierung verwendet als *PHP* selbst, dann sollte man eine Kodierung
setzen.

Man kann eine eigene Kodierung bei der Instanzierung mit der ``encoding`` Option setzen, oder indem die
``setEncoding()`` Methode verwendet wird. Wir nehmen an das die eigene Installation *ISO* verwendet und die
Anwendung auf *ISO* gesetzt ist. In diesem Fall sieht man das folgende Verhalten.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(
       array('min' => 6)
   );
   $validator->isValid("Ärger"); // Gibt false zurück

   $validator->setEncoding("UTF-8");
   $validator->isValid("Ärger"); // Gibt true zurück

   $validator2 = new Zend_Validate_StringLength(
       array('min' => 6, 'encoding' => 'UTF-8')
   );
   $validator2->isValid("Ärger"); // Gibt true zurück

Wenn die eigene Installation und die Anwendung also unterschiedliche Kodierungen verwenden, dann sollte man immer
selbst eine Kodierung setzen.


