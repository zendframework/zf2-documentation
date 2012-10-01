.. _zend.form.element.button:

Button Element
^^^^^^^^^^^^^^

``Zend\Form\Element\Button`` is meant to be paired with the ``Zend/Form/View/Helper/FormButton`` view helper.

``Zend\Form\Element\Button`` extends from :ref:`Zend\\Form\\Element <zend.form.element>`.

.. _zend.form.element.button.usage:

Basic Usage
"""""""""""

This element automatically adds a ``"type"`` attribute of value ``"button"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $button = new Element\Button('my-button');
   $button->setLabel('Button 1');

   $form = new Form('my-form');
   $form->add($button);
