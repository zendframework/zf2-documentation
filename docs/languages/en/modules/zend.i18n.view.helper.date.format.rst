.. _zend.i18n.view.helper.date-format:

DateFormat Helper
-----------------

The ``DateFormat`` view helper can be used to simplify rendering of localized date/time values. It acts as a
wrapper for the ``IntlDateFormatter`` class within the Internationalization extension (Intl).

.. _zend.i18n.view.helper.date-format.usage:

**Basic Usage**

.. code-block:: php
   :linenos:

   // Within your view

   // Date and Time
   echo $this->dateFormat(
       new DateTime(),
       IntlDateFormatter::MEDIUM, // date
       IntlDateFormatter::MEDIUM, // time
       "en_US"
   );
   // This returns: "Jul 2, 2012 6:44:03 PM"

   // Date Only
   echo $this->dateFormat(
       new DateTime(),
       IntlDateFormatter::LONG, // date
       IntlDateFormatter::NONE, // time
       "en_US"
   );
   // This returns: "July 2, 2012"

   // Time Only
   echo $this->dateFormat(
       new DateTime(),
       IntlDateFormatter::NONE,  // date
       IntlDateFormatter::SHORT, // time
       "en_US"
   );
   // This returns: "6:44 PM"

.. function:: dateFormat(mixed $date [, int $dateType [, int $timeType [, string $locale ]]])
   :noindex:

   :param $date: The value to format. This may be a ``DateTime`` object, an integer representing a Unix timestamp value or an array in the format output by ``localtime()``.

   :param $dateType: (Optional) Date type to use (none, short, medium, long, full). This is one of the `IntlDateFormatter constants`_. Defaults to ``IntlDateFormatter::NONE``.

   :param $timeType: (Optional) Time type to use (none, short, medium, long, full). This is one of the `IntlDateFormatter constants`_. Defaults to ``IntlDateFormatter::NONE``.

   :param $locale: (Optional) Locale in which the date would be formatted (locale name, e.g. en_US). If unset, it will use the default locale (``Locale::getDefault()``)

.. _zend.i18n.view.helper.date-format.setter-usage:

**Public Methods**

The ``$locale`` option can be set prior to formatting with the ``setLocale()`` method and will be applied each time
the helper is used.

By default, the system's default timezone will be used when formatting. This overrides any timezone that may be set
inside a DateTime object. To change the timezone when formatting, use the ``setTimezone`` method.

.. code-block:: php
   :linenos:

   // Within your view
   $this->plugin("dateFormat")->setTimezone("America/New_York")->setLocale("en_US");

   echo $this->dateFormat(new DateTime(), IntlDateFormatter::MEDIUM);  // "Jul 2, 2012"
   echo $this->dateFormat(new DateTime(), IntlDateFormatter::SHORT);   // "7/2/12"



.. _`IntlDateFormatter constants`: http://us.php.net/manual/en/class.intldateformatter.php#intl.intldateformatter-constants
