.. _zend.view.helpers.initial.translator:

Übersetzungs Helfer
===================

Oft sind Webseiten in verschiedenen Sprachen vorhanden. Um den Inhalt einer Site zu übersetzen sollte ganz einfach
:ref:`Zend_Translator <zend.translator.introduction>` verwendet werden, und um ``Zend_Translator`` in der eigenen
View zu integrieren sollte der **Translator** View Helfer verwendet werden.

In allen folgenden Beispielen verwenden wir den einfachen Array Übersetzungs Adapter. Natürlich kann jede Instanz
von ``Zend_Translator`` und genauso jede Subklasse von ``Zend_Translator_Adapter`` verwendet werden. Es gibt
verschiedene Wege den **Translator** View Helfer zu initiieren:

- Registriert, durch eine vorher in ``Zend_Registry`` registrierte Instanz

- Danach, durch das Fluent Interface

- Direkt, durch Instanzierung der Klasse

Eine registrierte Instanz von ``Zend_Translator`` ist die bevorzugte Verwendung für diesen Helfer. Bevor der
Adapter der Registry hinzugefügt wird, kann das zu verwendende Gebietsschema einfach ausgewählt werden.

.. note::

   Wir sprechen hier von Gebietsschemata (Locale) statt von Sprachen weil eine Sprache auch in verschiedenen
   Regionen vorhanden sein kann. Zum Beispiel wird Englisch in verschiedenen Dialekten gesprochen. Es könnte eine
   Übersetzung für Britisch und eine für Amerikanisches Englisch geben. Deswegen sagen wir Gebietsschema
   "locale" statt Sprache.

.. _zend.view.helpers.initial.translator.registered:

.. rubric:: Registrierte Instanz

Um eine registrierte Instanz zu verwenden muß einfach eine Instanz von ``Zend_Translator`` oder
``Zend_Translator_Adapter`` erstellt werden und in ``Zend_Registry`` durch Verwendung des Schlüssels
``Zend_Translator`` registriert werden.

.. code-block:: php
   :linenos:

   // unser Beispieladapter
   $adapter = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array('simple' => 'einfach'),
           'locale'  => 'de'
       )
   );
   Zend_Registry::set('Zend_Translator', $adapter);

   // In der View
   echo $this->translate('simple');
   // gibt 'einfach' zurück

Wenn man mit dem Fluent Interface besser zurecht kommt, kann eine Instanz auch in der View erstellt werden und der
Helfer im Nachhinein initiiert werden.

.. _zend.view.helpers.initial.translator.afterwards:

.. rubric:: In der View

Um das Fluid Interface zu verwenden muß eine Instanz von ``Zend_Translator`` oder ``Zend_Translator_Adapter``
erstellt werden, der Helfer ohne Parameter und anschließend die ``setTranslator()`` Methode aufgerufen werden.

.. code-block:: php
   :linenos:

   // in der View
   $adapter = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array('simple' => 'einfach'),
           'locale'  => 'de'
       )
   );
   $this->translate()->setTranslator($adapter)->translate('simple');
   // das gibt 'einfach' zurück

Wenn der Helfer ohne ``Zend_View`` verwendet werden soll kann er auch direkt angesprochen werden.

.. _zend.view.helpers.initial.translator.directly:

.. rubric:: Direkte Verwendung

.. code-block:: php
   :linenos:

   // unser Beispieladapter
   $adapter = new Zend_Translator(
       array(
           'adapter' => 'array',
           'content' => array('simple' => 'einfach'),
           'locale'  => 'de'
       )
   );

   // den Helfer initiieren
   $translate = new Zend_View_Helper_Translator($adapter);
   print $translate->translate('simple'); // das gibt 'einfach' zurück

Dieser Weg kann verwendet werden wenn man nicht mit ``Zend_View`` arbeitet und übersetzte Ausgaben erzeugen muß.

