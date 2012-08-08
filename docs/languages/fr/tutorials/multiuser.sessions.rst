.. EN-Revision: none
.. _learning.multiuser.sessions:

Gérer les sessions dans ZF
==========================

.. _learning.multiuser.sessions.intro:

Introduction aux sessions
-------------------------

Le succès du web est en grande partie dûe aux protocoles qui le supportent: HTTP. HTTP sur TCP est par nature
sans état ce qui signifie que le web n'a pas "de mémoire". Ce fait pose des problèmes pour les développeurs
voulant traiter leur application comme un service riche.

Interagir avec l'application web c'est en fait faire la somme de toutes les requêtes que celle-ci reçoit. Et
comme il y a beaucoup de clients, il y a beaucoup de requête, et le moyen d'associer une requête à un client est
appelé "session".

En PHP, le problème des sessions a été résolu au travers de l'extension session qui utilise un système de
persistance, typiquement basé sur des cookies et un stockage local des variables dans $_SESSION. Dans Zend
Framework, le composant Zend_Session ajoute de la valeur au système de session de PHP notamment une manipulation
objet.

.. _learning.multiuser.sessions.basic-usage:

Utilisation classique de Zend_Session
-------------------------------------

Le composant Zend_Session est un gestionnaire de session et une API pour stocker des données dans la session de
manière objet. L'API de la classe Zend_Session API permet de régler des options et de démarrer/arrêter la
session alors que Zend_Session_Namespace représente un objet contenant des données à stocker en session.

C'est générallement une bonne pratique que de démarrer sa session en bootstrap, cependant la première création
d'un objet Zend_Session_Namespace démarrera la session par défaut.

Zend_Application peut permettre de configurer Zend_Session grâce aux parties Zend_Application_Resource. Pour les
utiliser, en supposant que votre projet utilise Zend_Application, ajoutez le code suivant à application.ini:

.. code-block:: php
   :linenos:

   resources.session.save_path = APPLICATION_PATH "/../data/session"
   resources.session.use_only_cookies = true
   resources.session.remember_me_seconds = 864000

Comme vous le remarquez, les options utilisées sont les mêmes que celles que reconnait ext/session (l'extension
session de PHP). Le chemin de stockage des session par exemple. Les fichiers ini peuvent utiliser des constantes,
nous réutilisons APPLICATION_PATH pour calculer le chemin relatif vers un dossier arbitraire sensé stocker les
sessions.

La plupart des composants de Zend Framework utilisant les sessions n'ont rien besoin de plus. Dès lors, vous
pouvez utiliser un composant faisant appel à la session, ou manipuler la session vous-même au travers d'un ou
plusieurs objets Zend_Session_Namespace.

Zend_Session_Namespace est une classe qui guide ses données vers $_SESSION. La classe s'appelle
Zend_Session_Namespace car elle crée des espaces de noms au sein de $_SESSION, autorisant plusieurs composants ou
objets à stocker des valeurs sans se marcher dessus. Nous allons voir dans l'exemple qui suit comment créer un
simple compteur de session qui commence à 1000 et se remet à zéro après 1999.

.. code-block:: php
   :linenos:

   $mysession = new Zend_Session_Namespace('mysession');

   if (!isset($mysession->counter)) {
       $mysession->counter = 1000;
   } else {
       $mysession->counter++;
   }

   if ($mysession->counter > 1999) {
       unset($mysession->counter);
   }

Comme vous le remarquez, l'objet de session utilise les méthodes magiques \__get, \__set, \__isset, et \__unset
pour proposer une API intuitive. Les informations stockées dans notre exemple le sont en réalité dans
$_SESSION['mysession']['counter'].

.. _learning.multiuser.sessions.advanced-usage:

Utilisation avancée de Zend_Session
-----------------------------------

Si vous voulez utiliser le gestionnaire de sauvegarde des sessions "DbTable", vous pouvez simplement ajouter ces
options à application.ini:

.. code-block:: php
   :linenos:

   resources.session.saveHandler.class = "Zend_Session_SaveHandler_DbTable"
   resources.session.saveHandler.options.name = "session"
   resources.session.saveHandler.options.primary.session_id = "session_id"
   resources.session.saveHandler.options.primary.save_path = "save_path"
   resources.session.saveHandler.options.primary.name = "name"
   resources.session.saveHandler.options.primaryAssignment.sessionId = "sessionId"
   resources.session.saveHandler.options.primaryAssignment.sessionSavePath = "sessionSavePath"
   resources.session.saveHandler.options.primaryAssignment.sessionName = "sessionName"
   resources.session.saveHandler.options.modifiedColumn = "modified"
   resources.session.saveHandler.options.dataColumn = "session_data"
   resources.session.saveHandler.options.lifetimeColumn = "lifetime"


