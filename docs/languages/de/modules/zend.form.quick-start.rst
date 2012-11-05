.. EN-Revision: none
.. _zend.form.quickstart:

Schnellstart mit Zend_Form
==========================

Diese Anleitung soll die Grundsätze der Erstellung, Validierung und Darstellung von Formularen mit ``Zend_Form``
zeigen.

.. _zend.form.quickstart.create:

Ein Form Objekt erstellen
-------------------------

Die Erstellung eines Formular Objektes ist sehr einfach: nur ``Zend_Form`` instanzieren:

.. code-block:: php
   :linenos:

   $form = new Zend_Form;

Für fortgeschrittene Anwendungsfälle, kann man eine ``Zend_Form`` Unterklasse erstellen, aber für einfache
Formulare, kann ein Formular programmtechnisch mit einem ``Zend_Form`` erstellt werden.

Wenn man bei einem Formular Aktion und Methode spezifizieren will (immer eine gute Idee), kann das mit den
``setAction()`` und ``setMethod()`` Methoden gemacht werden:

.. code-block:: php
   :linenos:

   $form->setAction('/resource/process')
        ->setMethod('post');

Der obige Code setzt die Formular Aktion zu der partiellen *URL*"``/resource/process``" und die Formular Methode zu
*HTTP* *POST*. Das wird während der endgültigen Darstellung berücksichtigt.

Man kann zusätzliche *HTML* Attribute für das **<form>** Tag setzen, indem die ``setAttrib()`` oder
``setAttribs()`` Methoden verwendet werden. Zum Beispiel wenn man die ID setzen will, setzt man das "``id``"
Attribut:

.. code-block:: php
   :linenos:

   $form->setAttrib('id', 'login');

.. _zend.form.quickstart.elements:

Elemente einer Form hinzufügen
------------------------------

Ein Formular ist nichts ohne seine Elemente. ``Zend_Form`` kommt mit einigen Standardelementen die *XHTML* über
``Zend_View`` Helfer darstellen. Das sind die folgenden:

- button

- checkbox (oder viele Checkboxen auf einmal mit multiCheckbox)

- hidden

- image

- password

- radio

- reset

- select (beide, normale und Mehrfachauswahl Typen)

- submit

- text

- textarea

Es gibt zwei Optionen für das Hinzufügen von Elementen zu einem Formular: Man kann ein konkretes Element
instanzieren und dieses dem Objekt übergeben, oder man kann den Typ des Elements übergeben und ``Zend_Form`` ein
Objekt des richtigen Typs für einen instanzieren lassen.

Einige Beispiele:

.. code-block:: php
   :linenos:

   // Ein Element instanzieren und an das Form Objekt übergeben:
   $form->addElement(new Zend\Form_Element\Text('username'));

   // Den Fyp des Form Elements dem Form Objekt übergeben:
   $form->addElement('text', 'username');

Standardmäßig haben diese Elemente keine Prüfer oder Filter. Das bedeutet, dass man eigene Elemente mit
minimalen Prüfern und potentiellen Filtern konfigurieren muss. Man kann das entweder (a) vor der Übergabe des
Elements an das Formular machen, (b) über Konfigurationsoptionen die bei der Erstellung des Elements über
``Zend_Form`` angegeben werden, oder (c), durch beziehen des Elements vom Formular Objekt und dessen Konfiguration
im nachhinein.

Betrachten wir zuerst die Erstellung eines Prüfers für eine konkrete Instanz eines Elements. Es können entweder
``Zend\Validate\*`` Instanzen übergeben werden, oder der Name des Prüfers, der verwendet werden soll:

.. code-block:: php
   :linenos:

   $username = new Zend\Form_Element\Text('username');

   // Ein Zend\Validate\* Objekt übergeben:
   $username->addValidator(new Zend\Validate\Alnum());

   // Den Namen des Prüfers übergeben:
   $username->addValidator('alnum');

Wenn die zweite Option verwendet wird, kann, wenn der Prüfer Argumente im Konstruktor akzeptiert, diesem ein Array
als dritter Parameter übergeben werden:

.. code-block:: php
   :linenos:

   // Ein Pattern übergeben
   $username->addValidator('regex', false, array('/^[a-z]/i'));

(Der zweite Parameter wird verwendet um anzuzeigen, ob spätere Prüfer bei einem Fehler dieses Prüfers
ausgeführt werden sollen oder nicht; standardmäßig ist er ``FALSE``.)

Es kann auch gewünscht sein, ein Element als benötigt zu spezifizieren. Das kann durch Verwendung eines Accessors
getan werden, oder durch die Übergabe einer Option bei der Erstellung des Elements. Im ersteren Fall:

.. code-block:: php
   :linenos:

   // Dieses Element als benötigt definieren:
   $username->setRequired(true);

