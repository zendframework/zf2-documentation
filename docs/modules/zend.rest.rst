
Introduction
============

REST Web Services use service-specific *XML* formats. These ad-hoc standards mean that the manner for accessing a REST web service is different for each service. REST web services typically use *URL* parameters ( ``GET`` data) or path information for requesting data and POST data for sending data.

Zend Framework provides both Client and Server capabilities, which, when used together allow for a much more "local" interface experience via virtual object property access. The Server component features automatic exposition of functions and classes using a meaningful and simple *XML* format. When accessing these services using the Client, it is possible to easily retrieve the return data from the remote call. Should you wish to use the client with a non-Zend_Rest_Server based service, it will still provide easier data access.

In addition to ``Zend_Rest_Server`` and ``Zend_Rest_Client`` components, :ref:`Zend_Rest_Route and Zend_Rest_Controller <zend.controller.router.routes.rest>` classes are provided to aid routing REST requests to controllers.


