
Zend\\ServiceManager
====================

The ``ServiceManager`` is a Service Locator implementation. A Service Locator is a well-known object in which you may register objects and later retrieve them. The implementation within Zend Framework provides the following features:

In addition to the above, the ``ServiceManager`` also provides optional ties to ``Zend\Di`` , allowing ``Di`` to act as an initializer or an abstract factory for the manager.

Your typical interaction with a ``ServiceManager`` , however, will be via two methods:


