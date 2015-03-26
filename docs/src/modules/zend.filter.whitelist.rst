.. _zend.filter.set.whitelist:

Whitelist
---------

This filter will return ``null`` if the value being filtered is not present the filter's allowed list of values. If the
value is present, it will return that value.

For the opposite functionality see the ``Blacklist`` filter.

.. _zend.filter.set.whitelist.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following options are supported for ``Zend\Filter\Whitelist``:

- **strict**: Uses strict mode when comparing: passed through to ``in_array``'s third argument.
- **list**: An array of allowed values.

.. _zend.filter.set.whitelist.basic:

Basic Usage
^^^^^^^^^^^

This is a basic example:

.. code-block:: php
   :linenos:

   $whitelist = new \Zend\Filter\Whitelist(array(
       'list' => array('allowed-1', 'allowed-2')
   ));
   echo $whitelist->filter('allowed-2');   // => 'allowed-2'
   echo $whitelist->filter('not-allowed'); // => null
