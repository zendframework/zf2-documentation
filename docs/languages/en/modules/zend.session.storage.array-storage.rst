.. _zend.session.storage.array-storage:

Array Storage
-------------

``Zend\Session\Storage\ArrayStorage`` provides a facility to store all information in an ArrayObject.  This
storage method is likely incompatible with 3rd party libraries and all properties will be inaccessible through
the $_SESSION property.  Additionally ArrayStorage will not automatically repopulate the storage container in
the case of each new request and would have to manually be re-populated.

Basic Usage
^^^^^^^^^^^

A basic example is one like the following:

.. code-block:: php
   :linenos:

   use Zend\Session\Storage\ArrayStorage;
   use Zend\Session\SessionManager;

   $populateStorage = array('foo' => 'bar');
   $storage         = new ArrayStorage($populateStorage);
   $manager         = new SessionManager();
   $manager->setStorage($storage);

