.. EN-Revision: none
.. _zend.rest.client:

Zend\Rest\Client
================

.. _zend.rest.client.introduction:

Introduction
------------

Utiliser le ``Zend\Rest\Client`` est très semblable à l'utilisation des objets de *SoapClient* (`SOAP web service
extension`_). Vous pouvez simplement appeler les procédures de service de REST comme méthodes de
``Zend\Rest\Client``. Vous devez indiquer l'adresse complète du service dans le constructeur de
``Zend\Rest\Client``.

.. _zend.rest.client.introduction.example-1:

.. rubric:: Une requête REST basique

.. code-block:: php
   :linenos:

   /**
    * Connexion au serveur framework.zend.com server
    */
   $client = new Zend\Rest\Client('http://framework.zend.com/rest');

   echo $client->sayHello('Davey', 'Day')->get();
   // "Hello Davey, Good Day"

.. note::

   **Différences dans les appels**

   ``Zend\Rest\Client`` tente de rendre les méthodes distantes de la même manière que ses propres méthodes, la
   seule différence étant que vous devez suivre l'appel de méthode ``get()``, ``post()``, ``put()`` ou
   ``delete()``. Cet appel peut être fait par l'intermédiaire de méthodes enchaînées ou dans des appels
   séparés de méthode :

   .. code-block:: php
      :linenos:

      $client->sayHello('Davey', 'Day');
      echo $client->get();

.. _zend.rest.client.return:

Réponses
--------

Toutes les demandes faites en utilisant ``Zend\Rest\Client`` retourne un objet ``Zend\Rest\Client\Response``. Cet
objet a beaucoup de propriétés qui facilitent l'accès aux résultats.

Quand le service est basé sur ``Zend\Rest\Server``, Zend\Rest\Client peut faire plusieurs suppositions au sujet de
la réponse, y compris le statut de réponse (succès ou échec) et le type de retour.

.. _zend.rest.client.return.example-1:

.. rubric:: État de la réponse

.. code-block:: php
   :linenos:

   $result = $client->sayHello('Davey', 'Day')->get();

   if ($result->isSuccess()) {
       echo $result; // "Hello Davey, Good Day"
   }

Dans l'exemple ci-dessus, vous pouvez voir que nous utilisons le résultat de la demande comme un objet, pour
appeler ``isSuccess()``, et puis grâce à ``__toString()``, nous pouvons simplement faire *echo* sur l'objet pour
récupérer le résultat. ``Zend\Rest\Client\Response`` vous permettra de afficher n'importe quelle valeur
scalaire. Pour les types complexes, vous pouvez employer la notation type objet ou type tableau.

Si cependant, vous souhaitez questionner un service n'employant pas ``Zend\Rest\Server`` l'objet de
``Zend\Rest\Client\Response`` se comportera comme un *SimpleXMLElement*. Cependant, pour faciliter les choses, il
questionnera automatiquement le *XML* en utilisant XPath si la propriété n'est pas un descendant direct de
l'élément racine du document. En plus, si vous accédez à une propriété comme à une méthode, vous recevrez
la valeur de *PHP* pour l'objet, ou un tableau de résultats.

.. _zend.rest.client.return.example-2:

.. rubric:: Utiliser le service REST Technorati

.. code-block:: php
   :linenos:

   $technorati = new Zend\Rest\Client('http://api.technorati.com/bloginfo');
   $technorati->key($key);
   $technorati->url('http://pixelated-dreams.com');
   $result = $technorati->get();
   echo $result->firstname() .' '. $result->lastname();

.. _zend.rest.client.return.example-3:

.. rubric:: Exemple de réponse Technorati

.. code-block:: xml
   :linenos:

   <?xml version="1.0" encoding="utf-8"?>
   <!-- generator="Technorati API version 1.0 /bloginfo" -->
   <!DOCTYPE tapi PUBLIC "-//Technorati, Inc.//DTD TAPI 0.02//EN"
        "http://api.technorati.com/dtd/tapi-002.xml">
   <tapi version="1.0">
       <document>
           <result>
               <url>http://pixelated-dreams.com</url>
               <weblog>
                   <name>Pixelated Dreams</name>
                   <url>http://pixelated-dreams.com</url>
                   <author>
                       <username>DShafik</username>
                       <firstname>Davey</firstname>
                       <lastname>Shafik</lastname>
                   </author>
                   <rssurl>http://pixelated-dreams.com/feeds/index.rss2</rssurl>
                   <atomurl>http://pixelated-dreams.com/feeds/atom.xml</atomurl>
                   <inboundblogs>44</inboundblogs>
                   <inboundlinks>218</inboundlinks>
                   <lastupdate>2006-04-26 04:36:36 GMT</lastupdate>
                   <rank>60635</rank>
               </weblog>
               <inboundblogs>44</inboundblogs>
               <inboundlinks>218</inboundlinks>
           </result>
       </document>
   </tapi>

Ici nous accédons aux propriétés *firstname* et *lastname*.Bien que ce ne soient pas les éléments supérieurs,
elles sont automatiquement retournées quand on accède par le nom.

.. note::

   **Éléments multiples**

   Si des éléments multiples sont trouvés en accédant à une valeur de nom, un tableau d'élément
   SimpleXMLElement sera retourné ; l'accès par l'intermédiaire de la notation de méthode retournera un tableau
   de valeurs.

.. _zend.rest.client.args:

Arguments de requêtes
---------------------

A moins que vous ne fassiez une demande à un service basé sur ``Zend\Rest\Server``, il y a des chances que vous
devez envoyer des arguments multiples avec votre requête. Ceci est fait en appelant une méthode avec le nom de
l'argument, en passant la valeur comme premier (et seul) argument. Chacun de ces appels de méthode renvoie l'objet
lui-même, tenant compte de l'enchaînement, ou de l'utilisation habituelle. Le premier appel, ou le premier
argument si vous passez plus d'un argument, est toujours considéré comme la méthode en appelant un service
``Zend\Rest\Server``.

.. _zend.rest.client.args.example-1:

.. rubric:: Affecter des arguments de requêtes

.. code-block:: php
   :linenos:

   $client = new Zend\Rest\Client('http://example.org/rest');

   $client->arg('value1');
   $client->arg2('value2');
   $client->get();

   // or

   $client->arg('value1')->arg2('value2')->get();

Les deux méthodes dans l'exemple ci-dessus, auront comme conséquence l'obtention des arguments suivants :
*?method=arg&arg1=value1&arg=value1&arg2=value2*

Vous noterez que le premier appel de *$client->arg('value1');* a eu comme conséquence *method=arg&arg1=value1* et
*arg=value1*; ceci afin que ``Zend\Rest\Server`` puisse comprendre la demande correctement, plutôt que d'exiger la
connaissance préalable du service.

.. warning::

   **Sévérité de Zend\Rest\Client**

   Tout service REST qui est strict au sujet des arguments qu'il reçoit échouera probablement en utilisant
   ``Zend\Rest\Client``, en raison du comportement décrit ci-dessus. Ce n'est pas une pratique courante et ne
   devrait pas poser des problèmes.



.. _`SOAP web service extension`: http://www.php.net/soap
