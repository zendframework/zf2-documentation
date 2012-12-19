.. _zend.form.element.file:

File
^^^^

``Zend\Form\Element\File`` represents a form file input.
It can be used with the ``Zend\Form\View\Helper\FormFile`` view helper.

``Zend\Form\Element\File`` extends from :ref:`Zend\Form\Element <zend.form.element>`.

.. _zend.form.element.file.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"file"``,
and will set the form's enctype to ``multipart/form-data``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $file = new Element\File('my-file');

   $form = new Form('my-file');
   $form->add($file);
