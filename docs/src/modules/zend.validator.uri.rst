.. _zend.validator.uri:

Uri Validator
==================

``Zend\Validator\Uri`` allows you to validate a uri using the ``Zend\Uri\Uri`` handler to parse to uri.
The validator allows for both validation of absolute and/or relative uris. There is the possibility to
exchange the handler for another one in case the parsing of the uri should be done differently.

.. _zend.validator.uri.options:

Supported options for Zend\\Validator\\Uri
-----------------------------------------------

The following options are supported for ``Zend\Validator\Uri``:

- **uriHandler**: Defines the handler to be used to parse the uri. This options defaults to a new instance of ``Zend\Uri\Uri``.

- **allowRelative**: Defines if relative paths are allowed. This option defaults to ``TRUE``.

- **allowAbsolute**: Defines if absolute paths are allowed. This option defaults to ``TRUE``.
