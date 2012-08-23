.. EN-Revision: none
.. _learning.form.decorators.composite:

Erstellung und Darstellung von kombinierten Elementen
=====================================================

Im :ref:`letzten Abschnitt <learning.form.decorators.individual>`, hatten wir ein Beispiel welches ein "Element
für das Geburtsdatum" gezeigt hat:

.. code-block:: php
   :linenos:

   <div class="element">
       <?php echo $form->dateOfBirth->renderLabel() ?>
       <?php echo $this->formText('dateOfBirth[day]', '', array(
           'size' => 2, 'maxlength' => 2)) ?>
       /
       <?php echo $this->formText('dateOfBirth[month]', '', array(
           'size' => 2, 'maxlength' => 2)) ?>
       /
       <?php echo $this->formText('dateOfBirth[year]', '', array(
           'size' => 4, 'maxlength' => 4)) ?>
   </div>

Wie könnte man dieses Element als ``Zend_Form_Element`` Element darstellen? Wie kann man einen Decoratpr schreiben
um es darzustellen?

.. _learning.form.decorators.composite.element:

Das Element
-----------

Die Fragen darüber wie das Element arbeiten würde beinhalten:

- Wir würde man den Wert setzen und empfangen?

- Wie würde der Wert geprüft werden?

- Wie würde man trotzdem getrennte Formulareingaben für diese drei Abschnitte erlauben (Tag, Monat, Jahr)?

Die ersten zwei Fragen drehen sich um das Formularelement selbst: Wie würden ``setValue()`` und ``getValue()``
arbeiten? Es gibt aktuell eine weitere implizite Frage durch die Frage über den Decorator: Wie würde man
getrennte Datenabschnitte vom Element empfangen und/oder setzen?

Die Lösung besteht darin die ``setValue()`` Methode des Elements zu überladen um eigene Logik anzubieten. In
diesem speziellen Fall sollte unser Element drei getrennte Verhalten haben:

- Wenn ein Integer Zeitpunkt angegeben wird, sollte er verwendet werden um Tag, Monat und Jahr zu erkennen und zu
  speichern.

- Wenn ein textueller String angegeben wird sollte er in einen Zeitpunkt gecastet werden, und dieser Wert sollte
  verwendet werden um Tag, Monat und Jahr zu erkennen und zu speichern.

- Wenn ein Array angegeben wird welches die Schlüssel für Tag, Monat und Jahr enthält, dann sollten diese Werte
  gespeichert werden.

Intern werden Tag, Monat und Jahr getrennt gespeichert. Wenn der Wert des Elements empfangen wird, wird das in
einem normalisierten String Format getan. Wir überschreiben ``getValue()`` und ordnen die getrennten
Datenabschnitte dem endgültigen String zu.

So würde die Klasse aussehen:

.. code-block:: php
   :linenos:

   class My_Form_Element_Date extends Zend_Form_Element_Xhtml
   {
       protected $_dateFormat = '%year%-%month%-%day%';
       protected $_day;
       protected $_month;
       protected $_year;

       public function setDay($value)
       {
           $this->_day = (int) $value;
           return $this;
       }

       public function getDay()
       {
           return $this->_day;
       }

       public function setMonth($value)
       {
           $this->_month = (int) $value;
           return $this;
       }

       public function getMonth()
       {
           return $this->_month;
       }

       public function setYear($value)
       {
           $this->_year = (int) $value;
           return $this;
       }

       public function getYear()
       {
           return $this->_year;
       }

       public function setValue($value)
       {
           if (is_int($value)) {
               $this->setDay(date('d', $value))
                    ->setMonth(date('m', $value))
                    ->setYear(date('Y', $value));
           } elseif (is_string($value)) {
               $date = strtotime($value);
               $this->setDay(date('d', $date))
                    ->setMonth(date('m', $date))
                    ->setYear(date('Y', $date));
           } elseif (is_array($value)
                     && (isset($value['day'])
                         && isset($value['month'])
                         && isset($value['year'])
                     )
           ) {
               $this->setDay($value['day'])
                    ->setMonth($value['month'])
                    ->setYear($value['year']);
           } else {
               throw new Exception('Ungültiger Datumswert angegeben');
           }

           return $this;
       }

       public function getValue()
       {
           return str_replace(
               array('%year%', '%month%', '%day%'),
               array($this->getYear(), $this->getMonth(), $this->getDay()),
               $this->_dateFormat
           );
       }
   }

Diese Klasse bietet einige nette Flexibilitäten -- wir können Standardwerte von unserer Datenbank setzen, und
sicher sein das der Wert richtig gespeichert und dargestellt wird. Zusätzlich können wir erlauben den Wert von
einem Array zu setzen welches über die Formulareingabe übergebenen wurde. Letztendlich haben wir getrennte
Zugriffe für jeden Datenabschnitt, welche wir jetzt in einem Decorator verwenden können um ein kombiniertes
Element zu erstellen.

.. _learning.form.decorators.composite.decorator:

Der Decorator
-------------

Bei der erneuten Betrachtung des Beispiels im letzten Abschnitt, nehmen wir wir an dass wir wollen das unsere
Benutzer Jahr, Monat und Tag separat eingeben. *PHP* erlaubt es uns glücklicherweise die Array Schreibweise zu
verwenden wenn Elemente erstellt werden, deshalb ist es möglich diese drei Entitäten in einem einzelnen Wert zu
fangen -- und wir erstellen jetzt ein ``Zend_Form`` Element das solch einen Array Wert verarbeiten kann.

