.. _learning.multiuser.sessions:

Managing User Sessions In ZF
============================

.. _learning.multiuser.sessions.intro:

Introduction to Sessions
------------------------

The success of the web is deeply rooted in the protocol that drives the web: *HTTP*. *HTTP* over TCP is by its very
nature stateless, which means that inherently the web is also stateless. While this very aspect is one of the
dominating factors for why the web has become such a popular medium, it also causes an interesting problem for
developers that want to use the web as an application platform.

The act of interacting with a web application is typically defined by the sum of all requests sent to a web server.
Since there can be many consumers being served simultaneously, the application must decide which requests belong to
which consumer. These requests are typically known as a "session".

In *PHP*, the session problem is solved by the session extension which utilizes some state tracking, typically
cookies, and some form of local storage which is exposed via the $_SESSION superglobal. In Zend Framework, the
component ``Zend_Session`` adds value to the *PHP* session extension making it easier to use and depend on inside
object-oriented applications.

.. _learning.multiuser.sessions.basic-usage:

Basic Usage of Zend_Session
---------------------------

The ``Zend_Session`` component is both a session manager as well as an *API* for storing data into a session object
for long-term persistence. The ``Zend_Session`` *API* is for managing the options and behavior of a session, like
options, starting and stopping a session, whereas ``Zend\Session\Namespace`` is the actual object used to store
data.

While its generally good practice to start a session inside a bootstrap process, this is generally not necessary as
all sessions will be automatically started upon the first creation of a ``Zend\Session\Namespace`` object.

``Zend_Application`` is capable of configuring ``Zend_Session`` for you as part of the
``Zend\Application\Resource`` system. To use this, assuming your project uses ``Zend_Application`` to bootstrap,
you would add the following code to your application.ini file:

.. code-block:: php
   :linenos:

   resources.session.save_path = APPLICATION_PATH "/../data/session"
   resources.session.use_only_cookies = true
   resources.session.remember_me_seconds = 864000

As you can see, the options passed in are the same options that you'd expect to find in the ext/session extension
in *PHP*. Those options setup the path to the session files where data will be stored within the project. Since
*INI* files can additionally use constants, the above will use the APPLICATION_PATH constant and relatively point
to a data session directory.

Most Zend Framework components that use sessions need nothing more to use ``Zend_Session``. At this point, you an
either use a component that consumes ``Zend_Session``, or start storing your own data inside a session with
``Zend\Session\Namespace``.

``Zend\Session\Namespace`` is a simple class that proxies data via an easy to use *API* into the ``Zend_Session``
managed $_SESSION superglobal. The reason it is called ``Zend\Session\Namespace`` is that it effectively namespaces
the data inside $_SESSION, thus allowing multiple components and objects to safely store and retrieve data. In the
following code, we'll explore how to build a simple session incrementing counter, starting at 1000 and resetting
itself after 1999.

.. code-block:: php
   :linenos:

   $mysession = new Zend\Session\Namespace('mysession');

   if (!isset($mysession->counter)) {
       $mysession->counter = 1000;
   } else {
       $mysession->counter++;
   }

   if ($mysession->counter > 1999) {
       unset($mysession->counter);
   }

As you can see above, the session namespace object uses the magic \__get, \__set, \__isset, and \__unset to allow
you to seamlessly and fluently interact with the session. The information stored in the above example is stored at
$_SESSION['mysession']['counter'].

.. _learning.multiuser.sessions.advanced-usage:

Advanced Usage of Zend_Session
------------------------------

Additionally, if you wanted to use the DbTable save handler for ``Zend_Session``, you'd add the following code to
your application.ini:

.. code-block:: php
   :linenos:

   resources.session.saveHandler.class = "Zend\Session\SaveHandler\DbTable"
   resources.session.saveHandler.options.name = "session"
   resources.session.saveHandler.options.primary.session_id = "session_id"
   resources.session.saveHandler.options.primary.save_path = "save_path"
   resources.session.saveHandler.options.primary.name = "name"
   resources.session.saveHandler.options.primaryAssignment.sessionId = "sessionId"
   resources.session.saveHandler.options.primaryAssignment.sessionSavePath = "sessionSavePath"
   resources.session.saveHandler.options.primaryAssignment.sessionName = "sessionName"
   resources.session.saveHandler.options.modifiedColumn = "modified"
   resources.session.saveHandler.options.dataColumn = "session_data"
   resources.session.saveHandler.options.lifetimeColumn = "lifetime"


