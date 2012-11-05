.. EN-Revision: none
.. _migration.17:

Zend Framework 1.7
==================

Wenn man von einem älteren Release auf Zend Framework 1.7 oder höher hochrüstet sollte man die folgenden
Migrations Hinweise beachten.

.. _migration.17.zend.controller:

Zend_Controller
---------------

.. _migration.17.zend.controller.dispatcher:

Änderungen im Dispatcher Interface
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Benutzer haben uns darauf aufmerksam gemacht das ``Zend\Controller\Action\Helper\ViewRenderer`` Methoden auf der
abstrakten Dispatcher Klasse verwendet hat die nicht im Dispatcher Interface waren. Die folgenden Methoden wurden
hinzugefügt um sicherzustellen das eigene Dispatcher weiterhin mit den ausgelieferten Implementierungen
funktionieren:

- ``formatModuleName()``: sollte verwendet werden um einen rohen Controllernamen zu nehmen, wie den einen der in
  einem Anfrageobjekt gepackt ist, und Ihn in einen richtigen Klassennamen zu reformatieren den eine Klasse, die
  ``Zend\Controller\Action`` erweitert, verwenden würde

.. _migration.17.zend.file.transfer:

Zend\File\Transfer
------------------

.. _migration.17.zend.file.transfer.validators:

Änderungen bei der Verwendung von Filtern und Prüfungen
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wie von Benutzern erwähnt, arbeiteten die Prüfungen von ``Zend\File\Transfer`` nicht in Verbindung mit
``Zend_Config`` zusammen, durch den Fakt das Sie keine benannten Arrays verwendet haben.

Deswegen wurden alle Filter und Prüfungen für ``Zend\File\Transfer`` überarbeitet. Wärend die alten Signaturen
weiterhin funktionieren, wurden sie als veraltet markiert, und werfen eine *PHP* Notiz mit der Aufforderung das zu
beheben.

Die folgende Liste zeigt die Änderungen und was für die richtige Verwendung der Parameter getan werden muß.

.. _migration.17.zend.file.transfer.validators.rename:

Filter: Rename
^^^^^^^^^^^^^^

- Alte *API* der Methode: ``Zend\Filter_File\Rename($oldfile, $newfile, $overwrite)``

- Neue *API* der Methode: ``Zend\Filter_File\Rename($options)`` wobei ``$options`` die folgenden Schlüssel für
  das Array akzeptiert: **source** identisch mit ``$oldfile``, **target** identisch mit ``$newfile``, **overwrite**
  identisch mit ``$overwrite``

.. _migration.17.zend.file.transfer.validators.rename.example:

.. rubric:: Änderungen für den Rename Filter von 1.6 zu 1.7

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addFilter('Rename',
                      array('/path/to/oldfile', '/path/to/newfile', true));

   // Gleiches Beispiel für 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addFilter('Rename',
                      array('source' => '/path/to/oldfile',
                            'target' => '/path/to/newfile',
                            'overwrite' => true));

.. _migration.17.zend.file.transfer.validators.count:

Prüfung: Count
^^^^^^^^^^^^^^

- Alte *API* der Methode: ``Zend\Validate_File\Count($min, $max)``

- Neue *API* der Methode: ``Zend\Validate_File\Count($options)`` wobei ``$options`` die folgenden Schlüssel für
  das Array akzeptiert: **min** identisch mit ``$min``, **max** identisch mit ``$max``

.. _migration.17.zend.file.transfer.validators.count.example:

.. rubric:: Änderungen für die Count Prüfung von 1.6 zu 1.7

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Count',
                         array(2, 3));

   // Gleiches Beispiel für 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Count',
                         false,
                         array('min' => 2,
                               'max' => 3));

.. _migration.17.zend.file.transfer.validators.extension:

Prüfung: Extension
^^^^^^^^^^^^^^^^^^

- Alte *API* der Methode: ``Zend\Validate_File\Extension($extension, $case)``

- Neue *API* der Methode: ``Zend\Validate_File\Extension($options)`` wobei ``$options`` die folgenden Schlüssel
  für das Array akzeptiert: ***** identisch mit ``$extension`` und kann jeden anderen Schlüssel haben **case**
  identisch mit ``$case``

.. _migration.17.zend.file.transfer.validators.extension.example:

