.. EN-Revision: none
.. _migration.110:

Zend Framework 1.10
===================

Wenn man von einem älteren Release auf Zend Framework 1.10 oder höher hochrüstet sollte man die folgenden
Migrations Hinweise beachten.

.. _migration.110.zend.controller.front:

Zend\Controller\Front
---------------------

Ein fehlerhaftes Verhalten wurde behoben, welches aufgetreten ist wenn keine Modell Route und keine Route mit der
angegebenen Anfrage übereinstimmt. Vorher hat der Router das nicht modifizierte Anfrageobjekt zurückgegeben, und
der Frontcontroller hat damit nur den Standardcontroller und die Standardaktion angezeigt. Seit Zend Framework 1.10
wirft der Router korrekterweise, wie im Router Interface beschrieben, eine Exception wenn keine passende Route
vorhanden ist. Das Error Plugin fängt die Exception und leitet Sie an den Errorcontroller weiter. Man kann mit der
Konstante ``Zend\Controller_Plugin\ErrorHandler::EXCEPTION_NO_ROUTE`` auf einen spezifischen Fehler testen:

.. code-block:: php
   :linenos:

   /**
    * Vor 1.10
    */
       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend\Controller_Plugin\ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend\Controller_Plugin\ErrorHandler::EXCEPTION_NO_ACTION:
       // ...

   /**
    * Ab 1.10
    */
       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend\Controller_Plugin\ErrorHandler::EXCEPTION_NO_ROUTE:
               case Zend\Controller_Plugin\ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend\Controller_Plugin\ErrorHandler::EXCEPTION_NO_ACTION:
        // ...

.. _migration.110.zend.feed.reader:

Migrating from 1.9.6 to 1.10 or later
-------------------------------------

Mit der Einführung von Zend Framework 1.10 wurde die Behandlung für das Empfangen von Autoren und Entwicklern in
``Zend\Feed\Reader`` geändert. Diese Änderung war ein Weg die Behandlung solcher Daten zwischen RSS und Atom
Klassen zwischen den Komponenten zu harmonisieren und die Rückgabe von Autoren und Entwicklern in einer besseren,
verwendbareren und detailuerteren Form zu ermöglichen. Das korrigiert auch einen Fehler bei dem angenommen wurde
das jedes Autor Element auf einen Namen zeigt. In RSS ist das falsch, da ein Autor Element aktuell nur eine Email
Adresse anbieten muss. Zusätzlich fügte die originale Implementation seine RSS Limits bei Atom Feeds hinzu was zu
einer Reduzierung der Nützlichkeit des Parsers mit diesem Format führte.

Die Änderung bedeutet das Methoden wie ``getAuthors()`` und ``getContributors`` nicht länger ein einfaches Array
von Strings zurückgeben die von den relevanten RSS und Atom Elementen geparst wurden Statt dessen ist der
Rückgabewert eine Unterklasse von ``ArrayObject`` die ``Zend\Feed\Reader\Collection\Author`` genannt wird und ein
aufzählbares multidimensionales Array an Autoren simuliert. Jedes Mitglied dieses Objekts ist ein einfaches Array
mit drei potentiellen Schlüsseln (wie in den Quelldaten erlaubt). Diese beinhalten name, email und uri.

Das originale Verhalten dieser Methoden würde ein einfaches Array von Strings zurückgeben, wobei jeder String
versucht einen einzelnen Namen zu präsentieren, aber in der Realität war dies nicht möglich da es keine Regel
gibt die das Format der RSS Autor Strings leiten.

Die einfachste Methode der Simulation des originalen Verhaltens dieser Methoden ist die Verwendung von
``Zend\Feed\Reader\Collection\Author``'s ``getValues()`` welche auch ein einfaches Array an Strings darstellt und
die "relevantesten Daten" repräsentiert. Für Autoren wird deren Name angenommen. Jeder Wert in resultierenden
Array wird vom "name" Wert abgeleitet welcher jedem Autor angehängt ist (wenn vorhanden). In den meisten Fällen
ist diese einfache Änderung einfach durchzuführen wie anbei demonstriert.

.. code-block:: php
   :linenos:

   /**
    * In 1.9.6
    */
   $feed = Zend\Feed\Reader::import('http://example.com/feed');
   $authors = $feed->getAuthors();

   /**
    * Äquivalent in 1.10
    */
   $feed = Zend\Feed\Reader::import('http://example.com/feed');
   $authors = $feed->getAuthors()->getValues();

