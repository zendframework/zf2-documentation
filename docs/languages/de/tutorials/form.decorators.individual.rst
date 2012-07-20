.. _learning.form.decorators.individual:

Darstellung individueller Decorators
====================================

Im :ref:`vorigen Abschnitt <learning.form.decorators.layering>` haben wir uns angesehen wie man Decorators
kombinieren kann um komplexe Ausgaben zu erstellen. Wir haben gesehen dass, obwohl wir eine Tonne an Flexibilität
mit diesem Ansatz haben, fügt er auch einiges an Komplexität und Overhead hinzu. In diesem Abschnitt behandeln
wir wie Decorators individuell dargestellt werden können um eigene Markups für Formulare und/oder individuelle
Elemente zu erstellen.

Sobald man die Decorators registriert hat, kann man Sie später durch Ihren Namen vom Element erhalten. Sehen wir
uns das vorhergehende Beispiel nochmals an:

.. code-block:: php
   :linenos:

   $element = new Zend_Form_Element('foo', array(
       'label'      => 'Foo',
       'belongsTo'  => 'bar',
       'value'      => 'test',
       'prefixPath' => array('decorator' => array(
           'My_Decorator' => 'path/to/decorators/',
       )),
       'decorators' => array(
           'SimpleInput'
           array('SimpleLabel', array('placement' => 'append')),
       ),
   ));

Wenn wir nur den ``SimpleInput`` holen und darstellen wollen, können wir das tun indem wir die Methode
``getDecorator()`` verwenden:

.. code-block:: php
   :linenos:

   $decorator = $element->getDecorator('SimpleInput');
   echo $decorator->render('');

Das ist recht einfach kann aber sogar noch einfacher gemacht werden; machen wir es in einer einzelnen Zeile:

.. code-block:: php
   :linenos:

   echo $element->getDecorator('SimpleInput')->render('');

Nicht schlecht, aber trotzdem noch etwas komplex. Um es noch einfacher zu machen wurde mit 1.7 eine
Kurzschreibweise in ``Zend_Form`` eingeführt: man kann jeden registrierten Decorator darstellen indem eine Methode
des Formats ``renderDecoratorName()`` aufgerufen wird. Das wird effektiv ausgeführt wie man oben sieht, macht aber
das ``$content`` Argument optional und vereinfacht die Verwendung:

.. code-block:: php
   :linenos:

   echo $element->renderSimpleInput();

Das ist ein netter Trick, aber wie und warum sollte man Ihn verwenden?

Viele Entwickler und Designer haben sehr präzise Notwendigkeiten für das Markup in Ihren Formularen. Sie würden
eher volle Kontrolle über Ihre Ausgabe haben wollen als auf eine automatisiertere Lösung zu stützen welche mit
Ihrem Design mehr oder weniger konform geht. In anderen Fällen benötigt das Layout des Formulars ein
spezialisierteres Markup -- gruppieren von eigenen Elementen, einige von Ihnen unsichtbar solange bis ein
bestimmter Link ausgewählt wurde, usw.

Sehen wir uns die Fähigkeit an individuelle Decorators darzustellen und ein spezialisierteres Markup zu erstellen.

Definieren wir als erstes ein Formular. Unser Formular holt demografische Details des Benutzers. Das Markup wird
sehr stark anpassbar sein, und in einigen Fällen View Helfer direkt verwenden statt den Formular Elementen um
seine Ziele zu erreichen. Hier ist die grundsätzliche Definition des Formulars:

.. code-block:: php
   :linenos:

   class My_Form_UserDemographics extends Zend_Form
   {
       public function init()
       {
           // Einen Pfad für eigene Decorators hinzufügen
           $this->addElementPrefixPaths(array(
               'decorator' => array('My_Decorator' => 'My/Decorator'),
           ));

           $this->addElement('text', 'firstName', array(
               'label' => 'Vorname: ',
           ));
           $this->addElement('text', 'lastName', array(
               'label' => 'Nachname: ',
           ));
           $this->addElement('text', 'title', array(
               'label' => 'Titel: ',
           ));
           $this->addElement('text', 'dateOfBirth', array(
               'label' => 'Geburtsdatum (DD/MM/YYYY): ',
           ));
           $this->addElement('text', 'email', array(
               'label' => 'Emailadresse: ',
           ));
           $this->addElement('password', 'password', array(
               'label' => 'Passwort: ',
           ));
           $this->addElement('password', 'passwordConfirmation', array(
               'label' => 'Passwort wiederholen: ',
           ));
       }
   }

.. note::

   Wir definieren jetzt keine Prüfungen oder Filter, da Sie für die Diskussion der Decorators nicht relevant
   sind. In einem Real-World Szenario sollte man Sie definieren.

