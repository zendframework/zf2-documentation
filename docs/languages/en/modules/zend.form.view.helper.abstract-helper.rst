.. _zend.form.view.helper.abstract-helper:

Abstract Helper
===============

The ``AbstractHelper`` is used as a base abstract class for Form view helpers, providing methods
for validating form HTML attributes, as well as controlling the doctype and character encoding.
``AbstractHelper`` also extends from ``Zend\I18n\View\Helper\AbstractTranslatorHelper`` which
provides an implementation for the ``Zend\I18n\Translator\TranslatorAwareInterface``
that allows setting a translator and text domain.

.. _zend.form.view.helper.abstract-helper.methods:

Available Methods
-----------------

The following methods are in addition to the inherited :ref:`methods of Zend\\I18n\\View\\Helper\\AbstractTranslatorHelper
<zend.i18n.view.helper.abstract-translator-helper.methods>`.

.. _zend.form.view.helper.abstract-helper.methods.set-doctype:

**setDoctype**

   ``setDoctype($doctype)``

   Sets a doctype ``string`` to use in the helper.

.. _zend.form.view.helper.abstract-helper.methods.get-doctype:

**getDoctype**

   ``getDoctype()``

   Returns the doctype ``string`` used in the helper.

.. _zend.form.view.helper.abstract-helper.methods.set-encoding:

**setEncoding**

   ``setEncoding($textDomain = 'default')``

   Set the translation text domain to use in helper when translating.

.. _zend.form.view.helper.abstract-helper.methods.get-encoding:

**getEncoding**

   ``getEncoding()``

   Returns a ``string`` of the character encodingused in the helper.

.. _zend.form.view.helper.abstract-helper.methods.get-id:

**getId**

   ``getId()``

   Returns a ``string`` of the element id.

   If no ID attribute present, attempts to use the name attribute.

   If no name attribute is present, either, returns null.

