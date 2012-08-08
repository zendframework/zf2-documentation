.. EN-Revision: none
.. _zend.soap.server:

Zend_Soap_Server
================

La classe ``Zend_Soap_Server`` a été créée pour simplifier la création d'un service Web *SOAP* en *PHP*.

Elle peut être utilisée en mode WSDL ou non-WSDL, et elle utilise des fonctions ou des classes pour définir le
service Web rendu.

Lorsque le composant ``Zend_Soap_Server`` fonctionne en mode WSDL, il utilise le document WSDL pour décrire le
comportement des objets du serveur ainsi que les options de transport vers les clients.

Un document WSDL peut être auto-généré en utilisant :ref:`le composant Zend_Soap_AutoDiscovery
<zend.soap.autodiscovery.introduction>`, ou alors construit manuellement avec :ref:`la classe Zend_Soap_Wsdl
<zend.soap.wsdl>` ou tout autre outil de génération de *XML*

Si le mode non-WSDL est utilisé, alors toutes les options du protocole doivent être configurées.

.. _zend.soap.server.constructor:

Constructeur de Zend_Soap_Server
--------------------------------

Le constructeur de ``Zend_Soap_Server`` s'utilise différemment selon que l'on fonctionne en mode WSDL ou non.

.. _zend.soap.server.constructor.wsdl_mode:

