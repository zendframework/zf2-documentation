
Advanced Usage
==============

While the basic usage examples are a perfectly acceptable way to utilize Zend Framework sessions, there are some best practices to consider. This section discusses the finer details of session handling and illustrates more advanced usage of the ``Zend_Session`` component.

.. _zend.session.advanced_usage.starting_a_session:

Starting a Session
------------------

If you want all requests to have a session facilitated by ``Zend_Session`` , then start the session in the bootstrap file:

.. _zend.session.advanced_usage.starting_a_session.example:

Starting the Global Session
---------------------------

.. code-block:: php
    :linenos:
    
    Zend_Session::start();
    

By starting the session in the bootstrap file, you avoid the possibility that your session might be started after headers have been sent to the browser, which results in an exception, and possibly a broken page for website viewers. Various advanced features require ``Zend_Session::start()`` first. (More on advanced features later.)

There are four ways to start a session, when using ``Zend_Session`` . Two are wrong.

Wrong: Do not enable *PHP* 's `session.auto_start setting`_ . If you do not have the ability to disable this setting in php.ini, you are using mod_php (or equivalent), and the setting is already enabled inphp.ini, then add the following to your.htaccessfile (usually in your *HTML* document root directory):

.. code-block:: php
    :linenos:
    
    php_value session.auto_start 0
    

Wrong: Do not use *PHP* 's `session_start()`_ function directly. If you use ``session_start()`` directly, and then start using ``Zend_Session_Namespace`` , an exception will be thrown by ``Zend_Session::start()`` ("session has already been started"). If you call ``session_start()`` after using ``Zend_Session_Namespace`` or calling ``Zend_Session::start()`` , an error of level ``E_NOTICE`` will be generated, and the call will be ignored.

Correct: Use ``Zend_Session::start()`` . If you want all requests to have and use sessions, then place this function call early and unconditionally in your bootstrap code. Sessions have some overhead. If some requests need sessions, but other requests will not need to use sessions, then:

    - Unconditionally set the strict option to
    - TRUE using
    - Zend_Session::setOptions() in your bootstrap.
    - Call Zend_Session::start() only for requests
    - that need to use sessions and before any
    - Zend_Session_Namespace objects are instantiated.
    - Use "new Zend_Session_Namespace()" normally, where needed,
    - but make sure Zend_Session::start() has been
    - called previously.


Thestrictoption preventsnew Zend_Session_Namespace()from automatically starting the session using ``Zend_Session::start()`` . Thus, this option helps application developers enforce a design decision to avoid using sessions for certain requests, since it causes an exception to be thrown when ``Zend_Session_Namespace`` is instantiated before ``Zend_Session::start()`` is called. Developers should carefully consider the impact of using ``Zend_Session::setOptions()`` , since these options have global effect, owing to their correspondence to the underlying options for ext/session.

Correct: Just instantiate ``Zend_Session_Namespace`` whenever needed, and the underlying *PHP* session will be automatically started. This offers extremely simple usage that works well in most situations. However, you then become responsible for ensuring that the firstnew Zend_Session_Namespace()happensbeforeany output (e.g., `HTTP headers`_ ) has been sent by *PHP* to the client, if you are using the default, cookie-based sessions (strongly recommended). See :ref:`this section <zend.session.global_session_management.headers_sent>` for more information.

.. _zend.session.advanced_usage.locking:

Locking Session Namespaces
--------------------------

Session namespaces can be locked, to prevent further alterations to the data in that namespace. Use ``lock()`` to make a specific namespace read-only, ``unLock()`` to make a read-only namespace read-write, and ``isLocked()`` to test if a namespace has been previously locked. Locks are transient and do not persist from one request to the next. Locking the namespace has no effect on setter methods of objects stored in the namespace, but does prevent the use of the namespace's setter method to remove or replace objects stored directly in the namespace. Similarly, locking ``Zend_Session_Namespace`` instances does not prevent the use of symbol table aliases to the same data (see `PHP references`_ ).

.. _zend.session.advanced_usage.locking.example.basic:

