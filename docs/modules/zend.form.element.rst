.. _zend.form.element:

Zend\\Form\\Element
===================

``Zend\Form\Element`` is a base class for all specialized elements and Zend\\Form\\Fieldset, but can also be used
for all generic ``text``, ``select``, ``radio``, etc. type form inputs which do not have a specialized element
available.

.. _zend.form.element.usage:

.. rubric:: Basic Usage of Zend\\Form\\Element

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

Available Methods
-----------------

.. _zend.form.element.methods.set-name:

**setName**
   ``setName(string $name)``
   Set the name for this element.

   Returns ``Zend\Form\Element``

.. _zend.form.element.methods.get-name:

**getName**
   ``getName()``
   Return the name for this element.

   Returns string

.. _zend.form.element.methods.set-label:

**setLabel**
   ``setLabel(string $label)``
   Set the label content for this element.

   Returns ``Zend\Form\Element``

.. _zend.form.element.methods.get-label:

**getLabel**
   ``getLabel()``
   Return the label content for this element.

   Returns string

.. _zend.form.element.methods.set-label-attributes:

**setLabelAttributes**
   ``setLabelAttributes(array $labelAttributes)``
   Set the attributes to use with the label.

   Returns ``Zend\Form\Element``

.. _zend.form.element.methods.get-label-attributes:

**getLabelAttributes**
   ``getLabelAttributes()``
   Return the attributes to use with the label.

   Returns array

.. _zend.form.element.methods.set-options:

**setOptions**
   ``setOptions(array $options)``
   Set options for an element. Accepted options are: ``"label"`` and ``"label_attributes"``, which call
   ``setLabel`` and ``setLabelAttributes``, respectively.

   Returns ``Zend\Form\Element``

.. _zend.form.element.methods.set-attribute:

**setAttribute**
   ``setAttribute(string $key, mixed $value)``
   Set a single element attribute.

   Returns ``Zend\Form\Element``

.. _zend.form.element.methods.get-attribute:

**getAttribute**
   ``getAttribute(string $key)``
   Retrieve a single element attribute.

   Returns mixed

.. _zend.form.element.methods.has-attribute:

**hasAttribute**
   ``hasAttribute(string $key)``
   Check if a specific attribute exists for this element.

   Returns boolean

.. _zend.form.element.methods.set-attributes:

**setAttributes**
   ``setAttributes(array|Traversable $arrayOrTraversable)``
   Set many attributes at once. Implementation will decide if this will overwrite or merge.

   Returns ``Zend\Form\Element``

.. _zend.form.element.methods.get-attributes:

**getAttributes**
   ``getAttributes()``
   Retrieve all attributes at once.

   Returns array|Traversable

.. _zend.form.element.methods.clear-attributes:

**clearAttributes**
   ``clearAttributes()``
   Clear all attributes for this element.

   Returns ``Zend\Form\Element``

.. _zend.form.element.methods.set-messages:

**setMessages**
   ``setMessages(array|Traversable $messages)``
   Set a list of messages to report when validation fails.

   Returns ``Zend\Form\Element``

.. _zend.form.element.methods.get-messages:

**setMessages**
   ``getMessages()``
   Returns a list of validation failure messages, if any.

   Returns array|Traversable


