
Action View Helper
==================

The ``Action`` view helper enables view scripts to dispatch a given controller action; the result of the response object following the dispatch is then returned. These can be used when a particular action could generate re-usable content or "widget-ized" content.

Actions that result in a ``_forward()`` or redirect are considered invalid, and will return an empty string.

The *API* for the ``Action`` view helper follows that of most *MVC* components that invoke controller actions: ``action($action, $controller, $module = null, array $params = array())`` . ``$action`` and ``$controller`` are required; if no module is specified, the default module is assumed.


