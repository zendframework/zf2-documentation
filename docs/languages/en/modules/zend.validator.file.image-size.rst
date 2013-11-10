.. _zend.validator.file.image-size:

ImageSize
---------

``Zend\Validator\File\ImageSize`` checks the size of image files. Minimum and/or maximum
dimensions can be set to validate against.

.. _zend.validator.file.image-size.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **minWidth** ``(int|null) default: null``
- **minHeight** ``(int|null) default: null``
- **maxWidth** ``(int|null) default: null``
- **maxHeight** ``(int|null) default: null``
   To bypass validation of a particular dimension, the relevant option should be set to ``null``.

.. _zend.validator.file.image-size.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Is image size between 320x200 (min) and 640x480 (max)?
   $validator = new \Zend\Validator\File\ImageSize(320, 200, 640, 480);

   // ...or with array notation
   $validator = new \Zend\Validator\File\ImageSize(array(
       'minWidth' => 320, 'minHeight' => 200,
       'maxWidth' => 640, 'maxHeight' => 480,
   ));

   // Is image size equal to or larger than 320x200?
   $validator = new \Zend\Validator\File\ImageSize(array(
       'minWidth' => 320, 'minHeight' => 200,
   ));

   // Is image size equal to or smaller than 640x480?
   $validator = new \Zend\Validator\File\ImageSize(array(
       'maxWidth' => 640, 'maxHeight' => 480,
   ));

   // Perform validation with file path
   if ($validator->isValid('./myfile.jpg')) {
       // file is valid
   }


.. _zend.validator.file.image-size.methods:

Public Methods
^^^^^^^^^^^^^^

.. function:: getImageMin()
   :noindex:

   Returns the minimum dimensions (width and height)

   :rtype: ``array``

.. function:: getImageMax()
   :noindex:

   Returns the maximum dimensions (width and height)

   :rtype: ``array``
