.. _migration.09:

Zend Framework 0.9
==================

When upgrading from a previous release to Zend Framework 0.9 or higher you should note the following migration
notes.

.. _migration.09.zend.controller:

Zend_Controller
---------------

0.9.3 introduces :ref:`action helpers <zend.controller.actionhelpers>`. As part of this change, the following
methods have been removed as they are now encapsulated in the :ref:`redirector action helper
<zend.controller.actionhelpers.redirector>`:

- ``setRedirectCode()``; use ``Zend_Controller_Action_Helper_Redirector::setCode()``.

- ``setRedirectPrependBase()``; use ``Zend_Controller_Action_Helper_Redirector::setPrependBase()``.

- ``setRedirectExit()``; use ``Zend_Controller_Action_Helper_Redirector::setExit()``.

Read the :ref:`action helpers documentation <zend.controller.actionhelpers>` for more information on how to
retrieve and manipulate helper objects, and the :ref:`redirector helper documentation
<zend.controller.actionhelpers.redirector>` for more information on setting redirect options (as well as alternate
methods for redirecting).


