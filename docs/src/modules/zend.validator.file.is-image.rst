.. _zend.validator.file.is-image:

IsImage
-------

``Zend\Validator\File\IsImage`` checks if a file is an image, such as `jpg` or `png`.
This validator is based on the :ref:`MimeType validator <zend.validator.file.mime-type>`
and supports the same methods and options.

The default list of `image file MIME types`_ can be found in the source code.

.. _`image file MIME types`: https://github.com/zendframework/zf2/blob/master/library/Zend/Validator/File/IsImage.php#L49

Please refer to the :ref:`MimeType validator <zend.validator.file.mime-type>`
for options and public methods.


.. _zend.validator.file.is-image.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $validator = new \Zend\Validator\File\IsImage();
   if ($validator->isValid('./myfile.jpg')) {
       // file is valid
   }
