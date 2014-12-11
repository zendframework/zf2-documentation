:orphan:

.. _zend.i18n.view.helper.currency-format:

CurrencyFormat Helper
---------------------

The ``CurrencyFormat`` view helper can be used to simplify rendering of localized currency values. It acts as a
wrapper for the ``NumberFormatter`` class within the Internationalization extension (Intl).

.. _zend.i18n.view.helper.currency-format.basic-usage:

Basic Usage
^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Within your view

   echo $this->currencyFormat(1234.56, 'USD', null, 'en_US');
   // This returns: "$1,234.56"

   echo $this->currencyFormat(1234.56, 'EUR', null, 'de_DE');
   // This returns: "1.234,56 €"

   echo $this->currencyFormat(1234.56, 'USD', true, 'en_US');
   // This returns: "$1,234.56"

   echo $this->currencyFormat(1234.56, 'USD', false, 'en_US');
   // This returns: "$1,235"

   echo $this->currencyFormat(12345678.90, 'EUR', true, 'de_DE', '#0.# kg');
   // This returns: "12345678,90 kg"

   echo $this->currencyFormat(12345678.90, 'EUR', false, 'de_DE', '#0.# kg');
   // This returns: "12345679 kg"

.. function:: currencyFormat(float $number [, string $currencyCode = null [, bool $showDecimals = null [, string $locale = null [, string $pattern = null ]]]])
   :noindex:

   Format a number

   :param $number: The numeric currency value.

   :param $currencyCode: (Optional) The 3-letter ISO 4217 currency code indicating the currency to use. If unset, it will use the default value ``null`` (``getCurrencyCode()``).

   :param $showDecimals: (Optional) Boolean false as third argument shows no decimals. If unset, it will use the default value ``true`` (``shouldShowDecimals()``).

   :param $locale: (Optional) Locale in which the currency would be formatted (locale name, e.g. en_US). If unset, it will use the default locale (``Locale::getDefault()``).

   :param $pattern: (Optional) Pattern string that is used by the formatter. If unset, it will use the default value ``null`` (``getCurrencyPattern()``).

   :rtype: string

.. _zend.i18n.view.helper.currency-format.available-methods:

Available Methods
^^^^^^^^^^^^^^^^^

.. _zend.i18n.view.helper.currency-format.available-methods.currency-and-locale:

.. rubric:: Set the currency code and the locale

The ``$currencyCode`` and ``$locale`` options can be set prior to formatting and will be applied each time the
helper is used:

.. code-block:: php
   :linenos:

   // Within your view

   $this->plugin('currencyformat')->setCurrencyCode('USD')->setLocale('en_US');

   echo $this->currencyFormat(1234.56);
   // This returns: "$1,234.56"

   echo $this->currencyFormat(5678.90);
   // This returns: "$5,678.90"

.. function:: setCurrencyCode(string $currencyCode)
   :noindex:

   The 3-letter ISO 4217 currency code indicating the currency to use

   :param $currencyCode: The 3-letter ISO 4217 currency code.

   :rtype: Zend\\I18n\\View\\Helper\\CurrencyFormat

.. function:: setLocale(string $locale)
   :noindex:

   Set locale to use instead of the default

   :param $locale: Locale in which the number would be formatted.

   :rtype: Zend\\I18n\\View\\Helper\\CurrencyFormat

.. _zend.i18n.view.helper.currency-format.available-methods.show-decimals:

.. rubric:: Show decimals

.. code-block:: php
   :linenos:

   // Within your view

   $this->plugin('currencyformat')->setShouldShowDecimals(false);

   echo $this->currencyFormat(1234.56, 'USD', null, 'en_US');
   // This returns: "$1,235"

.. function:: setShouldShowDecimals(bool $showDecimals)
   :noindex:

   Set if the view helper should show two decimals

   :param $showDecimals: Whether or not to show the decimals.

   :rtype: Zend\\I18n\\View\\Helper\\CurrencyFormat

.. _zend.i18n.view.helper.currency-format.available-methods.currency-pattern:

.. rubric:: Set currency pattern

.. code-block:: php
   :linenos:

   // Within your view

   $this->plugin('currencyformat')->setCurrencyPattern('#0.# kg');

   echo $this->currencyFormat(12345678.90, 'EUR', null, 'de_DE');
   // This returns: "12345678,90 kg"

.. function:: setCurrencyPattern(string $currencyPattern)
   :noindex:

   Set the currency pattern used by the formatter. (See the `NumberFormatter::setPattern`_ *PHP* method for more information.)

   :param $currencyPattern: Pattern in syntax described in `ICU DecimalFormat documentation`_

   :rtype: Zend\\I18n\\View\\Helper\\CurrencyFormat

.. _`NumberFormatter::setPattern`: http://php.net/manual/numberformatter.setpattern.php
.. _`ICU DecimalFormat documentation`: http://www.icu-project.org/apiref/icu4c/classDecimalFormat.html#details