Locking Session Namespaces
--------------------------

.. code-block:: php
    :linenos:
    
    $userProfileNamespace = new Zend_Session_Namespace('userProfileNamespace');
    
    // marking session as read only locked
    $userProfileNamespace->lock();
    
    // unlocking read-only lock
    if ($userProfileNamespace->isLocked()) {
        $userProfileNamespace->unLock();
    }
    

.. _zend.session.advanced_usage.expiration:

Namespace Expiration
--------------------

Limits can be placed on the longevity of both namespaces and individual keys in namespaces. Common use cases include passing temporary information between requests, and reducing exposure to certain security risks by removing access to potentially sensitive information some time after authentication occurred. Expiration can be based on either elapsed seconds or the number of "hops", where a hop occurs for each successive request.

.. _zend.session.advanced_usage.expiration.example:

Expiration Examples
-------------------

.. code-block:: php
    :linenos:
    
    $s = new Zend_Session_Namespace('expireAll');
    $s->a = 'apple';
    $s->p = 'pear';
    $s->o = 'orange';
    
    $s->setExpirationSeconds(5, 'a'); // expire only the key "a" in 5 seconds
    
    // expire entire namespace in 5 "hops"
    $s->setExpirationHops(5);
    
    $s->setExpirationSeconds(60);
    // The "expireAll" namespace will be marked "expired" on
    // the first request received after 60 seconds have elapsed,
    // or in 5 hops, whichever happens first.
    

When working with data expiring from the session in the current request, care should be used when retrieving them. Although the data are returned by reference, modifying the data will not make expiring data persist past the current request. In order to "reset" the expiration time, fetch the data into temporary variables, use the namespace to unset them, and then set the appropriate keys again.

.. _zend.session.advanced_usage.controllers:

Session Encapsulation and Controllers
-------------------------------------

Namespaces can also be used to separate session access by controllers to protect variables from contamination. For example, an authentication controller might keep its session state data separate from all other controllers for meeting security requirements.

.. _zend.session.advanced_usage.controllers.example:

Namespaced Sessions for Controllers with Automatic Expiration
-------------------------------------------------------------

The following code, as part of a controller that displays a test question, initiates a boolean variable to represent whether or not a submitted answer to the test question should be accepted. In this case, the application user is given 300 seconds to answer the displayed question.

.. code-block:: php
    :linenos:
    
    // ...
    // in the question view controller
    $testSpace = new Zend_Session_Namespace('testSpace');
    // expire only this variable
    $testSpace->setExpirationSeconds(300, 'accept_answer');
    $testSpace->accept_answer = true;
    //...
    

Below, the controller that processes the answers to test questions determines whether or not to accept an answer based on whether the user submitted the answer within the allotted time:

.. code-block:: php
    :linenos:
    
    // ...
    // in the answer processing controller
    $testSpace = new Zend_Session_Namespace('testSpace');
    if ($testSpace->accept_answer === true) {
        // within time
    }
    else {
        // not within time
    }
    // ...
    

.. _zend.session.advanced_usage.single_instance:

Preventing Multiple Instances per Namespace
-------------------------------------------

Although :ref:`session locking <zend.session.advanced_usage.locking>` provides a good degree of protection against unintended use of namespaced session data, ``Zend_Session_Namespace`` also features the ability to prevent the creation of multiple instances corresponding to a single namespace.

To enable this behavior, pass ``TRUE`` to the second constructor argument when creating the last allowed instance of ``Zend_Session_Namespace`` . Any subsequent attempt to instantiate the same namespace would result in a thrown exception.

.. _zend.session.advanced_usage.single_instance.example:

Limiting Session Namespace Access to a Single Instance
------------------------------------------------------

