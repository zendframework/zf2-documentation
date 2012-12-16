.. _zend.filter.set.callback:

Callback
--------

This filter allows you to use own methods in conjunction with ``Zend\Filter``. You don't have to create a new
filter when you already have a method which does the job.

.. _zend.filter.set.callback.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\Callback``:

- **callback**: This sets the callback which should be used.

- **options**: This property sets the options which are used when the callback is processed.

.. _zend.filter.set.callback.basic:

.. rubric:: Basic Usage

The usage of this filter is quite simple. Let's expect we want to create a filter which reverses a string.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Callback('strrev');

   print $filter->filter('Hello!');
   // returns "!olleH"

As you can see it's really simple to use a callback to define a own filter. It is also possible to use a method,
which is defined within a class, by giving an array as callback.

.. code-block:: php
   :linenos:

   // Our classdefinition
   class MyClass
   {
       public function Reverse($param);
   }

   // The filter definition
   $filter = new Zend\Filter\Callback(array('MyClass', 'Reverse'));
   print $filter->filter('Hello!');

To get the actual set callback use ``getCallback()`` and to set another callback use ``setCallback()``.

.. note::

   **Possible exceptions**

   You should note that defining a callback method which can not be called will raise an exception.

.. _zend.filter.set.callback.parameters:

.. rubric:: Default Parameters Within a Callback

It is also possible to define default parameters, which are given to the called method as array when the filter is
executed. This array will be concatenated with the value which will be filtered.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\Callback(
       array(
           'callback' => 'MyMethod',
           'options'  => array('key' => 'param1', 'key2' => 'param2')
       )
   );
   $filter->filter(array('value' => 'Hello'));

When you would call the above method definition manually it would look like this:

.. code-block:: php
   :linenos:

   $value = MyMethod('Hello', 'param1', 'param2');


