.. _zend.filter.set.alpha:

Alpha
=====

``Zend\Filter\Alpha`` is a filter which returns the string ``$value``, removing all but alphabetic characters. This
filter includes an option to also allow white space characters.

.. _zend.filter.set.alpha.options:

Supported options for Zend\Filter\Alpha
---------------------------------------

The following options are supported for ``Zend\Filter\Alpha``:

- **allowwhitespace**: If this option is set then whitespace characters are allowed. Otherwise they are suppressed.
  By default whitespace characters are not allowed.

.. _zend.filter.set.alpha.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Alpha();

   print $filter->filter('This is (my) content: 123');

The above example returns 'Thisismycontent'. Notice that the whitespace characters and brackets are removed.

.. note::

   ``Zend\Filter\Alpha`` works on most languages; however, there are three exceptions: Chinese, Japanese and
   Korean. With these languages the english alphabet is used. The language is detected through the use of
   ``Locale``.

.. _zend.filter.set.alpha.whitespace:

Allow whitespace characters
---------------------------

``Zend\Filter\Alpha`` can also allow whitespace characters. This can be useful when you want to strip special
characters from a string. See the following example:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Alpha(array('allowwhitespace' => true));

   print $filter->filter('This is (my) content: 123');

The above example returns 'This is my content '. Notice that the parenthesis, colon, and numbers have all been
removed while the whitespace characters remain.

To change ``allowWhiteSpace`` after instantiation the method ``setAllowWhiteSpace()`` may be used.

To query the current value of ``allowWhiteSpace`` the method ``getAllowWhiteSpace()`` may be used.


