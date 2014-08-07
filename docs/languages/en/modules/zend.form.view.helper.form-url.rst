:orphan:

.. _zend.form.view.helper.form-url:

FormUrl
^^^^^^^

The ``FormUrl`` view helper can be used to render a ``<input type="url">`` HTML
form input. It is meant to work with the :ref:`Zend\\Form\\Element\\Url <zend.form.element.url>`
element, which provides a default input specification with an URL validator.

``FormUrl`` extends from :ref:`Zend\\Form\\View\\Helper\\FormInput <zend.form.view.helper.form-input.methods>`.

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