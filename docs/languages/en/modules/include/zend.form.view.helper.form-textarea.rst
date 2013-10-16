.. _zend.form.view.helper.form-textarea:

FormTextarea
^^^^^^^^^^^^

The ``FormTextarea`` view helper can be used to render a ``<textarea></textarea>``
HTML form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Textarea <zend.form.element.textarea>`
element.

.. _zend.form.view.helper.form-textarea.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Textarea('my-textarea');

   // Within your view...
   echo $this->formTextarea($element);

Output:

.. code-block:: html
   :linenos:

   <textarea name="my-textarea"></textarea>