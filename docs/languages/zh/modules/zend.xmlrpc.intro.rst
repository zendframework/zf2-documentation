.. _zend.xmlrpc.introduction:

Introduction to Zend\\XmlRpc
============================

From its `home page`_, *XML-RPC* is described as a "...remote procedure calling using *HTTP* as the transport and
*XML* as the encoding. *XML-RPC* is designed to be as simple as possible, while allowing complex data structures to
be transmitted, processed and returned."

Zend Framework provides support for both consuming remote *XML-RPC* services and building new *XML-RPC* servers.

.. _zend.xmlrpc.introduction.quickstart:

Quick Start
-----------

To show how easy is to create *XML-RPC* services with ``Zend\XmlRpc\Server``, take a look at the following example:

.. code-block:: php
    :linenos:

    class Greeter
    {

        /**
        * Say hello to someone.
        *
        * @param string $name Who to greet
        * @return string
        */
        public function sayHello($name='Stranger')
        {
            return sprintf("Hello %s!", $name);
        }
    }

    $server = new Zend\XmlRpc\Server;
    // Our Greeter class will be called
    // greeter from the client
    $server->setClass('Greeter', 'greeter');
    $server->handle();

.. note::
    
    It is necessary to write function and method docblocks for the services which are to be exposed via
    ``Zend\XmlRpc\Server``, as it will be used to validate parameters provided to the methods, and also
    to determine the method help text and method signatures.

An example of a client consuming this *XML-RPC* service would be something like this:

.. code-block:: php
    :linenos:

    $client = new Zend\XmlRpc\Client('http://example.com/xmlrpcserver.php');

    echo $client->call('greeter.sayHello');
    // will output "Hello Stranger!"

    echo $client->call('greeter.sayHello', array('Dude'));
    // will output "Hello Dude!"

.. _`home page`: http://www.xmlrpc.com/
