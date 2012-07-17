
.. _zend.i18n.view.helper.currency-format:

CurrencyFormat Helper
=====================

The ``CurrencyFormat`` view helper can be used to simplify rendering of localized currency values. It acts as a wrapper for the ``NumberFormatter`` class within the Internationalization extension (Intl).


.. _zend.i18n.view.helper.currency-format.usage:

.. rubric:: Basic Usage of CurrencyFormat

.. code-block:: php
   :linenos:

   // Within your view

   echo $this->currencyFormat(1234.56, "USD", "en_US");
   // This returns: "$1,234.56"

   echo $this->currencyFormat(1234.56, "EUR", "de_DE");
   // This returns: "1.234,56 €"

``currencyFormat(float $number , string $currencyCode [, string $locale ])``

- ``$number``: The numeric currency value.

- ``$currencyCode``: The 3-letter ISO 4217 currency code indicating the currency to use.

- ``$locale``: (Optional) Locale in which the currency would be formatted (locale name, e.g. en_US). If unset, it will use the default locale (``Locale::getDefault()``)


.. _zend.i18n.view.helper.currency-format.setter-usage:

.. rubric:: CurrencyFormat Setters

The ``$currencyCode`` and ``$locale`` options can be set prior to formatting and will be applied each time the helper is used:

.. code-block:: php
   :linenos:

   // Within your view
   $this->plugin("currencyformat")->setCurrencyCode("USD")->setLocale("en_US");

   echo $this->currencyFormat(1234.56);  // "$1,234.56"
   echo $this->currencyFormat(5678.90);  // "$5,678.90"


