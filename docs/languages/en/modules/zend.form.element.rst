.. _zend.form.element:

Element Base Class
------------------

``Zend\Form\Element`` is a base class for all specialized elements and Zend\\Form\\Fieldset, but can also be used
for all generic ``text``, ``select``, ``radio``, etc. type form inputs which do not have a specialized element
available.

.. _zend.form.element.usage:

**Basic Usage**

At the bare minimum, each element or fieldset requires a name. You will also typically provide some attributes to
hint to the view layer how it might render the item.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $username = new Element('username');
   $username
       ->setLabel('Username');
       ->setAttributes(array(
           'type'  => 'text',
           'class' => 'username',
           'size'  => '30',
       ));

   $password = new Element('password');
   $password
       ->setLabel('Password');
       ->setAttributes(array(
           'type'  => 'password',
           'size'  => '30',
       ));

   $form = new Form('my-form');
   $form
       ->add($username)
       ->add($password);

.. _zend.form.element.methods:

**Public Methods**

.. function:: setName(string $name)
   :noindex:

   Set the name for this element.

   Returns ``Zend\Form\Element``

.. function:: getName()
   :noindex:

   Return the name for this element.

   Returns string

.. function:: setLabel(string $label)
   :noindex:

   Set the label content for this element.

   Returns ``Zend\Form\Element``

.. function:: getLabel()
   :noindex:

   Return the label content for this element.

   Returns string

.. function:: setLabelAttributes(array $labelAttributes)
   :noindex:

   Set the attributes to use with the label.

   Returns ``Zend\Form\Element``

.. function:: getLabelAttributes()
   :noindex:

   Return the attributes to use with the label.

   Returns array

.. function:: setOptions(array $options)
   :noindex:

   Set options for an element. Accepted options are: ``"label"`` and ``"label_attributes"``, which call
   ``setLabel`` and ``setLabelAttributes``, respectively.

   Returns ``Zend\Form\Element``

.. function:: setAttribute(string $key, mixed $value)
   :noindex:

   Set a single element attribute.

   Returns ``Zend\Form\Element``

.. function:: getAttribute(string $key)
   :noindex:

   Retrieve a single element attribute.

   Returns mixed

.. function:: hasAttribute(string $key)
   :noindex:

   Check if a specific attribute exists for this element.

   Returns boolean

.. function:: setAttributes(array|Traversable $arrayOrTraversable)
   :noindex:

   Set many attributes at once. Implementation will decide if this will overwrite or merge.

   Returns ``Zend\Form\Element``

.. function:: getAttributes()
   :noindex:

   Retrieve all attributes at once.

   Returns array|Traversable

.. function:: clearAttributes()
   :noindex:

   Clear all attributes for this element.

   Returns ``Zend\Form\Element``

.. function:: setMessages(array|Traversable $messages)
   :noindex:

   Set a list of messages to report when validation fails.

   Returns ``Zend\Form\Element``

.. function:: getMessages()
   :noindex:

   Returns a list of validation failure messages, if any.

   Returns array|Traversable


