.. _zend.form.view.helper.form:

Form
^^^^

The ``Form`` view helper is used to render a ``<form>`` HTML element and its attributes.

It iterates through all its elements and relies on the ``FormCollection`` and ``FormRow`` view helpers to render
them appropriately.

You can also use :ref:`Zend\\Form\\View\\Helper\\FormRow <zend.form.view.helper.form-row>` in conjunction with
``Form::openTag()`` and ``Form::closeTag()`` to have a more fine grained control over the output.

Basic usage:

.. code-block:: php
   :linenos:

   /**
    * inside view template
    *
    * @var \Zend\View\Renderer\PhpRenderer $this
    * @var \Zend\Form\Form $form
    */

   echo $this->form($form);
   // i.e.
   // <form action="" method="POST">
   //    <label>
   //       <span>Some Label</span>
   //       <input type="text" name="some_element" value="">
   //    </label>
   // </form>


.. _zend.form.view.helper.form.methods:

The following public methods are in addition to those inherited from
:ref:`Zend\\Form\\View\\Helper\\AbstractHelper <zend.form.view.helper.abstract-helper.methods>`.

.. function:: __invoke(FormInterface $form = null)
   :noindex:

   Prepares and renders the whole form.

   :param $form: A Form object.
   :rtype: string

.. function:: openTag(FormInterface $form = null)
   :noindex:

   Renders the ``<form>`` open tag for the ``$form`` instance.

   :rtype: string

.. function:: closeTag()
   :noindex:

   Renders a ``</form>`` closing tag.

   :rtype: string
