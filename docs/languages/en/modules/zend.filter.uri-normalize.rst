.. _zend.filter.set.uri-normalize:

UriNormalize
------------

This filter can set a scheme on an URI, if a scheme is not present. If a scheme is present, that
scheme will not be affected, even if a different scheme is enforced.

.. _zend.filter.set.uri-normalize.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\UriNormalize``:

- **defaultScheme**: This option can be used to set the default scheme to use when parsing scheme-less URIs.

- **enforcedScheme**: Set a URI scheme to enforce on schemeless URIs.

.. _zend.filter.set.uri-normalize.basic:

.. rubric:: Basic Usage

See the following example for the default behaviour of this filter:

.. code-block:: php
    :linenos:

    $filter = new Zend\Filter\UriNormalize(array(
        'enforcedScheme' => 'https'
    ));

    echo $filter->filter('www.example.com');

As the result the string ``https://www.example.com`` will be output.