Constructeur de Zend_Soap_Server en mode WSDL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Le constructeur de ``Zend_Soap_Server`` prend 2 paramètres optionnel en mode WSDL:

   . ``$wsdl``, l'URI permettant l'accès au fichier WSDL [#]_.

   . ``$options``- options de création des objets serveurs [#]_.

     Les options suivantes sont reconnues en mode WSDL :

        - "soap_version" ("soapVersion") : version du protocole *SOAP* à utiliser (SOAP_1_1 ou *SOAP*\ _1_2).

        - "actor" : l'URI du serveur *SOAP*.

        - "classmap" ("classMap") : utilisé pour faire correspondre des types WSDL à des classes *PHP*.

          L'option doit être un tableau avec pour clés les types WSDL et pour valeur les classes *PHP*
          correspondantes.

        - "encoding" : encodage interne des caractères (l'encodage externe est toujours UTF-8).

        - "wsdl" : équivalent à un appel à ``setWsdl($wsdlValue)``





.. _zend.soap.server.wsdl_mode:

Constructeur de Zend_Soap_Server en mode non-WSDL
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Le premier paramètre du constructeur **doit** être mis à la valeur ``NULL`` si vous voulez utiliser
``Zend_Soap_Server`` en mode non-WSDL.

Vous devez aussi spécifier "uri" dans ce cas (voir juste après).

Le second paramètre de constructeur est un tableau (``$options``) d'options permettant la création de l'objet
serveur *SOAP*. [#]_.

Les options suivantes sont reconnues en mode non-WSDL :

   - "soap_version" ("soapVersion") : version *SOAP* à utiliser (SOAP_1_1 ou *SOAP*\ _1_2).

   - "actor" : l'URI du serveur *SOAP*.

   - "classmap" ("classMap") : utilisé pour faire correspondre des types WSDL à des classes *PHP*.

     L'option doit être un tableau avec pour clés les types WSDL et pour valeur les classes *PHP*
     correspondantes.

   - "encoding" : encodage interne des caractères (l'encodage externe est toujours UTF-8).

   - "wsdl" : équivalent à un appel à *setWsdl($wsdlValue).*



.. _zend.soap.server.api_define_methods:

Méthodes de définitions de l'API du service
-------------------------------------------

Il existe 2 manières de déclarer l'API de votre serveur *SOAP*.

La première consiste à attacher des classes à l'objet ``Zend_Soap_Server``, celles-ci devront alors décrire
l'API du service en totalité :

   .. code-block:: php
      :linenos:

      ...
      class MyClass {
          /**
           * Cette méthode accepte ...
           *
           * @param integer $inputParam
           * @return string
           */
          public function method1($inputParam) {
              ...
          }

          /**
           * Cette méthode accepte ...
           *
           * @param integer $inputParam1
           * @param string  $inputParam2
           * @return float
           */
          public function method2($inputParam1, $inputParam2) {
              ...
          }

          ...
      }
      ...
      $server = new Zend_Soap_Server(null, $options);
      // Connecte la classe au serveur Soap
      $server->setClass('MyClass');
      // Connecte un objet déjà initialisé au serveur Soap
      $server->setObject(new MyClass());
      ...
      $server->handle();



   .. note::

      **Important!**

      Vous devriez complètement décrire chaque méthode grâce aux blocs de commentaires PHPDoc dans le cas où
      vous souhaitez utiliser l'auto découverte du service pour préparer le WSDL correspondant.



La seconde manière de décrire l'API de votre service Web est d'utiliser des fonctions PHP conjointement avec les
méthodes ``addFunction()`` ou ``loadFunctions()``:

   .. code-block:: php
      :linenos:

      ...
      /**
       * Cette fonction ...
       *
       * @param integer $inputParam
       * @return string
       */
      function function1($inputParam) {
          ...
      }

      /**
       * Cette fonction ...
       *
       * @param integer $inputParam1
       * @param string  $inputParam2
       * @return float
       */
      function function2($inputParam1, $inputParam2) {
          ...
      }
      ...
      $server = new Zend_Soap_Server(null, $options);
      $server->addFunction('function1');
      $server->addFunction('function2');
      ...
      $server->handle();



.. _zend.soap.server.request_response:

Gestion des objets de requête et de réponse
-------------------------------------------

.. note::

   **Avancée**

   Cette section décrit la gestion avancée des requêtes et réponses *SOAP* et pourra être évitée.

Le composant Zend_Soap_Server effectue des requêtes et récupère des réponses, ceci automatiquement. Il est
possible d'intercepter la requête/réponse pour ajouter du pré ou post processus.

.. _zend.soap.server.request_response.request:

Requête
^^^^^^^

La méthode ``Zend_Soap_Server::handle()`` utilise la requête depuis le flux d'entrée standard ('php://input').
Le comportement peut être changé en passant des paramètres à la méthode ``handle()`` ou en spécifiant sa
propre requête grâce à la méthode ``setRequest()``:

   .. code-block:: php
      :linenos:

      ...
      $server = new Zend_Soap_Server(...);
      ...
      // Affecte une requête personnalisée
      $server->handle($request);
      ...
      // Affecte une requête personnalisée
      $server->setRequest();
      $server->handle();



Un objet de requête peut être représenté de plusieurs manières différentes :

   - DOMDocument (casté en *XML*)

   - DOMNode (le DOMDocument attaché est extrait et casté en *XML*)

   - SimpleXMLElement (casté en *XML*)

   - stdClass (\__toString() est appelée et son contenu est vérifié comme *XML* valide)

   - chaînes de caractères (vérifiée comme *XML* valide)



La dernière requête utilisée et traitée peut être récupérée en utilisant la méthode ``getLastRequest()``:

   .. code-block:: php
      :linenos:

      ...
      $server = new Zend_Soap_Server(...);
      ...
      $server->handle();
      $request = $server->getLastRequest();



.. _zend.soap.server.request_response.response:

Réponse
^^^^^^^

``Zend_Soap_Server::handle()`` émet automatiquement la réponse vers le flux standard de sortie. Ce comportement
peut être changé en utilisant ``setReturnResponse()`` avec une valeur ``TRUE`` ou ``FALSE`` en paramètre. [#]_.
La réponse générée par ``handle()`` est alors retournée et non plus émise.

   .. code-block:: php
      :linenos:

      ...
      $server = new Zend_Soap_Server(...);
      ...
      // Récupère la réponse plutôt que de l'émettre
      $server->setReturnResponse(true);
      ...
      $response = $server->handle();
      ...



Autrement, la dernière réponse peut être récupérer avec la méthode ``getLastResponse()``:

   .. code-block:: php
      :linenos:

      ...
      $server = new Zend_Soap_Server(...);
      ...
      $server->handle();
      $response = $server->getLastResponse();
      ...





.. [#] Peut être spécifié plus tard avec la méthode ``setWsdl($wsdl)``
.. [#] Peut être spécifié plus tard avec la méthode ``setOptions($options)``
.. [#] Les options se configurent aussi plus tard, grâce à la méthode ``setOptions($options)``
.. [#] L'état actuel du drapeau de retour de la réponse peut être vérifié via la méthode
       ``setReturnResponse()`` sans paramètre.