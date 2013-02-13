.. _zend.form.element.submit:

Submit
^^^^^^

``Zend\Form\Element\Submit`` represents a submit button form input.
It can be used with the ``Zend\Form\View\Helper\FormSubmit`` view helper.

``Zend\Form\Element\Submit`` extends from :ref:`Zend\\Form\\Element <zend.form.element>`.

.. _zend.form.element.submit.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"submit"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $submit = new Element\Submit('my-submit');
   $submit->setValue('Submit Form');

   $form = new Form('my-form');
   $form->add($submit);
