.. _zend.i18n.view.helper.translate-plural:

TranslatePlural Helper
======================

The ``TranslatePlural`` view helper can be used to translate words which take into account numeric meanings. English, for example, has a singular definition of "car", for one car. And has the plural definition, "cars", meaning zero "cars" or more than one car. Other languages like Russian or Polish have more plurals with different rules.

The viewhelper acts as a wrapper for the ``Zend\I18n\Translator\Translator`` class.

.. _zend.i18n.view.helper.translate-plural.setup:

.. rubric:: TranslatePlural Setup

Before using the ``TranslatePlural`` view helper, you must have first created a ``Translator`` object and have attached it to the view helper. If you use the ``Zend\I18n\Translator\TranslatorServiceFactory`` to create your ``Translator`` object, this will be done automatically for you.

If you are not using the ``TranslatorServiceFactory``, then you will need to manually attach your ``Translator`` object, such as:

.. code-block:: php
   :linenos:

   // Somewhere early in the process...
   $serviceLocator->get('ViewHelperManager')->get('translateplural')->setTranslator($translator);

.. _zend.i18n.view.helper.translate-plural.usage:

.. rubric:: Basic Usage of TranslatePlural

.. code-block:: php
   :linenos:

   // Within your view
   echo $this->translatePlural("car", "cars", $num);

   // Use a custom domain
   echo $this->translatePlural("monitor", "monitors", $num, "customDomain");

   // Change locale
   echo $this->translate("locale", "locales", $num, "default", "de_DE");

``translatePlural(string $singular, string $plural, int $number [, string $textDomain [, string $locale ]])``

- ``$singular``: The singular message to be translated.

- ``$plural``: The plural message to be translated.

- ``$number``: The number to evaluate and determine which message to use.

- ``$textDomain``: (Optional) The text domain where this translation lives. Defaults to the value "default".

- ``$locale``: (Optional) Locale in which the message would be translated (locale name, e.g. en_US). If unset, it will use the default locale (``Locale::getDefault()``)


