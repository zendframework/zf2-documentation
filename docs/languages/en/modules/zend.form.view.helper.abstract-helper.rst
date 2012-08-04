.. _zend.form.view.helper.abstract-helper:

AbstractHelper
^^^^^^^^^^^^^^

The ``AbstractHelper`` is used as a base abstract class for Form view helpers, providing methods
for validating form HTML attributes, as well as controlling the doctype and character encoding.
``AbstractHelper`` also extends from ``Zend\I18n\View\Helper\AbstractTranslatorHelper`` which
provides an implementation for the ``Zend\I18n\Translator\TranslatorAwareInterface``
that allows setting a translator and text domain.

.. _zend.form.view.helper.abstract-helper.methods:

The following public methods are in addition to the inherited :ref:`methods of Zend\\I18n\\View\\Helper\\AbstractTranslatorHelper
<zend.i18n.view.helper.abstract-translator-helper.methods>`.

.. function:: setDoctype(string $doctype)
   :noindex:

   Sets a doctype to use in the helper.

.. function:: getDoctype()
   :noindex:

   Returns the doctype used in the helper.

   :rtype: string

.. function:: setEncoding(string $encoding)
   :noindex:

   Set the translation text domain to use in helper when translating.

.. function:: getEncoding()
   :noindex:

   Returns the character encoding used in the helper.

   :rtype: string

.. function:: getId()
   :noindex:

   Returns the element id.
   If no ID attribute present, attempts to use the name attribute.
   If name attribute is also not present, returns null.

   :rtype: string or null

