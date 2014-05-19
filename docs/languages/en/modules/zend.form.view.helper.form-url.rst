:orphan:

.. _zend.form.view.helper.form-url:

FormUrl
^^^^^^^

TODO

.. _zend.form.view.helper.form-url.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Url('my-url');

   // Within your view...

   echo $this->formUrl($element);

Output:

.. code-block:: html
   :linenos:

   <input type="url" name="my-url" value="">

.. _zend.form.view.helper.form-url.usage.custom-pattern:

Usage of custom regular expression pattern:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Url('my-url');
   $element->setAttribute('pattern', 'https?://.+');

   // Within your view...

   echo $this->formUrl($element);

Output:

.. code-block:: html
   :linenos:

   <input type="url" name="my-url" pattern="https?://.+" value="">