.. _zend.form.element.hidden:

Hidden Element
^^^^^^^^^^^^^^

``Zend\Form\Element\Hidden`` represents a hidden form input.
It can be used with the ``Zend/Form/View/Helper/FormHidden`` view helper.

``Zend\Form\Element\Hidden`` extends from :ref:`Zend\\Form\\Element <zend.form.element>`.

.. _zend.form.element.hidden.usage:

Basic Usage
"""""""""""

This element automatically adds a ``"type"`` attribute of value ``"hidden"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $hidden = new Element\Hidden('my-hidden');
   $hidden->setValue('foo');

   $form = new Form('my-form');
   $form->add($hidden);
