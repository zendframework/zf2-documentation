.. EN-Revision: none
.. _zend.soap.autodiscovery:

Auto découverte
===============

.. _zend.soap.autodiscovery.introduction:

Introduction à l'auto découverte
--------------------------------

Les fonctionnalités *SOAP* de Zend Framework sont proposées afin de simplifier l'accès aux services Web de type
*SOAP*.

*SOAP* est un protocole d'échange de données indépendant d'un langage. Il peut donc être utilisé avec une
autre technologie que *PHP*.

Il y a trois configurations d'utilisation de *SOAP* avec Zend Framework :

   . SOAP serveur application *PHP* <---> *SOAP* client application *PHP*

   . SOAP serveur application non *PHP* <---> *SOAP* client application *PHP*

   . SOAP serveur application *PHP* <---> *SOAP* client application non *PHP*



Il est indispensable de connaître les fonctionnalités qu'offre un serveur *SOAP*, afin de pouvoir communiquer
avec lui. `WSDL`_ est alors utilisé pour décrire en détail l'API des services disponibles sur un serveur *SOAP*.

Le langage WSDL est assez complexe (voyez `http://www.w3.org/TR/wsdl`_ pour les détails ). Il est donc difficile
d'écrire une définition WSDL correcte, à la main.

Un autre problème concerne la synchronisation des changements dans l'API avec des fichiers WSDL déjà existants.

Ces 2 problèmes peuvent être résolus avec la génération automatique de WSDL, qui permet d'analyser une classe
ou des fonctions, d'en extraire les paramètres d'entrée/sortie, et de générer un fichier WSDL correct et
compréhensible par le serveur et les clients *SOAP*.

Il y a deux façons d'utiliser Zend Framework pour une application serveur *SOAP*:

   - Utiliser des classes.

   - Utiliser des fonctions.



Ces deux façons sont supportées par la fonctionnalité d'auto génération de Zend Framework.

Zend_Soap_AutoDiscovery supporte aussi la correspondance des types *PHP* vers `les types XSD`_.

Voici un exemple d'utilisation de l'auto découverte. La fonction ``handle()`` génère le fichier WSDL et l'envoie
au navigateur :

   .. code-block:: php
      :linenos:

      class My_SoapServer_Class {
      ...
      }

      $autodiscover = new Zend_Soap_AutoDiscover();
      $autodiscover->setClass('My_SoapServer_Class');
      $autodiscover->handle();



Si vous avez besoin d'accéder au fichier WSDL généré soit pour le sauvegarder dans un fichier ou en tant que
chaîne de caractères, vous pouvez utiliser les méthodes ``dump($filename)`` ou ``toXml()`` que la classe
AutoDiscover fournit.

.. note::

   **Zend_Soap_Autodiscover n'est pas un serveur SOAP**

   Il est très important de noter, que la classe ``Zend_Soap_Autodiscover`` n'agit pas en tant que serveur *SOAP*
   elle-même. Elle génère seulement le WSDL et le fournit à ceux qui accèdent à l'URL qu'elle écoute.

   Par défaut l'URI de *SOAP* est *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']*, mais ceci peut
   être changé avec la méthode ``setUri()`` ou le paramètre de constructeur de la classe
   ``Zend_Soap_AutoDiscover``. L'URI doit correspondre à un ``Zend_Soap_Server`` qui écoute les requêtes.



      .. code-block:: php
         :linenos:

         if(isset($_GET['wsdl'])) {
             $autodiscover = new Zend_Soap_AutoDiscover();
             $autodiscover->setClass('HelloWorldService');
             $autodiscover->handle();
         } else {
             // pointing to the current file here
             $soap = new Zend_Soap_Server("http://example.com/soap.php?wsdl");
             $soap->setClass('HelloWorldService');
             $soap->handle();
         }



.. _zend.soap.autodiscovery.class:

Auto découverte de classe
-------------------------

Si une classe est utilisée dans un serveur SOAP, alors celle-ci devrait aussi être fournie à
``Zend_Soap_AutoDiscovery`` afin d'en générer le fichier WSDL :

   .. code-block:: php
      :linenos:

      $autodiscover = new Zend_Soap_AutoDiscover();
      $autodiscover->setClass('My_SoapServer_Class');
      $autodiscover->handle();



Les règles suivantes sont utilisées lors de la génération du fichier WSDL :

   - Le fichier WSDL généré décrit un service Web de type RPC.

   - Le nom du service crée sera le nom de la classe utilisée.

   - *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']* est utilisé comme *URI* où le fichier WSDL est
     disponible par défaut mais ceci peut être surchargé avec la méthode ``setUri()``.

     Cet *URI* est aussi utilisé comme un espace de nom cible pour tous les noms du service (incluant les types
     complexes décrits éventuellement).

   - Les méthodes de la classe sont jointes dans un `Port Type`_.

     *$className . 'Port'* est utilisé comme nom de Port Type.

   - Chaque méthode de la classe est enregistrée comme une opération.

   - Chaque prototype de méthode génère des messages de requête/réponse correspondants.

     Une méthode peut avoir plusieurs prototypes si des paramètres sont optionnels.



.. note::

   **Important !**

   L'auto génération du fichier WSDL (avec auto découverte de la classe) utilise les blocs de documentation de
   *PHP* insérés par le développeur dans ses classes, afin de trouver les types retournés. De ce fait, pour les
   types scalaires, c'est le seul moyen de les déterminer de manière sûre, et concernant les types de retour des
   méthodes, c'est le seul moyen de les découvrir (PHP étant faiblement typé).

   Ceci signifie que documenter de manière correcte vos classes et méthodes n'est pas seulement une bonne
   pratique, c'est tout simplement essentiel pour partager vos classes en tant que services *SOAP* auto générés.

