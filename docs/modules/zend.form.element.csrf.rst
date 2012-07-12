
Zend\\Form\\Element\\Csrf
=========================

The ``Csrf`` element pairs with the ``Zend/Form/View/Helper/FormHidden`` to provide protection from *CSRF* attacks on forms, ensuring the data is submitted by the user session that generated the form and not by a rogue script. Protection is achieved by adding a hash element to a form and verifying it when the form is submitted.

.. _zend.form.element.csrf.methods:

Available Methods
-----------------

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element <zend.form.element.methods>` .

.. _zend.form.element.csrf.methods.get-input-specification:


**getInputSpecification**


    ``getInputSpecification()``


Returns a input filter specification, which includes a ``Zend\Filter\StringTrim`` filter and a ``Zend\Validator\Csrf`` to validate the *CSRF* value.

Returns array


