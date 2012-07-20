.. _zend.form.standardElements:

Standard Form Elemente die mit dem Zend Framework ausgeliefert werden
=====================================================================

Zend Framework wird mit konkreten Element Klassen ausgeliefert welche die meisten *HTML* Form Elemente abdecken.
Die meisten spezifizieren einfach einen speziellen View Helfer zur Verwendung wenn das Element dekoriert wird, aber
einige bieten zusätzliche Funktionalitäten an. Nachfolgend ist eine Liste aller solcher Klassen, sowie eine
Beschreibung der Funktionalität die Sie anbieten.

.. _zend.form.standardElements.button:

Zend_Form_Element_Button
------------------------

Wird für die Erstellung von *HTML* Button Elementen verwendet wobei ``Zend_Form_Element_Button``
:ref:`Zend_Form_Element_Submit <zend.form.standardElements.submit>` erweitert, und seine eigene Funktionalität
hinzufügt. Sie spezifiziert den 'formButton' View Helfer für die Dekoration.

Wie das Submit Element, verwendet es das Label des Elements als den Elementwert für Darstellungszwecke; in anderen
Worten, um den Text des Buttons zu setzen, muß der Wert des Elements gesetzt werden. Das Label wird übersetzt
wenn ein Übersetzungsadapter vorhanden ist.

Weil das Label als Teil des Elements verwendet wird, verwendet das Button Element nur den :ref:`ViewHelper
<zend.form.standardDecorators.viewHelper>` und den :ref:`DtDdWrapper <zend.form.standardDecorators.dtDdWrapper>`
Dekorator.

Nach der Veröffentlichung oder Prüfung einer Form, kann geprüft werden ob der gegebene Button geklickt wurd
indem die ``isChecked()`` Methode verwendet wird.

.. _zend.form.standardElements.captcha:

Zend_Form_Element_Captcha
-------------------------

CAPTCHAs werden verwendet um automatische Übermittlung von Formularen durch Bots und andere automatische Prozesse
zu verhindern.

Das Captcha Formularelement erlaubt es den :ref:`Zend_Captcha Adapter <zend.captcha.adapters>` der als Formular
CAPTCHA verwendet werden soll anzupassen. Er setzt dann diesen Adapter als Prüfung für das Objekt, und verwendet
den Captcha Dekorator für die Darstellung (welche den CAPTCHA Adapter aufruft).

Adapter können alle Adapter in ``Zend_Captcha`` sein, sowie jeder eigene Adapter der irgendwo anders definiert
wurde. Um das zu erlauben, kann ein zusätzlicher Schlüssel für den Plugin Ladetyp, 'CAPTCHA' oder 'captcha'
übergeben werden, wenn der Plugin Loader Präfixpfad spezifiziert wird:

.. code-block:: php
   :linenos:

   $element->addPrefixPath('My_Captcha', 'My/Captcha/', 'captcha');

Captcha's können dann durch Verwendung der ``setCaptcha()`` Methode registriert werden, welche entweder eine
konkrete CAPTCHA Instanz, oder den Kurznamen des CAPTCHA Adapters nimmt:

.. code-block:: php
   :linenos:

   // Konkrete Instanz:
   $element->setCaptcha(new Zend_Captcha_Figlet());

   // Verwendung von Kurznamen:
   $element->setCaptcha('Dumb');

Wenn das Element über die Konfiguration geladen werden soll, kann entweder der Schlüssel 'captcha' mit einem
Array das den Schlüssel 'captcha' enthält spezifiziert werden, oder beide Schlüssel 'captcha' und
'captchaOptions':

