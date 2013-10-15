.. _zend.session.storage.session-array-storage:

Session Array Storage
---------------------

``Zend\Session\Storage\SessionArrayStorage`` provides a facility to store all information directly in the
$_SESSION superglobal.  This storage class provides the most compatibility with 3rd party libraries and
allows for directly storing information into $_SESSION.

Basic Usage
^^^^^^^^^^^

A basic example is one like the following:

.. code-block:: php
   :linenos:

   use Zend\Session\Storage\SessionArrayStorage;
   use Zend\Session\SessionManager;

   $manager = new SessionManager();
   $manager->setStorage(new SessionArrayStorage());

