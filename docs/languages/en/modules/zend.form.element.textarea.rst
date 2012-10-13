.. _zend.form.element.textarea:

Textarea Element
^^^^^^^^^^^^^^^^

``Zend\Form\Element\Textarea`` represents a textarea form input.
It can be used with the ``Zend\Form\View\Helper\FormTextarea`` view helper.

``Zend\Form\Element\Textarea`` extends from :ref:`Zend\Form\Element <zend.form.element>`.

.. _zend.form.element.textarea.usage:

Basic Usage
"""""""""""

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $textarea = new Element\Textarea('my-textarea');
   $textarea->setLabel('Enter a description');

   $form = new Form('my-form');
   $form->add($textarea);
