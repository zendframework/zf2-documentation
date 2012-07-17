
.. _zend.filter.introduction.staticfilter:

Using the StaticFilter
======================

If it is inconvenient to load a given filter class and create an instance of the filter, you can use ``StaticFilter`` with it's method ``execute()`` as an alternative invocation style. The first argument of this method is a data input value, that you would pass to the ``filter()`` method. The second argument is a string, which corresponds to the basename of the filter class, relative to the ``Zend_Filter`` namespace. The ``execute()`` method automatically loads the class, creates an instance, and applies the ``filter()`` method to the data input.

.. code-block:: php
   :linenos:

   echo StaticFilter::execute('&', 'HtmlEntities');

You can also pass an array of constructor arguments, if they are needed for the filter class.

.. code-block:: php
   :linenos:

   echo StaticFilter::execute('"',
                              'HtmlEntities',
                              array('quotestyle' => ENT_QUOTES));

The static usage can be convenient for invoking a filter ad hoc, but if you have the need to run a filter for multiple inputs, it's more efficient to follow the first example above, creating an instance of the filter object and calling its ``filter()`` method.

Also, the ``FilterChain`` class allows you to instantiate and run multiple filter and validator classes on demand to process sets of input data. See :ref:`FilterChain <zend.filter.chain>`.


