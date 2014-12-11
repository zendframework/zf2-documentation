.. _zend.form.file-upload:

File Uploading
==============

Zend Framework provides support for file uploading by using features in ``Zend\Form``,
``Zend\InputFilter``, ``Zend\Validator``, ``Zend\Filter``, and ``Zend\ProgressBar``.
These reusable framework components provide a convenient and secure way for
handling file uploads in your projects.

.. note::

   If the reader has experience with file uploading in Zend Framework v1.x,
   he/she will notice some major differences.
   ``Zend_File\Transfer`` has been deprecated in favor of using the standard ZF2 ``Zend\Form``
   and ``Zend\InputFilter`` features.

.. note::

   The file upload features described here are specifically for forms using the
   ``POST`` method. Zend Framework itself does not currently provide specific support
   for handling uploads via the ``PUT`` method, but it is possible with PHP.
   See the `PUT Method Support`_ in the PHP documentation for more information.

.. _`PUT Method Support`: http://php.net/manual/en/features.file-upload.put-method.php

Standard Example
----------------

Handling file uploads is *essentially* the same as how you would use ``Zend\Form``
for form processing, but with some slight caveats that will be described below.

In this example we will:

- Define a **Form** for backend validation and filtering.
- Create a **view template** with a ``<form>`` containing a file input.
- Process the form within a **Controller action**.

The Form and InputFilter
^^^^^^^^^^^^^^^^^^^^^^^^

Here we define a ``Zend\Form\Element\File`` input in a Form class named ``UploadForm``.

.. code-block:: php
   :linenos:

   // File: UploadForm.php

   use Zend\Form\Element;
   use Zend\Form\Form;

   class UploadForm extends Form
   {
       public function __construct($name = null, $options = array())
       {
           parent::__construct($name, $options);
           $this->addElements();
       }

       public function addElements()
       {
           // File Input
           $file = new Element\File('image-file');
           $file->setLabel('Avatar Image Upload')
                ->setAttribute('id', 'image-file');
           $this->add($file);
       }
   }


The ``File`` element provides some automatic features that happen behind the scenes:

- The form's ``enctype`` will automatically be set to ``multipart/form-data`` when
  the form ``prepare()`` method is called.
- The file element's default input specification will create the correct ``Input`` type:
  :ref:`Zend\\InputFilter\\FileInput <zend.input-filter.file-input>`.
- The ``FileInput`` will automatically prepend an
  :ref:`UploadFile Validator <zend.validator.file.upload-file>`,
  to securely validate that the file is actually an uploaded file, and to report
  other types of upload errors to the user.


The View Template
^^^^^^^^^^^^^^^^^

In the view template we render the ``<form>``, a file input (with label and errors),
and a submit button.

.. code-block:: php
   :linenos:

   // File: upload-form.phtml
   <?php $form->prepare(); // The correct enctype is set here ?>
   <?php echo $this->form()->openTag($form); ?>

       <div class="form-element">
           <?php $fileElement = $form->get('image-file'); ?>
           <?php echo $this->formLabel($fileElement); ?>
           <?php echo $this->formFile($fileElement); ?>
           <?php echo $this->formElementErrors($fileElement); ?>
       </div>

       <button>Submit</button>

   <?php echo $this->form()->closeTag(); ?>

When rendered, the HTML should look similar to:

.. code-block:: html
   :linenos:

   <form name="upload-form" id="upload-form" method="post" enctype="multipart/form-data">
       <div class="form-element">
           <label for="image-file">Avatar Image Upload</label>
           <input type="file" name="image-file" id="image-file">
       </div>

       <button>Submit</button>
   </form>

The Controller Action
^^^^^^^^^^^^^^^^^^^^^

For the final step, we will instantiate the ``UploadForm`` and process any postbacks in
a Controller action.

The form processing in the controller action will be similar to normal forms, *except*
that you **must** merge the ``$_FILES`` information in the request with the other post
data.

.. code-block:: php
   :linenos:

   // File: MyController.php

   public function uploadFormAction()
   {
       $form = new UploadForm('upload-form');
        
       $request = $this->getRequest(); 
       if ($request->isPost()) {
           // Make certain to merge the files info!
           $post = array_merge_recursive(
               $request->getPost()->toArray(),
               $request->getFiles()->toArray()
           );

           $form->setData($post);
           if ($form->isValid()) {
               $data = $form->getData();
               // Form is valid, save the form!
               return $this->redirect()->toRoute('upload-form/success');
           }
       }

       return array('form' => $form);
   }

