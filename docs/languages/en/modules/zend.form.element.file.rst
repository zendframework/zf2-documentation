.. _zend.form.element.file:

File
^^^^

``Zend\Form\Element\File`` represents a form file input and
provides a default input specification with a type of :ref:`FileInput <zend.input-filter.file-input>`
(important for handling validators and filters correctly).
It can be used with the ``Zend\Form\View\Helper\FormFile`` view helper.

``Zend\Form\Element\File`` extends from :ref:`Zend\\Form\\Element <zend.form.element>`.

.. _zend.form.element.file.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"file"``.
It will also set the form's enctype to ``multipart/form-data`` during ``$form->prepare()``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   // Single file upload
   $file = new Element\File('file');
   $file->setLabel('Single file input');

   // HTML5 multiple file upload
   $multiFile = new Element\File('multi-file');
   $multiFile->setLabel('Multi file input')
             ->setAttribute('multiple', true);

   $form = new Form('my-file');
   $form->add($file)
        ->add($multiFile);

