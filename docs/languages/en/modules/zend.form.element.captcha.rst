.. _zend.form.element.captcha:

Captcha
^^^^^^^

``Zend\Form\Element\Captcha`` can be used with forms where authenticated users are not necessary, but you want to prevent
spam submissions. It is paired with one of the ``Zend\Form\View\Helper\Captcha\*`` view helpers that matches the
type of *CAPTCHA* adapter in use.

.. _zend.form.element.captcha.usage:

.. rubric:: Basic Usage

A *CAPTCHA* adapter must be attached in order for validation to be included in the element's input filter
specification. See the section on :ref:`Zend CAPTCHA Adapters <zend.captcha.adapters>` for more information on what
adapters are available.

.. code-block:: php
   :linenos:

   use Zend\Captcha;
   use Zend\Form\Element;
   use Zend\Form\Form;

   $captcha = new Element\Captcha('captcha');
   $captcha
       ->setCaptcha(new Captcha\Dumb())
       ->setLabel('Please verify you are human');

   $form = new Form('my-form');
   $form->add($captcha);

Here is with the array notation:

.. code-block:: php
   :linenos:

    use Zend\Captcha;
    use Zend\Form\Form;

    $form = new Form('my-form');
    $form->add(array(
        'type' => 'Zend\Form\Element\Captcha',
        'name' => 'captcha',
        'options' => array(
            'label' => 'Please verify you are human',
            'captcha' => new Captcha\Dumb(),
        ),
    ));
    
.. _zend.form.element.captcha.methods:

.. rubric:: Public Methods

The following methods are in addition to the inherited :ref:`methods of Zend\\Form\\Element
<zend.form.element.methods>`.

.. _zend.form.element.captcha.methods.set-captcha:

.. function:: setCaptcha(array|Zend\\Captcha\\AdapterInterface $captcha)
   :noindex:

   Set the *CAPTCHA* adapter for this element. If ``$captcha`` is an array, ``Zend\Captcha\Factory::factory()``
   will be run to create the adapter from the array configuration.

.. function:: getCaptcha()
   :noindex:

   Return the *CAPTCHA* adapter for this element.

   :rtype: ``Zend\Captcha\AdapterInterface``

.. function:: getInputSpecification()
   :noindex:

   Returns a input filter specification, which includes a ``Zend\Filter\StringTrim`` filter, and a *CAPTCHA*
   validator.

   :rtype: array
