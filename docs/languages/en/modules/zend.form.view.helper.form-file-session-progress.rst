.. _zend.form.view.helper.form-file-session-progress:

FormFileSessionProgress
^^^^^^^^^^^^^^^^^^^^^^^

The ``FormFileSessionProgress`` view helper can be used to render a ``<input type="hidden" ...>`` which can be used by
the PHP 5.4 File Upload Session Progress feature. PHP 5.4 is required for this view helper to work. Unlike
other Form view helpers, the ``FormFileSessionProgress`` helper does not accept a Form Element as a parameter.

An ``id`` attribute with a value of ``"progress_key"`` will automatically be added.

.. warning::

   The view helper **must** be rendered *before* the file input in the form,
   or upload progress will not work correctly.

Best used with the :ref:`Zend\\ProgressBar\\Upload\\SessionProgress <zend.progress-bar.upload.session-progress>` handler.

See the `Session Upload Progress`_ in the PHP documentation for more information.

``FormFileSessionProgress`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-file-session-progress.usage:

Basic usage:

.. code-block:: php
   :linenos:

   // Within your view...

   echo $this->formFileSessionProgress();
   // <input type="hidden" id="progress_key" name="PHP_SESSION_UPLOAD_PROGRESS" value="12345abcde">


.. _`Session Upload Progress`: http://php.net/manual/en/session.upload-progress.php