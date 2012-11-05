.. EN-Revision: none
.. _learning.multiuser.authentication:

Benutzer im Zend Framework authentifizieren
===========================================

.. _learning.multiuser.authentication.intro:

Einführung in die Authentifizierung
-----------------------------------

Sobald eine Web Anwendung in der Lage ist Benutzer von anderen Benutzern zu unterscheiden, indem eine Session
aufgebaut wird, prüfen Web Anwendungen normalerweise die Identität eines Benutzers. Der Prozess der Prüfung
eines Konsumenten als authentisch wird als "Authentifizierung" bezeichnet. Authentifizierung besteht auf zwei
getrennten Teilen: Einer Identität und einem Set von Zeugnissen. Es muss eine Variation von beidem in der
Anwendung für die Bearbeitung vorhanden sein damit diese einen Benutzer authentifizieren kann.

Wärend die meisten üblichen Pattern der Authentifizierung um Benutzernamen und Passwörtern dreht, sollte
erwähnt werden das dies nicht immer der Fall ist. Identitäten sind nicht auf Benutzernamen limitiert. Faktisch
kann jeder öffentliche Identifikator verwendet werden: eine zugeordnete Nummer, Sozialversicherungsnummer, oder
eine Wohnanschrift. Genauso sind Zeugnisse nicht auf Passwörter begrenzt. Zeugnisse können in Form von
geschützten privaten Informationen kommen: Fingerabdrücke, Augen Retinascan, Passphrase, oder jede andere obskure
personelle Information.

.. _learning.multiuser.authentication.basic-usage:

Grundsätzliche Verwendung von Zend_Auth
---------------------------------------

Im folgenden Beispiel verwenden wir ``Zend_Auth`` um zu komplettieren was möglicherweise die meist gelebte Form
der Authentifizierung ist: Benutzername und Passwort von einer Datenbank Tabelle. Dieses Beispiel nimmt an dass man
die eigene Anwendung bereits durch Verwendung von ``Zend_Application`` eingerichtet hat, und das man in der
Anwendung eine Datenbank Verbindung konfiguriert hat.

Der Job der ``Zend_Auth`` Klasse ist zweigeteilt. Erstens sollte Sie in der Lage sein einen Authentifizierungs
Adapter zu akzeptieren um einen Benutzer zu authentifizieren. Zweitens sollte Sie, nach einer erfolgreichen
Authentifizierung eines Benutzers, durch jede und alle Abfragen persistent sein welche wissen müssen ob der
aktuelle Benutzer authentifiziert wurde. Um diese Daten zu persistieren verwendet ``Zend_Auth``
``Zend\Session\Namespace``, man muss aber generell nie mit diesem Session Objekt interagieren.

Angenommen wir haben die folgende Datenbanktabelle konfiguriert:

.. code-block:: php
   :linenos:

   CREATE TABLE users (
       id INTEGER  NOT NULL PRIMARY KEY,
       username VARCHAR(50) UNIQUE NOT NULL,
       password VARCHAR(32) NULL,
       password_salt VARCHAR(32) NULL,
       real_name VARCHAR(150) NULL
   )

Das oben stehende demonstriert eine Benutzertabelle welche einen Benutzernamen, ein Passwort und auch eine Passwort
Salt Spalte enthält. Diese Salt Spalte wird als Teil einer Technik verwendet welche Salting genannt wird und die
Sicherheit der Datenbank für Informationen gegen Brute Force Attacken erhöht welche auf den Algorithmus des
Hashings vom Passwort abziehlt. `Weitere Informationen`_ über Salting.

Für diese Implementation müssen wir zuerst ein einfaches Formular erstellen welches wir als "Login Formular"
verwenden können. Wir nehmen ``Zend_Form`` um das zu ermöglichen.

.. code-block:: php
   :linenos:

   // Steht unter application/forms/Auth/Login.php

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
               'label' => 'Passwort:',
               'required' => true,
               ));

           $this->addElement('submit', 'submit', array(
               'ignore'   => true,
               'label'    => 'Login',
               ));

       }
   }

Mit dem oben stehenden Formular können wir weitermachen und unsere Login Aktion für unseren Authentifizierungs
Controller erstellen. Dieser Controller wird "``AuthController``" genannt, und wird unter
``application/controllers/AuthController.php`` zu finden sein. Er wird eine einzelne Methode enthalten welche
"``loginAction()``" heißt und als selbst-übermittelnde Aktion fungiert. In anderen Worten, unabhängig davon ob
die Url mit POST oder mit GET geschickt wurde, wird diese Methode die Logik behandeln.

Der folgende Code demonstriert wie die richtigen Adapter erstellt und in das Formular integriert werden:

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
                   $this->_helper->FlashMessenger('Erfolgreich angemeldet');
                   $this->redirect('/');
                   return;
               }

           }

           $this->view->loginForm = $loginForm;

       }

   }

Das entsprechende View Skript ist für diese Aktion recht einfach. Es setzt die aktuelle Url da dieses Formular
selbst bearbeitend ist, und zeigt das Formular an. Dieses View Skript ist unter
``application/views/scripts/auth/login.phtml`` zu finden:

.. code-block:: php
   :linenos:

   $this->form->setAction($this->url());
   echo $this->form;

Das ist es. Mit diesen Grundsätzen kann man die generellen Konzepte erweitern um komplexere Authentifizierungs
Szenarien zu inkludieren. Für mehr Informationen über andere ``Zend_Auth`` Adapter sollte in :ref:`das Referenz
Handbuch <zend.auth>` gesehen werden.



.. _`Weitere Informationen`: http://en.wikipedia.org/wiki/Salting_%28cryptography%29