.. _zend.soap.autodiscovery.functions:

Auto découverte des fonctions
-----------------------------

Si des fonctions doivent être utilisées (partagées) via un serveur SOAP, alors elles doivent être passées à
``Zend_Soap_AutoDiscovery`` pour générer un fichier WSDL :

   .. code-block:: php
      :linenos:

      $autodiscover = new Zend_Soap_AutoDiscover();
      $autodiscover->addFunction('function1');
      $autodiscover->addFunction('function2');
      $autodiscover->addFunction('function3');
      ...
      $autodiscover->handle();



Les règles suivantes sont utilisées lors de la génération du fichier WSDL :

   - Le fichier WSDL généré décrit un service web de type RPC.

   - Le nom du service crée sera le nom du script analysé (utilisé).

   - *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']* est utilisé comme *URI* pour rechercher le
     fichier WSDL.

     Cet *URI* est aussi utilisé comme un espace de nom cible pour tous les noms du service (incluant les types
     complexes décrits éventuellement).

   - Les fonctions sont encapsulées dans un `Port Type`_.

     *$functionName . 'Port'* est utilisé comme nom de Port Type.

   - Chaque fonction est enregistrée comme opération possible.

   - Chaque prototype de fonction génère des messages de requête/réponse correspondants.

     Une fonction peut avoir plusieurs prototypes si des paramètres sont optionnels.



.. note::

   **Important!**

   L'auto génération du fichier WSDL (avec auto découverte des fonctions) utilise les blocs de documentation de
   *PHP* insérés par le développeur dans ses fonctions, afin de trouver les types retournés. De ce fait, pour
   les types scalaires, c'est le seul moyen de les déterminer de manière sûre, et concernant les types de retour
   des méthodes, c'est le seul moyen de les découvrir (PHP étant faiblement typé).

   Ceci signifie que documenter de manière correcte vos fonctions n'est pas seulement une bonne pratique, c'est
   tout simplement essentiel pour partager vos fonctions en tant que services *SOAP* auto générés.

.. _zend.soap.autodiscovery.datatypes:

Types de donnée auto découverts
-------------------------------

Les types de données d'entrée/sortie sont convertis en types spéciaux pour le réseau, suivant ces règles :

   - Chaînes strings <-> *xsd:string*.

   - Entiers *PHP* <-> *xsd:int*.

   - Flottants *PHP* (décimaux) <-> *xsd:float*.

   - Booléens *PHP* <-> *xsd:boolean*.

   - Tableaux *PHP* <-> *soap-enc:Array*.

   - Objets *PHP* <-> *xsd:struct*.

   - Classe *PHP* <-> basé sur la stratégie des types complexes (Voir : :ref:`
     <zend.soap.wsdl.types.add_complex>`) [#]_.

   - *type[]* or *object[]* (c'est-à-dire *int[]*) <-> basé sur la stratégie des types complexes

   - Void *PHP* <-> type vide.

   - Si le type n'est pas reconnu en tant que l'un de ceux-ci, alors *xsd:anyType* est utilisé.

Où *xsd:* est l'espace "http://www.w3.org/2001/XMLSchema", *soap-enc:* est l'espace
"http://schemas.xmlsoap.org/soap/encoding/", *tns:* est "l'espace de nom cible" du service.

.. _zend.soap.autodiscovery.wsdlstyles:

Styles de liaisons WSDL
-----------------------

WSDL offre différents mécanismes et styles de transport. Ceci affecte les balises *soap:binding* et *soap:body*
à l'intérieur de la section binding du WSDL. Différents clients ont différentes conditions quant aux options
qui sont vraiment utilisées. Par conséquent vous pouvez placer les styles avant d'appeler n'importe quelle
méthode *setClass* ou *addFunction* de la classe *AutoDiscover*.



   .. code-block:: php
      :linenos:

      $autodiscover = new Zend_Soap_AutoDiscover();
      // Par défaut il s'agit de 'use' => 'encoded'
      // et 'encodingStyle' => 'http://schemas.xmlsoap.org/soap/encoding/'
      $autodiscover->setOperationBodyStyle(array('use' => 'literal', 'namespace' => 'http://framework.zend.com'));

      // Par défaut il s'agit de 'style' => 'rpc'
      // et 'transport' => 'http://schemas.xmlsoap.org/soap/http'
      $autodiscover->setBindingStyle(array('style' => 'document', 'transport' => 'http://framework.zend.com'));
      ...
      $autodiscover->addFunction('myfunc1');
      $autodiscover->handle();





.. _`WSDL`: http://www.w3.org/TR/wsdl
.. _`http://www.w3.org/TR/wsdl`: http://www.w3.org/TR/wsdl
.. _`les types XSD`: http://www.w3.org/TR/xmlschema-2/
.. _`Port Type`: http://www.w3.org/TR/wsdl#_porttypes

.. [#] ``Zend_Soap_AutoDiscover`` sera créé avec la classe ``Zend_Soap_Wsdl_Strategy_DefaultComplexType`` en
       tant qu'algorithme de détection pour les types complexes. Le premier paramètre du constructeur
       AutoDiscover accepte toute stratégie de types complexes implémentant
       ``Zend_Soap_Wsdl_Strategy_Interface`` ou une chaîne correspondant au nom de la classe. Pour une
       compatibilité ascendante, avec ``$extractComplexType`` les variables booléennes sont analysées comme
       avec Zend_Soap_Wsdl. Regardez le manuel :ref:`Zend_Soap_Wsdl sur l'ajout des types complexes
       <zend.soap.wsdl.types.add_complex>` pour plus d'informations.