Upon a successful file upload, ``$form->getData()`` would return:

.. code-block:: php
   :linenos:

   array(1) {
       ["image-file"] => array(5) {
           ["name"]     => string(11) "myimage.png"
           ["type"]     => string(9)  "image/png"
           ["tmp_name"] => string(22) "/private/tmp/phpgRXd58"
           ["error"]    => int(0)
           ["size"]     => int(14908679)
       }
   }

.. note::

   It is suggested that you always use the ``Zend\Http\PhpEnvironment\Request`` object
   to retrieve and merge the ``$_FILES`` information with the form, instead of using
   ``$_FILES`` directly.

   This is due to how the file information is mapped in the ``$_FILES`` array:

   .. code-block:: php
      :linenos:

      // A $_FILES array with single input and multiple files:
      array(1) {
          ["image-file"]=>array(2) {
              ["name"]=>array(2) {
                  [0]=>string(9)"file0.txt"
                  [1]=>string(9)"file1.txt"
              }
              ["type"]=>array(2) {
                  [0]=>string(10)"text/plain"
                  [1]=>string(10)"text/html"
              }
          }
      }

      // How Zend\Http\PhpEnvironment\Request remaps the $_FILES array:
      array(1) {
          ["image-file"]=>array(2) {
              [0]=>array(2) {
                  ["name"]=>string(9)"file0.txt"
                  ["type"]=>string(10)"text/plain"
              },
              [1]=>array(2) {
                  ["name"]=>string(9)"file1.txt"
                  ["type"]=>string(10)"text/html"
              }
          }
      }

   :ref:`Zend\\InputFilter\\FileInput <zend.input-filter.file-input>`
   expects the file data be in this re-mapped array format.


File Post-Redirect-Get Plugin
-----------------------------

When using other standard form inputs (i.e. ``text``, ``checkbox``, ``select``, etc.)
along with file inputs in a Form, you can encounter a situation where some inputs may
become invalid and the user must re-select the file and re-upload. PHP will delete
uploaded files from the temporary directory at the end of the request if it has not
been moved away or renamed. Re-uploading a valid file each time another form input is
invalid is inefficient and annoying to users.

One strategy to get around this is to split the form into multiple forms. One form for the
file upload inputs and another for the other standard inputs.

When you cannot separate the forms,
the :ref:`File Post-Redirect-Get Controller Plugin <zend.mvc.controller-plugins.file-postredirectget>`
can be used to manage the file inputs and save off valid uploads until the entire form
is valid.

Changing our earlier example to use the ``fileprg`` plugin will require two changes.

1. Adding a ``RenameUpload`` filter to our form's file input, with details on
   where the valid files should be stored:

   .. code-block:: php
      :linenos:

      // File: UploadForm.php

      use Zend\InputFilter;
      use Zend\Form\Element;
      use Zend\Form\Form;

      class UploadForm extends Form
      {
          public function __construct($name = null, $options = array())
          {
              parent::__construct($name, $options);
              $this->addElements();
              $this->addInputFilter();
          }

          public function addElements()
          {
              // File Input
              $file = new Element\File('image-file');
              $file->setLabel('Avatar Image Upload')
                   ->setAttribute('id', 'image-file');
              $this->add($file);
          }

          public function addInputFilter()
          {
              $inputFilter = new InputFilter\InputFilter();

              // File Input
              $fileInput = new InputFilter\FileInput('image-file');
              $fileInput->setRequired(true);
              $fileInput->getFilterChain()->attachByName(
                  'filerenameupload',
                  array(
                      'target'    => './data/tmpuploads/avatar.png',
                      'randomize' => true,
                  )
              );
              $inputFilter->add($fileInput);

              $this->setInputFilter($inputFilter);
          }
      }

   The ``filerenameupload`` options above would cause an uploaded file to be renamed
   and moved to: ``./data/tmpuploads/avatar_4b3403665fea6.png``.

   See the
   :ref:`RenameUpload filter <zend.filter.file.rename-upload>` documentation for
   more information on its supported options.


