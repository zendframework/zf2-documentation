.. _zend.form.element.button:

Button
^^^^^^

``Zend\Form\Element\Button`` represents a button form input.
It can be used with the ``Zend\Form\View\Helper\FormButton`` view helper.

``Zend\Form\Element\Button`` extends from :ref:`Zend\Form\Element <zend.form.element>`.

.. _zend.form.element.button.usage:

.. rubric:: Basic Usage

This element automatically adds a ``type`` attribute of value ``button``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $button = new Element\Button('my-button');
   $button->setLabel('My Button')
          ->setValue('foo');

   $form = new Form('my-form');
   $form->add($button);
