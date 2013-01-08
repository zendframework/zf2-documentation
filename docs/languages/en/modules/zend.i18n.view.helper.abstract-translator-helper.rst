.. _zend.i18n.view.helper.abstract-translator-helper:

Abstract Translator Helper
--------------------------

The ``AbstractTranslatorHelper`` view helper is used as a base abstract class for any helpers that need to
translate content. It provides an implementation for the ``Zend\I18n\Translator\TranslatorAwareInterface``
which allows injecting a translator and setting a text domain.

.. _zend.i18n.view.helper.abstract-translator-helper.methods:

**Public Methods**

.. _zend.i18n.view.helper.abstract-translator-helper.methods.set-translator:

.. function:: setTranslator(Translator $translator[, string $textDomain = null])
   :noindex:

   Sets ``Zend\I18n\Translator\Translator`` to use in helper. The ``$textDomain`` argument is optional.
   It is provided as a convenience for setting both the translator and textDomain at the same time.

.. _zend.i18n.view.helper.abstract-translator-helper.methods.get-translator:

.. function:: getTranslator()
   :noindex:

   Returns the ``Zend\I18n\Translator\Translator`` used in the helper.

   :rtype: ``Zend\I18n\Translator\Translator``

.. _zend.i18n.view.helper.abstract-translator-helper.methods.has-translator:

.. function:: hasTranslator()
   :noindex:

   Returns true if a ``Zend\I18n\Translator\Translator`` is set in the helper, and false if otherwise.

   :rtype: boolean

.. _zend.i18n.view.helper.abstract-translator-helper.methods.set-translator-enabled:

.. function:: setTranslatorEnabled(boolean $enabled)
   :noindex:

   Sets whether translations should be enabled or disabled.

.. _zend.i18n.view.helper.abstract-translator-helper.methods.is-translator-enabled:

.. function:: isTranslatorEnabled()
   :noindex:

   Returns true if translations are enabled, and false if disabled.

   :rtype: boolean

.. _zend.i18n.view.helper.abstract-translator-helper.methods.set-translator-text-domain:

.. function:: setTranslatorTextDomain(string $textDomain)
   :noindex:

   Set the translation text domain to use in helper when translating.

.. _zend.i18n.view.helper.abstract-translator-helper.methods.get-translator-text-domain:

.. function:: getTranslatorTextDomain()
   :noindex:

   Returns the translation text domain used in the helper.

   :rtype: string

