.. _zend.validator.file.word-count:

WordCount
---------

``Zend\Validator\File\WordCount`` checks for the number of words within a file.

.. _zend.validator.file.word-count.options:

Supported Options
^^^^^^^^^^^^^^^^^

The following set of options are supported:

- **min** ``(integer) default: null``
- **max** ``(integer) default: null``
   The number of words allowed.


.. _zend.validator.file.word-count.usage:

Usage Examples
^^^^^^^^^^^^^^

.. code-block:: php
   :linenos:

   // Limit the amount of words to a maximum of 2000
   $validator = new \Zend\Validator\File\WordCount(2000);

   // Limit the amount of words to between 100 and 5000
   $validator = new \Zend\Validator\File\WordCount(100, 5000);

   // ... or with array notation
   $validator = new \Zend\Validator\File\WordCount(array(
       'min' => 1000, 'max' => 5000
   ));

   // Perform validation with file path
   if ($validator->isValid('./myfile.txt')) {
       // file is valid
   }

