.. _zend.input-filter.specs:

Input filter specifications
===========================

``Zend\InputFilter`` allow configuration-driven creation of input
filters via ``InputFilterAbstractServiceFactory``.
This abstract factory is responsible for creating and returning an
appropriate input filter given a name and the configuration from the top-level key
``input_filter_specs``.

It is registered with ``Zend\InputFilter\InputFilterPluginManager``,
so the input filter can be retrieved through Input Filter

Setup
-----

This functionality is disabled by default.
To enable it, you must add the
``Zend\InputFilter\InputFilterAbstractServiceFactory`` abstract factory
into the ``input_filter`` key.

.. code-block:: php
   :linenos:

   return array(
       'input_filter' => array(
           'abstract_factories' => array(
               'Zend\InputFilter\InputFilterAbstractServiceFactory'
           ),
       ),
   );

Example
-------

In the following code, we defined an input filter named ``foobar``:

.. code-block:: php
   :linenos:

   return array(
       'input_filter_specs' => array(
           'foobar' => array(
               0 => array(
                   'name' => 'name',
                   'required' => true,
                   'filters' => array(
                       0 => array(
                           'name' => 'Zend\Filter\StringTrim',
                           'options' => array(),
                       ),
                   ),
                   'validators' => array(),
                   'description' => 'Hello to name',
                   'allow_empty' => false,
                   'continue_if_empty' => false,
           ),
       ),
   );

Then from a controller, we retrieve it via the ``InputFilterManager``:

.. code-block:: php
   :linenos:

   $inputFilter = $this->services->get('InputFilterManager')->get('foobar');

And you can use it, as you already did with other input filters:

.. code-block:: php
   :linenos:

   $inputFilter->setData(array(
           'name' => 'test',
       )
   );

   if (!$inputFilter->isValid()) {
       echo 'Data invalid';
   }
