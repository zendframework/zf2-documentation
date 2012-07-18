.. _zend.uri.chapter:

Zend_Uri
========

.. _zend.uri.overview:

Overview
--------

``Zend_Uri`` is a component that aids in manipulating and validating `Uniform Resource Identifiers`_ (URIs).
``Zend_Uri`` exists primarily to service other components, such as ``Zend_Http_Client``, but is also useful as a
standalone utility.

*URI*\ s always begin with a scheme, followed by a colon. The construction of the many different schemes varies
significantly. The ``Zend_Uri`` class provides a factory that returns a subclass of itself which specializes in
each scheme. The subclass will be named ``Zend_Uri_<scheme>``, where **<scheme>** is the scheme, lowercased with
the first letter capitalized. An exception to this rule is *HTTPS*, which is also handled by ``Zend_Uri_Http``.

.. _zend.uri.creation:

Creating a New URI
------------------

``Zend_Uri`` will build a new *URI* from scratch if only a scheme is passed to ``Zend_Uri::factory()``.

.. _zend.uri.creation.example-1:

.. rubric:: Creating a New URI with Zend_Uri::factory()

.. code-block:: php
   :linenos:

   // To create a new URI from scratch, pass only the scheme.
   $uri = Zend_Uri::factory('http');

   // $uri instanceof Zend_Uri_Http

