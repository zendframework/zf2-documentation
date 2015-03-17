:orphan:

.. _zend.filter.set.blacklist:

Blacklist
---------

This filter will return ``null`` if the value being filtered is present in the filter's list of values. If the
value is not present, it will return that value.

For the opposite functionality see the ``Whitelist`` filter.

.. _zend.filter.set.blacklist.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following options are supported for ``Zend\Filter\Blacklist``:

- **strict**: Uses strict mode when comparing: passed through to ``in_array``'s third argument.
- **list**: An array of forbidden values.

.. _zend.filter.set.blacklist.basic:

Basic Usage
^^^^^^^^^^^

This is a basic example:

.. code-block:: php
   :linenos:

   $blacklist = new \Zend\Filter\Blacklist(array(
       'list' => array('forbidden-1', 'forbidden-2')
   ));
   echo $blacklist->filter('forbidden-1'); // => null
   echo $blacklist->filter('allowed');     // => 'allowed'