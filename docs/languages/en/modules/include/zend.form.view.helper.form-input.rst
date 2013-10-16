.. _zend.form.view.helper.form-input:

FormInput
^^^^^^^^^

The ``FormInput`` view helper is used to render a ``<input>`` HTML form input tag.
It acts as a base class for all of the specifically typed form input helpers
(FormText, FormCheckbox, FormSubmit, etc.), and is not suggested for direct use.

It contains a general map of valid tag attributes and types for attribute filtering.
Each subclass of ``FormInput`` implements it's own specific map of valid tag attributes.

.. _zend.form.view.helper.form-input.methods:

The following public methods are in addition to those inherited from
:ref:`Zend\\Form\\View\\Helper\\AbstractHelper <zend.form.view.helper.abstract-helper.methods>`.

.. function:: render(ElementInterface $element)
   :noindex:

   Renders the ``<input>`` tag for the ``$element``.

   :rtype: string
