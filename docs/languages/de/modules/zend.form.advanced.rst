.. _zend.form.advanced:

Fortgeschrittene Verwendung von Zend_Form
=========================================

``Zend_Form`` hat eine Vielzahl an Funktionalitäten, von denen viele auf fortgeschrittene Entwickler zugeschnitten
sind. Dieses Kapitel beschreibt einige dieser Funktionalitäten mit Beispielen und Usecases.

.. _zend.form.advanced.arrayNotation:

Array Schreibweise
------------------

Viele fortgeschrittene Entwickler gruppieren zusammengehörige Formularelemente durch Verwendung einer Array
Schreibweise in den Namen der Elemente. Zum Beispiel, wenn man zwei Adressen hat die geholt werden sollen, eine
Versand- und eine Rechnungsadresse, hat man identische Elemente; durch deren Gruppierung in einem Array, kann
sichergestellt werden, dass sie separat geholt werden. Nehmen wir die folgende Form als Beispiel an:

.. code-block:: html
   :linenos:

   <form>
       <fieldset>
           <legend>Versandadresse</legend>
           <dl>
               <dt><label for="recipient">Versand an:</label></dt>
               <dd><input name="recipient" type="text" value="" /></dd>

               <dt><label for="address">Adresse:</label></dt>
               <dd><input name="address" type="text" value="" /></dd>

               <dt><label for="municipality">Stadt:</label></dt>
               <dd><input name="municipality" type="text" value="" /></dd>

               <dt><label for="province">Bundesland:</label></dt>
               <dd><input name="province" type="text" value="" /></dd>

               <dt><label for="postal">Postleitzahl:</label></dt>
               <dd><input name="postal" type="text" value="" /></dd>
           </dl>
       </fieldset>

       <fieldset>
           <legend>Rechnungsadresse</legend>
           <dl>
               <dt><label for="payer">Rechnung an:</label></dt>
               <dd><input name="payer" type="text" value="" /></dd>

               <dt><label for="address">Adresse:</label></dt>
               <dd><input name="address" type="text" value="" /></dd>

               <dt><label for="municipality">Stadt:</label></dt>
               <dd><input name="municipality" type="text" value="" /></dd>

               <dt><label for="province">Bundesland:</label></dt>
               <dd><input name="province" type="text" value="" /></dd>

               <dt><label for="postal">Postleitzahl:</label></dt>
               <dd><input name="postal" type="text" value="" /></dd>
           </dl>
       </fieldset>

       <dl>
           <dt><label for="terms">Ich stimme den AGBs zu</label></dt>
           <dd><input name="terms" type="checkbox" value="" /></dd>

           <dt></dt>
           <dd><input name="save" type="submit" value="Speichern" /></dd>
       </dl>
   </form>

In diesem Beispiel enthalten die Rechnungs- und Versanadresse einige identische Felder, was bedeueten würde, dass
sie sich gegenseitig überschreiben. Wir können das durch die Verwendung der Array Schreibweise lösen:

