.. _zend.form.view.helper.form-file-apc-progress:

FormFileApcProgress
^^^^^^^^^^^^^^^^^^^

The ``FormFileApcProgress`` view helper can be used to render a ``<input type="hidden" ...>`` with
a progress ID value used by the APC File Upload Progress feature. The APC php module is required for this
view helper to work. Unlike other Form view helpers, the ``FormFileSessionProgress`` helper does not accept a
Form Element as a parameter.

An ``id`` attribute with a value of ``"progress_key"`` will automatically be added.

.. warning::

   The view helper **must** be rendered *before* the file input in the form,
   or upload progress will not work correctly.

Best used with the :ref:`Zend\\ProgressBar\\Upload\\ApcProgress <zend.progress-bar.upload.apc-progress>` handler.

See the ``apc.rfc1867`` ini setting in the `APC Configuration`_ documentation for more information.

``FormFileApcProgress`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input>`.

.. _zend.form.view.helper.form-file-apc-progress.usage:

Basic usage:

.. code-block:: php
   :linenos:

   // Within your view...

   echo $this->formFileApcProgress();
   // <input type="hidden" id="progress_key" name="APC_UPLOAD_PROGRESS" value="12345abcde">


.. _`APC Configuration`: http://php.net/manual/en/apc.configuration.php