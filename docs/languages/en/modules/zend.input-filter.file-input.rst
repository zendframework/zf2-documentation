.. _zend.input-filter.file-input:

File Upload Input
=================

The ``Zend\FileInput`` class is a special ``Input`` type for uploaded files found in the ``$_FILES`` array.

While ``FileInput`` uses the same interface as ``Input``, it is special in two ways:

1. It expects the raw value to be in the ``$_FILES`` array format.
2. The validators are run **before** the filters (which is the opposite behavior of ``Input``).

The biggest thing to be concerned about is that if you are using a ``<input type="file">`` element in your form,
you will need to use the ``FileInput`` **instead of** ``Input`` or else you will encounter issues.

Usage of ``FileInput`` is essentially the same as ``Input``:

.. code-block:: php
   :linenos:

   use Zend\Http\PhpEnvironment\Request;
   use Zend\Filter;
   use Zend\InputFilter\InputFilter;
   use Zend\InputFilter\Input;
   use Zend\InputFilter\FileInput;
   use Zend\Validator;

   // Description text input
   $description = new Input('description'); // Standard Input type
   $description->getFilterChain()           // Filters are run first w/ Input
               ->attach(new Filter\StringTrim();
   $description->getValidatorChain()        // Validators are run second w/ Input
               ->addValidator(new Validator\StringLength(array('max' => 140));

   // File upload input
   $file = new FileInput('file');           // Special File Input type
   $file->getValidatorChain()               // Validators are run first w/ FileInput
        ->addValidator(new Validator\File\Upload());
   $file->getFilterChain()                  // Filters are run second w/ FileInput
        ->attach(new Filter\File\RenameUpload(array(
            'target'    => './data/tmpuploads/file',
            'randomize' => true,
        ));

   // Merge $_POST and $_FILES data together
   $request  = new Request();
   $postData = array_merge_recursive($request->getPost(), $request->getFiles());

   $inputFilter = new InputFilter();
   $inputFilter->add($description)
               ->add($file)
               ->setData($postData);

   if ($inputFilter->isValid()) {           // FileInput validators are run, but not the filters...
       echo "The form is valid\n";
       $data = $inputFilter->getValues();   // This is when the FileInput filters are run.
   } else {
       echo "The form is not valid\n";
       foreach ($inputFilter->getInvalidInput() as $error) {
           print_r ($error->getMessages());
       }
   }

