.. _learning.plugins.conclusion:

Conclusion
==========

Understanding the concept of prefix paths and overriding existing plugins will help you with your understanding of
many components within the framework. Plugins are used in a variety of places:

- ``Zend_Application``: resources.

- ``Zend\Controller\Action``: action helpers.

- ``Zend\Feed\Reader``: plugins.

- ``Zend_Form``: elements, filters, validators, and decorators.

- ``Zend_View``: view helpers.

And several more places, besides. Learn the concepts early so you can leverage this important extension point in
Zend Framework.

.. note::

   **Caveat**

   We'll note here that ``Zend\Controller\Front`` has a plugin system - but it does not adhere to any of the
   guidelines offered in this tutorial. The plugins registered with the front controller must be instantiated
   directly and registered individually with it. The reason for this is that this system predates any other plugin
   system in the framework, and changes to it must be carefully weighed to ensure existing plugins written by
   developers continue to work with it.


