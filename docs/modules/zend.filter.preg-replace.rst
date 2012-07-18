.. _zend.filter.set.pregreplace:

PregReplace
===========

``Zend_Filter_PregReplace`` performs a search using regular expressions and replaces all found elements.

.. _zend.filter.set.pregreplace.options:

Supported options for Zend_Filter_PregReplace
---------------------------------------------

The following options are supported for ``Zend_Filter_PregReplace``:

- **match**: The pattern which will be searched for.

- **replace**: The string which is used as replacement for the matches.

.. _zend.filter.set.pregreplace.basic:

Basic usage
-----------

To use this filter properly you must give two options:

The option ``match`` has to be given to set the pattern which will be searched for. It can be a string for a single pattern, or an array of strings for multiple pattern.

To set the pattern which will be used as replacement the option ``replace`` has to be used. It can be a string for a single pattern, or an array of strings for multiple pattern.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_PregReplace(array(
       'match'   => '/bob/',
       'replace' => 'john',
   ));
   $input  = 'Hy bob!";

   $filter->filter($input);
   // returns 'Hy john!'

You can use ``getMatchPattern()`` and ``setMatchPattern()`` to set the matching pattern afterwards. To set the replacement pattern you can use ``getReplacement()`` and ``setReplacement()``.

.. code-block:: php
   :linenos:

   $filter = new Zend_Filter_PregReplace();
   $filter->setMatchPattern(array('bob', 'Hy'))
         ->setReplacement(array('john', 'Bye'));
   $input  = 'Hy bob!";

   $filter->filter($input);
   // returns 'Bye john!'

For a more complex usage take a look into *PHP*'s `PCRE Pattern Chapter`_.



.. _`PCRE Pattern Chapter`: http://www.php.net/manual/en/reference.pcre.pattern.modifiers.php
