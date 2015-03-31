.. _zend.validator.file.is-compressed:

IsCompressed
------------

``Zend\Validator\File\IsCompressed`` checks if a file is a compressed archive,
such as zip or gzip. This validator is based on the :ref:`MimeType validator <zend.validator.file.mime-type>`
and supports the same methods and options.

The default list of `compressed file MIME types`_ can be found in the source code.

.. _`compressed file MIME types`: https://github.com/zendframework/zf2/blob/master/library/Zend/Validator/File/IsCompressed.php#L48

Please refer to the :ref:`MimeType validator <zend.validator.file.mime-type>`
for options and public methods.


.. _zend.validator.file.is-compressed.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   $validator = new \Zend\Validator\File\IsCompressed();
   if ($validator->isValid('./myfile.zip')) {
       // file is valid
   }
