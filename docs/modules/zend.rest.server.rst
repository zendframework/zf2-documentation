
.. _zend.rest.server:

Zend_Rest_Server
================


.. _zend.rest.server.introduction:

Introduction
------------

``Zend_Rest_Server`` is intended as a fully-featured REST server.


.. _zend.rest.server.usage:

REST Server Usage
-----------------


.. _zend.rest.server.usage.example-1:

.. rubric:: Basic Zend_Rest_Server Usage - Classes

.. code-block:: php
   :linenos:

   $server = new Zend_Rest_Server();
   $server->setClass('My_Service_Class');
   $server->handle();


.. _zend.rest.server.usage.example-2:

.. rubric:: Basic Zend_Rest_Server Usage - Functions

.. code-block:: php
   :linenos:

   /**
    * Say Hello
    *
    * @param string $who
    * @param string $when
    * @return string
    */
   function sayHello($who, $when)
   {
       return "Hello $who, Good $when";
   }

   $server = new Zend_Rest_Server();
   $server->addFunction('sayHello');
   $server->handle();


.. _zend.rest.server.args:

Calling a Zend_Rest_Server Service
----------------------------------

To call a ``Zend_Rest_Server`` service, you must supply a ``GET``/POST *method* argument with a value that is the method you wish to call. You can then follow that up with any number of arguments using either the name of the argument (i.e. "who") or using *arg* following by the numeric position of the argument (i.e. "arg1").

.. note::
   **Numeric index**

   Numeric arguments use a 1-based index.


To call *sayHello* from the example above, you can use either:

*?method=sayHello&who=Davey&when=Day*

or:

*?method=sayHello&arg1=Davey&arg2=Day*


.. _zend.rest.server.customstatus:

Sending A Custom Status
-----------------------

When returning values, to return a custom status, you may return an array with a *status* key.


.. _zend.rest.server.customstatus.example-1:

.. rubric:: Returning Custom Status

.. code-block:: php
   :linenos:

   /**
    * Say Hello
    *
    * @param string $who
    * @param string $when
    * @return array
    */
   function sayHello($who, $when)
   {
       return array('msg' => "An Error Occurred", 'status' => false);
   }

   $server = new Zend_Rest_Server();
   $server->addFunction('sayHello');
   $server->handle();


.. _zend.rest.server.customxml:

Returning Custom XML Responses
------------------------------

If you wish to return custom *XML*, simply return a *DOMDocument*, *DOMElement* or *SimpleXMLElement* object.


.. _zend.rest.server.customxml.example-1:

.. rubric:: Return Custom XML

.. code-block:: php
   :linenos:

   /**
    * Say Hello
    *
    * @param string $who
    * @param string $when
    * @return SimpleXMLElement
    */
   function sayHello($who, $when)
   {
       $xml ='<?xml version="1.0" encoding="ISO-8859-1"?>
   <mysite>
       <value>Hey $who! Hope you\'re having a good $when</value>
       <code>200</code>
   </mysite>';

       $xml = simplexml_load_string($xml);
       return $xml;
   }

   $server = new Zend_Rest_Server();
   $server->addFunction('sayHello');

   $server->handle();

The response from the service will be returned without modification to the client.


