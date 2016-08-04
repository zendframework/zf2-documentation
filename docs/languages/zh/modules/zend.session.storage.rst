.. _zend.session.storage:

Session Storage
===============

Zend Framework comes with a standard set of storage classes which are ready for you to use.  Storage handlers is
the intermediary between when the session starts and when the session writes and closes.  The default session storage
is ``Zend\Session\Storage\SessionArrayStorage``.

.. include:: zend.session.storage.array-storage.rst
.. include:: zend.session.storage.session-storage.rst
.. include:: zend.session.storage.session-array-storage.rst

.. _zend.session.storage.custom-storage:

Custom Storage
--------------

In the event that you prefer a different type of storage; to create a new custom storage container, you *must* implement
``Zend\Session\Storage\StorageInterface`` which is mostly in implementing ArrayAccess, Traversable, Serializable and
Countable.  StorageInterface defines some additional functionality that must be implemented.
