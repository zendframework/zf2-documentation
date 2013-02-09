.. _zend.form.element.image:

Image
^^^^^

``Zend\Form\Element\Image`` represents a image button form input.
It can be used with the ``Zend\Form\View\Helper\FormImage`` view helper.

``Zend\Form\Element\Image`` extends from :ref:`Zend\\Form\\Element <zend.form.element>`.

.. _zend.form.element.image.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"image"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $image = new Element\Image('my-image');
   $image->setAttribute('src', 'http://my.image.url'); // Src attribute is required

   $form = new Form('my-form');
   $form->add($image);
