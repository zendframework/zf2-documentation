.. _zend.form.view.helper.form-captcha:

FormCaptcha
^^^^^^^^^^^

TODO

.. _zend.form.view.helper.form-captcha.usage:

Basic usage:

.. code-block:: php
   :linenos:

   use Zend\Captcha;
   use Zend\Form\Element;

   $captcha = new Element\Captcha('captcha');
   $captcha
       ->setCaptcha(new Captcha\Dumb())
       ->setLabel('Please verify you are human');

   // Within your view...

   echo $this->formCaptcha($captcha);

   // TODO
