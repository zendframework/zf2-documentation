.. _zend.i18n.view.helper.translate:

Translate Helper
----------------

The ``Translate`` view helper can be used to translate content. It acts as a wrapper for the
``Zend\I18n\Translator\Translator`` class.

.. _zend.i18n.view.helper.translate.setup:

**Setup**

Before using the ``Translate`` view helper, you must have first created a ``Translator`` object and have attached
it to the view helper. If you use the ``Zend\View\HelperPluginManager`` to invoke the view helper,
this will be done automatically for you.

.. _zend.i18n.view.helper.translate.usage:

**Basic Usage**

.. code-block:: php
   :linenos:

   // Within your view

   echo $this->translate("Some translated text.");

   echo $this->translate("Translated text from a custom text domain.", "customDomain");

   echo sprintf($this->translate("The current time is %s."), $currentTime);

   echo $this->translate("Translate in a specific locale", "default", "de_DE");

.. function:: translate(string $message [, string $textDomain [, string $locale ]])
   :noindex:

   :param $message: The message to be translated.

   :param $textDomain: (Optional) The text domain where this translation lives. Defaults to the value "default".

   :param $locale: (Optional) Locale in which the message would be translated (locale name, e.g. en_US). If unset, it will use the default locale (``Locale::getDefault()``)

**Gettext**

The ``xgettext`` utility can be used to compile \*.po files from PHP source files containing the translate view helper.

.. code-block:: bash

   xgettext --language=php --add-location --keyword=translate my-view-file.phtml

See the `Gettext Wikipedia page <http://en.wikipedia.org/wiki/Gettext>`_ for more information.

.. _zend.i18n.view.helper.translate.methods:

**Public Methods**

Public methods for setting a ``Zend\I18n\Translator\Translator`` and a default text domain are inherited from
 :ref:`Zend\\I18n\\View\\Helper\\AbstractTranslatorHelper <zend.i18n.view.helper.abstract-translator-helper.methods>`.

