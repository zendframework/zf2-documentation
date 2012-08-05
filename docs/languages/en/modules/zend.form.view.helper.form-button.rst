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

   // Within your view...

   /**
    * Example #1: Render entire button in one shot...
    */
   echo $this->formButton($element);
   // <button name="my-button" type="button">Reset</button>

   /**
    * Example #2: Render button in 3 steps
    */
   // Render the opening tag
   echo $this->formButton()->openTag($element);
   // <button name="my-button" type="button">

   echo '<span class="inner">' . $element->getLabel() . '</span>';

   // Render the closing tag
   echo $this->formButton()->closeTag();
   // </button>

   /**
    * Example #3: Override the element label
    */
   echo $this->formButton()->render($element, 'My Content');
   // <button name="my-button" type="button">My Content</button>

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
