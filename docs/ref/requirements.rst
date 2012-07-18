.. _requirements:

***************************
Zend Framework Requirements
***************************

.. _requirements.introduction:

Introduction
------------

Zend Framework requires a *PHP* 5 interpreter with a web server configured to handle *PHP* scripts correctly. Some
features require additional extensions or web server features; in most cases the framework can be used without
them, although performance may suffer or ancillary features may not be fully functional. An example of such a
dependency is mod_rewrite in an Apache environment, which can be used to implement "pretty *URL*'s" like
"``http://www.example.com/user/edit``". If mod_rewrite is not enabled, Zend Framework can be configured to support
*URL*'s such as "``http://www.example.com?controller=user&action=edit``". Pretty *URL*'s may be used to shorten
*URL*'s for textual representation or search engine optimization (*SEO*), but they do not directly affect the
functionality of the application.

.. _requirements.version:

PHP Version
^^^^^^^^^^^

Zend recommends the most current release of *PHP* for critical security and performance enhancements, and currently
supports *PHP* 5.2.4 or later.

Zend Framework has an extensive collection of unit tests, which you can run using PHPUnit 3.3.0 or later.

.. _requirements.extensions:

PHP Extensions
^^^^^^^^^^^^^^

You will find a table listing all extensions typically found in *PHP* and how they are used in Zend Framework
below. You should verify that the extensions on which Zend Framework components you'll be using in your application
are available in your *PHP* environments. Many applications will not require every extension listed below.

A dependency of type "hard" indicates that the components or classes cannot function properly if the respective
extension is not available, while a dependency of type "soft" indicates that the component may use the extension if
it is available but will function properly if it is not. Many components will automatically use certain extensions
if they are available to optimize performance but will execute code with similar functionality in the component
itself if the extensions are unavailable.

.. include:: requirements.php.extensions.table.rst
.. _requirements.zendcomponents:

Zend Framework Components
^^^^^^^^^^^^^^^^^^^^^^^^^

Below is a table that lists all available Zend Framework Components and which *PHP* extension they need. This can
help guide you to know which extensions are required for your application. Not all extensions used by Zend
Framework are required for every application.

A dependency of type "hard" indicates that the components or classes cannot function properly if the respective
extension is not available, while a dependency of type "soft" indicates that the component may use the extension if
it is available but will function properly if it is not. Many components will automatically use certain extensions
if they are available to optimize performance but will execute code with similar functionality in the component
itself if the extensions are unavailable.

.. include:: requirements.zendcomponents.table.rst
.. _requirements.dependencies:

Zend Framework Dependencies
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Below you can find a table listing Zend Framework Components and their dependencies to other Zend Framework
Components. This can help you if you need to have only single components instead of the complete Zend Framework.

A dependency of type "hard" indicates that the components or classes cannot function properly if the respective
dependent component is not available, while a dependency of type "soft" indicates that the component may need the
dependent component in special situations or with special adapters. At last a dependency of type "fix" indicated
that these components or classes are in any case used by subcomponents, and a dependency of type "sub" indicates
that these components can be used by subcomponents in special situations or with special adapters.

.. note::

   Even if it's possible to separate single components for usage from the complete Zend Framework you should keep
   in mind that this can lead to problems when files are missed or components are used dynamically.

.. include:: requirements.dependencies.table.rst