2. And, changing the Controller action to use the ``fileprg`` plugin:

   .. code-block:: php
      :linenos:

      // File: MyController.php

      public function uploadFormAction()
      {
          $form     = new UploadForm('upload-form');
          $tempFile = null;

          $prg = $this->fileprg($form);
          if ($prg instanceof \Zend\Http\PhpEnvironment\Response) {
              return $prg; // Return PRG redirect response
          } elseif (is_array($prg)) {
              if ($form->isValid()) {
                  $data = $form->getData();
                  // Form is valid, save the form!
                  return $this->redirect()->toRoute('upload-form/success');
              } else {
                  // Form not valid, but file uploads might be valid...
                  // Get the temporary file information to show the user in the view
                  $fileErrors = $form->get('image-file')->getMessages();
                  if (empty($fileErrors)) {
                      $tempFile = $form->get('image-file')->getValue();
                  }
              }
          }

          return array(
              'form'     => $form,
              'tempFile' => $tempFile,
          );
      }

Behind the scenes, the ``FilePRG`` plugin will:

- Run the Form's filters, namely the ``RenameUpload`` filter, to move the files out of
  temporary storage.
- Store the valid POST data in the session across requests.
- Change the ``required`` flag of any file inputs that had valid uploads to ``false``.
  This is so that form re-submissions without uploads will not cause validation errors.

.. note::

   In the case of a partially valid form, it is up to the developer whether to notify
   the user that files have been uploaded or not.
   For example, you may wish to hide the form input and/or display the file information.
   These things would be implementation details in the view or in a custom view helper.
   Just note that neither the ``FilePRG`` plugin nor the ``formFile`` view helper will do
   any automatic notifications or view changes when files have been successfully uploaded.


HTML5 Multi-File Uploads
------------------------

With HTML5 we are able to select multiple files from a single file input using the ``multiple`` attribute.
Not all `browsers support multiple file uploads`_, but the file input will safely
remain a single file upload for those browsers that do not support the feature.

.. _`browsers support multiple file uploads`: http://caniuse.com/#feat=forms

To enable multiple file uploads in Zend Framework, just set the file element's
``multiple`` attribute to true:

.. code-block:: php
   :linenos:

   // File: UploadForm.php

   use Zend\InputFilter;
   use Zend\Form\Element;
   use Zend\Form\Form;

   class UploadForm extends Form
   {
       public function __construct($name = null, $options = array())
       {
           parent::__construct($name, $options);
           $this->addElements();
           $this->addInputFilter();
       }

       public function addElements()
       {
           // File Input
           $file = new Element\File('image-file');
           $file->setLabel('Avatar Image Upload')
                ->setAttribute('id', 'image-file')
                ->setAttribute('multiple', true);   // That's it
           $this->add($file);
       }

       public function addInputFilter()
       {
           $inputFilter = new InputFilter\InputFilter();

           // File Input
           $fileInput = new InputFilter\FileInput('image-file');
           $fileInput->setRequired(true);

           // You only need to define validators and filters
           // as if only one file was being uploaded. All files
           // will be run through the same validators and filters
           // automatically.
           $fileInput->getValidatorChain()
               ->attachByName('filesize',      array('max' => 204800))
               ->attachByName('filemimetype',  array('mimeType' => 'image/png,image/x-png'))
               ->attachByName('fileimagesize', array('maxWidth' => 100, 'maxHeight' => 100));

           // All files will be renamed, i.e.:
           //   ./data/tmpuploads/avatar_4b3403665fea6.png,
           //   ./data/tmpuploads/avatar_5c45147660fb7.png
           $fileInput->getFilterChain()->attachByName(
               'filerenameupload',
               array(
                   'target'    => './data/tmpuploads/avatar.png',
                   'randomize' => true,
               )
           );
           $inputFilter->add($fileInput);

           $this->setInputFilter($inputFilter);
       }
   }

You do not need to do anything special with the validators and filters to support
multiple file uploads.
All of the files that are uploaded will have the same validators and filters run
against them automatically (from logic within ``FileInput``).
You only need to define them as if one file was being uploaded.

Upload Progress
---------------

While pure client-based upload progress meters are starting to become available with `HTML5's Progress Events`_,
not all browsers have `XMLHttpRequest level 2 support`_. For upload progress to work in a greater number of browsers (IE9 and below),
you must use a server-side progress solution.

.. _`HTML5's Progress Events`: http://www.w3.org/TR/progress-events/
.. _`XMLHttpRequest level 2 support`: http://caniuse.com/#feat=xhr2

