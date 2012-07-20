.. _learning.multiuser.authentication:

Authentification d'utilisateurs dans Zend Framework
===================================================

.. _learning.multiuser.authentication.intro:

Introduction à l'authentification
---------------------------------

Une fois que l'application a récupéré les informations d'un utilisateur, elle doit vérifier leur
"authenticité", c'est l'authentification. Pour celà, deux informations sont nécessaires : l'identifiant et un
ensemble de règles régissant cet identifiant, aujourd'hui typiquement une chaine de caractères servant de mot de
passe est très classique, mais d'autres procédés existent (reconnaissances digitales, occulaires...)

Un identifiant peut lui aussi être un "login" tout banal, mais pourquoi pas un numéro de membre, une adresse
email... le secret, lui, est donc souvent un mot de passe sous forme de chaine de caractères.

.. _learning.multiuser.authentication.basic-usage:

Utilisation de base de Zend_Auth
--------------------------------

Dans l'exemple suivant, nous utiliserons ``Zend_Auth`` afin d'effectuer une authentification des plus classiques:
champ login et password puis vérification en base de données. Cet exemple suppose que vous utilisez
``Zend_Application`` afin de configurer une connexion à une base de données.

``Zend_Auth`` effectue deux tâches. D'abord elle doit récupérer un adaptateur d'authentification afin de
déclencher le processus d'authentification, puis si celui-ci est correct, elle doit faire persister ces
informations entre requêtes. Pour assurer cette persistance, ``Zend_Auth`` utilise un ``Zend_Session_Namespace``,
mais en général vous n'aurez pas besoin d'agir sur cet objet.

Supposant une table de base de données suivante:

.. code-block:: php
   :linenos:

   CREATE TABLE users (
       id INTEGER  NOT NULL PRIMARY KEY,
       username VARCHAR(50) UNIQUE NOT NULL,
       password VARCHAR(32) NULL,
       password_salt VARCHAR(32) NULL,
       real_name VARCHAR(150) NULL
   )

C'est une table qui inclue des champs nom, password et aussi grain de sel. Le grain de sel est utilisé pour
améliorer la sécurité contre les attaques par force brute qui cibleraient l'alogithme de hashage du mot de
passe. `Plus d'informations`_ sur le grain de sel.

Créons un formulaire de login simple. Nous utiliserons ``Zend_Form``.

.. code-block:: php
   :linenos:

   // localisé à application/forms/Auth/Login.php

   class Default_Form_Auth_Login extends Zend_Form
   {
       public function init()
       {
           $this->setMethod('post');

           $this->addElement(
               'text', 'username', array(
                   'label' => 'Username:',
                   'required' => true,
                   'filters'    => array('StringTrim'),
               ));

           $this->addElement('password', 'password', array(
               'label' => 'Password:',
               'required' => true,
               ));

           $this->addElement('submit', 'submit', array(
               'ignore'   => true,
               'label'    => 'Login',
               ));

       }
   }

Ce formulaire nous mène vers la création du contrôleur de traitement. Nous l'appellerons "``AuthController``",
et le logerons dans ``application/controllers/AuthController.php``. Il possèdera une seule méthode
"``loginAction()``" vers laquelle le formulaire enverra, la méthode va donc réagir à GET et à POST, elle
encapsule toute la logique.

Le code suivant montre comment construire l'adaptateur d'authentification et l'intégration du formulaire:

.. code-block:: php
   :linenos:

   class AuthController extends Zend_Controller_Action
   {

       public function loginAction()
       {
           $db = $this->_getParam('db');

           $loginForm = new Default_Form_Auth_Login($_POST);

           if ($loginForm->isValid()) {

               $adapter = new Zend_Auth_Adapter_DbTable(
                   $db,
                   'users',
                   'username',
                   'password',
                   'MD5(CONCAT(?, password_salt))'
                   );

               $adapter->setIdentity($loginForm->getValue('username'));
               $adapter->setCredential($loginForm->getValue('password'));

               $result = $auth->authenticate($adapter);

               if ($result->isValid()) {
                   $this->_helper->FlashMessenger('Successful Login');
                   $this->redirect('/');
                   return;
               }

           }

           $this->view->loginForm = $loginForm;

       }

   }

Le script de vue est quant à lui enfantin, il sera logé dans ``application/views/scripts/auth/login.phtml``:

.. code-block:: php
   :linenos:

   $this->form->setAction($this->url());
   echo $this->form;

Et voila! Avec ce scénario de base, vous pouvez étendre les possibilités et répondre à vos besoins précis.
Tous les adaptateurs ``Zend_Auth`` se trouvent décrits dans :ref:`le guide de réference <zend.auth>`.



.. _`Plus d'informations`: http://en.wikipedia.org/wiki/Salting_%28cryptography%29
