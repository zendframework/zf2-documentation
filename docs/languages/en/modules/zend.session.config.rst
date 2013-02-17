.. _zend.session.config:

Session Config
==============

Zend Framework comes with a standard set of config classes which are ready for you to use.  Config handles setting
various configuration such as where a cookie lives, lifetime, including several bits to configure ext/session when
using ``Zend\Session\Config\SessionConfig``.

.. include:: zend.session.config.standard-config.rst
.. include:: zend.session.config.session-config.rst

Custom Configuration
--------------------

In the event that you prefer to create your own session configuration; you *must* implement
``Zend\Session\Config\ConfigInterface`` which contains the basic interface for items needed when implementing a session.
This includes cookie configuration, lifetime, session name, save path and an interface for getting and setting options.
