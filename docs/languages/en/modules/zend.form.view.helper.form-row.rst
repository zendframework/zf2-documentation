.. _zend.form.view.helper.form-row:

FormRow
^^^^^^^^^^^^^^

The ``FormRow`` view helper is in turn used by ``Form`` view helper to render each row of a form, nevertheless it can be
use stand-alone.
A form row usually consists of the output produced by the helper specific to an input, plus its label and errors, if any.

``FormRow`` handles different rendering options, having elements wrapped by the <label> HTML block by default, but
also allowing to render them in separate blocks when the element has an ``id`` attribute specified, thus preserving
browser usability features in any case.

Other options involve label positioning, escaping, toggling errors and using custom partial templates. Please check out
``Zend\Form\View\Helper\FormRow`` method API for more details.

.. _zend.form.view.helper.form-row.usage:

Usage:

.. code-block:: php
   :linenos:

   /**
    * inside view template
    *
    * @var \Zend\View\Renderer\PhpRenderer $this
    * @var \Zend\Form\Form $form
    */

   // Prepare the form
   $form->prepare();

   // Render the opening tag
   echo $this->form()->openTag($form);

   /** @var \Zend\Form\Element\Text $element */
   $element = $form->get('some_element');
   $element->setLabel('Some Label');

   // Render 'some_element' label, input, and errors if any
   echo $this->formRow($element);
   // i.e. <label><span>Some Label</span><input type="text" name="some_element" value=""></label>

   // Altering label position
   echo $this->formRow($element, 'append');
   // i.e. <label><input type="text" name="some_element" value=""><span>Some Label</span></label>

   // Setting the 'id' attribute will result in a separated label rather than a wrapping one
   $element->setAttribute('id', 'element_id');
   echo $this->formRow($element);
   // i.e. <label for="element_id">Some Label</label><input type="text" name="some_element" id="element_id" value="">

   // Turn off escaping for HTML labels
   $element->setLabel('<abbr title="Completely Automated Public Turing test to tell Computers and Humans Apart">CAPTCHA</abbr>');
   $element->setLabelOptions(array('disable_html_escape' => true));
   // i.e.
   // <label>
   //   <span>
   //       <abbr title="Completely Automated Public Turing test to tell Computers and Humans Apart">CAPTCHA</abbr>
   //   </span>
   //   <input type="text" name="some_element" value="">
   // </label>

   // Render the closing tag
   echo $this->form()->closeTag();

.. note::

   Label content is escaped by default
