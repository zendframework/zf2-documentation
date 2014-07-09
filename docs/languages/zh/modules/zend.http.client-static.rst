.. _zend.http.client-static:

HTTP Client - Static Usage
==========================

.. _zend.http.client-static.intro:

Overview
--------

The ``Zend\Http`` component also provides ``Zend\Http\ClientStatic``, a static
HTTP client which exposes a simplified API for quickly performing GET and POST
operations:

.. _zend.http.client-static.quick-start:

Quick Start
-----------

.. code-block:: php
   :linenos:

   use Zend\Http\ClientStatic;

   // Simple GET request
   $response = ClientStatic::get('http://example.org');

   // More complex GET request, specifying query string 'foo=bar' and adding a
   // custom header to request JSON data be returned (Accept: application/json)
   $response = ClientStatic::get(
       'http://example.org',
       array( 'foo' => 'bar' ),
       array( 'Accept' => 'application/json')
   );

   // We can also do a POST request using the same format.  Here we POST
   // login credentials (username/password) to a login page:
   $response = ClientStatic::post('https://example.org/login.php', array(
       'username' => 'foo',
       'password' => 'bar',
   ));


Configuration Options
---------------------

It is not possible to set configuration options on the ``Zend\Http\Client`` instance
encapsulated by ``Zend\Http\ClientStatic``. To perform a HTTP request which requires
non-default configurations, please use ``Zend\Http\Client`` directly.

.. _zend.http.client-static.methods:

Available Methods
-----------------

.. _zend.http.client-static.methods.get:

**get**
   ``get(string $url, array $query = array(), array $headers = array(), mixed $body = null)``

   Perform an HTTP ``GET`` request using the provided URL, query string variables, headers
   and request body.

   Returns Zend\\Http\\Response

.. _zend.http.client-static.methods.post:

**post**
   ``post(string $url, array $params, array $headers = array(), mixed $body = null)``

   Perform an HTTP ``POST`` request using the provided URL, parameters, headers
   and request body.

   Returns Zend\\Http\\Response

