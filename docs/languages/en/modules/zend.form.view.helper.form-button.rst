.. _zend.form.view.helper.form-button:

FormButton
^^^^^^^^^^

The ``FormButton`` view helper is used to render a ``<button>`` HTML element and its attributes.

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Button('my-button');
   $element->setLabel("Reset");

   // Within your view, render entire button in one shot...

   echo $this->formButton($element);
   // Returns: <button name="my-button" type="button">Reset</button>

   // ...or manually...

   // Render the opening tag
   echo $this->formButton()->openTag($element);
   // Returns: <button name="my-button" type="button">

   echo '<span class="inner">' . $element->getLabel() . '</span>';

   // Render the closing tag
   echo $this->formButton()->closeTag();
   // Returns: </button>

   // ...or also...

   echo $this->formButton()->render($element, 'My Special Content');
   // Returns: <button name="my-button" type="button">My Special Content</button>

.. _zend.form.view.helper.form-button.methods:

The following public methods are in addition to those inherited from
:ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

.. function:: openTag($element = null)
   :noindex:

   Renders the ``<button>`` open tag for the ``$element`` instance.

   :rtype: string

.. function:: closeTag()
   :noindex:

   Renders a ``</button>`` closing tag.

   :rtype: string

.. function:: render(ElementInterface $element [, $buttonContent = null])
   :noindex:

   Renders a button's opening tag, inner content, and closing tag.

   :param $element: The button element.
   :param $buttonContent: (optional) The inner content to render. If ``null``, will default to the ``$element``'s label.
   :rtype: string
