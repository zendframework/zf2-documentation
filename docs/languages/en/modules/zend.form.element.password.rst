.. _zend.form.element.password:

Password
^^^^^^^^

``Zend\Form\Element\Password`` represents a password form input.
It can be used with the ``Zend\Form\View\Helper\FormPassword`` view helper.

``Zend\Form\Element\Password`` extends from :ref:`Zend\\Form\\Element <zend.form.element>`.

.. _zend.form.element.password.usage:

.. rubric:: Basic Usage

This element automatically adds a ``"type"`` attribute of value ``"password"``.

.. code-block:: php
   :linenos:

   use Zend\Form\Element;
   use Zend\Form\Form;

   $password = new Element\Password('my-password');
   $password->setLabel('Enter your password');

   $form = new Form('my-form');
   $form->add($password);
