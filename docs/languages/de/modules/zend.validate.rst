.. _zend.validate.introduction:

Einführung
==========

Die Komponente ``Zend_Validate`` bietet ein Reihe von häufig benötigten Prüfungen. Sie bietet auch einen
einfachen Verkettungsmechanismus für Prüfungen, mit welchem mehrfache Prüfungen in einer benutzerdefinierten
Reihenfolge auf einen einzelnen Wert angewendet werden können.

.. _zend.validate.introduction.definition:

Was ist eine Prüfung?
---------------------

Eine Prüfung untersucht ihre Eingabe hinsichtlich einiger Anforderungen und produziert ein boolesches Ergebnis -
wenn die Eingabe erfolgreich gegen die Anforderungen geprüft werden konnte. Wenn die Eingabe den Anforderungen
nicht entspricht, kann die Prüfung zusätzliche Informationen darüber bieten, welche der Anforderungen die
Eingabe nicht entspricht.

Zum Beispiel könnte eine Webanwendung erfordern, dass ein Benutzername zwischen sechs und zwölf Zeichen lang sein
soll und nur alphanumerische Zeichen enthalten soll. Eine Prüfung kann dafür verwendet werden um sicherzustellen,
dass Benutzernamen diesen Anforderungen entsprechen. Wenn ein gewählter Benutzername einer oder beiden
Anforderungen nicht entspricht, wäre es nützlich zu wissen, welche der Anforderungen der Benutzername nicht
entsprochen hat.

.. _zend.validate.introduction.using:

Standardnutzung von Prüfungen
-----------------------------

Prüfungen auf diesem Weg definiert zu haben, bietet die Grundlage für ``Zend_Validate_Interface``, welche zwei
Methoden definiert, ``isValid()`` und ``getMessages()``. Die Methode ``isValid()`` führt eine Prüfung über die
angegebenen Werte aus und gibt nur dann ``TRUE`` zurück, wenn der Wert gegenüber den Kriterien der Prüfung
entsprochen hat.

Wenn ``isValid()`` ``FALSE`` zurück gibt, bietet ``getMessages()`` ein Array von Nachrichten, welches die Gründe
für die fehlgeschlagene Prüfung beschreiben. Die Arrayschlüssel sind kurze Strings, welche die Gründe für eine
fehlgeschlagene Prüfung identifizieren und die Arraywerte sind die entsprechend menschenlesbaren
String-Nachrichten. Die Schlüssel und Werte sind klassenabhängig; jede Prüfklasse definiert ihr eigenes Set von
Nachrichten für fehlgeschlagene Prüfungen und die eindeutigen Schlüssel, welche diese identifizieren. Jede
Klasse hat also eine const Definition die jedem Identifikator für eine fehlgeschlagene Prüfung entspricht.

.. note::

   Die Methode ``getMessages()`` gibt die Information für Prüfungsfehler nur für den zuletzt durchgeführten
   Aufruf von ``isValid()`` zurück. Jeder Aufruf von ``isValid()`` löscht jegliche Nachricht und Fehler, welche
   durch vorhergehende Aufrufe von ``isValid()`` vorhanden waren, weil normalerweise jeder Aufruf von ``isValid()``
   für einen unterschiedlichen Eingabewert gemacht wird.

Das folgende Beispiel zeigt die Prüfung einer E-Mail Adresse:

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_EmailAddress();

   if ($validator->isValid($email)) {
       //
       // E-Mail scheint gültig zu sein
       //
   } else {
       //
       // E-Mail ist ungültig; drucke die Gründe
       //
       foreach ($validator->getMessages() as $messageId => $message) {
           echo "Validation failure '$messageId': $message\n";
       }
   }

.. _zend.validate.introduction.messages:

Nachrichten anpassen
--------------------

Prüfklassen bieten eine Methode ``setMessage()``, mit der das Format der Nachricht definiert werden kann, die von
``getMessages()`` im Fall einer fehlerhaften Prüfung zurückgegeben wird. Das erste Argument dieser Methode ist
ein String, der die Fehlernachricht enthält. Es können Kürzel in den String eingebaut werden, welche mit den
für die Prüfung relevanten Daten aufgefüllt werden. Das Kürzel **%value%** wird von allen Prüfungen
unterstützt; es ist verbunden mit dem Wert der an ``isValid()`` übergeben wird. Andere Kürzel können in jeder
Prüfklasse von Fall zu Fall unterstützt werden. Zum Beispiel ist **%max%** das Kürzel, welches von
``Zend_Validate_LessThan`` unterstützt wird. Die ``getMessageVariables()`` Methode gibt ein Array von variablen
Kürzeln zurück, welche vom Prüfer unterstützt werden.

