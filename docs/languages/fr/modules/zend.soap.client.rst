.. EN-Revision: none
.. _zend.soap.client:

Zend\Soap\Client
================

``Zend\Soap\Client`` est une classe destinée à simplifier l'interrogation de services *SOAP*.

Cette classe peut être utilisée en mode WSDL ou non WSDL.

Lorsque Zend\Soap\Client fonctionne en mode WSDL, il utilise le document WSDL pour définir les options de la
couche de transport des données.

Le fichier WSDL est en général fournit par le service auquel vous souhaitez accéder. Si la description WSDL
n'est pas disponible, vous pouvez vouloir utiliser ``Zend\Soap\Client`` en mode non WSDL . Dans ce cas, toutes les
options du protocole devront être définies explicitement dans la classe ``Zend\Soap\Client``.

.. _zend.soap.client.constructor:

Constructeur de Zend\Soap\Client
--------------------------------

Le constructeur de ``Zend\Soap\Client`` accepte 2 paramètres:

   - ``$wsdl``: l'URI du fichier WSDL.

   - ``$options``: options de création.

Ces deux paramètres peuvent être insérés après construction, ceci grâce aux méthodes ``setWsdl($wsdl)`` et
``setOptions($options)``.

.. note::

   **Important!**

   Si vous utilisez Zend\Soap\Client en mode non WSDL, vous **devez** fournir les options 'location' et 'uri'.

Les options suivantes sont reconnues:

   - 'soap_version' ('soapVersion') : version du protocole *SOAP* à utiliser (SOAP_1_1 ou *SOAP*\ _1_2).

   - 'classmap' ('classMap') : doit être utilisé pour faire correspondre des types WSDL à des classes *PHP*.

     Cette option doit être un tableau avec comme clés les types WSDL et comme valeurs les noms des classes
     *PHP*.

   - 'encoding' : encodage interne des caractères (l'encodage externe est toujours UTF-8).

   - 'wsdl' : qui est équivalent à un appel à ``setWsdl($wsdlValue)``.

     Changer cette option peut faire basculer Zend\Soap\Client en mode WSDL ou non WSDL.

   - 'uri' : cible du service *SOAP* (requis pour le mode non WSDL, inusité en mode WSDL).

   - 'location' : l'URL à requêter (requis pour le mode non WSDL, inusité en mode WSDL).

   - 'style' : style de requête (inusité en mode WSDL): ``SOAP_RPC`` ou ``SOAP_DOCUMENT``.

   - 'use' : méthode d'encodage des messages (inusité en mode WSDL): ``SOAP_ENCODED`` ou ``SOAP_LITERAL``.

   - 'login' et 'password' : login et password pour l'authentification *HTTP*.

   - 'proxy_host', 'proxy_port', 'proxy_login', et 'proxy_password' : utilisés pour une connexion *HTTP* via un
     proxy.

   - 'local_cert' et 'passphrase' : options d'authentification *HTTPS*.

   - 'compression' : options de compression ; c'est une combinaison entre ``SOAP_COMPRESSION_ACCEPT``,
     ``SOAP_COMPRESSION_GZIP`` et ``SOAP_COMPRESSION_DEFLATE``, qui peuvent être utilisées de cette manière :

        .. code-block:: php
           :linenos:

           // Accepte une response compressée
           $client = new Zend\Soap\Client("some.wsdl",
             array('compression' => SOAP_COMPRESSION_ACCEPT));
           ...
           // Compresse les requêtes avec gzip et un taux de 5
           $client = new Zend\Soap\Client("some.wsdl",
             array('compression' =>
                       SOAP_COMPRESSION_ACCEPT | SOAP_COMPRESSION_GZIP | 5));
           ...
           // Compresse les requêtes en utilisant deflate
           $client = new Zend\Soap\Client("some.wsdl",
             array('compression' =>
                       SOAP_COMPRESSION_ACCEPT | SOAP_COMPRESSION_DEFLATE));





.. _zend.soap.client.calls:

Effectuer des requêtes SOAP
---------------------------

Lorsqu'un objet ``Zend\Soap\Client`` est crée, nous sommes prêts à créer des requêtes *SOAP*.

Chaque méthode du service Web est liée à une méthode virtuelle de l'objet ``Zend\Soap\Client``, qui s'utilise
de manière tout à fait classique comme *PHP* le définit.

Voici un exemple :

   .. code-block:: php
      :linenos:

      ...
      //****************************************************************
      //                Code du serveur
      //****************************************************************
      // class MyClass {
      //     /**
      //      * Cette méthode utilise ...
      //      *
      //      * @param integer $inputParam
      //      * @return string
      //      */
      //     public function method1($inputParam) {
      //         ...
      //     }
      //
      //     /**
      //      * Cette méthode utilise ...
      //      *
      //      * @param integer $inputParam1
      //      * @param string  $inputParam2
      //      * @return float
      //      */
      //     public function method2($inputParam1, $inputParam2) {
      //         ...
      //     }
      //
      //     ...
      // }
      // ...
      // $server = new Zend\Soap\Server(null, $options);
      // $server->setClass('MyClass');
      // ...
      // $server->handle();
      //
      //****************************************************************
      //                Fin du code du serveur
      //****************************************************************

      $client = new Zend\Soap\Client("MyService.wsdl");
      ...
      // $result1 est une chaine
      $result1 = $client->method1(10);
      ...
      // $result2 est un flottant
      $result2 = $client->method2(22, 'some string');




