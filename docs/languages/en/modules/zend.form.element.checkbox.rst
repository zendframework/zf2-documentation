.. _zend.form.element.checkbox:

Checkbox Element
----------------

``Zend\Form\Element\Checkbox`` is meant to be paired with the ``Zend/Form/View/Helper/FormCheckbox`` for HTML inputs with type checkbox. This element adds an ``InArray`` validator to its input filter specification in order to validate on the server if the checkbox contains either the checked value or the unchecked value.

.. _zend.form.element.checkbox.usage:

Basic Usage
^^^^^^^^^^^

This element automatically adds a ``"type"`` attribute of value ``"checkbox"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $checkbox = new Element\Checkbox('checkbox');
   $checkbox->setLabel('A checkbox');
   $checkbox->setUseHiddenElement(true);
   $checkbox->setCheckedValue("good");
   $checkbox->setUncheckedValue("bad");

   $form = new Form('my-form');
   $form->add($checkbox);

.. _zend.form.element.checkbox.methods:

Public Methods
^^^^^^^^^^^^^^

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element <zend.form.element.methods>` .

.. function:: setOptions(array $options)
   :noindex:

   Set options for an element of type Checkbox. Accepted options, in addition to the inherited options of Zend\\Form\\Element <zend.form.element.methods.set-options>` , are: ``"use_hidden_element"``, ``"checked_value"`` and ``"unchecked_value"`` , which call ``setUseHiddenElement``, ``setCheckedValue`` and ``setUncheckedValue`` , respectively.

.. function:: setUseHiddenElement($useHiddenElement)
   :noindex:

   If set to true (which is default), the view helper will generate a hidden element that contains the unchecked value. Therefore, when using custom unchecked value, this option have to be set to true.

.. function:: useHiddenElement()
   :noindex:

   Return if a hidden element is generated.

.. function:: setCheckedValue($checkedValue)
   :noindex:

   Set the value to use when the checkbox is checked.

.. function:: getCheckedValue()
   :noindex:

   Return the value used when the checkbox is checked.

.. function:: setUncheckedValue($uncheckedValue)
   :noindex:

   Set the value to use when the checkbox is unchecked. For this to work, you must make sure that use_hidden_element is set to true.

.. function:: getUncheckedValue()
   :noindex:

   Return the value used when the checkbox is unchecked.

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes a ``Zend\Validator\InArray`` to validate if the value is either checked value or unchecked value.

   Returns array