Das zweite optionale Argument ist ein String, der das Template der fehlerhaften Prüfnachricht identifiziert, die
gesetzt werden soll. Das ist nützlich wenn eine Prüfklasse mehr als einen Grund für einen Fehlschlag definiert.
Wenn das zweite Argument nicht angegeben wird, nimmt ``setMessage()`` an, dass die spezifizierte Nachricht für das
erste Messagetemplate verwendet werden soll, das in der Prüfklasse definiert ist. Viele Prüfklassen haben nur ein
Template für eine Fehlernachricht definiert, sodass es nicht notwendig ist anzugeben, welches Template für
Fehlernachrichten geändert werden soll.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(8);

   $validator->setMessage(
       'Der String \'%value%\' ist zu kurz; er muss mindestens %min% ' .
       'Zeichen sein',
       Zend_Validate_StringLength::TOO_SHORT);

   if (!$validator->isValid('word')) {
       $messages = $validator->getMessages();
       echo $messages[0];

       // "Der String 'word' ist zu kurz; er muss mindestens 8 Zeichen sein"
   }

Es können mehrere Nachrichten durch Verwendung der Methode ``setMessages()`` gesetzt werden. Dessen Argument ist
ein Array, welches Schlüssel/Nachrichten Paare enthält.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(array('min' => 8, 'max' => 12));

   $validator->setMessages( array(
       Zend_Validate_StringLength::TOO_SHORT =>
           'Der String \'%value%\' ist zu kurz',
       Zend_Validate_StringLength::TOO_LONG  =>
           'Der String \'%value%\' ist zu lang'
   ));

Wenn die Anwendung mehr Flexibilität benötigt in der Art und Weise wie Prüffehler gemeldet werden, kann auf die
Eigenschaften durch denselben Namen zugegriffen werden, wie mit dem Nachrichtenkürzel, das von einer Prüfklasse
unterstützt wird. Die Eigenschaft ``value`` ist immer in einem Prüfer vorhanden; Das ist der Wert, der als
Argument von ``isValid()`` definiert wurde. Andere Eigenschaften können von Fall zu Fall in jeder Prüfklasse
unterstützt werden.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(array('min' => 8, 'max' => 12));

   if (!validator->isValid('word')) {
       echo 'Wort fehlgeschlaten: '
           . $validator->value
           . '; die Länge ist nicht zwischen '
           . $validator->min
           . ' und '
           . $validator->max
           . "\n";
   }

.. _zend.validate.introduction.static:

Verwenden der statischen is() Methode
-------------------------------------

Wenn es unpassend ist, eine gegebenen Prüfklasse zu laden und eine Instanz des Prüfers zu erstellen, kann die
statische Methode ``Zend_Validate::is()`` als alternativer Stil des Aufrufs verwendet werden. Das erste Argument
dieser Methode ist ein Datenwert, der an die Methode ``isValid()`` übergeben werden würde. Das zweite Argument
ist ein String, welcher mit dem Basisnamen der Prüfklasse übereinstimmt, relativ zum Namensraum von
``Zend_Validate``. Die Methode ``is()`` lädt die Klasse automatisch, erstellt eine Instanz und wendet die Methode
``isValid()`` auf die Eingabedaten an.

.. code-block:: php
   :linenos:

   if (Zend_Validate::is($email, 'EmailAddress')) {
       // Ja, die Email Adresse scheint gültig zu sein
   }

Es kann auch ein Array von Konstruktor-Argumenten übergeben werden, wenn diese für die Prüfung benötigt werden.

.. code-block:: php
   :linenos:

   if (Zend_Validate::is($value, 'Between', array('min' => 1, 'max' => 12))) {
       // Ja, $value ist zwischen 1 und 12
   }

Die Methode ``is()`` gibt einen booleschen Wert zurück, denselben wie die Methode ``isValid()``. Wird die
statische Methode ``is()`` verwendet, sind Nachrichten für Prüffehler nicht vorhanden.

Die statische Verwendung kann für das ad hoc Verwenden eines Prüfers bequem sein, aber wenn ein Prüfer für
mehrere Eingaben verwendet werden soll, ist es effizienter die nicht statische Verwendung zu benutzen, indem eine
Instanz des Prüfobjekts erstellt wird und dessen Methode ``isValid()`` aufgerufen wird.

Die Klasse ``Zend_Filter_Input`` erlaubt es, auch mehrfache Filter und Prüfklassen zu instanzieren und bei Bedarf
aufzurufen, um Sets von Eingabedaten zu bearbeiten. Siehe :ref:`Zend_Filter_Input <zend.filter.input>`.

