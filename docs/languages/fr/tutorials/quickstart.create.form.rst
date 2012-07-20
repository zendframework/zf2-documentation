.. _learning.quickstart.create-form:

Créer un formulaire
===================

Pour que notre livre d'or soit utile, nous allons avoir besoin d'un formulaire permettant de le remplir.

Nous devons donc créer un formulaire. Pour créer un formulaire vierge, exécutez la commande :

.. code-block:: console
   :linenos:

   % zf create form Guestbook
   Creating a form at application/forms/Guestbook.php
   Updating project profile '.zfproject.xml'

Ceci créera le dossier ``application/forms/`` avec un fichier de classe ``Guestbook.php``. Ouvrez ce fichier et
mettez le à jour comme suit :

.. code-block:: php
   :linenos:

   // application/forms/Guestbook.php

   class Application_Form_Guestbook extends Zend_Form
   {
       public function init()
       {
           // La méthode HTTP d'envoi du formulaire
           $this->setMethod('post');

           // Un élément Email
           $this->addElement('text', 'email', array(
               'label'      => 'Your email address:',
               'required'   => true,
               'filters'    => array('StringTrim'),
               'validators' => array(
                   'EmailAddress',
               )
           ));

           // Un élément pour le commentaire
           $this->addElement('textarea', 'comment', array(
               'label'      => 'Please Comment:',
               'required'   => true,
               'validators' => array(
                   array('validator' => 'StringLength', 'options' => array(0, 20))
                   )
           ));

           // Un captcha
           $this->addElement('captcha', 'captcha', array(
               'label'      => 'Please enter the 5 letters displayed below:',
               'required'   => true,
               'captcha'    => array(
                   'captcha' => 'Figlet',
                   'wordLen' => 5,
                   'timeout' => 300
               )
           ));

           // Un bouton d'envoi
           $this->addElement('submit', 'submit', array(
               'ignore'   => true,
               'label'    => 'Sign Guestbook',
           ));

           // Et une protection anti CSRF
           $this->addElement('hash', 'csrf', array(
               'ignore' => true,
           ));
       }
   }

Le formulaire ci-dessus définit cinq éléments : une adresse email, un champ commentaire, un *CAPTCHA* anti
spam, un bouton d'envoi et une protection anti *CSRF*.

Maintenant nous allons ajouter une action ``signAction()`` à notre ``GuestbookController`` qui va s'occuper de la
soumission du formulaire. Pour créer cette action et son script de vue, éxécutez :

.. code-block:: console
   :linenos:

   % zf create action sign Guestbook
   Creating an action named sign inside controller
       at application/controllers/GuestbookController.php
   Updating project profile '.zfproject.xml'
   Creating a view script for the sign action method
       at application/views/scripts/guestbook/sign.phtml
   Updating project profile '.zfproject.xml'

Comme vous le voyez d'après l'affichage, ceci va créer une méthode ``signAction()`` dans notre contrôleur,
ainsi que le script de vue approprié.

Ajoutons de la logique dans notre action. Nous devons d'abord vérifier le type de requête HTTP *POST* ou *GET*\
 ; dans ce dernier cas nous affichons simplement le formulaire. Cependant, si nous recevons une requête *POST*,
nous allons vouloir valider le formulaire par rapport aux données postées, et s'il est valide, créer une
nouvelle entrée et la sauvegarder. La logique ressemble à ceci :

.. code-block:: php
   :linenos:

   // application/controllers/GuestbookController.php

   class GuestbookController extends Zend_Controller_Action
   {
       // indexAction() ici ...

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

Bien sur, nous devons aussi éditer le script de vue. Editez ``application/views/scripts/guestbook/sign.phtml``
avec ceci :

.. code-block:: php
   :linenos:

   <!-- application/views/scripts/guestbook/sign.phtml -->

   Utilisez le formulaire ci-après pour signer notre livre d'or!

   <?php
   $this->form->setAction($this->url());
   echo $this->form;

.. note::

   **Améliorer le rendu visuel du formulaire**

   Ce formulaire n'a pas un look terrible, peu importe : l'apparence d'un formulaire est entièrement
   personnalisable ! Voyez la :ref:`section sur les décorateurs dans le guide de réference
   <zend.form.decorators>` pour plus de détails.

   Aussi, vous pouvez être intéréssés par :ref:`notre tutoriel sur les décorateurs de formulaires
   <learning.form.decorators.intro>`.

.. note::

   **Checkpoint**

   Naviguez maintenant sur "http://localhost/guestbook/sign". Vous devriez voir ceci dans votre navigateur :

   .. image:: ../images/learning.quickstart.create-form.png
      :width: 421
      :align: center


