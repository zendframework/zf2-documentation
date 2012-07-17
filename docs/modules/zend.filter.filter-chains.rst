
.. _zend.filter.filter_chains:

Filter Chains
=============

Often multiple filters should be applied to some value in a particular order. For example, a login form accepts a username that should be only lowercase, alphabetic characters. ``Zend_Filter`` provides a simple method by which filters may be chained together. The following code illustrates how to chain together two filters for the submitted username:

.. code-block:: php
   :linenos:

   // Create a filter chain and add filters to the chain
   $filterChain = new Zend_Filter();
   $filterChain->addFilter(new Zend_Filter_Alpha())
               ->addFilter(new Zend_Filter_StringToLower());

   // Filter the username
   $username = $filterChain->filter($_POST['username']);

Filters are run in the order they were added to ``Zend_Filter``. In the above example, the username is first removed of any non-alphabetic characters, and then any uppercase characters are converted to lowercase.

Any object that implements ``Zend_Filter_Interface`` may be used in a filter chain.


.. _zend.filter.filter_chains.order:

Changing filter chain order
---------------------------

Since 1.10, the ``Zend_Filter`` chain also supports altering the chain by prepending or appending filters. For example, the next piece of code does exactly the same as the other username filter chain example:

.. code-block:: php
   :linenos:

   // Create a filter chain and add filters to the chain
   $filterChain = new Zend_Filter();

   // this filter will be appended to the filter chain
   $filterChain->appendFilter(new Zend_Filter_StringToLower());

   // this filter will be prepended at the beginning of the filter chain.
   $filterChain->prependFilter(new Zend_Filter_Alpha());

   // Filter the username
   $username = $filterChain->filter($_POST['username']);