Der Decorator ist relativ einfach: er holt Tag, Monat und Jahr vom Element, und übergibt jedes einem eigenen View
Helfer um die individuellen Formular Eingaben darzustellen; diese werden dann für das endgültige Markup
gesammelt.

.. code-block:: php
   :linenos:

   class My_Form_Decorator_Date extends Zend_Form_Decorator_Abstract
   {
       public function render($content)
       {
           $element = $this->getElement();
           if (!$element instanceof My_Form_Element_Date) {
               // wir wollen nur das Date Element darstellen
               return $content;
           }

           $view = $element->getView();
           if (!$view instanceof Zend_View_Interface) {
               // verwenden von View Helfers, deshalb ist nichts zu tun
               // wenn keine View vorhanden ist
               return $content;
           }

           $day   = $element->getDay();
           $month = $element->getMonth();
           $year  = $element->getYear();
           $name  = $element->getFullyQualifiedName();

           $params = array(
               'size'      => 2,
               'maxlength' => 2,
           );
           $yearParams = array(
               'size'      => 4,
               'maxlength' => 4,
           );

           $markup = $view->formText($name . '[day]', $day, $params)
                   . ' / ' . $view->formText($name . '[month]', $month, $params)
                   . ' / ' . $view->formText($name . '[year]', $year, $yearParams);

           switch ($this->getPlacement()) {
               case self::PREPEND:
                   return $markup . $this->getSeparator() . $content;
               case self::APPEND:
               default:
                   return $content . $this->getSeparator() . $markup;
           }
       }
   }

Jetzt müssen wir kleinere Änderungen an unserem Formular Element durchführen und Ihm sagen das wir den obigen
Decorator als Standard verwenden wollen. Das benötigt zwei Schritte. Erstens müssen wir das Element über den
Pfad des Decorators informieren. Wir können das im Constructor tun:

.. code-block:: php
   :linenos:

   class My_Form_Element_Date extends Zend_Form_Element_Xhtml
   {
       // ...

       public function __construct($spec, $options = null)
       {
           $this->addPrefixPath(
               'My_Form_Decorator',
               'My/Form/Decorator',
               'decorator'
           );
           parent::__construct($spec, $options);
       }

       // ...
   }

Es ist zu beachten dass das im Constructor getan wird und nicht in ``init()``. Es gibt hierfür zwei Gründe.
Erstens erlaubt dies das Element später zu erweitern um Logik in ``init`` hinzuzufügen ohne das man sich Gedanken
über den Aufruf von ``parent::init()`` machen muss. Zweitens erlaubt es zusätzliche Plugin Pfade über die
Konfiguration zu übergeben oder in einer ``init`` Methode die dann das Überladen des standardmäßigen ``Date``
Decorators mit einem eigenen Ersatz erlaubt.

Als nächstes überladen wir die ``loadDefaultDecorators()`` Methode um unseren neuen ``Date`` Decorator zu
verwenden:

.. code-block:: php
   :linenos:

   class My_Form_Element_Date extends Zend_Form_Element_Xhtml
   {
       // ...

       public function loadDefaultDecorators()
       {
           if ($this->loadDefaultDecoratorsIsDisabled()) {
               return;
           }

           $decorators = $this->getDecorators();
           if (empty($decorators)) {
               $this->addDecorator('Date')
                    ->addDecorator('Errors')
                    ->addDecorator('Description', array(
                        'tag'   => 'p',
                        'class' => 'description'
                    ))
                    ->addDecorator('HtmlTag', array(
                        'tag' => 'dd',
                        'id'  => $this->getName() . '-element'
                    ))
                    ->addDecorator('Label', array('tag' => 'dt'));
           }
       }

       // ...
   }

Wie sieht die endgültige Ausgabe aus=? Nehmen wir das folgende Element an:

.. code-block:: php
   :linenos:

   $d = new My_Form_Element_Date('dateOfBirth');
   $d->setLabel('Geburtsdatum: ')
     ->setView(new Zend_View());

   // Das sind Äquivalente:
   $d->setValue('20 April 2009');
   $d->setValue(array('year' => '2009', 'month' => '04', 'day' => '20'));

Wenn man dieses Element ausgibt erhält man das folgende Markup (mit einigen wenigen Modifikationen an Leerzeichen
für die Lesbarkeit):

.. code-block:: html
   :linenos:

   <dt id="dateOfBirth-label"><label for="dateOfBirth" class="optional">
       Geburtsdatum:
   </label></dt>
   <dd id="dateOfBirth-element">
       <input type="text" name="dateOfBirth[day]" id="dateOfBirth-day"
           value="20" size="2" maxlength="2"> /
       <input type="text" name="dateOfBirth[month]" id="dateOfBirth-month"
           value="4" size="2" maxlength="2"> /
       <input type="text" name="dateOfBirth[year]" id="dateOfBirth-year"
           value="2009" size="4" maxlength="4">
   </dd>

.. _learning.form.decorators.composite.conclusion:

Zusammenfassung
---------------

Wir haben jetzt ein Element das mehrere zusammengehörende Formular Eingabefelder darstellen kann, und die
getrennten Felder anschließend als einzelne Entität behandelt -- das Element ``dateOfBirth`` wird als Array an
das Element übergeben, und das Element wird anschließend, wie vorher erwähnt, die passenden Datenabschnitte
erstellen und einen Wert zurückgeben den wir für die meisten Backends verwenden können.

Am Ende erhält man eine einheitliche *API* für ein Element welche man verwenden kann um ein Element zu
beschreiben welches einen kombinierten Wert repräsentiert.