.. code-block:: html
   :linenos:

   <form>
       <fieldset>
           <legend>Versandadresse</legend>
           <dl>
               <dt><label for="shipping-recipient">Versand an:</label></dt>
               <dd><input name="shipping[recipient]" id="shipping-recipient"
                   type="text" value="" /></dd>

               <dt><label for="shipping-address">Adresse:</label></dt>
               <dd><input name="shipping[address]" id="shipping-address"
                   type="text" value="" /></dd>

               <dt><label for="shipping-municipality">Stadt:</label></dt>
               <dd><input name="shipping[municipality]" id="shipping-municipality"
                   type="text" value="" /></dd>

               <dt><label for="shipping-province">Bundesland:</label></dt>
               <dd><input name="shipping[province]" id="shipping-province"
                   type="text" value="" /></dd>

               <dt><label for="shipping-postal">Postleitzahl:</label></dt>
               <dd><input name="shipping[postal]" id="shipping-postal"
                   type="text" value="" /></dd>
           </dl>
       </fieldset>

       <fieldset>
           <legend>Rechnungsadresse</legend>
           <dl>
               <dt><label for="billing-payer">Rechnung an:</label></dt>
               <dd><input name="billing[payer]" id="billing-payer"
                   type="text" value="" /></dd>

               <dt><label for="billing-address">Adresse:</label></dt>
               <dd><input name="billing[address]" id="billing-address"
                   type="text" value="" /></dd>

               <dt><label for="billing-municipality">Stadt:</label></dt>
               <dd><input name="billing[municipality]" id="billing-municipality"
                   type="text" value="" /></dd>

               <dt><label for="billing-province">Bundesland:</label></dt>
               <dd><input name="billing[province]" id="billing-province"
                   type="text" value="" /></dd>

               <dt><label for="billing-postal">Postleitzahl:</label></dt>
               <dd><input name="billing[postal]" id="billing-postal"
                   type="text" value="" /></dd>
           </dl>
       </fieldset>

       <dl>
           <dt><label for="terms">Ich stimme den AGBs zu</label></dt>
           <dd><input name="terms" type="checkbox" value="" /></dd>

           <dt></dt>
           <dd><input name="save" type="submit" value="Speichern" /></dd>
       </dl>
   </form>

In dem obigen Beispiel erhalten wir jetzt separate Adressen. In der übermittelten Form haben wir jetzt zwei
Elemente, 'shipping' und 'billing', jedes mit Schlüsseln für deren verschiedene Elemente.

``Zend_Form`` versucht diesen Prozess mit seinen :ref:`Unterformularen <zend.form.forms.subforms>` zu
automatisieren. Standardmäßig werden Unterformulare dargestellt, indem die Array Schreibweise, wie im vorherigen
*HTML* Form Code gezeigt, komplett mit Ids, verwendet wird. Der Arrayname basiert auf dem Namen des Unterformulars,
mit den Schlüsseln basierend auf den Elementen, die im Unterformualr enthalten sind. Unterformulare können
beliebig tief verschachtelt sein, und das erzeugt verschachtelte Arrays um die Struktur zu reflektieren.
Zusätzlich beachten die verschiedenen Prüfroutinen in ``Zend_Form`` die Arraystruktur, und stellen sicher, dass
die form korrekt überprüft wird, egal wie tief verschachtelt die Unterformulare sind. Es muss nichts getan
werden, um davon zu profitieren; dieses Verhalten ist standardmäßig aktiviert.

Zusätzlich gibt es Möglichkeiten, die es erlauben die Array Schreibweise fallweise zu aktivieren, wie auch die
Spezifikation eines speziellen Array zu welchem ein Element oder eine Sammlung gehört:

- ``Zend_Form::setIsArray($flag)``: Durch das Setzen dieses Flags auf ``TRUE``, kann angezeigt werden, dass das
  komplette Formular als Array behandelt werden soll. Standardmäßig wird der Name des Formulars als Name des
  Arrays verwendet, solange ``setElementsBelongTo()`` aufgerufen wurde. Wenn das Formular keinen Namen spezifiziert
  hat, oder ``setElementsBelongTo()`` nicht gesetzt wurde, wird dieses Flag ignoriert (da es kein Arraynamen gibt
  zu dem die Elemente gehören).

  Man kann auswählen, ob ein Formular als Array behandelt wird, indem die Zugriffsmethode ``isArray()`` verwendet
  wird.

- ``Zend_Form::setElementsBelongTo($array)``: Durch Verwendung dieser Methode kann der Name eines Arrays
  spezifiziert werden dem alle Elemente des Formulars angehören. Der Name kann durch Verwendung der
  Zugriffsmethode ``getElementsBelongTo()`` eruiert werden.

