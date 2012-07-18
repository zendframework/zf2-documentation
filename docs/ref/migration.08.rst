.. _migration.08:

Zend Framework 0.8
==================

When upgrading from a previous release to Zend Framework 0.8 or higher you should note the following migration notes.

.. _migration.08.zend.controller:

Zend_Controller
---------------

Per previous changes, the most basic usage of the *MVC* components remains the same:

.. code-block:: php
   :linenos:

   Zend_Controller_Front::run('/path/to/controllers');

However, the directory structure underwent an overhaul, several components were removed, and several others either renamed or added. Changes include:

- ``Zend_Controller_Router`` was removed in favor of the rewrite router.

- ``Zend_Controller_RewriteRouter`` was renamed to ``Zend_Controller_Router_Rewrite``, and promoted to the standard router shipped with the framework; ``Zend_Controller_Front`` will use it by default if no other router is supplied.

- A new route class for use with the rewrite router was introduced, ``Zend_Controller_Router_Route_Module``; it covers the default route used by the *MVC*, and has support for :ref:`controller modules <zend.controller.modular>`.

- ``Zend_Controller_Router_StaticRoute`` was renamed to ``Zend_Controller_Router_Route_Static``.

- ``Zend_Controller_Dispatcher`` was renamed ``Zend_Controller_Dispatcher_Standard``.

- ``Zend_Controller_Action::_forward()``'s arguments have changed. The signature is now:

  .. code-block:: php
     :linenos:

     final protected function _forward($action,
                                       $controller = null,
                                       $module = null,
                                       array $params = null);

  ``$action`` is always required; if no controller is specified, an action in the current controller is assumed. ``$module`` is always ignored unless ``$controller`` is specified. Finally, any ``$params`` provided will be appended to the request object. If you do not require the controller or module, but still need to pass parameters, simply specify ``NULL`` for those values.


