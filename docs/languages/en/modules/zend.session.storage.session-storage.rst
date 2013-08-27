.. _zend.session.storage.session-storage:

Session Storage
---------------

``Zend\Session\Storage\SessionStorage`` replaces $_SESSION providing a facility to store all information in
an ArrayObject.  This means that it may not be compatible with 3rd party libraries.  Although information
stored in the $_SESSION superglobal should be available in other scopes.

Basic Usage
^^^^^^^^^^^

A basic example is one like the following:

.. code-block:: php
   :linenos:

   use Zend\Session\Storage\SessionStorage;
   use Zend\Session\SessionManager;

   $manager = new SessionManager();
   $manager->setStorage(new SessionStorage());