Zusätzlich können auf dem Element Level, individuelle Elemente spezifiziert werden die bestimmten Arrays
angehören indem die ``Zend_Form_Element::setBelongsTo()`` Methode verwendet wird. Um herauszufinden welcher Wert
gesetzt ist -- egal ob dieser explizit gesetzt wurde oder implzit über das Formular -- kann die Zugriffsmethode
``getBelongsTo()`` verwendet werden.

.. _zend.form.advanced.multiPage:

Mehrseitige Formulare
---------------------

Aktuell werden mehrseitige Formulare nicht offiziell in ``Zend_Form`` unterstützt; trotzdem ist die meiste
Unterstützung für deren Implementierung bereits vorhanden und kann mit etwas extra Code angepasst werden.

Der Schlüssel in der Erstellung von mehrseitigen Formularen, ist die Anpassung von Unterformularen, aber der
Anzeige, von nur einem Unterformular pro Seite. Das erlaubt es, ein einzelnes Unterformular auf einmal zu
übertragen und diese zu prüfen, aber das Formular nicht zu bearbeiten bis alle weiteren Unterformulare komplett
sind.

.. _zend.form.advanced.multiPage.registration:

.. rubric:: Beispiel: Anmeldeformular

Verwenden wir also ein Anmeldeformular als Beispiel. Für unsere Zwecke wollen wir auf der ersten Seite einen
gewünschten Benutzernamen und Passwort holen, dann die Metadaten des Benutzers -- das heißt Vorname, Familienname
und Wohnort -- und letztendlich die Auswahl welcher Mailingliste, wenn überhaupt, der Benutzer angehören will.

Erstellen wir als erstes unser, eigenes, Formular und definieren in diesem die verschiedenen Unterformulare:

.. code-block:: php
   :linenos:

   class My_Form_Registration extends Zend_Form
   {
       public function init()
       {
           // Erstellt die Benutzer Subform: Benutzername und Passwort
           $user = new Zend_Form_SubForm();
           $user->addElements(array(
               new Zend_Form_Element_Text('username', array(
                   'required'   => true,
                   'label'      => 'Benutzername:',
                   'filters'    => array('StringTrim', 'StringToLower'),
                   'validators' => array(
                       'Alnum',
                       array('Regex',
                             false,
                             array('/^[a-z][a-z0-9]{2,}$/'))
                   )
               )),

               new Zend_Form_Element_Password('password', array(
                   'required'   => true,
                   'label'      => 'Passwort:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       'NotEmpty',
                       array('StringLength', false, array(6))
                   )
               )),
           ));

           // Erstellt die Demographische Subform: Vorname,
           // Familienname und Ort
           $demog = new Zend_Form_SubForm();
           $demog->addElements(array(
               new Zend_Form_Element_Text('givenName', array(
                   'required'   => true,
                   'label'      => 'Vorname (erster):',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('Regex',
                             false,
                             array('/^[a-z][a-z0-9., \'-]{2,}$/i'))
                   )
               )),

               new Zend_Form_Element_Text('familyName', array(
                   'required'   => true,
                   'label'      => 'Familienname (letzter):',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('Regex',
                             false,
                             array('/^[a-z][a-z0-9., \'-]{2,}$/i'))
                   )
               )),

               new Zend_Form_Element_Text('location', array(
                   'required'   => true,
                   'label'      => 'Der eigene Ort:',
                   'filters'    => array('StringTrim'),
                   'validators' => array(
                       array('StringLength', false, array(2))
                   )
               )),
           ));

           // Erstellt die Mailinglisten Subform
           $listOptions = array(
               'none'        => 'keine Listen bitte',
               'fw-general'  => 'Zend Framework General Liste',
               'fw-mvc'      => 'Zend Framework MVC Liste',
               'fw-auth'     => 'Zend Framework Authentication und ACL Liste',
               'fw-services' => 'Zend Framework Web Services Liste',
           );
           $lists = new Zend_Form_SubForm();
           $lists->addElements(array(
               new Zend_Form_Element_MultiCheckbox('subscriptions', array(
                   'label'        =>
                       'Welche Liste wollen Sie erhalten?',
                   'multiOptions' => $listOptions,
                   'required'     => true,
                   'filters'      => array('StringTrim'),
                   'validators'   => array(
                       array('InArray',
                             false,
                             array(array_keys($listOptions)))
                   )
               )),
           ));

           // Die Subformen der Hauptform anhängen
           $this->addSubForms(array(
               'user'  => $user,
               'demog' => $demog,
               'lists' => $lists
           ));
       }
   }

