.. _zend.form.view.helper.form:

Form
^^^^

The ``Form`` view helper is used to render a ``<form>`` HTML element and its attributes.

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Form;
   use Zend\Form\Element;

   // Within your view...

   $form = new Form();
   // ...add elements and input filter to form...

   // Set attributes
   $form->setAttribute('action', $this->url('contact/process'));
   $form->setAttribute('method', 'post');

   // Prepare the form elements
   $form->prepare();

   // Render the opening tag
   echo $this->form()->openTag($form);
   // <form action="/contact/process" method="post">

   // ...render the form elements...

   // Render the closing tag
   echo $this->form()->closeTag();
   // </form>


.. _zend.form.view.helper.form.methods:

The following public methods are in addition to those inherited from
:ref:`Zend\\Form\\View\\Helper\\AbstractHelper <zend.form.view.helper.abstract-helper.methods>`.

.. function:: openTag(FormInterface $form = null)
   :noindex:

   Renders the ``<form>`` open tag for the ``$form`` instance.

   :rtype: string

.. function:: closeTag()
   :noindex:

   Renders a ``</form>`` closing tag.

   :rtype: string