.. code-block:: php
   :linenos:

   // Verwendung eines einzelnen captcha Schlüssels:
   $element = new Zend_Form_Element_Captcha('foo', array(
       'label' => "Bitte verifizieren Sie das Sie menschlich sind",
       'captcha' => array(
           'captcha' => 'Figlet',
           'wordLen' => 6,
           'timeout' => 300,
       ),
   ));

   // Verwendung von beiden, captcha und captchaOptions:
   $element = new Zend_Form_Element_Captcha('foo', array(
       'label' => "Bitte verifizieren Sie das Sie menschlich sind",
       'captcha' => 'Figlet',
       'captchaOptions' => array(
           'captcha' => 'Figlet',
           'wordLen' => 6,
           'timeout' => 300,
       ),
   ));

Der verwendete Dekorator wird durch die Abfrage des Captcha Adapters erkannt. Standardmäßig wird der
:ref:`Captcha Dekorator <zend.form.standardDecorators.captcha>` verwendet, aber ein Adapter kann einen anderen
über die ``getDecorator()`` Methode spezifizieren.

Wie beschrieben, fungiert der Captcha Adapter selbst als Prüfnug für das Element. Zusätzlich wird die NotEmpty
Prüfung nicht verwendet, und das Element wird als benötigt markiert. In den meisten Fällen sollte sonst nichts
anderes mehr notwendig sein um das Captcha im eigenen Formular zu haben.

.. _zend.form.standardElements.checkbox:

Zend_Form_Element_Checkbox
--------------------------

*HTML* Checkboxen erlauben es spezifische Werte zurückzugeben, arbeiten aber grundsätzlich als Boolean. Wenn Sie
angehackt sind, wird der Wert der Checkbox übertragen. Wenn Sie nicht angehackt sind, wird nichts übertragen.
Intern erzwingt ``Zend_Form_Element_Checkbox`` diesen Status.

Standardmäßg ist der angehackte Wert '1', und der nicht angehackte Wert '0'. Dieser Wert kann spezifiziert werden
indem die ``setCheckedValue()`` und ``setUncheckedValue()`` Zugriffsmethoden verwendet werden. Intern wird,
jedesmal wenn der Wert gesetzt wird, wenn der angebotene Wert dem angehackten Wert entspricht, er gesetzt, aber
jeder andere Wert bewirkt das der nicht angehackte Wert gesetzt wird.

Zusätzlich setzt, das Setzen des Werte, die ``checked`` Eigenschaft der Checkbox. Das kann abgefragt werden indem
``isChecked()`` verwendet wird oder einfach auf die Eigenschaft zugegriffen wird. Das Verwenden der
``setChecked($flag)`` Methode setzt beides, den Status des Flags sowie den entsprechenden gecheckten oder nicht
gecheckten Wert im Element. Bitte verwenden Sie diese Methode wenn der gecheckte Status eines Checkbox Elements
gesetzt wird um sicherzustellen das der Wert richtig gesetzt wird.

``Zend_Form_Element_Checkbox`` verwendet den 'formCheckbox' View Helfer. Der angehackte Wert wird immer verwendet
um Sie zu veröffentlichen.

.. _zend.form.standardElements.file:

Zend_Form_Element_File
----------------------

Das File Formularelement bietet einen Mechanismus um File Upload-felder in eigenen Formularen zu Unterstützen. Es
verwendet intern :ref:`Zend_File_Transfer <zend.file.transfer.introduction>` um diese Funktionalität zu bieten,
und den ``FormFile`` Viewhelfer sowie den ``File`` Decorator um das Formularelement anzuzeigen.

Standardmäßig verwendet es den ``Http`` Transferadapter, welcher das ``$_FILES`` Array prüft und es erlaubt
Prüfungen und Filter hinzuzufügen. Prüfungen und Filter die dem Formularelement hinzugefügt werden, werden dem
Transferadapter hinzugefügt.

.. _zend.form.standardElements.file.usage:

.. rubric:: Verwendung des File Formularelements

Die obige Erklärung der Verwendung des File Formularelements mag geheimnisvoll erscheinen, aber die aktuelle
Verwendung ist relativ trivial:

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Ein Bild hochladen:')
           ->setDestination('/var/www/upload');
   // Nur 1 Datei sicherstellen
   $element->addValidator('Count', false, 1);
   // Maximal 100k
   $element->addValidator('Size', false, 102400);
   // Nur JPEG, PNG, und GIFs
   $element->addValidator('Extension', false, 'jpg,png,gif');
   $form->addElement($element, 'foo');