``Zend\ProgressBar\Upload`` provides handlers that can give you the actual state of a
file upload in progress. To use this feature you need to choose one of the
:ref:`Upload Progress Handlers <zend.progress-bar.upload>`
(APC, uploadprogress, or Session) and ensure that your server setup has the appropriate extension
or feature enabled.

.. note::

   For this example we will use PHP **5.4**'s `Session progress handler`_

   **PHP 5.4 is required** and you may need to verify these php.ini settings for it to work:

   .. code-block:: ini

      file_uploads = On
      post_max_size = 50M
      upload_max_filesize = 50M
      session.upload_progress.enabled = On
      session.upload_progress.freq =  "1%"
      session.upload_progress.min_freq = "1"
      ; Also make certain 'upload_tmp_dir' is writable

.. _`Session progress handler`: http://php.net/manual/en/session.upload-progress.php

When uploading a file with a form POST, you must also include the progress identifier in a
hidden input. The :ref:`File Upload Progress View Helpers <zend.form.view.helper.file>` provide a
convenient way to add the hidden input based on your handler type.

.. code-block:: php
   :linenos:

   // File: upload-form.phtml
   <?php $form->prepare(); ?>
   <?php echo $this->form()->openTag($form); ?>
       <?php echo $this->formFileSessionProgress(); // Must come before the file input! ?>

       <div class="form-element">
           <?php $fileElement = $form->get('image-file'); ?>
           <?php echo $this->formLabel($fileElement); ?>
           <?php echo $this->formFile($fileElement); ?>
           <?php echo $this->formElementErrors($fileElement); ?>
       </div>

       <button>Submit</button>

   <?php echo $this->form()->closeTag(); ?>

When rendered, the HTML should look similar to:

.. code-block:: html
   :linenos:

   <form name="upload-form" id="upload-form" method="post" enctype="multipart/form-data">
       <input type="hidden" id="progress_key" name="PHP_SESSION_UPLOAD_PROGRESS" value="12345abcde">

       <div class="form-element">
           <label for="image-file">Avatar Image Upload</label>
           <input type="file" name="image-file" id="image-file">
       </div>

       <button>Submit</button>
   </form>


There are a few different methods for getting progress information to the browser
(long vs. short polling). Here we will use short polling since it is simpler
and less taxing on server resources, though keep in mind it is not as responsive as long polling.

When our form is submitted via AJAX, the browser will continuously poll the server for upload progress.

The following is an example Controller action which provides the progress information:

.. code-block:: php
   :linenos:

   // File: MyController.php

   public function uploadProgressAction()
   {
       $id = $this->params()->fromQuery('id', null);
       $progress = new \Zend\ProgressBar\Upload\SessionProgress();
       return new \Zend\View\Model\JsonModel($progress->getProgress($id));
   }

   // Returns JSON
   //{
   //    "total"    : 204800,
   //    "current"  : 10240,
   //    "rate"     : 1024,
   //    "message"  : "10kB / 200kB",
   //    "done"     : false
   //}

.. warning::

   This is *not* the most efficient way of providing upload progress, since each polling request must go
   through the Zend Framework bootstrap process. A better example would be to use a standalone
   php file in the public folder that bypasses the MVC bootstrapping and only uses the essential
   ``Zend\ProgressBar`` adapters.

Back in our view template, we will add the JavaScript to perform the AJAX POST of the form data, and
to start a timeout interval for the progress polling. To keep the example code relatively short, we are using the
`jQuery Form plugin`_ to do the AJAX form POST. If your project uses a different JavaScript framework
(or none at all), this will hopefully at least illustrate the necessary high-level logic that would need
to be performed.

.. _`jQuery Form plugin`: https://github.com/malsup/form

