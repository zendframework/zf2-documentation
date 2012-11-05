.. EN-Revision: none
.. _zend.rest.server:

Zend\Rest\Server
================

.. _zend.rest.server.introduction:

Einführung
----------

``Zend\Rest\Server`` ist ein komplett-feature REST Server.

.. _zend.rest.server.usage:

Verwenden des REST Servers
--------------------------

.. _zend.rest.server.usage.example-1:

.. rubric:: Grundsätzliche Verwendung von Zend\Rest\Server: Klassen

.. code-block:: php
   :linenos:

   $server = new Zend\Rest\Server();
   $server->setClass('My_Service_Class');
   $server->handle();

.. _zend.rest.server.usage.example-2:

.. rubric:: Grundsätzliche Verwendung von Zend\Rest\Server: Funktionen

.. code-block:: php
   :linenos:

   /**
    * Sag Hallo
    *
    * @param string $who
    * @param string $when
    * @return string
    */
   function sayHello($who, $when)
   {
       return "Hallo $who, Gut $when";
   }

   $server = new Zend\Rest\Server();
   $server->addFunction('sayHello');
   $server->handle();

.. _zend.rest.server.args:

Aufruf eines Zend\Rest\Server Services
--------------------------------------

Um ein ``Zend\Rest\Server`` Service aufzurufen, muß ein ``GET``/POST *method* Argument mit einem Wert angegeben
werden, welcher der Methode entspricht, die aufgerufen werden soll. Es können anschließend beliebig viele
Argumente folgen, die entweder den Namen des Arguments verwenden (z.B. "wer"), oder man kann *arg* verwenden,
gefolgt von der nummerischen Position des Arguments (z.B. "arg1").

.. note::

   **Nummerischer Index**

   Nummerische Argumente verwenden einen 1-basierenden Index.

Um *sayHello* vom obigen Beispiel aufzurufen, kann:

*?method=sayHello&who=Davey&when=Day*

verwendet werden, oder:

*?method=sayHello&arg1=Davey&arg2=Day*

.. _zend.rest.server.customstatus:

Senden eines eigenen Status
---------------------------

Wenn Werte zurückgegeben werden, kann man, um einen eigenen Status zurückzugeben, ein Array mit einem *status*
Schlüssel zurückgeben.

.. _zend.rest.server.customstatus.example-1:

.. rubric:: Einen eigenen Status zurückgeben

.. code-block:: php
   :linenos:

   /**
    * Sag Hallo
    *
    * @param string $who
    * @param string $when
    * @return array
    */
   function sayHello($who, $when)
   {
       return array('msg' => 'Ein Fehler ist aufgetreten', 'status' => false);
   }

   $server = new Zend\Rest\Server();
   $server->addFunction('sayHello');
   $server->handle();

.. _zend.rest.server.customxml:

Eigene XML Antworten zurückgeben
--------------------------------

Wenn man eigenes *XML* zurückgeben will, kann einfach ein *DOMDocument*, *DOMElement* oder *SimpleXMLElement*
Objekt zurückgegeben werden.

.. _zend.rest.server.customxml.example-1:

.. rubric:: Eigenes XML zurückgeben

.. code-block:: php
   :linenos:

   /**
    * Sag Hallo
    *
    * @param string $who
    * @param string $when
    * @return SimpleXMLElement
    */
   function sayHello($who, $when)
   {
       $xml ='<?xml version="1.0" encoding="ISO-8859-1"?>
   <mysite>
       <value>Hallo $who! Hoffentlich hast Du einen guten $when</value>
       <code>200</code>
   </mysite>';

       $xml = simplexml_load_string($xml);
       return $xml;
   }

   $server = new Zend\Rest\Server();
   $server->addFunction('sayHello');

   $server->handle();

Die Antwort des Services wird ohne Modifizierungen zum Client zurückgegeben.


