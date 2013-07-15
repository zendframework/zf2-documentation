.. _zend.form.view.helper.form-search:

FormSearch
^^^^^^^^^^

The ``FormSearch`` view helper can be used to render a ``<input type="search">``
HTML5 form input.

``FormSearch`` extends from :ref:`Zend\\Form\\View\\Helper\\FormText <zend.form.view.helper.form-text>`.

.. _zend.form.view.helper.form-search.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element('my-search');

   // Within your view...
   echo $this->formSearch($element);

Output:

.. code-block:: html
   :linenos:

   <input type="search" name="my-search" value="">