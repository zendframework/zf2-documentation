
Zend\\Form\\Element\\Checkbox
==========================

The ``Checkbox`` element is meant to be paired with the ``Zend/Form/View/Helper/FormCheckbox`` for `HTML inputs with type checkbox`_ . This element adds an ``InArray`` validator to its input filter specification in order to validate on the server if the checkbox contains either the checked value or the unchecked value.

.. _zend.form.element.checkbox.methods:

Available Methods
-----------------

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element <zend.form.element.methods>` .

.. _zend.form.element.checkbox.methods.set-options:

**setOptions**

    ``setOptions(array $options)``

Set options for an element of type Checkbox. Accepted options, in addition to the inherited options of Zend\\Form\\Element <zend.form.element.methods.set-options>` , are: ``"use_hidden_element"``, ``"checked_value"`` and ``"unchecked_value"`` , which call ``setUseHiddenElement``, ``setCheckedValue`` and ``setUncheckedValue`` , respectively.

.. _zend.form.element.checkbox.methods.set-use-hidden-element:

**setUseHiddenElement**

    ``setUseHiddenElement($useHiddenElement)``

If set to true (which is default), the view helper will generate a hidden element that contains the unchecked value. Therefore, when using custom unchecked value, this option have to be set to true.

.. _zend.form.element.checkbox.methods.use-hidden-element:

**useHiddenElement**

    ``useHiddenElement()``

Return if a hidden element is generated.

.. _zend.form.element.checkbox.methods.set-checked-value:

**setCheckedValue**

    ``setCheckedValue($checkedValue)``

Set the value to use when the checkbox is checked.

.. _zend.form.element.checkbox.methods.get-checked-value:

**getCheckedValue**

    ``getCheckedValue()``

Return the value used when the checkbox is checked.

.. _zend.form.element.checkbox.methods.set-unchecked-value:

**setUncheckedValue**

    ``setUncheckedValue($uncheckedValue)``

Set the value to use when the checkbox is unchecked. For this to work, you must make sure that use_hidden_element is set to true.

.. _zend.form.element.checkbox.methods.get-unchecked-value:

**getUncheckedValue**

    ``getUncheckedValue()``

Return the value used when the checkbox is unchecked.

.. _zend.form.element.checkbox.methods.get-input-specification:

**getInputSpecification**


    ``getInputSpecification()``


Returns a input filter specification, which includes a ``Zend\Validator\InArray`` to validate if the value is either checked value or
unchecked value.

Returns array
