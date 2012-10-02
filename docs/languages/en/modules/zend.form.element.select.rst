.. _zend.form.element.select:

Select Element
^^^^^^^^^^^^^^

``Zend\Form\Element\Select`` is meant to be paired with the ``Zend/Form/View/Helper/FormSelect`` for HTML inputs with type select. This element adds an InArray validator to validate if the selected value is one of the available values originally provided by the select element.
Use ``$select->setAttribute('multiple', 'multiple');`` to allow multiple selections. To select one option by default use ``$select->setValue('bar');``

.. _zend.form.element.select.usage:

Basic Usage
"""""""""""

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $select = new Element\Select('select');
   $select->setLabel('A select')
          ->setValueOptions(array(
              'foo' => 'Foo',
              'bar' => 'Bar',
              'baz' => 'Baz',
          ));
   $select->value('bar'); // select one option

   $form = new Form('my-form');
   $form->add($select);

The above could be altered as follows in order to select one option:

.. code-block:: php
   :linenos:

   $select->setLabel('A select')
          ->setValueOptions(array(
              'foo' => 'Foo',
              array(
                'selected' => 'selected',
                'value'    => 'bar',
                'label'    => 'Bar',
              ),
              'baz' => 'Baz',
          ));

.. _zend.form.element.select.methods:

Public Methods
""""""""""""""

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element <zend.form.element.methods>` .

.. function:: setValueOptions(array $options)
   :noindex:

   Set the available select options. Accepts key/value pair array of values and labels.

   :rtype: Select

.. function:: getValueOptions()
   :noindex:

   Return all current select options as key/value pair array. Empty options do not get included.

   :rtype: array

.. function:: setEmptyOption(string $emptyOption)
   :noindex:

   Set empty select option with given text and no value. If set to null, no option will be added.

   :rtype: Select

.. function:: getEmptyOption()
   :noindex:

   Return the label text for the empty select option.

   :rtype: string|null

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes a ``Zend\Validator\InArray`` to validate if the selected value is one of the available values originally provided by the select element.
   :rtype: array