Es ist zu beachten, dass es keinen 'Abschicken' Button gibt, und, dass wir nichts mit den Dekoratoren des
Unterformulars gemacht haben -- was bedeutet, dass Sie standardmäßig als Fieldsets angezeigt werden. Wir müssen
das Überladen wenn wir jedes individuelle Unterformular anzeigen wollen und einen 'Abschicken' Button hinzufügen,
damit wir sie dann bearbeiten können -- was auch Aktions- und Methodeneigenschaften benötigt. Füllen wir unsere
Klasse ein wenig und bieten diese Information:

.. code-block:: php
   :linenos:

   class My_Form_Registration extends Zend_Form
   {
       // ...

       /**
        * Eine Subform für die anzeige Vorbereiten
        *
        * @param  string|Zend_Form_SubForm $spec
        * @return Zend_Form_SubForm
        */
       public function prepareSubForm($spec)
       {
           if (is_string($spec)) {
               $subForm = $this->{$spec};
           } elseif ($spec instanceof Zend_Form_SubForm) {
               $subForm = $spec;
           } else {
               throw new Exception('Ungültiges Argument an ' .
                                   __FUNCTION__ . '() übergeben');
           }
           $this->setSubFormDecorators($subForm)
                ->addSubmitButton($subForm)
                ->addSubFormActions($subForm);
           return $subForm;
       }

       /**
        * Form Dekoratore zu einer individuellen Subform hinzufügen
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function setSubFormDecorators(Zend_Form_SubForm $subForm)
       {
           $subForm->setDecorators(array(
               'FormElements',
               array('HtmlTag', array('tag' => 'dl',
                                      'class' => 'zend_form')),
               'Form',
           ));
           return $this;
       }

       /**
        * Einen Sendebutton in einer individuellen Subform hinzufügen
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function addSubmitButton(Zend_Form_SubForm $subForm)
       {
           $subForm->addElement(new Zend_Form_Element_Submit(
               'save',
               array(
                   'label'    => 'Speichern und Fortfahren',
                   'required' => false,
                   'ignore'   => true,
               )
           ));
           return $this;
       }

       /**
        * Aktion und Methode der Subform hinzufügen
        *
        * @param  Zend_Form_SubForm $subForm
        * @return My_Form_Registration
        */
       public function addSubFormActions(Zend_Form_SubForm $subForm)
       {
           $subForm->setAction('/registration/process')
                   ->setMethod('post');
           return $this;
       }
   }

Als nächstes benötigen wir das Grundgerüst für unseren Action Controller, und wir haben verschiedene
Entscheidungen zu treffen. Zuerst müssen wir sicherstellen, dass die Formulardaten zwischen den Anfragen fixiert
werden, sodass wir feststellen können wann abgebrochen wird. Zweitens wird etwas Logik benötigt, um festzustellen
welche Formularteile bereits übermittelt wurden und welches Unterformular, basierend auf dieser Information,
angezeigt werden soll. Wir verwenden ``Zend_Session_Namespace`` um Daten zu fixieren, was uns auch hilft die Frage
zu beantworten welches Formular zu übertragen ist.

Erstellen wir also unseren Controller, und fügen eine Methode für den Empfang der Formular Instanz hinzu:

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       protected $_form;

       public function getForm()
       {
           if (null === $this->_form) {
               $this->_form = new My_Form_Registration();
           }
           return $this->_form;
       }
   }