.. rubric:: Änderungen für die Extension Prüfung von 1.6 zu 1.7

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Extension',
                         array('jpg,gif,bmp', true));

   // Gleiches Beispiel für 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Extension',
                         false,
                         array('extension1' => 'jpg,gif,bmp',
                               'case' => true));

.. _migration.17.zend.file.transfer.validators.filessize:

Prüfung: FilesSize
^^^^^^^^^^^^^^^^^^

- Alte *API* der Methode: ``Zend\Validate_File\FilesSize($min, $max, $bytestring)``

- Neue *API* der Methode: ``Zend\Validate_File\FilesSize($options)`` wobei ``$options`` die folgenden Schlüssel
  für das Array akzeptiert: **min** identisch mit ``$min``, **max** identisch mit ``$max``, **bytestring**
  identisch mit ``$bytestring``

Zustätzlich wurde die Signatur der ``useByteString()`` Methode geändert. Sie kann nur verwendet werden um zu
testen ob die Prüfung ByteStrings in den erzeugten Meldungen verwendet oder ncht. Um den Wert dieses Flags zu
setzen muß die ``setUseByteString()`` Methode verwendet werden.

.. _migration.17.zend.file.transfer.validators.filessize.example:

.. rubric:: Änderungen für die FilesSize Prüfung von 1.6 zu 1.7

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('FilesSize',
                         array(100, 10000, true));

   // Gleiches Beispiel für 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('FilesSize',
                         false,
                         array('min' => 100,
                               'max' => 10000,
                               'bytestring' => true));

   // Beispiel für 1.6
   $upload->useByteString(true); // Flag setzen

   // Gleiches Beispiel für 1.7
   $upload->setUseByteSting(true); // Flag setzen

.. _migration.17.zend.file.transfer.validators.hash:

Prüfung: Hash
^^^^^^^^^^^^^

- Alte *API* der Methode: ``Zend\Validate_File\Hash($hash, $algorithm)``

- Neue *API* der Methode: ``Zend\Validate_File\Hash($options)`` wobei ``$options`` die folgenden Schlüssel für
  das Array akzeptiert: ***** identisch mit ``$hash`` und kann jeden anderen Schlüssel haben **algorithm**
  identisch mit ``$algorithm``

.. _migration.17.zend.file.transfer.validators.hash.example:

.. rubric:: Änderungen für die Hash Prüfung von 1.6 zu 1.7

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Hash',
                         array('12345', 'md5'));

   // Gleiches Beispiel für 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Hash',
                         false,
                         array('hash1' => '12345',
                               'algorithm' => 'md5'));

.. _migration.17.zend.file.transfer.validators.imagesize:

Prüfung: ImageSize
^^^^^^^^^^^^^^^^^^

- Alte *API* der Methode: ``Zend\Validate_File\ImageSize($minwidth, $minheight, $maxwidth, $maxheight)``

- Neue *API* der Methode: ``Zend\Validate_File\FilesSize($options)`` wobei ``$options`` die folgenden Schlüssel
  für das Array akzeptiert: **minwidth** identisch mit ``$minwidth``, **maxwidth** identisch mit ``$maxwidth``,
  **minheight** identisch mit ``$minheight``, **maxheight** identisch mit ``$maxheight``

.. _migration.17.zend.file.transfer.validators.imagesize.example:

.. rubric:: Änderungen für die ImageSize Prüfung von 1.6 zu 1.7

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('ImageSize',
                         array(10, 10, 100, 100));

   // Gleiches Beispiel für 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('ImageSize',
                         false,
                         array('minwidth' => 10,
                               'minheight' => 10,
                               'maxwidth' => 100,
                               'maxheight' => 100));

.. _migration.17.zend.file.transfer.validators.size:

Prüfung: Size
^^^^^^^^^^^^^

- Alte *API* der Methode: ``Zend\Validate_File\Size($min, $max, $bytestring)``

- Neue *API* der Methode: ``Zend\Validate_File\Size($options)`` wobei ``$options`` die folgenden Schlüssel für
  das Array akzeptiert: **min** identisch mit ``$min``, **max** identisch mit ``$max``, **bytestring** identisch
  mit ``$bytestring``

.. _migration.17.zend.file.transfer.validators.size.example:

