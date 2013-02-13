.. _zend.form.element.csrf:

Csrf
^^^^

``Zend\Form\Element\Csrf`` pairs with the ``Zend\Form\View\Helper\FormHidden`` to provide protection from *CSRF* attacks
on forms, ensuring the data is submitted by the user session that generated the form and not by a rogue script.
Protection is achieved by adding a hash element to a form and verifying it when the form is submitted.

.. _zend.form.element.csrf.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"hidden"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $csrf = new Element\Csrf('csrf');

   $form = new Form('my-form');
   $form->add($csrf);

You can change the options of the CSRF validator using the ``setCsrfValidatorOptions`` function, or by using the ``"csrf_options"`` key. Here is an example using the array notation:

.. code-block:: php
   :linenos:

    use Zend\Form\Form;

    $form = new Form('my-form');
    $form->add(array(
    	'type' => 'Zend\Form\Element\Csrf',
    	'name' => 'csrf',
    	'options' => array(
    		'csrf_options' => array(
    			'timeout' => 600
    		)
    	)
    ));

.. _zend.form.element.csrf.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element
<zend.form.element.methods>`.

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes a ``Zend\Filter\StringTrim`` filter and a
   ``Zend\Validator\Csrf`` to validate the *CSRF* value.

   :rtype: array
   
.. function:: setCsrfValidatorOptions(array $options)
   :noindex:

   Set the options that are used by the CSRF validator.

.. function:: getCsrfValidatorOptions()
   :noindex:

   Get the options that are used by the CSRF validator.
   
   :rtype: array
   
.. function:: setCsrfValidator(Zend\Validator\Csrf $validator)
   :noindex:

   Override the default CSRF validator by setting another one.

.. function:: getCsrfValidator()
   :noindex:

   Get the CSRF validator.
   
   :rtype: Zend\Validator\Csrf 