Man sollte auch den richtigen Encodingtyp sicherstellen in dem das Formular angeboten wird. Das kann getan werden
indem das 'enctype' Attribut des Formulars gesetzt wird:

.. code-block:: php
   :linenos:

   $form->setAttrib('enctype', 'multipart/form-data');

Nachdem das Formular erfolgreich geprüft wurde, muß die Datei empfangen werden um Sie an Ihrem endgültigen Ziel
zu speichern indem ``receive()`` verwendet wird. Zusätzlich kann man das endgültige Ziel ermittelt werden indem
``getFileName()`` verwendet wird:

.. code-block:: php
   :linenos:

   if (!$form->isValid()) {
       print "Uh oh... Prüfungsfehler";
   }

   if (!$form->foo->receive()) {
       print "Fehler beim Empfangen der Datei";
   }

   $location = $form->foo->getFileName();

.. note::

   **Standardmäßige Ablage von Uploads**

   Standardmäßig werden Dateien in das Temp Verzeichnis des Systems hochgeladen.

.. note::

   **Datei Werte**

   In *HTTP* hat das File Element keinen Wert. Aus diesem Grund, und aus Gründen der Sicherheit erhält gibt
   ``getValue()`` nur den Dateinamen der hochgeladenen Datei zurück und nicht den kompletten Pfad. Wenn man die
   kompletten Informationen benötigt kann ``getFileName()`` aufgerufen werden, welches sowohl den Pfad als auch
   den Namen der Datei zurückgibt.

Standardmäßig wird die Datei automatisch empfangen wenn man ``getValues()`` auf dem Formular aufruft. Der Grund
hinter diesem Verhalten ist, das die Datei selbst der Wert des File Elements ist.

.. code-block:: php
   :linenos:

   $form->getValues();

.. note::

   Deshalb hat ein weiterer Aufruf von ``receive()`` nach dem Aufruf von ``getValues()`` keinen Effekt. Auch die
   Erstellung einer Instanz von ``Zend_File_Transfer`` wird keinen Effekt haben da es keine weitere Datei zum
   Empfangen gibt.

Trotzdem kann es manchmal gewünscht sein ``getValues()`` aufzurufen ohne das die Datei empfangen wird. Man kann
dies erreichen indem ``setValueDisabled(true)`` aufgerufen wird. Um den aktuellen Wert dieses Flags zu erhalten
kann man ``isValueDisabled()`` aufrufen.

.. _zend.form.standardElements.file.retrievement:

.. rubric:: Datei explizit empfangen

Zuerst ``setValueDisabled(true)`` aufrufen.

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Ein Bild hochladen:')
           ->setDestination('/var/www/upload')
           ->setValueDisabled(true);

Jetzt wird die Datei nicht mehr empfangen wenn man ``getValues()`` aufruft. Man muß also ``receive()`` vom Datei
Element, oder einer Instanz von ``Zend_File_Transfer`` selbst aufrufen.

.. code-block:: php
   :linenos:

   $values = $form->getValues();

   if ($form->isValid($form->getPost())) {
       if (!$form->foo->receive()) {
           print "Upload Fehler";
       }
   }

Es gibt verschiedene Stati von hochgeladenen Dateien welche mit den folgenden Optionen geprüft werden können:

- ``isUploaded()``: Prüft ob das Dateielement hochgeladen wurde oder nicht.

- ``isReceived()``: Prüft ob das Dateielement bereits empfangen wurde.

- ``isFiltered()``: Prüft ob die Filter bereits dem Dateielement angehängt wurden oder nicht.

.. _zend.form.standardElements.file.isuploaded:

.. rubric:: Prüfen ob eine optionale Datei hochgeladen wurde

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Ein Bild hochladen:')
           ->setDestination('/var/www/upload')
           ->setRequired(false);
   $element->addValidator('Size', false, 102400);
   $form->addElement($element, 'foo');

   // Das foo Dateielement is optional, aber wenn es angegeben wurde, gehe hier herein
   if ($form->foo->isUploaded()) {
       // Die foo Datei ist angegeben... mach was
   }

``Zend_Form_Element_File`` unterstützt auch mehrere Dateien. Durch den Aufruf der ``setMultiFile($count)`` Methode
kann die Anzahl an File Elementen die man erstellen will festgelegt werden. Das verhindert das die selben
Einstellungen mehrere Male durchgeführt werden müssen.

.. _zend.form.standardElements.file.multiusage:

.. rubric:: Mehrere Dateien setzen

Die Erstellung eines Multifile Elements ist das gleiche wie das Erstellen eines einzelnen Elements. Man muß nur
``setMultiFile()`` aufrufen nachdem das Element erstellt wurde:

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Ein Bild hochladen:')
           ->setDestination('/var/www/upload');
   // Mindestens 1 und maximal 3 Dateien sicherstellen
   $element->addValidator('Count', false, array('min' => 1, 'max' => 3));
   // Auf 100k limitieren
   $element->addValidator('Size', false, 102400);
   // Nur JPEG, PNG, und GIFs
   $element->addValidator('Extension', false, 'jpg,png,gif');
   // 3 identische Dateielemente definieren
   $element->setMultiFile(3);
   $form->addElement($element, 'foo');

In der View erhält man nun 3 identische File Upload Elemente welche alle die gleichen Einstellungen verwenden. Um
die Multifile Anzahl zu erhalten kann man einfach ``getMultiFile()`` aufrufen.

.. note::

   **File Elemente in Subformularen**

   Wenn File Elemente in Subformularen verwendet werden muß man eindeutige Namen setzen. Wenn man zum Beispiel ein
   File Element in Subform1 "file" benennt, muß es in Subform2 einen anderen Namen erhalten.

   Sobald es 2 identisch benannte File Elemente gibt, wird das zweite Element entweder nicht dargestellt oder nicht
   übertragen.

   Zusätzlich werden File Element nicht im Unterformulat dargestellt. Wenn man also ein File Element in einem
   Unterformulat hinzufügt, wird das Element im Hauptformular dargestellt.

Um die Größe der Datei zu begrenzen, kann die maximale Dateigröße spezifiziert werden indem die
``MAX_FILE_SIZE`` Option im Formular gesetzt wird. Sobald der Wert, durch die Verwendung der
``setMaxFileSize($size)`` Methode, gesetzt ist, wird er mit dem File Element dargestellt.

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_File('foo');
   $element->setLabel('Ein Bild hochladen:')
           ->setDestination('/var/www/upload')
           ->addValidator('Size', false, 102400) // Limitiert auf 100k
           ->setMaxFileSize(102400); // Limitiert die Dateigröße auf der Clientseite
   $form->addElement($element, 'foo');

.. note::

   **MaxFileSize mit mehreren File Elementen**

   Wenn mehrere File Elemente im Formular verwendet werden sollte man ``MAX_FILE_SIZE`` nur einmal setzen. Wird es
   nochmals gesetzt überschreibt es den vorherigen Wert.

   Beachte, dass das auch der Fall ist wenn man mehrere Formulare verwendet.

.. _zend.form.standardElements.hidden:

Zend_Form_Element_Hidden
------------------------

Versteckte Elemente fügen Daten ein die übertragen werden sollen, welche der Benutzer aber nicht manipulieren
soll. ``Zend_Form_Element_Hidden`` ermöglicht das mit dem 'formHidden' View Helfers.

.. _zend.form.standardElements.hash:

Zend_Form_Element_Hash
----------------------

