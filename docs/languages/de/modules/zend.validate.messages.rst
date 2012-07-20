.. _zend.validate.messages:

Prüfungsmeldungen
=================

Jede Prüfung die auf ``Zend_Validate`` basiert, bietet im Fall einer fehlgeschlagen Prüfung eine oder mehrere
Meldungen an. Diese Information kann verwendet werden um eigene Meldungen zu setzen, oder bestehende Meldungen
welche eine Prüfung zurückgeben könnte, auf etwas anderes zu übersetzen.

Diese Prüfmeldungen sind Konstanten welche am Beginn jeder Prüfklasse gefunden werden können. Sehen wir uns für
ein beschreibendes Beispiel ``Zend_Validate_GreaterThan`` an:

.. code-block:: php
   :linenos:

   protected $_messageTemplates = array(
       self::NOT_GREATER => "'%value%' is not greater than '%min%'",
   );

Wie man siehr referenziert die Konstante ``self::NOT_GREATER`` auf den Fehler und wird als Schlüssel verwendet.
Und die Nachricht selbst ist der Wert des Nachrichtenarrays.

Man kann alle Nachrichten Templates einer Prüfung erhalten indem man die Methode ``getMessageTemplates()``
verwendet. Diese gibt das oben stehende array zurück, welches alle Nachrichten enthält die eine Prüfung im Falle
einer fehlgeschlagenen Prüfung zurückgeben kann.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_GreaterThan();
   $messages  = $validator->getMessageTemplates();

Indem die Methode ``setMessage()`` verwendet wird kann man eine andere Meldung definieren die im Fall des
spezifizierten Fehlers zurückgegeben werden.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_GreaterThan();
   $validator->setMessage(
       'Bitte einen kleineren Wert angeben',
       Zend_Validate_GreaterThan::NOT_GREATER
   );

Der zweite Parameter definiert den Fehler der überschrieben wird. Wenn man diesen Parameter nicht angibt, wird die
angegebene Meldung für alle möglichen Fehler dieser Prüfung gesetzt.

.. _zend.validate.messages.pretranslated:

Verwendung vor-übersetzter Prüfungsmeldungen
--------------------------------------------

Zend Framework wird mit mehr als 45 unterschiedlichen Prüfern und mehr als 200 Fehlermeldungen ausgeliefert. Es
kann eine zeitraubende Aufgabe sein alle diese Meldungen zu übersetzen. Aber der Bequemlichkeit halber kommt Zend
Framework mit bereits vor-übersetzten Prüfmeldungen. Diese können im Pfad ``/resources/languages`` der eigenen
Zend Framework Installation gefunden werden.

.. note::

   **Verwendeter Pfad**

   Die Ressource Dateien liegen ausserhalb des Bibliothekspfads weil alle Übersetzungen ausserhalb dieses Pfades
   liegen sollten.

Um also alle Prüfmeldungen zum Beispiel auf Deutsch zu übersetzen muss man nur einen Übersetzer an
``Zend_Validate`` anhängen der diese Ressourcedateien verwendet.

.. code-block:: php
   :linenos:

   $translator = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => '/resources/languages',
           'locale'  => $language,
           'scan'    => Zend_Translator::LOCALE_DIRECTORY
       )
   );
   Zend_Validate_Abstract::setDefaultTranslator($translator);

.. note::

   **Verwendeter Übersetzungsadapter**

   Als Übersetzungsadapter hat Zend Framework den Array Adapter ausgewählt. Er ist einfach zu bearbeiten und sehr
   schnell erstellt.

.. note::

   **Unterstützte Sprachen**

   Dieses Feature ist sehr jung, und deshalb ist die Anzahl der unterstützten Sprachen nicht sehr komplett. Neue
   Sprachen werden mit jedem Release hinzugefügt. Zusätzlich können die existierenden Ressourcedateien verwendet
   werden um eigene Übersetzungen durchzuführen.

   Man kann diese Ressource Dateien auch verwenden um existierende Übersetzungen umzuschreiben. Man muss diese
   Dateien also nicht selbst per Hand erstellen.

.. _zend.validate.messages.limitation:

Begrenzen der Größe einer Prüfungsmeldung
-----------------------------------------

Manchmal ist es notwendig die maximale Größe die eine Prüfungsmeldung haben kann zu begrenzen. Zum Beispiel wenn
die View nur eine maximale Größe von 100 Zeichen für die Darstellung auf einer Zeile erlaubt. Um die Verwendung
zu vereinfachen, ist ``Zend_Validate`` dazu in der Lage die maximal zurückgegebene Größe einer Prüfnachricht zu
begrenzen.

Um die aktuell gesetzte Größe zu erhalten ist ``Zend_Validate::getMessageLength()`` zu verwenden. Wenn diese -1
ist, dann wird die zurückgegebene Nachricht nicht begrenzt. Das ist das Standardverhalten.

Um die Größe der zurückgegebenen Nachrichten zu begrenzen ist ``Zend_Validate::setMessageLength()`` zu
verwenden. Man kann diese auf jede benötigte Integer Größe setzen. Wenn die zurückzugebende Nachricht die
gesetzte Größe überschreitet, dann wird die Nachricht abgeschnitten und der String '**...**' wird statt dem Rest
der Nachricht hinzugefügt.

.. code-block:: php
   :linenos:

   Zend_Validate::setMessageLength(100);

.. note::

   **Wo wird dieser Parameter verwendet?**

   Die gesetzte Länge der Nachrichten wird für alle Prüfungen verwendet, sogar für selbstdefinierte, solange
   Sie ``Zend_Validate_Abstract`` erweitern.