Wie man bereits sehen konnte, wird die ``translate()`` Methode verwendet um die Übersetzung zurückzugeben. Sie
muss nur mit der benötigten messageid des Übersetzungsadapters aufgerufen werden. Aber sie kann auch Parameter im
Übersetzungsstring ersetzen. Deswegen akzeptiert Sie variable Parameter in zwei Wegen: entweder als Liste von
Parametern, oder als Array von Parametern. Als Beispiel:

.. _zend.view.helpers.initial.translator.parameter:

.. rubric:: Einzelne Parameter

Um einen einzelnen Parameter zu verwenden muss dieser einfach der Methode angefügt werden.

.. code-block:: php
   :linenos:

   // innerhalb der View
   $date = "Montag";
   $this->translate("Today is %1\$s", $date);
   // könnte 'Heute ist Montag' zurückgeben

.. note::

   Wenn man Parameter verwendet die auch Text sind ist zu beachten das es auch nötig sein kann diese Parameter zu
   übersetzen.

.. _zend.view.helpers.initial.translator.parameterlist:

.. rubric:: Liste von Parametern

Oder eine Liste von Parametern verwenden und diese der Methode hinzufügen.

.. code-block:: php
   :linenos:

   // innerhalb der View
   $date = "Monday";
   $month = "April";
   $time = "11:20:55";
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s",
                    $date,
                    $month,
                    $time);
   // könnte 'Heute ist Monday in April. Aktuelle Zeit: 11:20:55' zurückgeben

.. _zend.view.helpers.initial.translator.parameterarray:

.. rubric:: Array von Parametern

Oder ein Array von Parametern verwenden und dieses der Methode hinzufügen.

.. code-block:: php
   :linenos:

   // innerhalb der View
   $date = array("Monday", "April", "11:20:55");
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);
   // könnte 'Heute ist Monday in April. Aktuelle Zeit: 11:20:55' zurückgeben

Manchmal ist es notwendig das Gebietsschema der Übersetzung zu Ändern. Das kann entweder dynamisch pro
Übersetzung oder statisch für alle folgenden Übersetzungen durchgeführt werden. Dies kann mit beidem, einer
Liste von Paramtern oder einem Array von Parametern, verwendet werden. In beiden Fällen muss das als letzter
einzelner Parameter angegeben werden.

.. _zend.view.helpers.initial.translator.dynamic:

.. rubric:: Das Gebietsschema dynamisch wechseln

.. code-block:: php
   :linenos:

   // innerhalb der View
   $date = array("Monday", "April", "11:20:55");
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date, 'it');

Dieses Beispiel gibt die italienische Übersetzung für die messageid zurück. Aber Sie wird nur einmal verwendet.
Die nächste Übersetzung verwendet wieder das Gebietsschema des Adapters. Normalerweise wird das gewünschte
Gebietsschema im Übersetzungsadapter gesetzt bevor dieser der Registry hinzugefügt wird. Das Gebietsschema kann
aber auch im Helfer gesetzt werden:

.. _zend.view.helpers.initial.translator.static:

.. rubric:: Das Gebietsschema statisch wechseln

.. code-block:: php
   :linenos:

   // innerhalb der View
   $date = array("Monday", "April", "11:20:55");
   $this->translate()->setLocale('it');
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);

Das obige Beispiel setzt **'it'** als neues standardmäßiges Gebietsschema welches für alle weiteren
Übersetzungen verwendet wird.

Natürlich gibt es auch eine ``getLocale()`` Methode um das aktuell gesetzte Gebietsschema zu erhalten.

.. _zend.view.helpers.initial.translator.getlocale:

.. rubric:: Das aktuell gesetzte Gebietsschema erhalten

.. code-block:: php
   :linenos:

   // innerhalb der View
   $date = array("Monday", "April", "11:20:55");

   // gibt 'de' als standardmäßig gesetztes Gebietsschema
   // vom obigen Beispiel zurück
   $this->translate()->getLocale();

   $this->translate()->setLocale('it');
   $this->translate("Today is %1\$s in %2\$s. Actual time: %3\$s", $date);

   // gibt 'it' als neues standardmäßig gesetztes Gebietsschema zurück
   $this->translate()->getLocale();