.. code-block:: php
    :linenos:
    
    // create an instance of a namespace
    $authSpaceAccessor1 = new Zend_Session_Namespace('Zend_Auth');
    
    // create another instance of the same namespace, but disallow any
    // new instances
    $authSpaceAccessor2 = new Zend_Session_Namespace('Zend_Auth', true);
    
    // making a reference is still possible
    $authSpaceAccessor3 = $authSpaceAccessor2;
    
    $authSpaceAccessor1->foo = 'bar';
    
    assert($authSpaceAccessor2->foo, 'bar');
    
    try {
        $aNamespaceObject = new Zend_Session_Namespace('Zend_Auth');
    } catch (Zend_Session_Exception $e) {
        echo 'Cannot instantiate this namespace since ' .
             '$authSpaceAccessor2 was created\n';
    }
    

The second parameter in the constructor above tells ``Zend_Session_Namespace`` that any future instances with the " ``Zend_Auth`` " namespace are not allowed. Attempting to create such an instance causes an exception to be thrown by the constructor. The developer therefore becomes responsible for storing a reference to an instance object ( ``$authSpaceAccessor1`` , ``$authSpaceAccessor2`` , or ``$authSpaceAccessor3`` in the example above) somewhere, if access to the session namespace is needed at a later time during the same request. For example, a developer may store the reference in a static variable, add the reference to a `registry`_ (see :ref:`Zend_Registry <zend.registry>` ), or otherwise make it available to other methods that may need access to the session namespace.

.. _zend.session.advanced_usage.arrays:

Working with Arrays
-------------------

Due to the implementation history of *PHP* magic methods, modifying an array inside a namespace may not work under *PHP* versions before 5.2.1. If you will only be working with *PHP* 5.2.1 or later, then you may :ref:`skip to the next section <zend.session.advanced_usage.objects>` .

.. _zend.session.advanced_usage.arrays.example.modifying:

Modifying Array Data with a Session Namespace
---------------------------------------------

The following illustrates how the problem may be reproduced:

.. code-block:: php
    :linenos:
    
    $sessionNamespace = new Zend_Session_Namespace();
    $sessionNamespace->array = array();
    
    // may not work as expected before PHP 5.2.1
    $sessionNamespace->array['testKey'] = 1;
    echo $sessionNamespace->array['testKey'];
    

.. _zend.session.advanced_usage.arrays.example.building_prior:

Building Arrays Prior to Session Storage
----------------------------------------

If possible, avoid the problem altogether by storing arrays into a session namespace only after all desired array values have been set.

.. code-block:: php
    :linenos:
    
    $sessionNamespace = new Zend_Session_Namespace('Foo');
    $sessionNamespace->array = array('a', 'b', 'c');
    

If you are using an affected version of *PHP* and need to modify the array after assigning it to a session namespace key, you may use either or both of the following workarounds.

.. _zend.session.advanced_usage.arrays.example.workaround.reassign:

Workaround: Reassign a Modified Array
-------------------------------------

In the code that follows, a copy of the stored array is created, modified, and reassigned to the location from which the copy was created, overwriting the original array.

.. code-block:: php
    :linenos:
    
    $sessionNamespace = new Zend_Session_Namespace();
    
    // assign the initial array
    $sessionNamespace->array = array('tree' => 'apple');
    
    // make a copy of the array
    $tmp = $sessionNamespace->array;
    
    // modfiy the array copy
    $tmp['fruit'] = 'peach';
    
    // assign a copy of the array back to the session namespace
    $sessionNamespace->array = $tmp;
    
    echo $sessionNamespace->array['fruit']; // prints "peach"
    

.. _zend.session.advanced_usage.arrays.example.workaround.reference:

Workaround: store array containing reference
--------------------------------------------

Alternatively, store an array containing a reference to the desired array, and then access it indirectly.

.. code-block:: php
    :linenos:
    
    $myNamespace = new Zend_Session_Namespace('myNamespace');
    $a = array(1, 2, 3);
    $myNamespace->someArray = array( &$a );
    $a['foo'] = 'bar';
    echo $myNamespace->someArray['foo']; // prints "bar"
    

.. _zend.session.advanced_usage.objects:

Using Sessions with Objects
---------------------------