Wenn ein Element benötigt wird, wird ein 'NotEmpty' Prüfer ganz oben in der Prüfkette definiert, um
sicherzustellen, dass dieses Element einen Wert hat wenn er benötigt wird.

Filter werden grundsätzlich auf dem gleichen Weg, wie die Prüfer, definiert. Zu Anschauungszwecken, wird ein
Filter hinzugefügt, der den endgültigen Wert klein schreibt:

.. code-block:: php
   :linenos:

   $username->addFilter('StringtoLower');

Das endgültige Setup, des Elements, könnte wie folgt aussehen:

.. code-block:: php
   :linenos:

   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]/'))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // oder kompakter:
   $username->addValidators(array('alnum',
           array('regex', false, '/^[a-z]/i')
       ))
       ->setRequired(true)
       ->addFilters(array('StringToLower'));

So einfach das ist, ist das für jedes einzelne Elemet in einer Form sehr aufwendig. Versuchen wir es also mit
Option (b) von oben. Wenn wir ein neues Element erstellen wird ``Zend\Form\Form::addElement()`` als Factory verwendet,
und wir können optional Konfigurationsoptionen übergeben. Diese können Prüfer und Filter enthalten die
angepasst werden können. Um alles von oben implizit durchzuführen, versuchen wir folgendes:

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array(
       'validators' => array(
           'alnum',
           array('regex', false, '/^[a-z]/i')
       ),
       'required' => true,
       'filters'  => array('StringToLower'),
   ));

.. note::

   Wenn man sieht, dass man Elemente welche die gleichen Optionen in vielen Plätzen verwenden, konfiguriert, kann
   es gewünscht sein, eine eigene ``Zend\Form\Element`` Unterklasse zu erstellen und diese stattdessen anzupassen;
   das spart viel Tipparbeit im weiteren Verlauf.

.. _zend.form.quickstart.render:

Ein Formular darstellen
-----------------------

Die Darstellung eines Formulars ist einfach. Die meisten Elemente verwenden einen ``Zend_View`` Helfer, um sich
selbst darzustellen und benötigen deshalb ein View Objekt, um dargestellt zu werden. Dafür gibt es zwei
unterschiedliche Varianten: Die *render()* Methode des Formulare verwenden, oder ein einfaches *echo*.

.. code-block:: php
   :linenos:

   // Explizit render() aufrufen und ein optionales View Objekt übergeben:
   echo $form->render($view);

   // Angenommen ein View Objekt wurde vorher über setView() gesetzt:
   echo $form;

Standardmäßig versuchen ``Zend_Form`` und ``Zend\Form\Element`` ein im ``ViewRenderer`` initialisiertes View
Objekt zu verwenden, was bedeutet, dass die View nicht manuell gesetzt werden muss, wenn das *MVC* des Zend
Frameworks verwendet wird. Die Darstellung eines Formulars in einem View Skript ist sehr einfach:

.. code-block:: php
   :linenos:

   <?php $this->form ?>

Unter der Hand verwendet ``Zend_Form``"Dekoratoren" um die Darstellung durchzuführen. Diese Dekoratoren können
Inhalte ersetzen, anfügen oder voranstellen, und haben eine volle Introspektive des Elements das Ihnen übergeben
wurde. Als Ergebnis können mehrere Dekoratoren kombiniert werden, um eigene Effekte zu ermöglichen.
Standardmüßig kombiniert ``Zend\Form\Element`` View Dekoratoren um seine Ausgaben zu erstellen; das Setup sieht
ähnlich diesem aus:

.. code-block:: php
   :linenos:

   $element->addDecorators(array(
       'ViewHelper',
       'Errors',
       array('HtmlTag', array('tag' => 'dd')),
       array('Label', array('tag' => 'dt')),
   ));

(Wobei <HELPERNAME> der Name des View Helfers ist der verwendet wird, und variiert basierend auf dem Element.)

Das obige Beispiel erstellt eine Ausgabe, ähnlich der folgenden:

.. code-block:: html
   :linenos:

   <dt><label for="username" class="required">Username</dt>
   <dd>
       <input type="text" name="username" value="123-abc" />
       <ul class="errors">
           <li>'123-abc' has not only alphabetic and digit characters</li>
           <li>'123-abc' does not match against pattern '/^[a-z]/i'</li>
       </ul>
   </dd>

(Wenngleich nicht mit der gleichen Formatierung.)

Die Dekoratoren die von einem Element verwendet werden, können geändert werden, um eine andere Ausgabe zu
erzeugen; seihe dazu das :ref:`Kapitel über Dekoratoren <zend.form.decorators>` für mehr Informationen.

