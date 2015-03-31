.. _zend.uri.chapter:

Zend\\Uri
=========

.. _zend.uri.overview:

Overview
--------

``Zend\Uri`` is a component that aids in manipulating and validating 
`Uniform Resource Identifiers`_ (URIs) [#]_. ``Zend\Uri`` exists primarily to service
other components, such as ``Zend\Http\``, but is also useful as a standalone 
utility.

*URI*\ s always begin with a scheme, followed by a colon. The construction of 
the many different schemes varies significantly. The ``Zend\Uri`` component 
provides the ``Zend\Uri\UriFactory`` that returns a class implementing the 
``Zend\Uri\UriInterface`` which specializes in the scheme if such a class is 
registered with the Factory. 
  
.. _zend.uri.creation:

Creating a New URI
------------------

``Zend\Uri\UriFactory`` will build a new *URI* from scratch if only a scheme is 
passed to ``Zend\Uri\UriFactory::factory()``.

.. _zend.uri.creation.example-1:

.. rubric:: Creating a New URI with Zend\Uri\UriFactory::factory()

.. code-block:: php
   :linenos:

   // To create a new URI from scratch, pass only the scheme 
   // followed by a colon.
   $uri = Zend\Uri\UriFactory::factory('http:');

   // $uri instanceof Zend\Uri\UriInterface

To create a new *URI* from scratch, pass only the scheme followed by a colon to 
``Zend\Uri\UriFactory::factory()`` [#]_. If an unsupported scheme is passed and 
no scheme-specific class is specified, a 
``Zend\Uri\Exception\InvalidArgumentException`` will be thrown.

If the scheme or *URI* passed is supported, ``Zend\Uri\UriFactory::factory()`` 
will return a class implementing ``Zend\Uri\UriInterface`` that specializes 
in the scheme to be created.

Creating a New Custom-Class URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

You can specify a custom class to be used when using the ``Zend\Uri\UriFactory``
by registering your class with the Factory using 
``\Zend\Uri\UriFactory::registerScheme()`` which takes the scheme as first 
parameter. This enables you to create your own *URI*-class and instantiate new 
URI objects based on your own custom classes.

The 2nd parameter passed to ``Zend\Uri\UriFactory::registerScheme()`` must be a
string with the name of a class implementing ``Zend\Uri\UriInterface``. The 
class must either be already loaded, or be loadable by the autoloader.

.. _zend.uri.creation.custom.example-1:

.. rubric:: Creating a URI using a custom class

.. code-block:: php
   :linenos:

   // Create a new 'ftp' URI based on a custom class
   use Zend\Uri\UriFactory

   UriFactory::registerScheme('ftp', 'MyNamespace\MyClass');

   $ftpUri = UriFactory::factory(
       'ftp://user@ftp.example.com/path/file'
   );

   // $ftpUri is an instance of MyLibrary\MyClass, which implements 
   // Zend\Uri\UriInterface

.. _zend.uri.manipulation:

Manipulating an Existing URI
----------------------------

To manipulate an existing *URI*, pass the entire *URI* as string to 
``Zend\Uri\UriFactory::factory()``.

.. _zend.uri.manipulation.example-1:

.. rubric:: Manipulating an Existing URI with Zend\\Uri\\UriFactory::factory()

.. code-block:: php
   :linenos:

   // To manipulate an existing URI, pass it in.
   $uri = Zend\Uri\UriFactory::factory('http://www.zend.com');

   // $uri instanceof Zend\Uri\UriInterface

The *URI* will be parsed and validated. If it is found to be invalid, a 
``Zend\Uri\Exception\InvalidArgumentException`` will be thrown immediately. 
Otherwise, ``Zend\Uri\UriFactory::factory()`` will return a class implementing
``Zend\Uri\UriInterface`` that specializes in the scheme to be manipulated.

.. _zend.uri.instance-methods:

Common Instance Methods
-----------------------

The ``Zend\Uri\UriInterface`` defines several instance methods that are useful 
for working with any kind of *URI*.

.. _zend.uri.instance-methods.getscheme:

Getting the Scheme of the URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The scheme of the *URI* is the part of the *URI* that precedes the colon. For 
example, the scheme of ``http://johndoe@example.com/my/path?query#token`` is 'http'.

.. _zend.uri.instance-methods.getscheme.example-1:

.. rubric:: Getting the Scheme from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('mailto:john.doe@example.com');

   $scheme = $uri->getScheme();  // "mailto"

The ``getScheme()`` instance method returns only the scheme part of the *URI* 
object.

.. _zend.uri.instance-methods.getuserinfo:

Getting the Userinfo of the URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The userinfo of the *URI* is the optional part of the *URI* that follows the 
colon and comes before the host-part. For example, the userinfo of 
``http://johndoe@example.com/my/path?query#token`` is 'johndoe'.

.. _zend.uri.instance-methods.getuserinfo.example-1:

.. rubric:: Getting the Username from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('mailto:john.doe@example.com');

   $scheme = $uri->getUserinfo();  // "john.doe"

The ``getUserinfo()``  method returns only the userinfo part of the *URI* 
object.

.. _zend.uri.instance-methods.gethost:

Getting the host of the URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The host of the *URI* is the optional part of the *URI* that follows the 
user-part and comes before the path-part. For example, the host of 
``http://johndoe@example.com/my/path?query#token`` is 'example.com'.

.. _zend.uri.instance-methods.gethost.example-1:

.. rubric:: Getting the host from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('mailto:john.doe@example.com');

   $scheme = $uri->getHost();  // "example.com"

The ``getHost()``  method returns only the host part of the *URI* 
object.

.. _zend.uri.instance-methods.getport:

Getting the port of the URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The port of the *URI* is the optional part of the *URI* that follows the 
host-part and comes before the path-part. For example, the host of 
``http://johndoe@example.com:80/my/path?query#token`` is '80'. The URI-class
can define default-ports that can be returned when no port is given in the 
``URI``.

.. _zend.uri.instance-methods.getport.example-1:

.. rubric:: Getting the port from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('http://example.com:8080');

   $scheme = $uri->getPort();  // "8080"
   
.. _zend.uri.instance-methods.getport.example-2:

.. rubric:: Getting a default port from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('http://example.com');

   $scheme = $uri->getPort();  // "80"

The ``getHost()``  method returns only the port part of the *URI* 
object.

.. _zend.uri.instance-methods.getpath:

Getting the path of the URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^

The path of the *URI* is the mandatory part of the *URI* that follows the 
port and comes before the query-part. For example, the path of 
``http://johndoe@example.com:80/my/path?query#token`` is '/my/path'.

.. _zend.uri.instance-methods.getpath.example-1:

.. rubric:: Getting the path from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('http://example.com:80/my/path?a=b&c=d#token');

   $scheme = $uri->getPath();  // "/my/path"
   
The ``getPath()``  method returns only the path of the *URI* object.


.. _zend.uri.instance-methods.getquery:

Getting the query-part of the URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The query-part of the *URI* is the optional part of the *URI* that follows the 
path and comes before the fragment. For example, the query of 
``http://johndoe@example.com:80/my/path?query#token`` is 'query'.

.. _zend.uri.instance-methods.getquery.example-1:

.. rubric:: Getting the query from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('http://example.com:80/my/path?a=b&c=d#token');

   $scheme = $uri->getQuery();  // "a=b&c=d"
   
The ``getQuery()``  method returns only the query-part of the *URI* object.

.. _zend.uri.instance-methods.getquery.example-2:

.. rubric:: Getting the query as array from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('http://example.com:80/my/path?a=b&c=d#token');

   $scheme = $uri->getQueryAsArray();  
   // array(
   //  'a' => 'b',
   //  'c' => 'd',
   // )
   
The query-part often contains key=value pairs and therefore can be split into 
an associative array. This array can be retrieved using ``getQueryAsArray()``

.. _zend.uri.instance-methods.getfragment:

Getting the fragment-part of the URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The fragment-part of the *URI* is the optional part of the *URI* that follows the 
query. For example, the fragment of 
``http://johndoe@example.com:80/my/path?query#token`` is 'token'.

.. _zend.uri.instance-methods.getfragment.example-1:

.. rubric:: Getting the fragment from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('http://example.com:80/my/path?a=b&c=d#token');

   $scheme = $uri->getFragment();  // "token"
   
The ``getFragment()``  method returns only the fragment-part of the *URI* object.

.. _zend.uri.instance-methods.geturi:

Getting the Entire URI
^^^^^^^^^^^^^^^^^^^^^^

.. _zend.uri.instance-methods.geturi.example-1:

.. rubric:: Getting the Entire URI from a Zend\\Uri\\UriInterface Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('http://www.zend.com');

   echo $uri->toString();  // "http://www.zend.com"
   
   // Alternate method:
   echo (string) $uri;     // "http://www.zend.com"

The ``toString()`` method returns the string representation of the entire *URI*.

The ``Zend\Uri\UriInterface`` defines also a magic ``__toString()`` method that 
returns the string representation of the *URI* when the Object is cast to a 
string.

.. _zend.uri.instance-methods.valid:

Validating the URI
^^^^^^^^^^^^^^^^^^

When using ``Zend\Uri\UriFactory::factory()`` the given *URI* will always be 
validated and a ``Zend\Uri\Exception\InvalidArgumentException`` will be thrown
when the *URI* is invalid. However, after the ``Zend\Uri\UriInterface`` is 
instantiated for a new *URI* or an existing valid one, it is possible that the
*URI* can later become invalid after it is manipulated.

.. _zend.uri.instance-methods.valid.example-1:

.. rubric:: Validating a Zend\Uri\* Object

.. code-block:: php
   :linenos:

   $uri = Zend\Uri\UriFactory::factory('http://www.zend.com');

   $isValid = $uri->isValid();  // TRUE

The ``isValid()`` instance method provides a means to check that the *URI* 
object is still valid.



.. _`Uniform Resource Identifiers`: http://www.w3.org/Addressing/

.. [#] See http://www.ietf.org/rfc/rfc3986.txt for more information on URIs
.. [#] At the time of writing, ``Zend\Uri`` provides built-in support for 
       the following schemes: *HTTP*, *HTTPS*, *MAILTO* and *FILE*
