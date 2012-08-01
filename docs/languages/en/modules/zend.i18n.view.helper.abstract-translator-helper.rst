.. _zend.i18n.view.helper.abstract-translator-helper:

Abstract Translator Helper
==========================

The ``AbstractTranslatorHelper`` view helper is used as a base abstract class for any helpers that need to
translate content. It provides an implementation for the ``Zend\I18n\Translator\TranslatorAwareInterface``
which allows injecting a translator and setting a text domain.

.. _zend.i18n.view.helper.abstract-translator-helper.methods:

Available Methods
-----------------

.. _zend.i18n.view.helper.abstract-translator-helper.methods.set-translator:

**setTranslator**

   ``setTranslator(Translator $translator = null, $textDomain = null)``

   Sets ``Zend\I18n\Translator\Translator`` to use in helper. The ``$textDomain`` argument is optional.
   It is provided as a convenience for setting both the translator and textDomain at the same time.

.. _zend.i18n.view.helper.abstract-translator-helper.methods.get-translator:

**getTranslator**

   ``getTranslator()``

   Returns the ``Zend\I18n\Translator\Translator`` used in the helper.

.. _zend.i18n.view.helper.abstract-translator-helper.methods.has-translator:

**hasTranslator**

   ``hasTranslator()``

   Returns a ``boolean`` true if a ``Zend\I18n\Translator\Translator`` is set in the helper, and false if otherwise.

.. _zend.i18n.view.helper.abstract-translator-helper.methods.set-translator-enabled:

**setTranslatorEnabled**

   ``setTranslatorEnabled($enabled = true)``

   Sets whether translations should be enabled or disabled.

.. _zend.i18n.view.helper.abstract-translator-helper.methods.is-translator-enabled:

**isTranslatorEnabled**

   ``isTranslatorEnabled()``

   Returns a ``boolean`` true if translations are enabled, and false if disabled.

.. _zend.i18n.view.helper.abstract-translator-helper.methods.set-translator-text-domain:

**setTranslatorTextDomain**

   ``setTranslatorTextDomain($textDomain = 'default')``

   Set the translation text domain to use in helper when translating.

.. _zend.i18n.view.helper.abstract-translator-helper.methods.get-translator-text-domain:

**getTranslatorTextDomain**

   ``getTranslatorTextDomain()``

   Returns a ``string`` of the translation text domain used in the helper.