Das Formular selbst, geht alle Elemente durch, und fügt diese in eine *HTML* **<form>** ein. Die Aktion und
Methode, die bei der Erstellung des Formulars angegeben wurden, werden dem **<form>** Tag angegeben, wie wenn sie
Attribute wären, die über ``setAttribs()`` und ähnliche gesetzt werden.

Elemente werden, entweder in der Reihenfolge in der sie registriert wurden durchlaufen, oder, wenn ein Element ein
'order' Attribut enthält, in dieser Reihenfolge. Die Reihenfolge eines Elements kann, wie folgt, gesetzt werden:

.. code-block:: php
   :linenos:

   $element->setOrder(10);

Oder bei der Erstellung des Elements durch Übergabe als Option:

.. code-block:: php
   :linenos:

   $form->addElement('text', 'username', array('order' => 10));

.. _zend.form.quickstart.validate:

Prüfen, ob ein Formular gültig ist
----------------------------------

Nachdem ein Formular übermittelt wurde, muss diese geprüft werden, um zu sehen ob sie alle Prüfungen besteht.
Jedes Element wird gegen die angegebenen Daten geprüft; wenn ein Schlüssel, der dem Elementnamen entspricht,
nicht vorhanden ist, und das Element als benötigt markiert ist, werden die Prüfungen mit einem ``NULL`` Wert
ausgeführt.

Wo kommen die Daten her? Man kann ``$_POST`` oder ``$_GET`` verwenden, oder jede andere Datenquelle die man bei der
Hand hat (Web Service Anfragen zum Beispiel):

.. code-block:: php
   :linenos:

   if ($form->isValid($_POST)) {
       // erfolgreich!
   } else {
       // fehlgeschlagen!
   }

Mit *AJAX* Anfragen kann man manchmal davon abweichen einzelne Elemente oder Gruppen von Elementen zu prüfen.
``isValidPartial()`` prüft einen Teil des Formulars. Anders, als ``isValid()``, werden, wenn ein spezieller
Schlüssel nicht vorhanden ist, Prüfungen für dieses spezielle Element nicht durchgeführt:

.. code-block:: php
   :linenos:

   if ($form->isValidPartial($_POST)) {
       // Elemente hat alle Prüfungen bestanden
   } else {
       // Ein oder mehrere getestete Elemente haben die Prüfung nicht bestanden
   }

Eine zusätzliche Methode, ``processAjax()``, kann auch dafür verwendet werden, um Teilformen zu prüfen. Anders
als ``isValidPartial()``, gibt sie eine *JSON* formatierten Zeichenkette zurück, die bei einem Fehler, die
Fehlermeldungen enthält.

Angenommen die Prüfungen sind durchgeführt worden, dann können jetzt die gefilterten Werte geholt werden:

.. code-block:: php
   :linenos:

   $values = $form->getValues();

Wenn an irgendeinem Punkt die ungefilterten Werte benötigt werden, kann man folgendes verwenden:

.. code-block:: php
   :linenos:

   $unfiltered = $form->getUnfilteredValues();

Wenn man andererseits alle gültigen und gefilterten Werte eines teilweise gültigen Formulars benötigt kann
folgendes aufgerufen werden:

.. code-block:: php
   :linenos:

   $values = $form->getValidValues($_POST);

.. _zend.form.quickstart.errorstatus:

Fehlerstatus holen
------------------

Das Formular hat die Prüfungen nicht bestanden? In den meisten Fällen, kann das Formular neu dargestellt werden,
und Fehler werden angezeigt wenn Standardekoratoren verwendet werden:

.. code-block:: php
   :linenos:

   if (!$form->isValid($_POST)) {
       echo $form;

       // oder dem View Obejekt zuordnen und eine View darstellen...
       $this->view->form = $form;
       return $this->render('form');
   }

Wenn die Fehler inspiziert werden sollen, gibt es zwei Methoden. ``getErrors()`` gibt ein assoziatives Array von
Elementnamen/Codes zurück (wobei Codes ein Array von Fehlercodes ist). ``getMessages()`` gibt ein assoziatives
Array von Elementnamen/Nachrichten zurück (wobei Nachrichten ein assoziatives Array von
Fehlercodes/Fehlernachrichten Paaren ist). Wenn ein gegebenes Element keinen Fehler hat, wird es dem Array nicht
angefügt.

.. _zend.form.quickstart.puttingtogether:

Alles zusammenfügen
-------------------

Bauen wir also ein Login Formular. Es benötigt Elemente die folgendes repräsentieren:

- username

- password

- submit

Für unsere Zwecke nehmen wir an, dass ein gültiger Benutzername nur alphanumerische Zeichen enthalten soll und
mit einem Buchstaben beginnt, eine Mindestlänge von 6 und eine Maximallänge von 20 Zeichen hat; er wird zu
Kleinschreibung normalisiert. Passwörter müssen mindestens 6 Zeichen lang sein. Der submit Wert wird einfach
ignoriert wenn wir fertig sind, er kann also ungeprüft bleiben.