Füllen wir unseren Controller nun um die Funktionalität, zu erkennen, welches Formular angezeigt werden soll.
Grundsätzlich müssen wir, bis das komplette Formular als gültig angenommen wird, die Darstellung der
Formularabschnitte weiterführen. Zusätzlich müssen wir sicherstellen, dass sie in einer bestimmten Reihenfolge
sind: Benutzer, Zusätze und dann Listen. Wir können feststellen, ob Daten übertragen wurden, indem wir im
Namensraum der Session nach speziellen Schlüssen suchen, die jedes Unterformular repräsentieren.

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       protected $_namespace = 'RegistrationController';
       protected $_session;

       /**
        * Den Session Namespace erhalten den wir verwenden
        *
        * @return Zend_Session_Namespace
        */
       public function getSessionNamespace()
       {
           if (null === $this->_session) {
               $this->_session =
                   new Zend_Session_Namespace($this->_namespace);
           }

           return $this->_session;
       }

       /**
        * Eine Liste von bereits in der Session gespeicherten Forms erhalten
        *
        * @return array
        */
       public function getStoredForms()
       {
           $stored = array();
           foreach ($this->getSessionNamespace() as $key => $value) {
               $stored[] = $key;
           }

           return $stored;
       }

       /**
        * Eine Liste aller vorhandenen Subforms erhalten
        *
        * @return array
        */
       public function getPotentialForms()
       {
           return array_keys($this->getForm()->getSubForms());
       }

       /**
        * Welche Subform wurde übermittelt?
        *
        * @return false|Zend_Form_SubForm
        */
       public function getCurrentSubForm()
       {
           $request = $this->getRequest();
           if (!$request->isPost()) {
               return false;
           }

           foreach ($this->getPotentialForms() as $name) {
               if ($data = $request->getPost($name, false)) {
                   if (is_array($data)) {
                       return $this->getForm()->getSubForm($name);
                       break;
                   }
               }
           }

           return false;
       }

       /**
        * Die nächste Suboform für die Anzeige erhalten
        *
        * @return Zend_Form_SubForm|false
        */
       public function getNextSubForm()
       {
           $storedForms    = $this->getStoredForms();
           $potentialForms = $this->getPotentialForms();

           foreach ($potentialForms as $name) {
               if (!in_array($name, $storedForms)) {
                   return $this->getForm()->getSubForm($name);
               }
           }

           return false;
       }
   }

Die obigen Methoden erlauben uns eine Schreibweise wie ``$subForm = $this->getCurrentSubForm();`` um das aktuelle
Unterformular für die Prüfung zu erhalten, oder ``$next = $this->getNextSubForm();``, um die nächste anzuzeigen.

Sehen wir uns nun an, wie die verschiedenen Unterformulare bearbeitet und angezeigt werden können. Wir können
``getCurrentSubForm()`` verwenden um herauszufinden ob ein Unterformular übertragen wurde (``FALSE``
Rückgabewerte zeigen an, dass keine angezeigt oder übertragen wurden) und ``getNextSubForm()`` empfängt die Form
die angezeigt werden soll. Wir können die ``prepareSubForm()`` Methode des Formulars verwenden, um
sicherzustellen, dass das Formular bereit zur Anzeige ist.

Wenn ein Formular übertragen wird, kann das Unterformular bestätigt werden, und dann kann geprüft werden, ob das
komplette Formular gültig ist. Um diese Arbeiten durchzuführen werden zusätzliche Methoden benötigt die
sicherstellen, dass die übermittelten Daten der Session hinzugefügt werden, und, dass, wenn das komplette
Formular geprüft wird, die Prüfung gegen alle Teile der Session durchgeführt wird:

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Form
   {
       // ...

       /**
        * Ist die Form gültig?
        *
        * @param  Zend_Form_SubForm $subForm
        * @param  array $data
        * @return bool
        */
       public function subFormIsValid(Zend_Form_SubForm $subForm,
                                      array $data)
       {
           $name = $subForm->getName();
           if ($subForm->isValid($data)) {
               $this->getSessionNamespace()->$name = $subForm->getValues();
               return true;
           }

           return false;
       }

       /**
        * Ist die komplette Form gültig?
        *
        * @return bool
        */
       public function formIsValid()
       {
           $data = array();
           foreach ($this->getSessionNamespace() as $key => $info) {
               $data[$key] = $info;
           }

           return $this->getForm()->isValid($data);
       }
   }