.. _migration.110.zend.filter.html-entities:

Zend\Filter\HtmlEntities
------------------------

Um zu einem höheren Sicherheitsstandard für die Zeichenkodierung zu kommen, ist der Standardwert von
``Zend\Filter\HtmlEntities`` jetzt *UTF-8* statt *ISO-8859-1*.

Zusätzlich, weil der aktuelle Mechanismus mit Zeichenkodierung handelt und nicht mit Zeichensets, wurden zwei
Methoden hinzugefügt. ``setEncoding()`` und ``getEncoding()``. Die vorhergehenden Methoden ``setCharSet()`` und
``setCharSet()`` sind jetzt deprecated und verweisen auf die neuen Methoden. Letztendlich, statt die geschützten
Mitglieder in der ``filter()`` Methode direkt zu verwenden, werden Sie durch Ihre expliziten Zugriffsmethoden
empfangen. Wenn man den Filter in der Vergangenheit erweitert hat, sollte man seinen Code und seine Unittests
prüfen um sicherzustellen das weiterhin alles funktioniert.

.. _migration.110.zend.filter.strip-tags:

Zend\Filter\StripTags
---------------------

``Zend\Filter\StripTags`` enthielt in voehergehenden Versionen ein ``commentsAllowed`` Flag, welches es erlaubt hat
*HTML* Kommentare in von dieser Klasse gefiltertem *HTML* Text als erlaubt zu markieren. Aber das öffnet den Weg
für *XSS* Attacken, speziell im Internet Explorer (der es erlaubt konditionelle Funktionalität über *HTML*
Kommentare zu spezifizieren). Beginnend mit Version 1.9.7 (und retour mit den Versionen 1.8.5 und 1.7.9), hat das
``commentsAllowed`` Flag keine Bedeutung meht, und alle *HTML* Kommentare, inklusive denen die andere *HTML* Tags
oder untergeordnete Kommentare enthalten, werden von der endgültigen Aufgabe des Filters entfernt.

.. _migration.110.zend.file.transfer:

Zend\File\Transfer
------------------

.. _migration.110.zend.file.transfer.files:

Sicherheitsänderung
^^^^^^^^^^^^^^^^^^^

Aus Gründen der Sicherheit speichert ``Zend\File\Transfer`` nicht länger die originalen Mimetypen und
Dateigrößen welche vom anfragenden Client angegeben wurden in seinem internen Speicher. Stattdessen werden die
echten Werte bei der Instanzierung erkannt.

Zusätzlich werden die originalen Werte in ``$_FILES`` bei der Instanzierung mit den echten Werten überschrieben.
Das macht auch ``$_FILES`` sicher.

Wenn man die originalen Werte benötigt, kann man diese entweder vor der Instanzierung von ``Zend\File\Transfer``
speichern, oder bei der Instanzierung die Option ``disableInfos`` verwenden. Es ist zu beachten das diese Option
sinnlos ist wenn Sie nach der Instanzierung verwendet wird.

.. _migration.110.zend.file.transfer.count:

Count Prüfung
^^^^^^^^^^^^^

Vor dem Release 1.10 hat die ``MimeType`` Prüfung eine falsche Benennung verwendet. Aus Gründen der Konsistenz
wurden die folgenden Konstanten geändert:

.. _migration.110.zend.file.transfer.count.table:

.. table:: Geänderte Prüfmeldungen

   +--------+--------+-------------------------------------------------------------------+
   |Alt     |Neu     |Wert                                                               |
   +========+========+===================================================================+
   |TOO_MUCH|TOO_MANY|Too many files, maximum '%max%' are allowed but '%count%' are given|
   +--------+--------+-------------------------------------------------------------------+
   |TOO_LESS|TOO_FEW |Too few files, minimum '%min%' are expected but '%count%' are given|
   +--------+--------+-------------------------------------------------------------------+

Wenn man diese Meldungen im eigenen Code übersetzt dann sollte man die neuen Konstanten verwenden. Als Vorteil
muss man den originalen String im englischen nicht mehr übersetzen um die richtige Schreibweise zu erhalten.

.. _migration.110.zend.translator:

Zend_Translator
---------------

.. _migration.110.zend.translator.xliff:

Xliff Adapter
^^^^^^^^^^^^^

