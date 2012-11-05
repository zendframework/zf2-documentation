.. EN-Revision: none
.. _learning.quickstart.create-form:

Tworzenie formularza
====================

Aby aplikacja księgi gości była użyteczna należy umieścić w niej formularz umożliwiający dodawanie nowych
wpisów.

W pierwszej kolejności należy utworzyć klasę formularza. Można to osiągnąć poprzez polecenie:

.. code-block:: console
   :linenos:

   % zf create form Guestbook
   Creating a form at application/forms/Guestbook.php
   Updating project profile '.zfproject.xml'

Powyższe polecenie utworzy katalog ``application/forms/`` zawierający plik ``Guestbook.php``. Należy umieścić
w nim następującą treść:

.. code-block:: php
   :linenos:

   // application/forms/Guestbook.php

   class Application_Form_Guestbook extends Zend_Form
   {
       public function init()
       {
           // Ustawienie metody wysyłki danych formularza na POST
           $this->setMethod('post');

           // Dodanie elementu do wpisania adresu e-mail
           $this->addElement('text', 'email', array(
               'label'      => 'Your email address:',
               'required'   => true,
               'filters'    => array('StringTrim'),
               'validators' => array(
                   'EmailAddress',
               )
           ));

           // Dodanie elementu do dodania komentarza
           $this->addElement('textarea', 'comment', array(
               'label'      => 'Please Comment:',
               'required'   => true,
               'validators' => array(
                   array('validator' => 'StringLength', 'options' => array(0, 20))
                   )
           ));

           // Dodanie elementu captcha
           $this->addElement('captcha', 'captcha', array(
               'label'      => 'Please enter the 5 letters displayed below:',
               'required'   => true,
               'captcha'    => array(
                   'captcha' => 'Figlet',
                   'wordLen' => 5,
                   'timeout' => 300
               )
           ));

           // Dodanie guzika do wysyłki
           $this->addElement('submit', 'submit', array(
               'ignore'   => true,
               'label'    => 'Sign Guestbook',
           ));

           // Dodanie zabezpieczenia przed CSRF
           $this->addElement('hash', 'csrf', array(
               'ignore' => true,
           ));
       }
   }

Powyższy formularz definiuje pięć elementów: pole adresu e-mail, pole komentarza, pole *CAPTCHA* dla
zabezpieczenia przed spamem, przycisk wysłania komentarza oraz żeton bezpieczeństwa (przed *CSRF*).

Następnie należy zdefiniować nową akcję ``signAction()`` w kontrolerze ``GuestbookController``, która będzie
odpowiedzialna za odbiór danych wysłanych przez formularz. Aby utworzyć nową akcję oraz związany z nią
skrypt widoku należy uruchomić następujące polecenie:

.. code-block:: console
   :linenos:

   % zf create action sign Guestbook
   Creating an action named sign inside controller
       at application/controllers/GuestbookController.php
   Updating project profile '.zfproject.xml'
   Creating a view script for the sign action method
       at application/views/scripts/guestbook/sign.phtml
   Updating project profile '.zfproject.xml'

Jak widać z komunikatów, polecenie tworzy metodę ``signAction()`` w kontrolerze oraz odpowiedni widok.

Teraz należy zapisać logikę aplikacji w treści nowej akcji. Na początek należy sprawdzić czy żądanie
zostało otrzymane metodą *POST* czy *GET*. W drugim przypadku zostanie po prostu pokazany formularz do
wypełnienia. Jednak dla metody *POST* niezbędne będzie sprawdzenie poprawności przesyłanych danych oraz w
przypadku pozytywnej weryfikacji, utworzenie nowego rekordu i zapisanie go w bazie danych. Logika może wyglądać
następująco:

.. code-block:: php
   :linenos:

   // application/controllers/GuestbookController.php

   class GuestbookController extends Zend\Controller\Action
   {
       // w tym miejscu jest indexAction()...

       public function signAction()
       {
           $request = $this->getRequest();
           $form    = new Application_Form_Guestbook();

           if ($this->getRequest()->isPost()) {
               if ($form->isValid($request->getPost())) {
                   $comment = new Application_Model_Guestbook($form->getValues());
                   $mapper  = new Application_Model_GuestbookMapper();
                   $mapper->save($comment);
                   return $this->_helper->redirector('index');
               }
           }

           $this->view->form = $form;
       }
   }

Niezbędna jest również zmiana skryptu widoku ``application/views/scripts/guestbook/sign.phtml`` tak aby
zawierał następującą treść:

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/guestbook/sign.phtml -->

   Please use the form below to sign our guestbook!

   <?php
   $this->form->setAction($this->url());
   echo $this->form;

.. note::

   **Lepszy wygląd formularzy**

   Tak powstały formularz nie stanowi wzoru piękna, ale należy pamiętać, iż wygląd jest w pełni edytowalny.
   Więcej informacji można zasięgnąć w :ref:`rozdziale dotyczącym dekoratorów formularzy
   <zend.form.decorators>`.

   Dodatkowo przydatny może się okazać :ref:`samouczek tworzenia dekoratorów formularzy
   <learning.form.decorators.intro>`.

.. note::

   **Punkt kontrolny**

   Po wejściu pod adres "http://localhost/guestbook/sign" powinien się pokazać formularz księgi gości:

   .. image:: ../images/learning.quickstart.create-form.png
      :width: 421
      :align: center


