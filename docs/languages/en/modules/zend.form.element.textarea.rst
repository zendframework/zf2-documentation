.. _zend.form.element.textarea:

Textarea
^^^^^^^^

``Zend\Form\Element\Textarea`` represents a textarea form input.
It can be used with the ``Zend\Form\View\Helper\FormTextarea`` view helper.

``Zend\Form\Element\Textarea`` extends from :ref:`Zend\\Form\\Element <zend.form.element>`.

.. _zend.form.element.textarea.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"textarea"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $textarea = new Element\Textarea('my-textarea');
   $textarea->setLabel('Enter a description');

   $form = new Form('my-form');
   $form->add($textarea);
