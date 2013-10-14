.. _zend.i18n.filter.number-parse:

NumberParse
------------

The ``NumberParse`` filter can be used to parse a number from a string. It acts as a
wrapper for the ``NumberFormatter`` class within the Internationalization extension (Intl).

.. _zend.i18n.filter.number-parse.options:

.. rubric:: Supported Options for NumberParse Filter

The following options are supported for ``NumberParse``:

``NumberParse([ string $locale [, int $style [, int $type ]]])``

- ``$locale``: (Optional) Locale in which the number would be parsed (locale name, e.g. en_US). If unset, it
  will use the default locale (``Locale::getDefault()``)

  Methods for getting/setting the locale are also available: ``getLocale()`` and ``setLocale()``

- ``$style``: (Optional) Style of the parsing, one of the `format style constants`_. If unset, it will use
  ``NumberFormatter::DEFAULT_STYLE`` as the default style.

  Methods for getting/setting the parse style are also available: ``getStyle()`` and ``setStyle()``

- ``$type``: (Optional) The `parsing type`_ to use. If unset, it will use ``NumberFormatter::TYPE_DOUBLE`` as
  the default type.

  Methods for getting/setting the parse type are also available: ``getType()`` and ``setType()``

.. _zend.i18n.filter.number-parse.usage:

.. rubric:: NumberParse Filter Usage

.. code-block:: php
   :linenos:

   $filter = new \Zend\I18n\Filter\NumberParse("de_DE");
   echo $filter->filter("1.234.567,891");
   // Returns 1234567.8912346

   $filter = new \Zend\I18n\Filter\NumberParse("en_US", NumberFormatter::PERCENT);
   echo $filter->filter("80%");
   // Returns 0.80

   $filter = new \Zend\I18n\Filter\NumberParse("fr_FR", NumberFormatter::SCIENTIFIC);
   echo $filter->filter("1,23456789E-3");
   // Returns 0.00123456789


.. _`format style constants`: http://us.php.net/manual/en/class.numberformatter.php#intl.numberformatter-constants.unumberformatstyle
.. _`parsing type`: http://us.php.net/manual/en/class.numberformatter.php#intl.numberformatter-constants.types