To create a new *URI* from scratch, pass only the scheme to ``Zend_Uri::factory()`` [#]_. If an unsupported scheme
is passed and no scheme-specific class is specified, a ``Zend_Uri_Exception`` will be thrown.

If the scheme or *URI* passed is supported, ``Zend_Uri::factory()`` will return a subclass of itself that
specializes in the scheme to be created.

Creating a New Custom-Class URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Starting from Zend Framework 1.10.5, you can specify a custom class to be used when creating the Zend_Uri instance,
as a second parameter to the ``Zend_Uri::factory()`` method. This enables you to subclass Zend_Uri and create your
own custom URI classes, and instantiate new URI objects based on your own custom classes.

The 2nd parameter passed to ``Zend_Uri::factory()`` must be a string with the name of a class extending
``Zend_Uri``. The class must either be alredy-loaded, or loadable using ``Zend_Loader::loadClass()``- that is, it
must follow the Zend Framework class and file naming conventions, and must be in your include_path.

.. _zend.uri.creation.custom.example-1:

.. rubric:: Creating a URI using a custom class

.. code-block:: php
   :linenos:

   // Create a new 'ftp' URI based on a custom class
   $ftpUri = Zend_Uri::factory(
       'ftp://user@ftp.example.com/path/file',
       'MyLibrary_Uri_Ftp'
   );

   // $ftpUri is an instance of MyLibrary_Uri_Ftp, which is a subclass of Zend_Uri

.. _zend.uri.manipulation:

Manipulating an Existing URI
----------------------------

To manipulate an existing *URI*, pass the entire *URI* to ``Zend_Uri::factory()``.

.. _zend.uri.manipulation.example-1:

.. rubric:: Manipulating an Existing URI with Zend_Uri::factory()

.. code-block:: php
   :linenos:

   // To manipulate an existing URI, pass it in.
   $uri = Zend_Uri::factory('http://www.zend.com');

   // $uri instanceof Zend_Uri_Http

The *URI* will be parsed and validated. If it is found to be invalid, a ``Zend_Uri_Exception`` will be thrown
immediately. Otherwise, ``Zend_Uri::factory()`` will return a subclass of itself that specializes in the scheme to
be manipulated.

.. _zend.uri.validation:

URI Validation
--------------

The ``Zend_Uri::check()`` method can only be used if validation of an existing *URI* is needed.

.. _zend.uri.validation.example-1:

.. rubric:: URI Validation with Zend_Uri::check()

.. code-block:: php
   :linenos:

   // Validate whether a given URI is well formed
   $valid = Zend_Uri::check('http://uri.in.question');

   // $valid is TRUE for a valid URI, or FALSE otherwise.

``Zend_Uri::check()`` returns a boolean, which is more convenient than using ``Zend_Uri::factory()`` and catching
the exception.

.. _zend.uri.validation.allowunwise:

Allowing "Unwise" characters in URIs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

By default, ``Zend_Uri`` will not accept the following characters: **"{", "}", "|", "\", "^", "`"**. These
characters are defined by the *RFC* as "unwise" and invalid; however, many implementations do accept these
characters as valid.

``Zend_Uri`` can be set to accept these "unwise" characters by setting the 'allow_unwise' option to boolean
``TRUE`` using ``Zend_Uri::setConfig()``:

.. _zend.uri.validation.allowunwise.example-1:

.. rubric:: Allowing special characters in URIs

.. code-block:: php
   :linenos:

   // Contains '|' symbol
   // Normally, this would return false:
   $valid = Zend_Uri::check('http://example.com/?q=this|that');

   // However, you can allow "unwise" characters
   Zend_Uri::setConfig(array('allow_unwise' => true));

   // will return 'true'
   $valid = Zend_Uri::check('http://example.com/?q=this|that');

   // Reset the 'allow_unwise' value to the default FALSE
   Zend_Uri::setConfig(array('allow_unwise' => false));

.. note::

   ``Zend_Uri::setConfig()`` sets configuration options globally. It is recommended to reset the 'allow_unwise'
   option to '``FALSE``', like in the example above, unless you are certain you want to always allow unwise
   characters globally.

.. _zend.uri.instance-methods:

Common Instance Methods
-----------------------

Every instance of a ``Zend_Uri`` subclass (e.g. ``Zend_Uri_Http``) has several instance methods that are useful for
working with any kind of *URI*.

.. _zend.uri.instance-methods.getscheme:

Getting the Scheme of the URI
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The scheme of the *URI* is the part of the *URI* that precedes the colon. For example, the scheme of
``http://www.zend.com`` is 'http'.

.. _zend.uri.instance-methods.getscheme.example-1:

.. rubric:: Getting the Scheme from a Zend_Uri_* Object

.. code-block:: php
   :linenos:

   $uri = Zend_Uri::factory('http://www.zend.com');

   $scheme = $uri->getScheme();  // "http"

The ``getScheme()`` instance method returns only the scheme part of the *URI* object.

.. _zend.uri.instance-methods.geturi:

Getting the Entire URI
^^^^^^^^^^^^^^^^^^^^^^

.. _zend.uri.instance-methods.geturi.example-1:

.. rubric:: Getting the Entire URI from a Zend_Uri_* Object

.. code-block:: php
   :linenos:

   $uri = Zend_Uri::factory('http://www.zend.com');

   echo $uri->getUri();  // "http://www.zend.com"

The ``getUri()`` method returns the string representation of the entire *URI*.

.. _zend.uri.instance-methods.valid:

Validating the URI
^^^^^^^^^^^^^^^^^^

``Zend_Uri::factory()`` will always validate any *URI* passed to it and will not instantiate a new ``Zend_Uri``
subclass if the given *URI* is found to be invalid. However, after the ``Zend_Uri`` subclass is instantiated for a
new *URI* or an existing valid one, it is possible that the *URI* can later become invalid after it is manipulated.

.. _zend.uri.instance-methods.valid.example-1:

.. rubric:: Validating a Zend_Uri_* Object

.. code-block:: php
   :linenos:

   $uri = Zend_Uri::factory('http://www.zend.com');

   $isValid = $uri->valid();  // TRUE

The ``valid()`` instance method provides a means to check that the *URI* object is still valid.



.. _`Uniform Resource Identifiers`: http://www.w3.org/Addressing/

.. [#] At the time of writing, ``Zend_Uri`` only provides built-in support for the *HTTP* and *HTTPS* schemes.