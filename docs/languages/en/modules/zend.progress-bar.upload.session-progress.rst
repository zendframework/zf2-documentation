.. _zend.progress-bar.upload.session-progress:

Session Progress Handler
^^^^^^^^^^^^^^^^^^^^^^^^

The ``Zend\ProgressBar\Upload\SessionProgress`` handler uses the PHP 5.4 `Session Progress`_ feature for tracking
upload progress.

.. note::

   PHP 5.4 is required.


This handler is best used with the :ref:`FormFileSessionProgress <zend.form.view.helper.form-file-session-progress>`
view helper, to provide a hidden element with the upload progress identifier.


.. _`Session Progress`: http://php.net/manual/en/session.upload-progress.php