Dieses Element bietet Schutz vor CSRF Attacken auf Forms, und stellt sicher das die Daten die übertragen werden
von der Benutzersession stammen welche die Form erstellt hat und nicht durch ein bösartiges Skript. Sicherheit
wird ermöglicht durch das hinzufügen eines Hash Elements zur form und dessen Prüfung wenn die Form übermittelt
wird.

Der Name des Hash Elements sollte einmalig sein. Wir emphehlen die Verwendung der ``salt`` Option für das Element-
damit zwei Hashes mit dem gleichen Namen und unterschiedlichen Salts nicht kollidieren:

.. code-block:: php
   :linenos:

   $form->addElement('hash', 'no_csrf_foo', array('salt' => 'unique'));

Das Salt kann später gesetzt werden durch Verwendung der ``setSalt($salt)`` Methode.

Intern speichert das Element einen eindeutigen Identifikator indem es ``Zend_Session_Namespace`` verwendet, und
danach bei der Übertragung checkt (es wird geprüft das die TTL nicht abgelaufen ist). Die 'Identical' Prüfung
wird anschließend verwendet um sicherzustellen dass der übermittelte Hash dem gespeicherten Hash entspricht.

Der 'formHidden' View Helfer wird verwendet um das Element in der Form darzustellen.

.. _zend.form.standardElements.Image:

Zend_Form_Element_Image
-----------------------

Bilder können als Form Elemente verwendet werden und man kann diese Bilder als graphische Elemente auf Form
Buttons verwenden.