In der Vergangenheit hat der Xliff Adapter den Source String als Message Id verwendet. Laut dem Xliff Standard
sollte die trans-unit Id verwendet werden. Dieses Verhalten wurde mit Zend Framework 1.10 korrigiert. Jetzt wird
standardmäßig die trans-unit Id als Message Id verwendet.

Aber man kann trotzdem das falsch und alte Verhalten bekommen indem die ``useId`` Option auf ``FALSE`` gesetzt
wird.

.. code-block:: php
   :linenos:

   $trans = new Zend\Translator\Translator(
       'xliff', '/path/to/source', $locale, array('useId' => false)
   );

.. _migration.110.zend.validate:

Zend_Validate
-------------

.. _migration.110.zend.validate.selfwritten:

Selbst geschriebene Adapter
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wenn in einer selbst geschriebenen Prüfung ein Fehler gesetzt wird um diesen zurückzugeben muß die ``_error()``
Methode aufgerufen werden. Vor Zend Framework 1.10 konnte man diese Methode ohne einen angegebenen Parameter
aufrufen. Es wurde dann das erste gefundene Nachrichtentemplate verwendet.

Dieses Verhalten ist problematisch wenn man Prüfungen hat die mehr als eine Nachricht zurückgeben kann. Auch wenn
man eine existierende Prüfung erweitert kann man unerwartete Ergebnisse erhalten. Das kann zum Problem führen das
der Benutzer nicht die Nachricht erhält die man erwartet.

.. code-block:: php
   :linenos:

   My_Validator extends Zend\Validate\Abstract
   {
       public isValid($value)
       {
           ...
           $this->_error(); // Unerwartete Ergebnisse zwischen verschiedenen OS
           ...
       }
   }

Um dieses Problem zu verhindern erlaubt es die ``_error()`` Methode nicht mehr ohne einen angegebenen Parameter
aufgerufen zu werden.

.. code-block:: php
   :linenos:

   My_Validator extends Zend\Validate\Abstract
   {
       public isValid($value)
       {
           ...
           $this->_error(self::MY_ERROR);
           // Definierter Fehler, keine unerwarteten Ergebnisse
           ...
       }
   }

.. _migration.110.zend.validate.datevalidator:

Vereinfachungen im Date Prüfer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vor Zend Framework 1.10 wurden 2 identische Nachrichten im Date Prüfer geworfen. Es gab ``NOT_YYYY_MM_DD`` und
``FALSEFORMAT``. Ab Zend Framework 1.10 wird nur mehr die ``FALSEFORMAT`` Meldung zurückgegeben wenn das
angegebene Datum mit dem gesetzten Format nicht übereinstimmt.

.. _migration.110.zend.validate.barcodevalidator:

Fehlerbehebungen im Alpha, Alum und Barcode Prüfer
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Vor dem Zend Framework 1.10 waren Nachrichten in den 2 Barcode Adaptern, dem Alpha und dem Alnum Prüfer identisch.
Das führte zu Problemen bei der Verwendung von eigenen Meldungen, Übersetzungen oder mehreren Instanzen dieser
Prüfer.

Mit Zend Framework 1.10 wurden die Werte dieser Konstanten so geändert das Sie eindeutig sind. Wenn man, so wie es
im Handbuhc erklärt wird, die Konstanten verwendet gibt es keine Änderungen. Aber wenn man den Inhalt der
Konstanten im eigenen Code verwendet dann muß man diese Ändern. Die folgende Tabelle zeigt die geänderten Werte:

.. _migration.110.zend.validate.barcodevalidator.table:

.. table:: Vorhandenen Meldungen der Prüfer

   +-------------+--------------+------------------+
   |Prüfer       |Konstante     |Wert              |
   +=============+==============+==================+
   |Alnum        |STRING_EMPTY  |alnumStringEmpty  |
   +-------------+--------------+------------------+
   |Alpha        |STRING_EMPTY  |alphaStringEmpty  |
   +-------------+--------------+------------------+
   |Barcode_Ean13|INVALID       |ean13Invalid      |
   +-------------+--------------+------------------+
   |Barcode_Ean13|INVALID_LENGTH|ean13InvalidLength|
   +-------------+--------------+------------------+
   |Barcode_UpcA |INVALID_LENGTH|upcaInvalidLength |
   +-------------+--------------+------------------+
   |Digits       |STRING_EMPTY  |digitsStringEmpty |
   +-------------+--------------+------------------+


