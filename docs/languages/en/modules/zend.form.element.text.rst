.. _zend.form.element.text:

Text
^^^^

``Zend\Form\Element\Text`` represents a text form input.
It can be used with the ``Zend\Form\View\Helper\FormText`` view helper.

``Zend\Form\Element\Text`` extends from :ref:`Zend\\Form\\Element <zend.form.element>`.

.. _zend.form.element.text.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"text"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $text = new Element\Text('my-text');
   $text->setLabel('Enter your name');

   $form = new Form('my-form');
   $form->add($text);
