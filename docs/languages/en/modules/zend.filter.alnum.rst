.. _zend.filter.set.alnum:

Alnum
=====

``Zend\Filter\Alnum`` is a filter which returns only alphabetic characters and digits. All other characters are
supressed.

.. _zend.filter.set.alnum.options:

Supported options for Zend\Filter\Alnum
---------------------------------------

The following options are supported for ``Zend\Filter\Alnum``:

- **allowwhitespace**: If this option is set then whitespace characters are allowed. Otherwise they are supressed.
  Per default whitespaces are not allowed.

.. _zend.filter.set.alnum.basic:

Basic usage
-----------

See the following example for the default behaviour of this filter.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Alnum();
   $return = $filter->filter('This is (my) content: 123');
   // returns 'Thisismycontent123'

The above example returns 'Thisismycontent123'. As you see all whitespaces and also the brackets are filtered.

.. note::

   ``Zend\Filter\Alnum`` works on almost all languages. But actually there are three exceptions: Chinese, Japanese
   and Korean. Within these languages the english alphabet is use instead of the characters from these languages.
   The language itself is detected by using ``Locale``.

.. _zend.filter.set.alnum.whitespace:

Allow whitespaces
-----------------

``Zend\Filter\Alnum`` can also allow whitespaces. This can be usefull when you want to strip special chars from a
text. See the following example:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Alnum(array('allowwhitespace' => true));
   $return = $filter->filter('This is (my) content: 123');
   // returns 'This is my content 123'

The above example returns 'This is my content 123'. As you see only the brackets are filtered whereas the
whitespaces are not touched.

To change ``allowWhiteSpace`` afterwards you can use ``setAllowWhiteSpace()`` and ``getAllowWhiteSpace()``.


