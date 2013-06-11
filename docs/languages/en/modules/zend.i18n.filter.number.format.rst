.. _zend.i18n.filter.number-format:

NumberFormat
------------

The ``NumberFormat`` filter can be used to return locale-specific number and percentage strings. It extends the
``NumberParse`` filter, which acts as wrapper for the ``NumberFormatter`` class within the Internationalization
extension (Intl).

.. _zend.i18n.filter.number-format.options:

.. rubric:: Supported Options for NumberFormat Filter

The following options are supported for ``NumberFormat``:

``NumberFormat([ string $locale [, int $style [, int $type ]]])``

- ``$locale``: (Optional) Locale in which the number would be formatted (locale name, e.g. en_US). If unset, it
  will use the default locale (``Locale::getDefault()``)

  Methods for getting/setting the locale are also available: ``getLocale()`` and ``setLocale()``

- ``$style``: (Optional) Style of the formatting, one of the `format style constants`_. If unset, it will use
  ``NumberFormatter::DEFAULT_STYLE`` as the default style.

  Methods for getting/setting the format style are also available: ``getStyle()`` and ``setStyle()``

- ``$type``: (Optional) The `formatting type`_ to use. If unset, it will use ``NumberFormatter::TYPE_DOUBLE`` as
  the default type.

  Methods for getting/setting the format type are also available: ``getType()`` and ``setType()``

.. _zend.i18n.filter.number-format.usage:

.. rubric:: NumberFormat Filter Usage

.. code-block:: php
   :linenos:

   $filter = new \Zend\I18n\Filter\NumberFormat("de_DE");
   echo $filter->filter(1234567.8912346);
   // Returns "1.234.567,891"

   $filter = new \Zend\I18n\Filter\NumberFormat("en_US", NumberFormatter::PERCENT);
   echo $filter->filter(0.80);
   // Returns "80%"

   $filter = new \Zend\I18n\Filter\NumberFormat("fr_FR", NumberFormatter::SCIENTIFIC);
   echo $filter->filter(0.00123456789);
   // Returns "1,23456789E-3"



.. _`format style constants`: http://us.php.net/manual/en/class.numberformatter.php#intl.numberformatter-constants.unumberformatstyle
.. _`formatting type`: http://us.php.net/manual/en/class.numberformatter.php#intl.numberformatter-constants.types
