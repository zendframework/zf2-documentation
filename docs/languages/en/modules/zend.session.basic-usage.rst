.. _zend.session.basic_usage:

基础用例
===========

``Zend\Session\Namespace`` instances provide the primary *API* for manipulating session data in the Zend Framework.
Namespaces are used to segregate all session data, although a default namespace exists for those who only want one
namespace for all their session data. ``Zend\Session`` utilizes ext/session and its special ``$_SESSION``
superglobal as the storage mechanism for session state data. while ``$_SESSION`` is still available in *PHP*'s
global namespace, developers should refrain from directly accessing it, so that ``Zend\Session`` and
``Zend\Session\Namespace`` can most effectively and securely provide its suite of session related functionality.

Each instance of ``Zend\Session\Namespace`` corresponds to an entry of the ``$_SESSION`` superglobal array, where
the namespace is used as the key.

.. code-block:: php
   :linenos:

   $myNamespace = new Zend\Session\Namespace('myNamespace');

   // $myNamespace corresponds to $_SESSION['myNamespace']

It is possible to use ``Zend\Session`` in conjunction with other code that uses ``$_SESSION`` directly. To avoid
problems, however, it is highly recommended that such code only uses parts of ``$_SESSION`` that do not correspond
to instances of ``Zend\Session\Namespace``.

.. _zend.session.basic_usage.basic_examples:

实例教程
-----------------

If no namespace is specified when instantiating ``Zend\Session\Namespace``, all data will be transparently stored
in a namespace called "*Default*". ``Zend\Session`` is not intended to work directly on the contents of session
namespace containers. Instead, we use ``Zend\Session\Namespace``. The example below demonstrates use of this
default namespace, showing how to count the number of client requests during a session:

.. _zend.session.basic_usage.basic_examples.example.counting_page_views:

.. rubric:: Counting Page Views

.. code-block:: php
   :linenos:

   $defaultNamespace = new Zend\Session\Namespace('Default');

   if (isset($defaultNamespace->numberOfPageRequests)) {
       // this will increment for each page load.
       $defaultNamespace->numberOfPageRequests++;
   } else {
       $defaultNamespace->numberOfPageRequests = 1; // first time
   }

   echo "Page requests this session: ",
       $defaultNamespace->numberOfPageRequests;

When multiple modules use instances of ``Zend\Session\Namespace`` having different namespaces, each module obtains
data encapsulation for its session data. The ``Zend\Session\Namespace`` constructor can be passed an optional
``$namespace`` argument, which allows developers to partition session data into separate namespaces. Namespacing
provides an effective and popular way to secure session state data against changes due to accidental naming
collisions.

Namespace names are restricted to character sequences represented as non-empty *PHP* strings that do not begin with
an underscore ("*_*") character. Only core components included in Zend Framework should use namespace names
starting with "*Zend*".

.. _zend.session.basic_usage.basic_examples.example.namespaces.new:

.. rubric:: New Way: Namespaces Avoid Collisions

.. code-block:: php
   :linenos:

   // in the Zend\Authentication component
   $authNamespace = new Zend\Session\Namespace('Zend_Auth');
   $authNamespace->user = "myusername";

   // in a web services component
   $webServiceNamespace = new Zend\Session\Namespace('Some_Web_Service');
   $webServiceNamespace->user = "mywebusername";

The example above achieves the same effect as the code below, except that the session objects above preserve
encapsulation of session data within their respective namespaces.

.. _zend.session.basic_usage.basic_examples.example.namespaces.old:

.. rubric:: Old Way: PHP Session Access

.. code-block:: php
   :linenos:

   $_SESSION['Zend_Auth']['user'] = "myusername";
   $_SESSION['Some_Web_Service']['user'] = "mywebusername";

.. _zend.session.basic_usage.iteration:

Iterating Over Session Namespaces
---------------------------------

``Zend\Session\Namespace`` provides the full `IteratorAggregate interface`_, including support for the *foreach*
statement:

.. _zend.session.basic_usage.iteration.example:

.. rubric:: Session Iteration

.. code-block:: php
   :linenos:

   $aNamespace =
       new Zend\Session\Namespace('some_namespace_with_data_present');

   foreach ($aNamespace as $index => $value) {
       echo "aNamespace->$index = '$value';\n";
   }

.. _zend.session.basic_usage.accessors:

Accessors for Session Namespaces
--------------------------------

``Zend\Session\Namespace`` implements the ``__get()``, ``__set()``, ``__isset()``, and ``__unset()`` `magic
methods`_, which should not be invoked directly, except from within a subclass. Instead, the normal operators
automatically invoke these methods, such as in the following example:

.. _zend.session.basic_usage.accessors.example:

.. rubric:: Accessing Session Data

.. code-block:: php
   :linenos:

   $namespace = new Zend\Session\Namespace(); // default namespace

   $namespace->foo = 100;

   echo "\$namespace->foo = $namespace->foo\n";

   if (!isset($namespace->bar)) {
       echo "\$namespace->bar not set\n";
   }

   unset($namespace->foo);



.. _`IteratorAggregate interface`: http://www.php.net/~helly/php/ext/spl/interfaceIteratorAggregate.html
.. _`magic methods`: http://www.php.net/manual/en/language.oop5.overloading.php
