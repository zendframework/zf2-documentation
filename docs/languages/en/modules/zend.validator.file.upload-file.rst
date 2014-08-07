:orphan:

.. _zend.validator.file.upload-file:

UploadFile
----------

``Zend\Validator\File\UploadFile`` checks whether a single file has been uploaded via a form ``POST``
and will return descriptive messages for any upload errors.

.. note::

   :ref:`Zend\\InputFilter\\FileInput <zend.input-filter.file-input>` will automatically
   prepend this validator in it's validation chain.

.. _zend.validator.file.upload-file.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   use Zend\Http\PhpEnvironment\Request;

   $request = new Request();
   $files   = $request->getFiles();
   // i.e. $files['my-upload']['error'] == 0

   $validator = new \Zend\Validator\File\UploadFile();
   if ($validator->isValid($files['my-upload'])) {
       // file is valid
   }