.. code-block:: html
   :linenos:

   // File: upload-form.phtml
   // ...after the form...

   <!-- Twitter Bootstrap progress bar styles:
        http://twitter.github.com/bootstrap/components.html#progress -->
   <div id="progress" class="help-block">
       <div class="progress progress-info progress-striped">
           <div class="bar"></div>
       </div>
       <p></p>
   </div>

   <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
   <script src="/js/jquery.form.js"></script>
   <script>
   var progressInterval;

   function getProgress() {
       // Poll our controller action with the progress id
       var url = '/upload-form/upload-progress?id=' + $('#progress_key').val();
       $.getJSON(url, function(data) {
           if (data.status && !data.status.done) {
               var value = Math.floor((data.status.current / data.status.total) * 100);
               showProgress(value, 'Uploading...');
           } else {
               showProgress(100, 'Complete!');
               clearInterval(progressInterval);
           }
       });
   }

   function startProgress() {
       showProgress(0, 'Starting upload...');
       progressInterval = setInterval(getProgress, 900);
   }

   function showProgress(amount, message) {
       $('#progress').show();
       $('#progress .bar').width(amount + '%');
       $('#progress > p').html(message);
       if (amount < 100) {
           $('#progress .progress')
               .addClass('progress-info active')
               .removeClass('progress-success');
       } else {
           $('#progress .progress')
               .removeClass('progress-info active')
               .addClass('progress-success');
       }
   }

   $(function() {
       // Register a 'submit' event listener on the form to perform the AJAX POST
       $('#upload-form').on('submit', function(e) {
           e.preventDefault();

           if ($('#image-file').val() == '') {
               // No files selected, abort
               return;
           }

           // Perform the submit
           //$.fn.ajaxSubmit.debug = true;
           $(this).ajaxSubmit({
               beforeSubmit: function(arr, $form, options) {
                   // Notify backend that submit is via ajax
                   arr.push({ name: "isAjax", value: "1" });
               },
               success: function (response, statusText, xhr, $form) {
                   clearInterval(progressInterval);
                   showProgress(100, 'Complete!');

                   // TODO: You'll need to do some custom logic here to handle a successful
                   // form post, and when the form is invalid with validation errors.
                   if (response.status) {
                       // TODO: Do something with a successful form post, like redirect
                       // window.location.replace(response.redirect);
                   } else {
                       // Clear the file input, otherwise the same file gets re-uploaded
                       // http://stackoverflow.com/a/1043969
                       var fileInput = $('#image-file');
                       fileInput.replaceWith( fileInput.val('').clone( true ) );

                       // TODO: Do something with these errors
                       // showErrors(response.formErrors);
                   }
               },
               error: function(a, b, c) {
                   // NOTE: This callback is *not* called when the form is invalid.
                   // It is called when the browser is unable to initiate or complete the ajax submit.
                   // You will need to handle validation errors in the 'success' callback.
                   console.log(a, b, c);
               }
           });
           // Start the progress polling
           startProgress();
       });
   });
   </script>

And finally, our Controller action can be modified to return form status and validation messages
in JSON format if we see the 'isAjax' post parameter (which was set in the JavaScript just before submit):

.. code-block:: php
   :linenos:

   // File: MyController.php

   public function uploadFormAction()
   {
       $form = new UploadForm('upload-form');
        
       $request = $this->getRequest();
       if ($request->isPost()) {
           // Make certain to merge the files info!
           $post = array_merge_recursive(
               $request->getPost()->toArray(),
               $request->getFiles()->toArray()
           );

           $form->setData($post);
           if ($form->isValid()) {
               $data = $form->getData();
               // Form is valid, save the form!
               if (!empty($post['isAjax'])) {
                   return new JsonModel(array(
                       'status'   => true,
                       'redirect' => $this->url()->fromRoute('upload-form/success'),
                       'formData' => $data,
                   ));
               } else {
                   // Fallback for non-JS clients
                   return $this->redirect()->toRoute('upload-form/success');
               }
           } else {
               if (!empty($post['isAjax'])) {
                    // Send back failure information via JSON
                    return new JsonModel(array(
                        'status'     => false,
                        'formErrors' => $form->getMessages(),
                        'formData'   => $form->getData(),
                    ));
               }
           }
       }

       return array('form' => $form);
   }


Additional Info
---------------

Related documentation:

- :ref:`Form File Element <zend.form.element.file>`
- :ref:`Form File View Helper <zend.form.view.helper.form-file>`
- :ref:`List of File Validators <zend.validator.file>`
- :ref:`List of File Filters <zend.filter.file>`
- :ref:`File Post-Redirect-Get Controller Plugin <zend.mvc.controller-plugins.file-postredirectget>`
- :ref:`Zend\\InputFilter\\FileInput <zend.input-filter.file-input>`
- :ref:`Upload Progress Handlers <zend.progress-bar.upload>`
- :ref:`Upload Progress View Helpers <zend.form.view.helper.file>`

External resources and blog posts from the community:

- `ZF2FileUploadExamples`_  : A ZF2 module with several file upload examples.


.. _`ZF2FileUploadExamples`: https://github.com/cgmartin/ZF2FileUploadExamples
