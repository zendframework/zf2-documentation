.. _zend.i18n.view.helper.translate-plural:

TranslatePlural Helper
----------------------

The ``TranslatePlural`` view helper can be used to translate words which take into account numeric meanings.
English, for example, has a singular definition of "car", for one car. And has the plural definition, "cars",
meaning zero "cars" or more than one car. Other languages like Russian or Polish have more plurals with different
rules.

The viewhelper acts as a wrapper for the ``Zend\I18n\Translator\Translator`` class.

.. _zend.i18n.view.helper.translate-plural.setup:

**Setup**

Before using the ``TranslatePlural`` view helper, you must have first created a ``Translator`` object and
have attached it to the view helper. If you use the ``Zend\View\HelperPluginManager`` to invoke the view helper,
this will be done automatically for you.

.. _zend.i18n.view.helper.translate-plural.usage:

**Basic Usage**

.. code-block:: php
   :linenos:

   // Within your view
   echo $this->translatePlural("car", "cars", $num);

   // Use a custom domain
   echo $this->translatePlural("monitor", "monitors", $num, "customDomain");

   // Change locale
   echo $this->translatePlural("locale", "locales", $num, "default", "de_DE");

.. function:: translatePlural(string $singular, string $plural, int $number [, string $textDomain [, string $locale ]])
   :noindex:

   :param $singular: The singular message to be translated.

   :param $plural: The plural message to be translated.

   :param $number: The number to evaluate and determine which message to use.

   :param $textDomain: (Optional) The text domain where this translation lives. Defaults to the value "default".

   :param $locale: (Optional) Locale in which the message would be translated (locale name, e.g. en_US). If unset, it will use the default locale (``Locale::getDefault()``)

.. _zend.i18n.view.helper.translate-plural.methods:

**Public Methods**

Public methods for setting a ``Zend\I18n\Translator\Translator`` and a default text domain are inherited from
 :ref:`Zend\\I18n\\View\\Helper\\AbstractTranslatorHelper <zend.i18n.view.helper.abstract-translator-helper.methods>`.


