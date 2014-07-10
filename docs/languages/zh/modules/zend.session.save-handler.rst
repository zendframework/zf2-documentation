.. _zend.session.save-handler:

Session Save Handlers
=====================

Zend Framework comes with a standard set of save handler classes which are ready for you to use.  Save Handlers
themselves are decoupled from PHP's save handler functions and are *only* implemented as a PHP save handler when
utilized in conjunction with ``Zend\Session\SessionManager``. 

.. include:: zend.session.save-handler.cache.rst
.. include:: zend.session.save-handler.db-table-gateway.rst
.. include:: zend.session.save-handler.mongo-db.rst

.. _zend.session.save-handler.custom-save-handler:

Custom Save Handlers
--------------------

There may be cases where you want to create a save handler where a save handler currently does not exist.  Creating
a custom save handler is much like creating a custom PHP save handler.  All save handlers *must* implement
``Zend\Session\SaveHandler\SaveHandlerInterface``.  Generally if your save handler has options you will create another
options class for configuration of the save handler.