.. rubric:: Änderungen für die Size Prüfung von 1.6 zu 1.7

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Size',
                         array(100, 10000, true));

   // Gleiches Beispiel für 1.7
   $upload = new Zend\File\Transfer\Adapter\Http();
   $upload->addValidator('Size',
                         false,
                         array('min' => 100,
                               'max' => 10000,
                               'bytestring' => true));

.. _migration.17.zend.locale:

Zend_Locale
-----------

.. _migration.17.zend.locale.islocale:

Änderungen bei der Verwendung von isLocale()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Bezugnehmend auf den Codingstandard mußte ``isLocale()`` so geändert werden das es ein Boolean zurückgibt. In
vorhergehenden Releases wurde im Erfolgsfall ein String zurückgegeben. Für das Release 1.7 wurde ein
Kompatibilitätsmodus hinzugefügt der es erlaubt das alte Verhalten, das ein String zurückgegeben wird, zu
verwenden, aber das triggert auch eine User Warning die darauf hinweist das man auf das neue Verhalten wechseln
sollte. Das Rerouting welches das alte Verhalten von ``isLocale()`` durchgeführt hätte ist nicht länger
notwendig, da alle I18n Komponenten jetzt das Rerouting selbst durchführen.

Um die Skripte auf die neue *API* zu migrieren muß die Methode einfach wie anbei gezeigt verwendet werden.

.. _migration.17.zend.locale.islocale.example:

.. rubric:: Wie man isLocale() von 1.6 nach 1.7 ändern muß

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   if ($locale = Zend\Locale\Locale::isLocale($locale)) {
       // mach was
   }

   // Selbes Beispiel für 1.7

   // Man sollte den Kompatibilitätsmodus ändern um User Warnings zu verhindern
   // Aber man kann das in der Bootstrap tun
   Zend\Locale\Locale::$compatibilityMode = false;

   if (Zend\Locale\Locale::isLocale($locale)) {
   }

Es ist zu beachten das man den zweiten Parameter verwendet kann um zu sehen ob das Gebietsschema richtig ist ohne
das ein Rerouting durchgeführt wird.

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   if ($locale = Zend\Locale\Locale::isLocale($locale, false)) {
       // mach was
   }

   // Selbes Beispiel für 1.7

   // Man sollte den Kompatibilitätsmodus ändern um User Warnings zu verhindern
   // Aber man kann das in der Bootstrap tun
   Zend\Locale\Locale::$compatibilityMode = false;

   if (Zend\Locale\Locale::isLocale($locale, false)) {
       if (Zend\Locale\Locale::isLocale($locale, true)) {
           // gar kein Gebietsschema
       }

       // Original String ist kein Gebietsschema, kann aber Reroutet werden
   }

.. _migration.17.zend.locale.islocale.getdefault:

Änderungen bei der Verwendung von getDefault()
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Die Bedeutung der ``getDefault()`` Methode wurde verändert durch den Fakt das Framework-weite Gebietsschemata
integriert wurden welche mit ``setDefault()`` gesetzt werden können. Deswegen gibe es nicht mehr die Kette der
Gebietsschemata zurück sondern nur die gesetzten Framework-weiten Gebietsschemata.

Um die eigenen Skripte auf die neue *API* zu migrieren, muß einfach die Methode wie unten gezeigt verwendet
werden.

.. _migration.17.zend.locale.getdefault.example:

.. rubric:: Wie man getDefault() von 1.6 auf 1.7 ändert

.. code-block:: php
   :linenos:

   // Beispiel für 1.6
   $locales = $locale->getDefault(Zend\Locale\Locale::BROWSER);

   // Selbes Beispiel für 1.7

   // Man sollte den Compatibility Mode setzen um User Notices zu verhindern
   // Das kann in der Bootstrap Datei getan werden
   Zend\Locale\Locale::$compatibilityMode = false;

   $locale = Zend\Locale\Locale::getOrder(Zend\Locale\Locale::BROWSER);

Es ist zu beachten das der zweite Parameter der alten ``getDefault()`` Implementation nicht mehr vorhanden ist,
aber die zurückgegebenen Werte die gleichen sind.

.. note::

   Standardmäßig ist das alte Verhalten noch immer aktiv, wirft aber eine User Notice. Wenn man den eigenen Code
   zum neuen Verhalten geändert hat sollte man auch den Compatibility Mode auf ``FALSE`` setzen damit keine
   Notices mehr geworfen werden.

.. _migration.17.zend.translator:

Zend_Translator
---------------

