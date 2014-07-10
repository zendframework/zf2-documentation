.. _zend.session.validator:

Session Validators
==================

Session validators provide various protection against session hijacking.  Session hijacking in particular has
various drawbacks when you are protecting against it.  Such as an IP address may change from the end user depending
on their ISP; or a browsers user agent may change during the request either by a web browser extension OR an upgrade
that retains session cookies.

.. include:: zend.session.validator.http-user-agent.rst
.. include:: zend.session.validator.remote-addr.rst

Custom Validators
-----------------

You may want to provide your own custom validators to validate against other items from storing a token and validating
a token to other various techniques.  To create a custom validator you *must* implement the validation interface
``Zend\Session\Validator\ValidatorInterface``.
