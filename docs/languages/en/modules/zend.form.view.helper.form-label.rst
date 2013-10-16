.. _zend.form.view.helper.form-label:

FormLabel
^^^^^^^^^

The ``FormLabel`` view helper is used to render a ``<label>`` HTML element and its attributes.
If you have a ``Zend\I18n\Translator\Translator`` attached, ``FormLabel`` will translate
the label contents during it's rendering.

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Form\Element;

   $element = new Element\Text('my-text');
   $element->setLabel('Label')
           ->setAttribute('id', 'text-id')
           ->setLabelAttributes(array('class' => 'control-label'));

   // Within your view...

   /**
    * Example #1: Render label in one shot
    */
   echo $this->formLabel($element);
   // <label class="control-label" for="text-id">Label</label>

   echo $this->formLabel($element, $this->formText($element));
   // <label class="control-label" for="text-id">Label<input type="text" name="my-text"></label>

   echo $this->formLabel($element, $this->formText($element), 'append');
   // <label class="control-label" for="text-id"><input type="text" name="my-text">Label</label>

   /**
    * Example #2: Render label in separate steps
    */
   // Render the opening tag
   echo $this->formLabel()->openTag($element);
   // <label class="control-label" for="text-id">

   // Render the closing tag
   echo $this->formLabel()->closeTag();
   // </label>

Attaching a translator and setting a text domain:

.. code-block:: php
   :linenos:

   // Setting a translator
   $this->formLabel()->setTranslator($translator);

   // Setting a text domain
   $this->formLabel()->setTranslatorTextDomain('my-text-domain');

   // Setting both
   $this->formLabel()->setTranslator($translator, 'my-text-domain');

.. note::

   Note: If you have a translator in the Service Manager under the key, 'translator', the view helper plugin
   manager will automatically attach the translator to the FormLabel view helper. See
   ``Zend\View\HelperPluginManager::injectTranslator()`` for more information.

.. _zend.form.view.helper.form-label.methods:

The following public methods are in addition to those inherited from
:ref:`Zend\\Form\\View\\Helper\\AbstractHelper <zend.form.view.helper.abstract-helper.methods>`.

.. function:: __invoke(ElementInterface $element = null, string $labelContent = null, string $position = null)
   :noindex:

   Render a form label, optionally with content.

   Always generates a "for" statement, as we cannot assume the form input will be provided in the ``$labelContent``.

   :param $element: A form element.
   :param $labelContent: If null, will attempt to use the element's label value.
   :param $position: Append or prepend the element's label value to the ``$labelContent``. One of ``FormLabel::APPEND`` or ``FormLabel::PREPEND`` (default)
   :rtype: string

.. function:: openTag(array|ElementInterface $attributesOrElement = null)
   :noindex:

   Renders the ``<label>`` open tag and attributes.

   :param $attributesOrElement: An array of key value attributes or a ``ElementInterface`` instance.
   :rtype: string

.. function:: closeTag()
   :noindex:

   Renders a ``</label>`` closing tag.

   :rtype: string