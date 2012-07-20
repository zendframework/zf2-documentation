.. _zend.rest.server:

Zend_Rest_Server
================

.. _zend.rest.server.introduction:

Introduction
------------

Zend_Rest_Server est prévu comme un serveur supportant l'ensemble des fonctionnalités d'un serveur REST.

.. _zend.rest.server.usage:

Utilisation d'un serveur REST
-----------------------------

.. _zend.rest.server.usage.example-1:

.. rubric:: Utilisation basique Zend_Rest_Server - Avec des classes

.. code-block:: php
   :linenos:

   $server = new Zend_Rest_Server();
   $server->setClass('Mon_Service_Classe');
   $server->handle();

.. _zend.rest.server.usage.example-2:

.. rubric:: Utilisation basique Zend_Rest_Server - Avec des fonctions

.. code-block:: php
   :linenos:

   /**
    * Dit Bonjour
    *
    * @param string $qui
    * @param string $quand
    * @return string
    */
   function ditBonjour($qui, $quand)
   {
       return "Bonjour $qui, bonne $quand";
   }

   $server = new Zend_Rest_Server();
   $server->addFunction('ditBonjour');
   $server->handle();

.. _zend.rest.server.args:

Appelé un service Zend_Rest_Server
----------------------------------

Pour appeler un service ``Zend_Rest_Server``, vous devez fournir un argument de *method* GET/POST avec une valeur
qui est la méthode que vous souhaitez appeler. Vous pouvez alors ajouter tout nombre d'arguments en utilisant le
nom de l'argument (c.-à-d. "qui ") ou en utilisant 'arg' suivi de la position numérique de l'argument (c.-à-d.
"arg1").

.. note::

   **Index numérique**

   Les arguments numériques utilisent 1 comme point de départ.

Pour appeler le *ditBonjour* de l'exemple ci-dessus, vous pouvez employer soit :

*?method=ditBonjour&qui=Davey&quand=journée*

or:

*?method=ditBonjour&arg1=Davey&arg2=journée*

.. _zend.rest.server.customstatus:

Envoyer un statut personnalisé
------------------------------

En envoyant des valeurs, pour ajouter un statut personnalisé, vous pouvez envoyer un tableau avec une clé
*status*.

.. _zend.rest.server.customstatus.example-1:

.. rubric:: Renvoyer un statut personnalisé

.. code-block:: php
   :linenos:

   /**
    * Dit Bonjour
    *
    * @param string $qui
    * @param string $quand
    * @return array
    */
   function ditBonjour($qui, $quand)
   {
       return array('msg' => "Une erreur est apparue", 'status' => false);
   }

   $server = new Zend_Rest_Server();
   $server->addFunction('ditBonjour');
   $server->handle();

.. _zend.rest.server.customxml:

Renvoyer une réponse XML personnalisée
--------------------------------------

Si vous voulez retourner du *XML* personnalisé, retournez simplement un objet *DOMDocument*, *DOMElement* ou
*SimpleXMLElement*.

.. _zend.rest.server.customxml.example-1:

.. rubric:: Renvoyer une réponse XML personnalisée

.. code-block:: php
   :linenos:

   /**
    * Dit Bonjour
    *
    * @param string $who
    * @param string $when
    * @return SimpleXMLElement
    */
   function ditBonjour($qui, $quand)
   {
       $xml ='<?xml version="1.0" encoding="ISO-8859-1"?>
   <mysite>
       <value>Salut $qui! J\'espère que tu passes une bonne $when</value>
       <constant>200</constant>
   </mysite>';

       $xml = simplexml_load_string($xml);
       return $xml;
   }

   $server = new Zend_Rest_Server();
   $server->addFunction('ditBonjour');

   $server->handle();

La réponse du service sera retournée sans modification au client.


