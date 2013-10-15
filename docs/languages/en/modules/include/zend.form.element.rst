.. _zend.form.element:

Element Base Class
------------------

``Zend\Form\Element`` is a base class for all specialized elements and ``Zend\Form\Fieldset``.

.. _zend.form.element.usage:

.. rubric:: Basic Usage

At the bare minimum, each element or fieldset requires a name. You will also typically provide some attributes to
hint to the view layer how it might render the item.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $username = new Element\Text('username');
   $username
       ->setLabel('Username')
       ->setAttributes(array(
           'class' => 'username',
           'size'  => '30',
       ));

   $password = new Element\Password('password');
   $password
       ->setLabel('Password')
       ->setAttributes(array(
           'size'  => '30',
       ));

   $form = new Form('my-form');
   $form
       ->add($username)
       ->add($password);

.. _zend.form.element.methods:

.. rubric:: Public Methods

.. function:: setName(string $name)
   :noindex:

   Set the name for this element.

.. function:: getName()
   :noindex:

   Return the name for this element.

   :rtype: string
   
.. function:: setValue(string $value)
   :noindex:

   Set the value for this element.

.. function:: getValue()
   :noindex:

   Return the value for this element.

   :rtype: string

.. function:: setLabel(string $label)
   :noindex:

   Set the label content for this element.

.. function:: getLabel()
   :noindex:

   Return the label content for this element.

   :rtype: string

.. function:: setLabelAttributes(array $labelAttributes)
   :noindex:

   Set the attributes to use with the label.

.. function:: getLabelAttributes()
   :noindex:

   Return the attributes to use with the label.

   :rtype: array

.. _zend.form.element.methods.set-options:

.. function:: setOptions(array $options)
   :noindex:

   Set options for an element. Accepted options are: ``"label"`` and ``"label_attributes"``, which call
   ``setLabel`` and ``setLabelAttributes``, respectively.

.. function:: getOptions()
   :noindex:

   Get defined options for an element

   :rtype: array

.. function:: getOption(string $option)
   :noindex:

   Return the specified option, if defined. If it's not defined, returns null.

   :rtype: null|mixed

.. function:: setAttribute(string $key, mixed $value)
   :noindex:

   Set a single element attribute.

.. function:: getAttribute(string $key)
   :noindex:

   Retrieve a single element attribute.

   :rtype: mixed

.. function:: removeAttribute(string $key)
   :noindex:

   Remove a single attribute

.. function:: hasAttribute(string $key)
   :noindex:

   Check if a specific attribute exists for this element.

   :rtype: boolean

.. function:: setAttributes(array|Traversable $arrayOrTraversable)
   :noindex:

   Set many attributes at once. Implementation will decide if this will overwrite or merge.

.. function:: getAttributes()
   :noindex:

   Retrieve all attributes at once.

   :rtype: array|Traversable

.. function:: removeAttributes(array $keys)
   :noindex:

   Remove many attributes at once

.. function:: clearAttributes()
   :noindex:

   Clear all attributes for this element.

.. function:: setMessages(array|Traversable $messages)
   :noindex:

   Set a list of messages to report when validation fails.

.. function:: getMessages()
   :noindex:

   Returns a list of validation failure messages, if any.

   :rtype: array|Traversable