Bilder benötigen eine Bildquelle. ``Zend_Form_Element_Image`` erlaube dessen Spezifikation durch Verwendung der
``setImage()`` Zugriffsmethode (oder des 'image' Konfigurations Schlüssels). Es kann auch optional ein Wert
spezifiziert werden der zu verwenden ist wenn das Bild übertragen wird indem die Zugriffsmethode
``setImageValue()`` verwendet wird (oder der 'imageValue Konfigurations Schlüssel). Wenn der Wert der für das
Element gesetzt ist, mit ``imageValue`` übereinstimmt, gibt ``isChecked()`` ``TRUE`` zurück.

Bild Elemente verwenden den :ref:`Image Decorator <zend.form.standardDecorators.image>` für die Darstellung,
zusätzlich zu den Standard Error, HtmlTag und Label Dekoratoren. Es kann optional ein Tag für den ``Image``
Dekorator spezifiziert werden der das Bild einbettet.

.. _zend.form.standardElements.multiCheckbox:

Zend_Form_Element_MultiCheckbox
-------------------------------

Oft hat man ein Set von zusammenhängenden Checkboxen, und die Ergebnisse sollen gruppiert werden. Das ist so
ähnlich wie :ref:`Multiselect <zend.form.standardElements.multiselect>` aber statt das Sie in einer DropDown Liste
sind, müssen Checkbox/Werte Paare dargestellt werden.

``Zend_Form_Element_MultiCheckbox`` macht das in einem Rutsch. Wie alle anderen Elemente kann mit der Erweiterung
des Basis MultiElements eine Liste von Optionen spezifiziert werden und einfach gegen die selbe Liste geprüft
werden. Der 'formMultiCheckbox' View Helfer stellt sicher das Sie als Array bei der Übermittlung der Form
zurückgegeben werden.

Standardmäßig registriert dieses Element die ``InArray`` Prüfung welche gegen Arrayschlüssel von registrierten
Optionen prüft. Dieses Verhalten kann deaktiviert werden indem entweder ``setRegisterInArrayValidator(false)``
aufgerufen, oder indem ein ``FALSE`` Wert an den ``registerInArrayValidator`` Konfigurationsschlüssel übergeben
wird.

Die verschiedenen Checkbox Optionen können mit den folgenden Methoden manipuliert werden:

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (überschreibt existierende Optionen)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

Um gecheckte Elemente zu markieren, muß ein Array an Werte an ``setValue()`` übergeben werden. Der folgende Code
prüft die Werte "bar" und "bat":

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element_MultiCheckbox('foo', array(
       'multiOptions' => array(
           'foo' => 'Foo Option',
           'bar' => 'Bar Option',
           'baz' => 'Baz Option',
           'bat' => 'Bat Option',
       );
   ));

   $element->setValue(array('bar', 'bat'));

Beachte das man auch für das Setzen eines einzelnen Wertes ein Array übergeben muß.

.. _zend.form.standardElements.multiselect:

Zend_Form_Element_Multiselect
-----------------------------

*XHTML* **select** Elemente erlaube ein 'multiple' Attribut, das zeigt das mehrere Optionen für die Übermittlung
ausgewählt werden können, statt normalerweise nur eines. ``Zend_Form_Element_Multiselect`` erweitert
:ref:`Zend_Form_Element_Select <zend.form.standardElements.select>` und setzt das ``multiple`` Attribut auf
'multiple'. Wie andere Klassen die von der Basisklasse ``Zend_Form_Element_Multi`` abgeleitet werden, können die
Optionen für die Auswahl wie folgt verändert werden:

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (überschreibt existierende Optionen)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

Wenn ein Übersetzungs Adapter in der Form und/oder dem Element registriert ist, werden Optionswerte für
Darstellungzwecke übersetzt.

Standardmäßig registriert dieses Element die ``InArray`` Prüfung welche gegen Arrayschlüssel von registrierten
Optionen prüft. Dieses Verhalten kann deaktiviert werden indem entweder ``setRegisterInArrayValidator(false)``
aufgerufen, oder indem ein ``FALSE`` Wert an den ``registerInArrayValidator`` Konfigurationsschlüssel übergeben
wird.

.. _zend.form.standardElements.password:

Zend_Form_Element_Password
--------------------------

Passwort Element sind grundsätzlich normale Textelemente -- ausser das typischerweise das eingegebene Passwort
nicht in Fehlermeldungen oder dem Element selbst angezeigt werden soll wenn die Form normals angezeigt wird.

``Zend_Form_Element_Password`` ermöglicht das durch den Aufruf von ``setValueObscured(true)`` auf jeder Prüfung
(und stellt sicher das das Passwort in der Prüfungs Fehlermeldung verschleiert wird), und verwendet den
'formPassword' View Helfer (welcher den an Ihn übergebenen Wert nicht anzeigt).

.. _zend.form.standardElements.radio:

Zend_Form_Element_Radio
-----------------------

Radio Elemente erlauben es verschiedene Optionen zu spezifizieren, von denen ein einzelner Wert zurückgegeben
wird. ``Zend_Form_Element_Radio`` erweitert die Basisklasse ``Zend_Form_Element_Multi`` und erlaubt es eine Anzahl
von Optionen zu spezifizieren, und verwendet dann den **formRadio** View Helfer um diese darzustellen.

Standardmäßig registriert dieses Element die ``InArray`` Prüfung welche gegen Arrayschlüssel von registrierten
Optionen prüft. Dieses Verhalten kann deaktiviert werden indem entweder ``setRegisterInArrayValidator(false)``
aufgerufen, oder indem ein ``FALSE`` Wert an den ``registerInArrayValidator`` Konfigurationsschlüssel übergeben
wird.

Wie alle Elemente welche die Basisklasse des Multl Elements erweitern, können die folgenden Methode verwendet
werden um die Radio Optionen zu manipulieren die angezeigt werden:

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (überschreibt existierende Optionen)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

.. _zend.form.standardElements.reset:

Zend_Form_Element_Reset
-----------------------

Reset Buttons werden typischerweise verwendet um eine Form zu löschen, und sind nicht Teil der übermittelten
Daten. Da Sie trotzdem einen Zweck in der Anzeige bieten, sind Sie in den Standardelementen enthalten.

``Zend_Form_Element_Reset`` erweitert :ref:`Zend_Form_Element_Submit <zend.form.standardElements.submit>`. Deswegen
wird das Label für die Anzeige des Buttons verwendet und wird übersetzt wenn ein Übersetzungs Adapter vorhanden
ist. Es verwendet nur die 'ViewHelper' und 'DtDdWrapper' Dekoratore, da es nie Fehlermeldungen für solche Elemente
geben sollte, noch sollte ein Label notwendig sein.

.. _zend.form.standardElements.select:

Zend_Form_Element_Select
------------------------

Auswahlboxen sind der übliche Weg um spezielle Auswahlen für gegebene Formdaten zu begrenzen.
``Zend_Form_Element_Select`` erlaubt es diese schnell und einfach zu erzeugen.

Standardmäßig registriert dieses Element die ``InArray`` Prüfung welche gegen Arrayschlüssel von registrierten
Optionen prüft. Dieses Verhalten kann deaktiviert werden indem entweder ``setRegisterInArrayValidator(false)``
aufgerufen, oder indem ein ``FALSE`` Wert an den ``registerInArrayValidator`` Konfigurationsschlüssel übergeben
wird.

Da es das Basis Multielement erweitert, können die folgenden Methoden verwendet werden um die Auswahloptionen zu
manipulieren:

- ``addMultiOption($option, $value)``

- ``addMultiOptions(array $options)``

- ``setMultiOptions(array $options)`` (überschreibt existierende Optionen)

- ``getMultiOption($option)``

- ``getMultiOptions()``

- ``removeMultiOption($option)``

- ``clearMultiOptions()``

``Zend_Form_Element_Select`` verwendet den 'formSelect' View Helfer für die Dekoration.

.. _zend.form.standardElements.submit:

Zend_Form_Element_Submit
------------------------

Sendebuttons (Submit) werden verwendet um eine Form zu senden. Es kann gewünscht sein mehrere Sendebuttons zu
verwendetn; die Buttons zur Übermittlung der Form können verwendet werden um auszuwählen welche Aktion mit den
übermittelten Daten genommen werden soll. ``Zend_Form_Element_Submit`` macht die Entscheidung einfach, durch das
Hinzufügen einer ``isChecked()`` Methode; da nur ein Button Element von der Form übermittelt wird, nachdem die
Form übermittelt oder geprüft wurde, kann diese Methode auf jedem Sendebutton ausgerufen werden um festzustellen
welcher verwendet wurde.

``Zend_Form_Element_Submit`` verwendet das Label als den "Wert" des Sendebuttons, und übersetzt es wenn ein
Übersetzungsadapter vorhanden ist. ``isChecked()`` prüft den übermittelten Wert gegen das Label um festzustellen
ob der Button verwendet wurde.

Die :ref:`ViewHelper <zend.form.standardDecorators.viewHelper>` und :ref:`DtDdWrapper
<zend.form.standardDecorators.dtDdWrapper>` Dekoratore werden verwendet um das Element darzustellen. Es wird kein
Labeldekorator verwendet, da das Label des Buttons verwendet wird wenn das Element dargestellt wird; typischerweise
werden acuh keine Fehler mit einem Sendeelement assoziiert.

.. _zend.form.standardElements.text:

Zend_Form_Element_Text
----------------------

Der nützlichste Typ von Form Element ist das Text Element, das begrenzte Texteinträge erlaubt; es ist ein ideales
Element für die meisten Dateneinträge. ``Zend_Form_Element_Text`` verwendet einfach den 'formText' View Helfer um
das Element darzustellen.

.. _zend.form.standardElements.textarea:

Zend_Form_Element_Textarea
--------------------------

Textbereiche werden verwendet wenn große Mengen von Text erwartet werden, und keine Begrenzung in der Anzahl des
übermittelten Textes vorhanden sind (anders als das Limit der Maximalgröße wie vom Server von *PHP* diktiert).
``Zend_Form_Element_Textarea`` verwendet den 'textArea' View Helfer um solche Element darzustellen, und platziert
den Wert als Inhalt des Elements.