Jetzt, da die Kleinarbeiten aus dem Weg sind, können die Aktionen für diesen Controller erstellt werden. Es wird
eine Grundseite für das Formular und dann eine 'process' (Bearbeiten) Aktion für die Bearbeitung des Formulars
benötigt.

.. code-block:: php
   :linenos:

   class RegistrationController extends Zend_Controller_Action
   {
       // ...

       public function indexAction()
       {
           // Entweder die aktuelle Seite nochmals anzeigen, oder
           // die nächste "next" (erste) Subform holen
           if (!$form = $this->getCurrentSubForm()) {
               $form = $this->getNextSubForm();
           }
           $this->view->form = $this->getForm()->prepareSubForm($form);
       }

       public function processAction()
       {
           if (!$form = $this->getCurrentSubForm()) {
               return $this->_forward('index');
           }

           if (!$this->subFormIsValid($form,
                                      $this->getRequest()->getPost())) {
               $this->view->form = $this->getForm()->prepareSubForm($form);
               return $this->render('index');
           }

           if (!$this->formIsValid()) {
               $form = $this->getNextSubForm();
               $this->view->form = $this->getForm()->prepareSubForm($form);
               return $this->render('index');
           }

           // Gültige Form!
           // Information in einer Prüfseite darstellen
           $this->view->info = $this->getSessionNamespace();
           $this->render('verification');
       }
   }

Wie festzustellen ist, ist der aktuelle Code für die Bearbeitung des Formulars relativ einfach. Wir prüfen, um zu
sehen ob wir eine aktuelle Übertragung eines Unterformulars haben, oder nicht, und wir versuchen sie zu prüfen,
und sie nochmals darzustellen wenn es fehlschlägt. Wenn das Unterformular gültig ist, muss anschließend geprüft
werden, ob das Formular gültig ist, was dann bedeuten würde, dass wir fertig sind; wen nicht muss das nächste
Formularsegment angezeigt werden. Letztendlich wird eine Prüfseite mit dem Inhalt der Session angezeigt.

Die View Skripte sind sehr einfach:

.. code-block:: php
   :linenos:

   <?php // registration/index.phtml ?>
   <h2>Registration</h2>
   <?php echo $this->form ?>

   <?php // registration/verification.phtml ?>
   <h2>Danke für die Registrierung!</h2>
   <p>
       Hier sind die angegebenen Informationen:
   </p>

   <?
   // Dieses Konstrukt muß getan werden wegen dem Weg wie Elemente
   // im Session Namespace gespeichert werden
   foreach ($this->info as $info):
       foreach ($info as $form => $data): ?>
   <h4><?php echo ucfirst($form) ?>:</h4>
   <dl>
       <?php foreach ($data as $key => $value): ?>
       <dt><?php echo ucfirst($key) ?></dt>
       <?php if (is_array($value)):
           foreach ($value as $label => $val): ?>
       <dd><?php echo $val ?></dd>
           <?php endforeach;
          else: ?>
       <dd><?php echo $this->escape($value) ?></dd>
       <?php endif;
       endforeach; ?>
   </dl>
   <?php endforeach;
   endforeach ?>

Kommende Releases des Zend Frameworks werden Komponenten enthalten die mehrseitige Formulare einfacher machen -
durch die Abstraktion der Session und der Reihungslogik. In der Zwischenzeit sollte das obige Beispiel als
angemessene Grundlage dienen, wie diese Aufgabe für eigene Seiten realisiert werden kann.


