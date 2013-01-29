.. _zend.validator.file.upload:

Upload
------

``Zend\Validator\File\Upload`` checks whether a file has been uploaded via a form ``POST``
and will return descriptive messages for any upload errors.

.. note::

   :ref:`Zend\\InputFilter\\FileInput <zend.input-filter.file-input>` will automatically
   prepend this validator in it's validation chain.

.. _zend.validator.file.upload.usage:

.. rubric:: Usage Examples

.. code-block:: php
   :linenos:

   use Zend\Http\PhpEnvironment\Request;

   $request = new Request();
   $files   = $request->getFiles();
   // i.e. $files['my-upload']['error'] == 0

   $validator = \Zend\Validator\File\Upload();
   if ($validator->isValid($files['my-upload'])) {
       // file is valid
   }