Wir verwenden die Stärke von ``Zend_Form``'s Konfigurationsoptionen um die Form zu erstellen:

.. code-block:: php
   :linenos:

   $form = new Zend\Form\Form();
   $form->setAction('/user/login')
        ->setMethod('post');

   // Ein username Element erstellen und konfigurieren:
   $username = $form->createElement('text', 'username');
   $username->addValidator('alnum')
            ->addValidator('regex', false, array('/^[a-z]+/'))
            ->addValidator('stringLength', false, array(6, 20))
            ->setRequired(true)
            ->addFilter('StringToLower');

   // Ein Passwort Element erstellen und konfigurieren:
   $password = $form->createElement('password', 'password');
   $password->addValidator('StringLength', false, array(6))
            ->setRequired(true);

   // Elemente dem Formular hinzufügen:
   $form->addElement($username)
        ->addElement($password)
        // addElement() als Factory verwenden um den 'Login' Button zu erstellen:
        ->addElement('submit', 'login', array('label' => 'Login'));

Als nächstes wird ein Controller erstellt der das Formular behandelt:

.. code-block:: php
   :linenos:

   class UserController extends Zend\Controller\Action
   {
       public function getForm()
       {
           // Formular, wie oben beschrieben, erstellen
           return $form;
       }

       public function indexAction()
       {
           // user/form.phtml darstellen
           $this->view->form = $this->getForm();
           $this->render('form');
       }

       public function loginAction()
       {
           if (!$this->getRequest()->isPost()) {
               return $this->_forward('index');
           }
           $form = $this->getForm();
           if (!$form->isValid($_POST)) {
               // Fehlgeschlagene Prüfung; Form wieder anzeigen
               $this->view->form = $form;
               return $this->render('form');
           }

           $values = $form->getValues();
           // Jetzt versuchen zu Authentifizieren...
       }
   }

Und ein View Skript für die Darstellung des Formulars:

.. code-block:: php
   :linenos:

   <h2>Bitte anmelden:</h2>
   <?php echo $this->form ?>

Wie man im Controller Code sieht, gibt es mehr Arbeit zu tun: Während die Übertragung gültig sein muss, kann es
trotzdem notwendig sein, zum Beispiel, ein Authentifizierung mit Hilfe von ``Zend_Auth`` durchzuführen.

.. _zend.form.quickstart.config:

Ein Zend_Config Objekt verwenden
--------------------------------

Alle ``Zend_Form``'s sind konfigurierbar, indem ``Zend_Config`` verwendet wird; es kann entweder ein
``Zend_Config`` Objekt an den Kontruktor oder über ``setConfig()`` übergeben werden. Sehen wir uns an, wie das
obige Formular erstellt werden kann, wenn wir eine *INI* Datei verwenden. Zuerst folgen wir den Notwendigkeiten und
platzieren die Konfigurationen in Sektionen, die den Ort des Releases reflektieren, und fokusieren auf die
'development' Sektion. Als nächstes wird eine Sektion für den gegebenen Controller ('user') definiert und ein
Schlüssel für das Formular ('login'):

.. code-block:: ini
   :linenos:

   [development]
   ; general form metainformation
   user.login.action = "/user/login"
   user.login.method = "post"

   ; username element
   user.login.elements.username.type = "text"
   user.login.elements.username.options.validators.alnum.validator = "alnum"
   user.login.elements.username.options.validators.regex.validator = "regex"
   user.login.elements.username.options.validators.regex.options.pattern = "/^[a-z]/i"
   user.login.elements.username.options.validators.strlen.validator = "StringLength"
   user.login.elements.username.options.validators.strlen.options.min = "6"
   user.login.elements.username.options.validators.strlen.options.max = "20"
   user.login.elements.username.options.required = true
   user.login.elements.username.options.filters.lower.filter = "StringToLower"

   ; password element
   user.login.elements.password.type = "password"
   user.login.elements.password.options.validators.strlen.validator = "StringLength"
   user.login.elements.password.options.validators.strlen.options.min = "6"
   user.login.elements.password.options.required = true

   ; submit element
   user.login.elements.submit.type = "submit"

Das kann dann an den Contruktor des Formulars übergeben werden:

.. code-block:: php
   :linenos:

   $config = new Zend\Config\Ini($configFile, 'development');
   $form   = new Zend\Form\Form($config->user->login);

und das komplette Formular wird definiert werden.

.. _zend.form.quickstart.conclusion:

Schlussfolgerung
----------------

Hoffentlich ist, mit dieser kleinen Anleitung der Weg klar, um die Leistung und Flexibilität von ``Zend_Form``
einzusetzen. Für detailiertere Informationen lesen Sie weiter!


