.. _zend.form.element.csrf:

Csrf Element
^^^^^^^^^^^^

``Zend\Form\Element\Csrf`` pairs with the ``Zend/Form/View/Helper/FormHidden`` to provide protection from *CSRF* attacks
on forms, ensuring the data is submitted by the user session that generated the form and not by a rogue script.
Protection is achieved by adding a hash element to a form and verifying it when the form is submitted.

.. _zend.form.element.csrf.usage:

Basic Usage
"""""""""""

This element automatically adds a ``"type"`` attribute of value ``"hidden"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $csrf = new Element\Csrf('csrf');

   $form = new Form('my-form');
   $form->add($csrf);

.. _zend.form.element.csrf.methods:

Public Methods
""""""""""""""

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element
<zend.form.element.methods>`.

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes a ``Zend\Filter\StringTrim`` filter and a
   ``Zend\Validator\Csrf`` to validate the *CSRF* value.

   :rtype: array