Da dass auf dem Weg ist, besprechen wir wie dieses Formular angezeigt werden soll. Eine übliche Ausdrucksweise mit
Vor-/Nachnamen ist Sie in einer einzelnen Zeile anzuzeigen; wenn ein Titel angegeben wird, ist er oft auch in der
selben Zeile. Daten werden oft in drei Felder separiert und Seite an Seite angezeigt, wen keine JavaScript
Datumsauswahl verwendet wird.

Verwenden wir die Fähigkeit die Decorators eines Elements einzeln darzustellen um das zu ermöglichen. Erstens ist
zu beachten das keine expliziten Decorators für die angegebenen Elemente definiert wurden. Als Auffrischung sind
die standardmäßigen Decorators für die (meisten) Elemente:

- ``ViewHelper``: Verwendet einen View Helfer um eine Formulareingabe darzustellen

- ``Errors``: Verwendet den View Helfer ``FormErrors`` um Prüfungsfehler darzustellen

- ``Description``: Verwendet den View Helfer ``FormNote`` um die Beschreibung des Elements darzustellen (wenn
  vorhanden)

- ``HtmlTag``: Umschließt die obigen drei Elemente mit einem **<dd>** Tag

- ``Label``: Stellt die Überschrift des Elements dar indem es den View Helfer ``FormLabel`` verwendet (und Ihn in
  ein **<dt>** Tag umhüllt)

Auch als Auffrischung, kann man auf jedes Element eines Formulars zugreifen wie wenn es die Eigenschaft einer
Klasse wäre; auf das Element muss einfach mit dem Namen verwiesen werden der Ihm zugeordnet wurde.

Unser View Skript könnte dann wie folgt aussehen:

.. code-block:: php
   :linenos:

   <?php
   $form = $this->form;
   // Entfernt <dt> von der Erstellung der Überschrift
   foreach ($form->getElements() as $element) {
       $element->getDecorator('label')->setOption('tag', null);
   }
   ?>
   <form method="<?php echo $form->getMethod() ?>" action="<?php echo
       $form->getAction()?>">
       <div class="element">
           <?php echo $form->title->renderLabel()
                 . $form->title->renderViewHelper() ?>
           <?php echo $form->firstName->renderLabel()
                 . $form->firstName->renderViewHelper() ?>
           <?php echo $form->lastName->renderLabel()
                 . $form->lastName->renderViewHelper() ?>
       </div>
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
       <div class="element">
           <?php echo $form->password->renderLabel()
                 . $form->password->renderViewHelper() ?>
       </div>
       <div class="element">
           <?php echo $form->passwordConfirmation->renderLabel()
                 . $form->passwordConfirmation->renderViewHelper() ?>
       </div>
       <?php echo $this->formSubmit('submit', 'Speichern') ?>
   </form>

Wenn man obiges View Skript verwendet erhält man voraussichtlich das folgende *HTML* (angenähert da das *HTML*
von anbei formatiert ist):

.. code-block:: html
   :linenos:

   <form method="post" action="">
       <div class="element">
           <label for="title" tag="" class="optional">Titel:</label>
           <input type="text" name="title" id="title" value=""/>

           <label for="firstName" tag="" class="optional">Vorname:</label>
           <input type="text" name="firstName" id="firstName" value=""/>

           <label for="lastName" tag="" class="optional">Nachname:</label>
           <input type="text" name="lastName" id="lastName" value=""/>
       </div>

       <div class="element">
           <label for="dateOfBirth" tag="" class="optional">Geburtsdatum
               (DD/MM/YYYY):</label>
           <input type="text" name="dateOfBirth[day]" id="dateOfBirth-day"
               value="" size="2" maxlength="2"/>
           /
           <input type="text" name="dateOfBirth[month]" id="dateOfBirth-month"
               value="" size="2" maxlength="2"/>
           /
           <input type="text" name="dateOfBirth[year]" id="dateOfBirth-year"
               value="" size="4" maxlength="4"/>
       </div>

       <div class="element">
           <label for="password" tag="" class="optional">Passwort:</label>
           <input type="password" name="password" id="password" value=""/>
       </div>

       <div class="element">
           <label for="passwordConfirmation" tag="" class="" id="submit"
               value="Speichern"/>
   </form>

Ist mag nicht wirklich schön sein, aber mit etwas CSS könnte man es so verändern das es exakt so aussieht wie
man es haben will. Der Punkt ist, das dieses Formular erstellt wurde indem fast komplett eigenes Markup verwendet
wurde, wärend trotzdem Decorators für das meiste gemeinsame Markup verwendet wurden (und um sicherzustellen das
Dinge wie das Escaping mit HtmlEntities und die Injektion von Werten stattfinden).

Ab diesem Punkt des Tutorials sollte man sich recht gut auskennen not den Möglichkeiten des Markups wenn
``Zend_Form``'s Decorators verwendet werden. Im nächsten Abschnitt sehen wir uns das Datumselement von oben
nochmals an, und demonstrieren wie ein eigenes Element und ein Decorator für kombinierte Elemente erstellt werden
kann.


