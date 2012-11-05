.. EN-Revision: none
.. _zend.filter.set.pregreplace:

PregReplace
===========

``Zend\Filter\PregReplace`` performs a search using regular expressions and replaces all found elements.

The option ``match`` has to be given to set the pattern which will be searched for. It can be a string for a single
pattern, or an array of strings for multiple pattern.

To set the pattern which will be used as replacement the option ``replace`` has to be used. It can be a string for
a single pattern, or an array of strings for multiple pattern.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\PregReplace(array('match' => '/bob/',
                                               'replace' => 'john'));
   $input  = 'Hy bob!';

   $filter->filter($input);
   // returns 'Hy john!'

You can use ``getMatchPattern()`` and ``setMatchPattern()`` to set the matching pattern afterwards. To set the
replacement pattern you can use ``getReplacement()`` and ``setReplacement()``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\PregReplace();
   $filter->setMatchPattern(array('bob', 'Hy'))
          ->setReplacement(array('john', 'Bye'));
   $input  = 'Hy bob!";

   $filter->filter($input);
   // returns 'Bye john!'

For a more complex usage take a look into *PHP*'s `PCRE Pattern Chapter`_.



.. _`PCRE Pattern Chapter`: http://www.php.net/manual/en/reference.pcre.pattern.modifiers.php
