
Zend\\Form\\Element\\Captcha
============================

The ``Captcha`` element can be used with forms where authenticated users are not necessary, but you want to prevent spam submissions. It is pairs with one of the ``Zend/Form/View/Helper/Captcha/*`` view helpers that matches the type of *CAPTCHA* adapter in use.

.. _zend.form.element.captcha.methods:

Available Methods
-----------------

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element <zend.form.element.methods>` .

.. _zend.form.element.captcha.methods.set-captcha:


**setCaptcha**


    ``setCaptcha(array|Zend\\Captcha\\AdapterInterface $captcha)``


Set the *CAPTCHA* adapter for this element. If ``$captcha`` is an array, ``Zend\Captcha\Factory::factory()`` will be run to create the adapter from the array configuration.

Returns ``Zend\Form\Element\Captcha`` 

.. _zend.form.element.captcha.methods.get-captcha:


**getCaptcha**


    ``getCaptcha()``


Return the *CAPTCHA* adapter for this element.

Returns ``Zend\Captcha\AdapterInterface`` 

.. _zend.form.element.captcha.methods.get-input-specification:


**getInputSpecification**


    ``getInputSpecification()``


Returns a input filter specification, which includes a ``Zend\Filter\StringTrim`` filter, and a *CAPTCHA* validator.

Returns array


