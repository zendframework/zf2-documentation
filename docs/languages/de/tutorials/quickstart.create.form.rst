.. EN-Revision: none
.. _learning.quickstart.create-form:

Erstellen eines Formulars
=========================

Damit unser Guestbook nützlich ist, benötigen wir ein Formular für die Übermittlung neuer Einträge.

Unsere erste Arbeit ist die Erstellung der aktuellen Formularklasse. Um eine leere Fomularklasse zu erstellen muss
folgendes ausgeführt werden:

.. code-block:: console
   :linenos:

   % zf create form Guestbook
   Creating a form at application/forms/Guestbook.php
   Updating project profile '.zfproject.xml'

Dies erstellt das Verzeichnis ``application/forms/`` mit der Klassendatei ``Guestbook.php``. Diese Datei ist zu
öffnen und so zu aktualisieren das Sie wie folgt aussieht:

.. code-block:: php
   :linenos:

   // application/forms/Guestbook.php

   class Application_Form_Guestbook extends Zend_Form
   {
       public function init()
       {
           // Setzt die Methode for das Anzeigen des Formulars mit POST
           $this->setMethod('post');

           // Ein Email Element hinzufügen
           $this->addElement('text', 'email', array(
               'label'      => 'Deine Email Adresse:',
               'required'   => true,
               'filters'    => array('StringTrim'),
               'validators' => array(
                   'EmailAddress',
               )
           ));

           // Das Kommentar Element hinzufügen
           $this->addElement('textarea', 'comment', array(
               'label'      => 'Bitte ein Kommentar:',
               'required'   => true,
               'validators' => array(
                   array('validator' => 'StringLength', 'options' => array(0, 20))
                   )
           ));

           // Ein Captcha hinzufügen
           $this->addElement('captcha', 'captcha', array(
               'label'      => "Bitte die 5 Buchstaben eingeben die unterhalb "
                             . "angezeigt werden:",
               'required'   => true,
               'captcha'    => array(
                   'captcha' => 'Figlet',
                   'wordLen' => 5,
                   'timeout' => 300
               )
           ));

           // Den Submit Button hinzufügen
           $this->addElement('submit', 'submit', array(
               'ignore'   => true,
               'label'    => 'Im Guestbook eintragen',
           ));

           // Und letztendlich etwas CSRF Protektion hinzufügen
           $this->addElement('hash', 'csrf', array(
               'ignore' => true,
           ));
       }
   }

Das obige Formular definiert fünf Elemente: ein Feld für die Email Adresse, eines für das Kommentar, ein
*CAPTCHA* um Spam Einträge zu verhindern, einen Submit Button und ein *CSRF* Protektions Token.

Als nächstes fügen wir eine ``signAction()`` zu unserem ``GuestbookController`` welche das Formular nach der
Übertragung bearbeitet. Um die Action und das betreffende View Skript zu erstellen muss das folgende ausgeführt
werden:

.. code-block:: console
   :linenos:

   % zf create action sign Guestbook
   Creating an action named sign inside controller
       at application/controllers/GuestbookController.php
   Updating project profile '.zfproject.xml'
   Creating a view script for the sign action method
       at application/views/scripts/guestbook/sign.phtml
   Updating project profile '.zfproject.xml'

Das erstellt eine ``signAction()`` Methode in unserem Controller, sowie das betreffende View Skript.

Fügen wir etwas Logik in unsere Sign Aktion des Guestbook Controller's ein. Wir müssen zuerst prüfen ob wir eine
*POST* oder eine *GET* Anfrage erhalten; im letzteren Fall zeigen wir das Formular einfach an. Wenn wir aber eine
*POST* Anfrage erhalten, wollten wir die übermittelten Daten gegenüber unserem Formular prüfen, und wenn es
gültig ist, wird ein neuer Eintrag erstellt und gespeichert. Die Logik könnte wie folgt aussehen:

.. code-block:: php
   :linenos:

   // application/controllers/GuestbookController.php

   class GuestbookController extends Zend\Controller\Action
   {
       // wir übergehen indexAction()...

       public function signAction()
       {
           $request = $this->getRequest();
           $form    = new Application_Form_Guestbook();

           if ($this->getRequest()->isPost()) {
               if ($form->isValid($request->getPost())) {
                   $comment = new Application_Model_Guestbook($form->getValues());
                   $mapper = new Application_Model_GuestbookMapper();
                   $mapper->save($comment);
                   return $this->_helper->redirector('index');
               }
           }

           $this->view->form = $form;
       }
   }

Natürlich müssen wir das View Skript bearbeiten; es muss ``application/views/scripts/guestbook/sign.phtml``
bearbeitet werden damit es wie folgt aussieht:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/guestbook/sign.phtml -->

   Bitte verwende das folgende Formular um sich in unser Guestbook einzutragen!

   <?php
   $this->form->setAction($this->url());
   echo $this->form;

.. note::

   **Besser aussehende Formulare**

   Keiner wird sich irgendwann poetisch über die Schönheit dieses Formulars auslassen. Kein Problem - das
   Aussehen des Formulars kann komplett angepasst werden! Siehe auch im :ref:`Kapitel über Decorations vom
   Referenz Handbuch <zend.form.decorators>` nach Details.

   Zusätzlich könnte man an :ref:`unserem Tutorial über Formular Decorations <learning.form.decorators.intro>`
   interessiert sein.

.. note::

   **Checkpoint**

   Jetzt gehen wir auf "http://localhost/guestbook/sign". Man sollte das folgende im eigenen Browser sehen:

   .. image:: ../images/learning.quickstart.create-form.png
      :width: 421
      :align: center