.. _zend.validate.introduction.static.namespaces:

Namespaces
^^^^^^^^^^

Wenn man mit selbst definierten Prüfungen arbeitet, dann kann man an ``Zend_Validate::is()`` einen vierten
Parameter übergeben welcher der Namespace ist, an dem die eigene Prüfung gefunden werden kann.

.. code-block:: php
   :linenos:

   if (Zend_Validate::is($value, 'MyValidator', array('min' => 1, 'max' => 12),
                         array('FirstNamespace', 'SecondNamespace')) {
       // Ja, $value ist in Ordnung
   }

``Zend_Validate`` erlaubt es auch, standardmäßige Namespaces zu setzen. Das bedeutet, dass man sie einmal in der
Bootstrap setzt und sie nicht mehr bei jedem Aufruf von ``Zend_Validate::is()`` angeben muss. Der folgende
Codeschnipsel ist identisch mit dem vorherigen.

.. code-block:: php
   :linenos:

   Zend_Validate::setDefaultNamespaces(array('FirstNamespace', 'SecondNamespace'));
   if (Zend_Validate::is($value, 'MyValidator', array('min' => 1, 'max' => 12)) {
       // Yes, $value is ok
   }

   if (Zend_Validate::is($value,
                         'OtherValidator',
                         array('min' => 1, 'max' => 12)) {
       // Yes, $value is ok
   }

Der Bequemlichkeit halber gibt es die folgenden Methoden, welche die Behandlung von Namespaces erlauben:

- **Zend_Validate::getDefaultNamespaces()**: Gibt alle standardmäßigen Namespaces als Array zurück.

- **Zend_Validate::setDefaultNamespaces()**: Setzt neue standardmäßige Namespaces und überschreibt alle vorher
  gesetzten. Es wird entweder ein String für einen einzelnen Namespace akzeptiert oder ein Array für mehrere
  Namespaces.

- **Zend_Validate::addDefaultNamespaces()**: Fügt zusätzliche Namespaces zu den bereits gesetzten hinzu. Es wird
  entweder ein String für einen einzelnen Namespace akzeptiert oder ein Array für mehrere Namespaces.

- **Zend_Validate::hasDefaultNamespaces()**: Gibt ``TRUE`` zurück, wenn ein oder mehrere standardmäßige
  Namespaces gesetzt sind und ``FALSE``, wenn keine standardmäßigen Namespaces gesetzt sind.

.. _zend.validate.introduction.translation:

Meldungen übersetzen
--------------------

Prüfungsklassen bieten eine Methode ``setTranslator()``, mit der man eine Instanz von ``Zend_Translator``
definieren kann, die Nachrichten im Falle eines Prüfungsfehlers übersetzt. Die ``getTranslator()`` Methode gibt
die gesetzte Übersetzungsinstanz zurück.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(array('min' => 8, 'max' => 12));
   $translate = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array(
               Zend_Validate_StringLength::TOO_SHORT => 'Übersetzt \'%value%\''
           ),
           'locale'  => 'en'
       )
   );

   $validator->setTranslator($translate);

Mit der statischen Methode ``setDefaultTranslator()`` kann eine Instanz von ``Zend_Translator`` gesetzt werden und
mit ``getDefaultTranslator()`` empfangen. Das verhindert, dass man den Übersetzer manuell für alle
Prüfungsklassen setzen muss und vereinfacht den Code.

.. code-block:: php
   :linenos:

   $translate = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array(
               Zend_Validate_StringLength::TOO_SHORT => 'Übersetzt \'%value%\''
           ),
           'locale'  => 'en'
       )
   );
   Zend_Validate::setDefaultTranslator($translate);

.. note::

   Wenn man ein anwendungsweites Gebietsschema in der Registry gesetzt hat, wird dieses Gebietsschema als
   standardmäßiger Übersetzer verwendet.

Manchmal ist es notwendig, den Übersetzer in einer Prüfklasse auszuschalten. Um das zu tun, kann die Methode
``setDisableTranslator()`` verwendet werden, welche einen booleschen Wert akzeptiert und
``isTranslatorDisabled()``, um den gesetzten Wert zu erhalten.

.. code-block:: php
   :linenos:

   $validator = new Zend_Validate_StringLength(array('min' => 8, 'max' => 12));
   if (!$validator->isTranslatorDisabled()) {
       $validator->setDisableTranslator();
   }

Es ist auch möglich einen Übersetzer zu verwenden, statt eigene Meldungen mit ``setMessage()`` zu setzen. Aber
wenn man das tut, sollte man im Kopf behalten, dass der Übersetzer auch mit den Meldungen arbeitet, die man selbst
gesetzt hat.


