
Zend_Rest_Client
================

.. _zend.rest.client.introduction:

Introduction
------------

Using the ``Zend_Rest_Client`` is very similar to usingSoapClientobjects ( `SOAP web service extension`_ ). You can simply call the REST service procedures as ``Zend_Rest_Client`` methods. Specify the service's full address in the ``Zend_Rest_Client`` constructor.

.. _zend.rest.client.introduction.example-1:

A basic REST request
--------------------

.. code-block:: php
    :linenos:
    
    /**
     * Connect to framework.zend.com server and retrieve a greeting
     */
    $client = new Zend_Rest_Client('http://framework.zend.com/rest');
    
    echo $client->sayHello('Davey', 'Day')->get(); // "Hello Davey, Good Day"
    

.. note::
    **Differences in calling**

     ``Zend_Rest_Client`` attempts to make remote methods look as much like native methods as possible, the only difference being that you must follow the method call with one of either ``get()`` , ``post()`` , ``put()`` or ``delete()`` . This call may be made via method chaining or in separate method calls:

.. code-block:: php
    :linenos:
    
    $client->sayHello('Davey', 'Day');
    echo $client->get();
    

.. _zend.rest.client.return:

Responses
---------

All requests made using ``Zend_Rest_Client`` return a ``Zend_Rest_Client_Response`` object. This object has many properties that make it easier to access the results.

When the service is based on ``Zend_Rest_Server`` , ``Zend_Rest_Client`` can make several assumptions about the response, including response status (success or failure) and return type.

.. _zend.rest.client.return.example-1:

Response Status
---------------

.. code-block:: php
    :linenos:
    
    $result = $client->sayHello('Davey', 'Day')->get();
    
    if ($result->isSuccess()) {
        echo $result; // "Hello Davey, Good Day"
    }
    

In the example above, you can see that we use the request result as an object, to call ``isSuccess()`` , and then because of ``__toString()`` , we can simplyechothe object to get the result. ``Zend_Rest_Client_Response`` will allow you to echo any scalar value. For complex types, you can use either array or object notation.

If however, you wish to query a service not using ``Zend_Rest_Server`` the ``Zend_Rest_Client_Response`` object will behave more like aSimpleXMLElement. However, to make things easier, it will automatically query the *XML* using XPath if the property is not a direct descendant of the document root element. Additionally, if you access a property as a method, you will receive the *PHP* value for the object, or an array of *PHP* value results.

.. _zend.rest.client.return.example-2:

Using Technorati's Rest Service
-------------------------------

.. code-block:: php
    :linenos:
    
    $technorati = new Zend_Rest_Client('http://api.technorati.com/bloginfo');
    $technorati->key($key);
    $technorati->url('http://pixelated-dreams.com');
    $result = $technorati->get();
    echo $result->firstname() .' '. $result->lastname();
    

.. _zend.rest.client.return.example-3:

Example Technorati Response
---------------------------

.. code-block:: php
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
                    <rssurl>
                        http://pixelated-dreams.com/feeds/index.rss2
                    </rssurl>
                    <atomurl>
                        http://pixelated-dreams.com/feeds/atom.xml
                    </atomurl>
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
    

Here we are accessing thefirstnameandlastnameproperties. Even though these are not top-level elements, they are automatically returned when accessed by name.

.. note::
    **Multiple items**

    If multiple items are found when accessing a value by name, an array of SimpleXMLElements will be returned; accessing via method notation will return an array of *PHP* values.

.. _zend.rest.client.args:

Request Arguments
-----------------

Unless you are making a request to a ``Zend_Rest_Server`` based service, chances are you will need to send multiple arguments with your request. This is done by calling a method with the name of the argument, passing in the value as the first (and only) argument. Each of these method calls returns the object itself, allowing for chaining, or "fluent" usage. The first call, or the first argument if you pass in more than one argument, is always assumed to be the method when calling a ``Zend_Rest_Server`` service.

.. _zend.rest.client.args.example-1:

Setting Request Arguments
-------------------------

.. code-block:: php
    :linenos:
    
    $client = new Zend_Rest_Client('http://example.org/rest');
    
    $client->arg('value1');
    $client->arg2('value2');
    $client->get();
    
    // or
    
    $client->arg('value1')->arg2('value2')->get();
    

Both of the methods in the example above, will result in the following get args:?method=arg&arg1=value1&arg=value1&arg2=value2

You will notice that the first call of$client->arg('value1');resulted in bothmethod=arg&arg1=value1andarg=value1; this is so that ``Zend_Rest_Server`` can understand the request properly, rather than requiring pre-existing knowledge of the service.

Strictness of Zend_Rest_Client
------------------------------

Any REST service that is strict about the arguments it receives will likely fail using ``Zend_Rest_Client`` , because of the behavior described above. This is not a common practice and should not cause problems.


.. _`SOAP web service extension`: http://www.php.net/soap