If you plan to persist objects in the *PHP* session, know that they will be `serialized`_ for storage. Thus, any object persisted with the *PHP* session must be unserialized upon retrieval from storage. The implication is that the developer must ensure that the classes for the persisted objects must have been defined before the object is unserialized from session storage. If an unserialized object's class is not defined, then it becomes an instance ofstdClass.

.. _zend.session.advanced_usage.testing:

Using Sessions with Unit Tests
------------------------------

Zend Framework relies on PHPUnit to facilitate testing of itself. Many developers extend the existing suite of unit tests to cover the code in their applications. The exception "Zend_Session is currently marked as read-only" is thrown while performing unit tests, if any write-related methods are used after ending the session. However, unit tests using ``Zend_Session`` require extra attention, because closing ( ``Zend_Session::writeClose()`` ), or destroying a session ( ``Zend_Session::destroy()`` ) prevents any further setting or unsetting of keys in any instance of ``Zend_Session_Namespace`` . This behavior is a direct result of the underlying ext/session mechanism and *PHP* 's ``session_destroy()`` and ``session_write_close()`` , which have no "undo" mechanism to facilitate setup/teardown with unit tests.

To work around this, see the unit test ``testSetExpirationSeconds()`` inSessionTest.phpandSessionTestHelper.php, both located intests/Zend/Session, which make use of *PHP* 's ``exec()`` to launch a separate process. The new process more accurately simulates a second, successive request from a browser. The separate process begins with a "clean" session, just like any *PHP* script execution for a web request. Also, any changes to ``$_SESSION`` made in the calling process become available to the child process, provided the parent closed the session before using ``exec()`` .

.. _zend.session.advanced_usage.testing.example:

PHPUnit Testing Code Dependent on Zend_Session
----------------------------------------------

.. code-block:: php
    :linenos:
    
    // testing setExpirationSeconds()
    $script = 'SessionTestHelper.php';
    $s = new Zend_Session_Namespace('space');
    $s->a = 'apple';
    $s->o = 'orange';
    $s->setExpirationSeconds(5);
    
    Zend_Session::regenerateId();
    $id = Zend_Session::getId();
    session_write_close(); // release session so process below can use it
    sleep(4); // not long enough for things to expire
    exec($script . "expireAll $id expireAll", $result);
    $result = $this->sortResult($result);
    $expect = ';a === apple;o === orange;p === pear';
    $this->assertTrue($result === $expect,
        "iteration over default Zend_Session namespace failed; " .
        "expecting result === '$expect', but got '$result'");
    
    sleep(2); // long enough for things to expire (total of 6 seconds
              // waiting, but expires in 5)
    exec($script . "expireAll $id expireAll", $result);
    $result = array_pop($result);
    $this->assertTrue($result === '',
        "iteration over default Zend_Session namespace failed; " .
        "expecting result === '', but got '$result')");
    session_start(); // resume artificially suspended session
    
    // We could split this into a separate test, but actually, if anything
    // leftover from above contaminates the tests below, that is also a
    // bug that we want to know about.
    $s = new Zend_Session_Namespace('expireGuava');
    $s->setExpirationSeconds(5, 'g'); // now try to expire only 1 of the
                                      // keys in the namespace
    $s->g = 'guava';
    $s->p = 'peach';
    $s->p = 'plum';
    
    session_write_close(); // release session so process below can use it
    sleep(6); // not long enough for things to expire
    exec($script . "expireAll $id expireGuava", $result);
    $result = $this->sortResult($result);
    session_start(); // resume artificially suspended session
    $this->assertTrue($result === ';p === plum',
        "iteration over named Zend_Session namespace failed (result=$result)");
    


.. _`session.auto_start setting`: http://www.php.net/manual/en/ref.session.php#ini.session.auto-start
.. _`session_start()`: http://www.php.net/session_start
.. _`HTTP headers`: http://www.php.net/headers_sent
.. _`PHP references`: http://www.php.net/references
.. _`registry`: http://www.martinfowler.com/eaaCatalog/registry.html
.. _`serialized`: http://www.php.net/manual/en/language.oop.serialization.php
