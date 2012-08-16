.. EN-Revision: none
.. _zend.validator.set.iban:

Iban
====

``Zend_Validate_Iban`` prüft ob ein angegebener Wert eine *IBAN* Nummer sein könnte. *IBAN* ist die Abkürzung
für "International Bank Account Number".

.. _zend.validator.set.iban.options:

Unterstützte Optionen für Zend_Validate_Iban
--------------------------------------------

Die folgenden Optionen werden für ``Zend_Validate_Iban`` unterstützt:

- **locale**: Setzt das Gebietsschema welches verwendet wird um das *IBAN* Format für die Prüfung zu erhalten.

.. _zend.validator.set.iban.basic:

IBAN Prüfung
------------

*IBAN* Nummern sind immer in Bezug zu einem Land. Dies bedeutet dass unterschiedliche Länder unterschiedliche
Formate für Ihre *IBAN* Nummern verwenden. Das ist der Grund dafür warum *IBAN* nummern immer ein Gebietsschema
benötigen. Wenn wir dies wissen, dann wissen wir bereits wie wir ``Zend_Validate_Iban`` verwenden können.

.. _zend.validator.set.iban.basic.application:

Anwendungsweites Gebietsschema
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wir können das Anwendungsweite Gebietsschema verwenden. Dass bedeutet, wenn keine Option bei der Instanzierung
angegeben wird, das ``Zend_Validate_Iban`` nach dem Anwendungsweiten Gebietsschema sucht. Siehe den folgenden
Codeabschnitt:

.. code-block:: php
   :linenos:

   // In der Bootstrap
   Zend_Registry::set('Zend_Locale', new Zend_Locale('de_AT'));

   // Im Modul
   $validator = new Zend_Validate_Iban();

   if ($validator->isValid('AT611904300234573201')) {
       // IBAN scheint gültig zu sein
   } else {
       // IBAN ist ungültig
   }

.. note::

   **Anwendungsweites Gebietsschema**

   Natürlich funktioniert dies nur wenn das Anwendungsweite Gebietsschema in der Registry vorher gesetzt wurde.
   Andernfalls wird ``Zend_Locale`` versuchen das Gebietsschema zu verwenden welches der Client sendet, oder wenn
   keines gesendet wurde, das Gebietsschema der Umgebung. Man sollte darauf achten das dies zu ungewünschtem
   Verhalten bei der Prüfung führen kann.

.. _zend.validator.set.iban.basic.false:

Unscharfe IBAN Prüfung
^^^^^^^^^^^^^^^^^^^^^^

Manchmal ist es nützlich, nur zu prüfen ob der angegebene Wert eine *IBAN* Nummer **ist** oder nicht. Das
bedeutet das man nicht auf ein definiertes Land prüfen will. Das kann getan werden indem ein ``FALSE`` als
Gebietsschema verwendet wird.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Iban(array('locale' => false));
   // Achtung: Man kann ein FALSE auch als einzelnen Parmeter setzen

   if ($validator->isValid('AT611904300234573201')) {
       // IBAN scheint gültig zu sein
   } else {
       // IBAN ist nicht gültig
   }

So wird **jede** *IBAN* Nummer gültig sein. Es ist zu beachten dass man dies nicht tun sollte wenn man nur Konten
von einem einzelnen Land akzeptiert.

.. _zend.validator.set.iban.basic.aware:

Gebietsschema verwendende IBAN Prüfung
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Um gegen ein definiertes Land zu prüfen muss man nur das gewünschte Gebietsschema angeben. Man kann dies mit der
``locale`` Option tun, und bei Verwendung von ``setLocale()`` auch im Nachhinein.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_Iban(array('locale' => 'de_AT'));

   if ($validator->isValid('AT611904300234573201')) {
       // IBAN scheint gültig zu sein
   } else {
       // IBAN ist ungültig
   }

.. note::

   **Vollständig qualifizierte Gebietsschemas verwenden**

   Man muss ein vollständig qualifiziertes Gebietsschema verwenden. Andernfalls kann das Land nicht korrekt
   erkannt werden, da gleiche Sprachen in mehreren Ländern gesprochen werden.