.. _migration.17.zend.translator.languages:

Setzen von Sprachen
^^^^^^^^^^^^^^^^^^^

Wenn man die automatische Erkennung von Sprachen verwendet, oder Sprachen manuell auf ``Zend_Translator`` setzt
kann es sein das man von Zeit zu Zeit eine Notiz geworfen bekommen die über nicht hinzugefügte oder leere
Übersetzungen schreibt. In einigen vorhergehenden Releases wurde in einigen Fällen auch eine Exception geworfen.

Der Grund ist, das wenn ein Benutzer eine nicht existierende Sprache anfragt, man einfach keinen Weg hat um
festzustellen was falsch ist. Deswegen haben wir diese Notizen hinzugefügt die einem in den eigenen Logs zeigen
das der Benutzer eine Sprache angefragt hat die man nicht unterstützt. Es ist zu beachten das der Code, selbst
wenn eine Notiz getriggert wird, weiterhin ohne Probleme arbeitet.

Aber wenn man einen eigenen Fehler oder Exception Handler, wie XDebug, verwendet wird man alle Notizen
zurückerhalten, selbst wenn man das nicht gewollt hat. Das ist der Fall, weil diese Handler alle Einstellungen von
*PHP* selbst überschreiben.

Um diese Notizen wegzubekommen kann man einfach die neue Option 'disableNotices' auf ``TRUE`` setzen. Der
Standardwert ist ``FALSE``.

.. _migration.17.zend.translator.example:

.. rubric:: Setzen von Sprachen ohne das man Notizen erhält

Nehmen wir an das wir 'en' vorhanden haben und unser Benutzer 'fr' anfragt was nicht in unserem Portfolio der
übersetzten Sprachen ist.

.. code-block:: php
   :linenos:

   $language = new Zend\Translator\Translator('gettext',
                                  '/path/to/translations',
                                  'auto');

In diesem Fall werden wir eine Notiz darüber erhalten das die Sprache 'fr' nicht vorhanden ist. Durch das einfache
Hinzufügen der Option wird die Notiz abgeschaltet.

.. code-block:: php
   :linenos:

   $language = new Zend\Translator\Translator('gettext',
                                  '/path/to/translations',
                                  'auto',
                                  array('disableNotices' => true));

.. _migration.17.zend.view:

Zend_View
---------

.. note::

   Die Änderung der *API* in ``Zend_View`` sind nur dann zu beachten wenn man zum Release 1.7.5 oder höher
   hochrüstet.

Vor dem 1.7.5 Release wurde das Zend Framework Team darauf aufmerksam gemacht das eine potentielle Local File
Inclusion (*LFI*) Schwäche in der ``Zend\View\View::render()`` Methode existiert. Vor 1.7.5, erlaubte die Methode
standardmäßig, die Fähigkeit View Skripte zu spezifizieren die Schreibweisen für Eltern-Verzeichnisse enthalten
(z.B. "../" oder "..\\"). Das öffnet die Möglichkeit für eine *LFI* Attacke wenn ungefilterte Benutzereingaben
an die ``render()`` Methode übergeben werden:

.. code-block:: php
   :linenos:

   // Wobei $_GET['foobar'] = '../../../../etc/passwd'
   echo $view->render($_GET['foobar']); // LFI Einbruch

``Zend_View`` wirft jetzt standardmäßig eine Ausnahme wenn so ein View Skript angefragt wird.

.. _migration.17.zend.view.disabling:

Ausschalten des LFI Schutzes für die render() Methode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Da viele Entwickler gemeldet haben das Sie so eine Schreibweise in Ihren Anwendungen verwenden die **nicht** das
Ergebnis einer Benutzereingabe sind, wurde ein spezielles Flag erstellt um das Deaktivieren des standardmäßigen
Schutzes zu erlauben. Es gibt 2 Methoden um das Durchzuführen: Indem der 'lfiProtectionOn' Schlüssel in den
Konstruktor-Optionen übergeben wird, oder durch den expliziten Aufruf der ``setLfiProtection()`` Methode.

.. code-block:: php
   :linenos:

   // Ausschalten über den Konstruktor
   $view = new Zend\View\View(array('lfiProtectionOn' => false));

   // Ausschalten über expliziten Aufruf der Methode:
   $view = new Zend\View\View();
   $view->setLfiProtection(false);


