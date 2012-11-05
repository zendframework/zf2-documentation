.. _learning.multiuser.authentication:

Authenticating Users in Zend Framework
======================================

.. _learning.multiuser.authentication.intro:

Introduction to Authentication
------------------------------

Once a web application has been able to distinguish one user from another by establishing a session, web
applications typically want to validate the identity of a user. The process of validating a consumer as being
authentic is "authentication." Authentication is made up of two distinctive parts: an identity and a set of
credentials. It takes some variation of both presented to the application for processing so that it may
authenticate a user.

While the most common pattern of authentication revolves around usernames and passwords, it should be stated that
this is not always the case. Identities are not limited to usernames. In fact, any public identifier can be used:
an assigned number, social security number, or residence address. Likewise, credentials are not limited to
passwords. Credentials can come in the form of protected private information: fingerprint, eye retinal scan,
passphrase, or any other obscure personal information.

.. _learning.multiuser.authentication.basic-usage:

Basic Usage of Zend_Auth
------------------------

In the following example, we will be using ``Zend_Auth`` to complete what is probably the most prolific form of
authentication: username and password from a database table. This example assumes that you have already setup your
application using ``Zend_Application``, and that inside that application you have configured a database connection.

The job of the ``Zend_Auth`` class is twofold. First, it should be able to accept an authentication adapter to use
to authenticate a user. Secondly, after a successful authentication of a user, it should persist throughout each
and every request that might need to know if the current user has indeed been authenticated. To persist this data,
``Zend_Auth`` consumes ``Zend\Session\Namespace``, but you will generally never need to interact with this session
object.

Lets assume we have the following database table setup:

.. code-block:: php
   :linenos:

   CREATE TABLE users (
       id INTEGER  NOT NULL PRIMARY KEY,
       username VARCHAR(50) UNIQUE NOT NULL,
       password VARCHAR(32) NULL,
       password_salt VARCHAR(32) NULL,
       real_name VARCHAR(150) NULL
   )

The above demonstrates a user table that includes a username, password, and also a password salt column. This salt
column is used as part of a technique called salting that would improve the security of your database of
information against brute force attacks targeting the algorithm of your password hashing. `More information`_ on
salting.

For this implementation, we must first make a simple form that we can utilized as the "login form". We will use
``Zend_Form`` to accomplish this.

.. code-block:: php
   :linenos:

   // located at application/forms/Auth/Login.php

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

With the above form, we can now go about creating our login action for our authentication controller. This
controller will be called "``AuthController``", and will be located at
``application/controllers/AuthController.php``. It will have a single method called "``loginAction()``" which will
serve as the self-posting action. In other words, regardless of the url was POSTed to or GETed to, this method will
handle the logic.

The following code will demonstrate how to construct the proper adapter, integrate it with the form:

.. code-block:: php
   :linenos:

   class AuthController extends Zend\Controller\Action
   {

       public function loginAction()
       {
           $db = $this->_getParam('db');

           $loginForm = new Default_Form_Auth_Login($_POST);

           if ($loginForm->isValid()) {

               $adapter = new Zend\Auth_Adapter\DbTable(
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

The corresponding view script is quite simple for this action. It will set the current url since this form is self
processing, and it will display the form. This view script is located at
``application/views/scripts/auth/login.phtml``:

.. code-block:: php
   :linenos:

   $this->form->setAction($this->url());
   echo $this->form;

There you have it. With these basics you can expand the general concepts to include more complex authentication
scenarios. For more information on other ``Zend_Auth`` adapters, have a look in :ref:`the reference guide
<zend.auth>`.



.. _`More information`: http://en.wikipedia.org/wiki/Salting_%28cryptography%29
