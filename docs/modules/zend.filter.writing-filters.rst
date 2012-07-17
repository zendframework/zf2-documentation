
.. _zend.filter.writing_filters:

Writing Filters
===============

``Zend_Filter`` supplies a set of commonly needed filters, but developers will often need to write custom filters for their particular use cases. The task of writing a custom filter is facilitated by implementing ``Zend_Filter_Interface``.

``Zend_Filter_Interface`` defines a single method, ``filter()``, that may be implemented by user classes. An object that implements this interface may be added to a filter chain with ``Zend_Filter::addFilter()``.

The following example demonstrates how to write a custom filter:

.. code-block:: php
   :linenos:

   class MyFilter implements Zend_Filter_Interface
   {
       public function filter($value)
       {
           // perform some transformation upon $value to arrive on $valueFiltered

           return $valueFiltered;
       }
   }

To add an instance of the filter defined above to a filter chain:

.. code-block:: php
   :linenos:

   $filterChain = new Zend_Filter();
   $filterChain->addFilter(new MyFilter());


