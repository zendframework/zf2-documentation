.. _zend.i18n.view.helper.translate:

Translate Helper
================

The ``Translate`` view helper can be used to translate content. It acts as a wrapper for the ``Zend\I18n\Translator\Translator`` class.

.. _zend.i18n.view.helper.translate.setup:

.. rubric:: Translate Setup

Before using the ``Translate`` view helper, you must have first created a ``Translator`` object and have attached it to the view helper. If you use the ``Zend\I18n\Translator\TranslatorServiceFactory`` to create your ``Translator`` object, this will be done automatically for you.

If you are not using the ``TranslatorServiceFactory``, then you will need to manually attach your ``Translator`` object, such as:

.. code-block:: php
   :linenos:

   // Somewhere early in the process...
   $serviceLocator->get('ViewHelperManager')->get('translate')->setTranslator($translator);

.. _zend.i18n.view.helper.translate.usage:

.. rubric:: Basic Usage of Translate

.. code-block:: php
   :linenos:

   // Within your view

   echo $this->translate("Some translated text.");

   echo $this->translate("Translated text from a custom text domain.", "customDomain");

   echo sprintf($this->translate("The current time is %s."), $currentTime);

   echo $this->translate("Translate in a specific locale", "default", "de_DE");

``translate(string $message [, string $textDomain [, string $locale ]])``

- ``$message``: The message to be translated.

- ``$textDomain``: (Optional) The text domain where this translation lives. Defaults to the value "default".

- ``$locale``: (Optional) Locale in which the message would be translated (locale name, e.g. en_US). If unset, it will use the default locale (``Locale::getDefault()``)


