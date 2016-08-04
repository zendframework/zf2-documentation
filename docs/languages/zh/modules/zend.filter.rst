.. _zend.filter.introduction:

Introduction to Zend\\Filter
============================

The ``Zend\Filter`` component provides a set of commonly needed data filters. It also provides a simple filter
chaining mechanism by which multiple filters may be applied to a single datum in a user-defined order.

.. _zend.filter.introduction.definition:

What is a filter?
-----------------

In the physical world, a filter is typically used for removing unwanted portions of input, and the desired portion
of the input passes through as filter output (e.g., coffee). In such scenarios, a filter is an operator that
produces a subset of the input. This type of filtering is useful for web applications - removing illegal input,
trimming unnecessary white space, etc.

This basic definition of a filter may be extended to include generalized transformations upon input. A common
transformation applied in web applications is the escaping of *HTML* entities. For example, if a form field is
automatically populated with untrusted input (e.g., from a web browser), this value should either be free of *HTML*
entities or contain only escaped *HTML* entities, in order to prevent undesired behavior and security
vulnerabilities. To meet this requirement, *HTML* entities that appear in the input must either be removed or
escaped. Of course, which approach is more appropriate depends on the situation. A filter that removes the *HTML*
entities operates within the scope of the first definition of filter - an operator that produces a subset of the
input. A filter that escapes the *HTML* entities, however, transforms the input (e.g., "&" is transformed to
"&amp;"). Supporting such use cases for web developers is important, and "to filter," in the context of using
``Zend\Filter``, means to perform some transformations upon input data.

.. _zend.filter.introduction.using:

Basic usage of filters
----------------------

Having this filter definition established provides the foundation for ``Zend\Filter\FilterInterface``, which
requires a single method named ``filter()`` to be implemented by a filter class.

Following is a basic example of using a filter upon two input data, the ampersand (**&**) and double quote (**"**)
characters:

.. code-block:: php
   :linenos:

   $htmlEntities = new Zend\Filter\HtmlEntities();

   echo $htmlEntities->filter('&'); // &amp;
   echo $htmlEntities->filter('"'); // &quot;

Also, if a Filter inherits from ``Zend\Filter\AbstractFilter`` (just like all out-of-the-box Filters)
you can also use them as such:

.. code-block:: php
   :linenos:

   $strtolower = new Zend\Filter\StringToLower;

   echo $strtolower('I LOVE ZF2!'); // i love zf2!
   $zf2love = $strtolower('I LOVE ZF2!');

.. include:: zend.filter.static-filter.rst

.. _zend.filter.introduction.caveats:

Double filtering
----------------

When using two filters after each other you have to keep in mind that it is often not possible to get the original
output by using the opposite filter. Take the following example:

.. code-block:: php
   :linenos:

   $original = "my_original_content";

   // Attach a filter
   $filter   = new Zend\Filter\Word\UnderscoreToCamelCase();
   $filtered = $filter->filter($original);

   // Use it's opposite
   $filter2  = new Zend\Filter\Word\CamelCaseToUnderscore();
   $filtered = $filter2->filter($filtered)

The above code example could lead to the impression that you will get the original output after the second filter
has been applied. But thinking logically this is not the case. After applying the first filter
**my_original_content** will be changed to **MyOriginalContent**. But after applying the second filter the result
is **My_Original_Content**.

As you can see it is not always possible to get the original output by using a filter which seems to be the
opposite. It depends on the filter and also on the given input.


