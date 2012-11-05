.. EN-Revision: none
.. _zend.soap.wsdl:

WSDL
====

.. note::

   La classe ``Zend\Soap\Wsdl`` est utilisée par le composant Zend\Soap\Server pour manipuler des documents WSDL.
   Néanmoins, vous pouvez vous-même utiliser les services fournis par cette classe pour vos propres besoins. La
   classe Zend\Soap\Wsdl contient à la fois un analyseur et un constructeur de documents WSDL.

   Si vous ne voulez pas l'utiliser pour vos propres besoins, vous pouvez alors passer cette section de la
   documentation.

.. _zend.soap.wsdl.constructor:

Constructeur Zend\Soap\Wsdl
---------------------------

Le constructeur de ``Zend\Soap\Wsdl`` prend 3 paramètres :

   . ``$name``- nom du service Web décrit.

   . ``$uri``-*URI* d'accès au fichier WSDL. (Une référence dans le système de fichier local est possible.)

   . ``$strategy``- identifiant optionnel pour identifier la détection de stratégie des types complexes. Ceci est
     un booléen ``$extractComplexTypes`` avant la version 1.7 et peut toujours être paramétrer via un booléen
     pour la compatibilité ascendante. Par défaut le comportement de détection de la 1.6 est activé. Pour avoir
     de plus amples informations concernant les stratégies de détection des types complexes, lisez : :ref:`
     <zend.soap.wsdl.types.add_complex>`.



.. _zend.soap.wsdl.addmessage:

addMessage()
------------

