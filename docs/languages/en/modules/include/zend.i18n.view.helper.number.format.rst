.. _zend.i18n.view.helper.number-format:

NumberFormat Helper
-------------------

The ``NumberFormat`` view helper can be used to simplify rendering of locale-specific number and percentage
strings. It acts as a wrapper for the ``NumberFormatter`` class within the Internationalization extension (Intl).

.. _zend.i18n.view.helper.number-format.usage:

**Basic Usage**

.. code-block:: php
   :linenos:

   // Within your view

   // Example of Decimal formatting:
   echo $this->numberFormat(
       1234567.891234567890000,
       NumberFormatter::DECIMAL,
       NumberFormatter::TYPE_DEFAULT,
       "de_DE"
   );
   // This returns: "1.234.567,891"

   // Example of Percent formatting:
   echo $this->numberFormat(
       0.80,
       NumberFormatter::PERCENT,
       NumberFormatter::TYPE_DEFAULT,
       "en_US"
   );
   // This returns: "80%"

   // Example of Scientific notation formatting:
   echo $this->numberFormat(
       0.00123456789,
       NumberFormatter::SCIENTIFIC,
       NumberFormatter::TYPE_DEFAULT,
       "fr_FR"
   );
   // This returns: "1,23456789E-3"

.. function:: numberFormat(number $number [, int $formatStyle [, int $formatType [, string $locale ]]])
   :noindex:

   :param $number: The numeric value.

   :param $formatStyle: (Optional) Style of the formatting, one of the `format style constants`_. If unset, it will use ``NumberFormatter::DECIMAL`` as the default style.

   :param $formatType: (Optional) The `formatting type`_ to use. If unset, it will use ``NumberFormatter::TYPE_DEFAULT`` as the default type.

   :param $locale: (Optional) Locale in which the number would be formatted (locale name, e.g. en_US). If unset, it will use the default locale (``Locale::getDefault()``)

.. _zend.i18n.view.helper.number-format.setter-usage:

**Public Methods**

The ``$formatStyle``, ``$formatType``, and ``$locale`` options can be set prior to formatting and will be applied
each time the helper is used.

.. code-block:: php
   :linenos:

   // Within your view
   $this->plugin("numberformat")
               ->setFormatStyle(NumberFormatter::PERCENT)
               ->setFormatType(NumberFormatter::TYPE_DOUBLE)
               ->setLocale("en_US");

   echo $this->numberFormat(0.56);  // "56%"
   echo $this->numberFormat(0.90);  // "90%"



.. _`format style constants`: http://us.php.net/manual/en/class.numberformatter.php#intl.numberformatter-constants.unumberformatstyle
.. _`formatting type`: http://us.php.net/manual/en/class.numberformatter.php#intl.numberformatter-constants.types