``addMessage($name, $parts)`` ajoute un message de description au document WSDL (/definitions/message de
l'élément).

Chaque message correspond à une méthode en terme de fonctionnalité de ``Zend\Soap\Server`` et
``Zend\Soap\Client``.

Le paramètre ``$name`` représente le nom du message.

Le paramètre ``$parts`` est un tableau de paramètre des messages décrivant les paramètres d'appel *SOAP*. Le
tableau est associatif: 'nom du paramètre' (nom du paramètre d'appel *SOAP*) => 'type du paramètre'.

La correspondance de types est effectuée grâce à ``addTypes()`` et ``addComplexType()``\ (voyez après).

.. note::

   Les paramètres de messages peuvent être soit "element", soit "type" (voyez
   `http://www.w3.org/TR/wsdl#_messages`_).

   "element" doit correspondre à un élément de définition de type. "type" correspond à une entrée
   complexType.

   Tous les types standards XSD possèdent une définition "element" et "complexType" (Voyez
   `http://schemas.xmlsoap.org/soap/encoding/`_).

   Tous les éléments non standards, qui doivent être ajoutés avec la méthode
   ``Zend\Soap\Wsdl::addComplexType()``, sont décrits en utilisant un noeud "complexType" décrits dans la section
   "/definitions/types/schema/" du document WSDL.

   Ainsi, la méthode ``addMessage()`` utilise toujours un attribut "type" pour décrire des types.

.. _zend.soap.wsdl.add_port_type:

addPortType()
-------------

``addPortType($name)`` ajoute un nouveau type de portage au document WSDL (/definitions/portType).

Ceci fait la jointure entre des méthodes du service décrites en tant qu'implémentations de Zend\Soap\Server.

Voyez `http://www.w3.org/TR/wsdl#_porttypes`_ pour plus de détails.

.. _zend.soap.wsdl.add_port_operation:

addPortOperation()
------------------

*addPortOperation($portType, $name, $input = false, $output = false, $fault = false)* ajoute des définitions de
portage au portage défini dans le document WSDL (/definitions/portType/operation).

Chaque opération de portage correspond à une méthode de classe (si le Web Service est basé sur une classe) ou
à une fonction (si le Web Service est basé sur des fonctions), ceci en terme d'implémentation de
Zend\Soap\Server.

Cette méthode ajoute aussi les messages d'opération correspondants aux portages, ceci dépend des paramètres
``$input``, ``$output`` and ``$fault``.

   .. note::

      Zend\Soap\Server génère 2 messages pour chaque opération de portage lorsque le service est décrit au
      travers de la classe ``Zend\Soap\Server``:

         - Le message d'entrée nommé *$methodName . 'Request'*.

         - Les message de sortie nommé *$methodName . 'Response'*.





Voyez `http://www.w3.org/TR/wsdl#_request-response`_ pour les détails.

.. _zend.soap.wsdl.add_binding:

addBinding()
------------

``addBinding($name, $portType)`` ajoute de nouvelles correspondances (bindings) au document WSDL
(/definitions/binding).

Le noeud du document WSDL "binding" définit le format du message et les détails du protocole pour les opérations
et messages définis par un portage "portType" particulier (voyez `http://www.w3.org/TR/wsdl#_bindings`_).

La méthode crée le noeud de correspondance et le retourne. Il peut alors être utilisé.

L'implémentation de Zend\Soap\Server utilise le nom *$serviceName . "Binding"* pour la correspondance ("binding")
de l'élément du document WSDL.

.. _zend.soap.wsdl.add_binding_operation:

addBindingOperation()
---------------------

*addBindingOperation($binding, $name, $input = false, $output = false, $fault = false)* ajoute une opération à
l'élément de correspondance avec le nom spécifié (/definitions/binding/operation).

Cette méthode prend un objet *XML_Tree_Node* tel que retourné par ``addBinding()``, en paramètre (``$binding``)
pour ajouter un élément "operation" avec des entrées input/output/false dépendantes des paramètres
spécifiés.

``Zend\Soap\Server`` ajoute les correspondances pour chaque méthode du Web Service avec des entrées et sorties,
définissant l'élément "soap:body" comme *<soap:body use="encoded"
encodingStyle="http://schemas.xmlsoap.org/soap/encoding/"/>*

Voyez les détails à `http://www.w3.org/TR/wsdl#_bindings`_.

.. _zend.soap.wsdl.add_soap_binding:

addSoapBinding()
----------------

*addSoapBinding($binding, $style = 'document', $transport = 'http://schemas.xmlsoap.org/soap/http')* ajoute des
correspondances (bindings) *SOAP* ("soap:binding") à l'élément (déjà lié à un portage de type) avec le style
et le transport spécifié (``Zend\Soap\Server`` utilise le style RPC sur *HTTP*).

L'élément "/definitions/binding/soap:binding" est alors utilisé pour spécifier que la correspondance est
relative au format du protocole *SOAP*.

Voyez `http://www.w3.org/TR/wsdl#_bindings`_ pour les détails.

.. _zend.soap.wsdl.add_soap_operation:

addSoapOperation()
------------------

``addSoapOperation($binding, $soap_action)`` ajoute une opération *SOAP* ("soap:operation") à l'élément de
correspondance avec l'action spécifiée. L'attribut "style" de l'élément "soap:operation" n'est pas utilisé
alors que le modèle de programmation (RPC-oriented ou document-oriented) devrait utiliser la méthode
``addSoapBinding()``

L'attribut "soapAction" de l'élément "/definitions/binding/soap:operation" spécifie la valeur de l'en-tête
*SOAP*\ Action pour l'opération. Cet attribut est requis pour *SOAP* sur *HTTP* et **ne doit pas** être
renseigné pour les autres modes de transports.

``Zend\Soap\Server`` utilise *$serviceUri . '#' . $methodName* pour le nom de l'action *SOAP*.

Voyez `http://www.w3.org/TR/wsdl#_soap:operation`_ pour plus de détails.

.. _zend.soap.wsdl.add_service:

addService()
------------

``addService($name, $port_name, $binding, $location)`` ajoute un élément "/definitions/service" au document WSDL
avec le nom du Web Service spécifié, le nom du portage, la correspondance, et l'adresse.

WSDL 1.1 autorise d'avoir plusieurs types de portage par service. Cette particularité n'est pas utilisée dans
``Zend\Soap\Server`` et est non supportée par la classe ``Zend\Soap\Wsdl``.

Utilisations de ``Zend\Soap\Server``:

   - *$name . 'Service'* comme nom du Web Service,

   - *$name . 'Port'* comme nom de portage des types,

   - *'tns:' . $name . 'Binding'* [#]_ comme nom de la correspondance,

   - l'URI du script [#]_ en tant qu'URI du service pour les Web Service utilisant des classes.

où ``$name`` est un nom de classe pour le Web Service utilisant des classes, ou un nom de script pour le Web
Service qui utilise des fonctions.

Voyez `http://www.w3.org/TR/wsdl#_services`_ pour les détails.

.. _zend.soap.wsdl.types:

Correspondance de type
----------------------

Le WSDL de Zend_Soap utilise les correspondances suivantes pour faire correspondre les type *SOAP* à des types
*PHP*:

   - chaînes *PHP* <-> *xsd:string*.

   - entiers *PHP* <-> *xsd:int*.

   - flottants *PHP* <-> *xsd:float*.

   - booléens *PHP* <-> *xsd:boolean*.

   - tableaux *PHP* <-> *soap-enc:Array*.

   - objets *PHP* <-> *xsd:struct*.

   - Classe *PHP* <-> basé sur la stratégie des types complexes (Voir : :ref:`
     <zend.soap.wsdl.types.add_complex>`) [#]_.

   - Type *PHP* vide <-> void.

   - Si le type na aucune correspondance avec les valeurs ci-dessus, alors *xsd:anyType* est utilisé.

Où *xsd:* est l'espace de noms "http://www.w3.org/2001/XMLSchema", *soap-enc:* est l'espace de noms
"http://schemas.xmlsoap.org/soap/encoding/", *tns:* est un "espace de noms cible" pour le service.

.. _zend.soap.wsdl.types.retrieve:

Récupérer des infos sur les types
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``getType($type)`` peut être utilisée pour récupérer la correspondance d'un type PHP spécifié :

   .. code-block:: php
      :linenos:

      ...
      $wsdl = new Zend\Soap\Wsdl('My_Web_Service', $myWebServiceUri);

      ...
      $soapIntType = $wsdl->getType('int');

      ...
      class MyClass {
          ...
      }
      ...
      $soapMyClassType = $wsdl->getType('MyClass');



.. _zend.soap.wsdl.types.add_complex:

Ajouter des infos sur les types complexes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``addComplexType($type)`` est utilisée pour ajouter des types complexes (classes *PHP*) à un document WSDL.

C'est automatiquement utilisé par la méthode ``getType()`` pour ajouter les types complexes des paramètres de
méthodes ou des types retournés.

Sa détection et son algorithme de construction est basé sur la détection de stratégie des types complexes
couramment active. Vous pouvez paramétrer la stratégie de détection soit en spécifiant le nom de classe sous la
forme d'une chaîne de caractères ou une instance implémentant ``Zend\Soap\Wsdl\Strategy\Interface`` en tant que
troisième paramètre du constructeur ou en utilisant la fonction ``setComplexTypeStrategy($strategy)`` de
``Zend\Soap\Wsdl``. Les stratégies de détection suivantes existent couramment :

- la classe ``Zend\Soap\Wsdl\Strategy\DefaultComplexType``: activé par défaut (quand aucun troisième paramètre
  n'est fourni). Itère parmi les attributs publics d'un type de classe et les enregistre en tant que sous-types
  d'un type d'objet complexe.

- la classe ``Zend\Soap\Wsdl\Strategy\AnyType``: caste tous les types complexes en un type XSD simple xsd:anyType.
  Attention ce raccourci pour la détection des types complexes peut probablement seulement être géré avec des
  langages faiblement typés comme le *PHP*.

- la classe ``Zend\Soap\Wsdl\Strategy\ArrayOfTypeSequence``: cette stratégie permet de spécifier les paramètres
  de retour de type : *int[]* ou *string[]*. A partir de Zend Framework 1.9, il peut gérer des types *PHP* simples
  comme int, string, boolean, float ainsi que des objets ou des tableaux d'objets.

- la classe ``Zend\Soap\Wsdl\Strategy\ArrayOfTypeComplex``: cette stratégie permet de détecter des tableaux
  complexes d'objets. Les types d'objets sont détectés sur la base de
  ``Zend\Soap\Wsdl\Strategy\DefaultComplexType`` et un tableau enveloppe cette définition.

- la classe ``Zend\Soap\Wsdl\Strategy\Composite``: cette stratégie peut combiner toutes les stratégies en
  connectant les types complexes *PHP* (nom de classe) à la stratégie désirée grâce à la méthode
  ``connectTypeToStrategy($type, $strategy)``. Une carte de correspondance complète de types peut être fourni au
  constructeur sous la forme d'un tableau de paires ``$type``-> ``$strategy``. Le second paramètre spécifie la
  stratégie par défaut si un type inconnu est ajouté. La valeur par défaut de ce paramètre est la stratégie
  ``Zend\Soap\Wsdl\Strategy\DefaultComplexType``.

la méthode ``addComplexType()`` crée un élément "*/definitions/types/xsd:schema/xsd:complexType*" pour chaque
type complexe décrit avec le nom d'une classe *PHP* spécifiée.

Les propriétés des classes **doivent** posséder un bloc de documentation avec le type *PHP* en question, afin
que la propriété soit incluse dans la description WSDL.

``addComplexType()`` vérifie sur le type est déjà décrit dans la section des types du document WSDL.

Ceci évite les duplications et récursions si cette méthode est appelée plus d'une fois.

Voyez `http://www.w3.org/TR/wsdl#_types`_ pour plus de détails.

.. _zend.soap.wsdl.add_documentation:

addDocumentation()
------------------

``addDocumentation($input_node, $documentation)`` ajoute de la documentation lisible ("human readable") grâce à
l'élément optionnel "wsdl:document".

L'élément "/definitions/binding/soap:binding" est utilisé pour dire que la correspondance est liée au format du
protocole *SOAP*.

Voyez `http://www.w3.org/TR/wsdl#_documentation`_ pour les détails.

.. _zend.soap.wsdl.retrieve:

Récupérer un document WSDL finalisé
-----------------------------------

``toXML()``, ``toDomDocument()`` et *dump($filename = false)* peuvent être utilisées pour récupérer un document
WSDL sous forme de *XML*, de structure DOM, ou de fichier.



.. _`http://www.w3.org/TR/wsdl#_messages`: http://www.w3.org/TR/wsdl#_messages
.. _`http://schemas.xmlsoap.org/soap/encoding/`: http://schemas.xmlsoap.org/soap/encoding/
.. _`http://www.w3.org/TR/wsdl#_porttypes`: http://www.w3.org/TR/wsdl#_porttypes
.. _`http://www.w3.org/TR/wsdl#_request-response`: http://www.w3.org/TR/wsdl#_request-response
.. _`http://www.w3.org/TR/wsdl#_bindings`: http://www.w3.org/TR/wsdl#_bindings
.. _`http://www.w3.org/TR/wsdl#_soap:operation`: http://www.w3.org/TR/wsdl#_soap:operation
.. _`http://www.w3.org/TR/wsdl#_services`: http://www.w3.org/TR/wsdl#_services
.. _`http://www.w3.org/TR/wsdl#_types`: http://www.w3.org/TR/wsdl#_types
.. _`http://www.w3.org/TR/wsdl#_documentation`: http://www.w3.org/TR/wsdl#_documentation

.. [#] *'tns:' namespace* est l'URI du script (*'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']*).
.. [#] *'http://' .$_SERVER['HTTP_HOST'] . $_SERVER['SCRIPT_NAME']*
.. [#] ``Zend\Soap\AutoDiscover`` sera créé avec la classe ``Zend\Soap\Wsdl\Strategy\DefaultComplexType`` en
       tant qu'algorithme de détection pour les types complexes. Le premier paramètre du constructeur
       AutoDiscover accepte toute stratégie de types complexes implémentant
       ``Zend\Soap\Wsdl\Strategy\Interface`` ou une chaîne correspondant au nom de la classe. Pour une
       compatibilité ascendante, avec ``$extractComplexType`` les variables booléennes sont analysées comme
       avec Zend\Soap\Wsdl. Regardez le manuel :ref:`Zend\Soap\Wsdl sur l'ajout des types complexes
       <zend.soap.wsdl.types.add_complex>` pour plus d'informations.