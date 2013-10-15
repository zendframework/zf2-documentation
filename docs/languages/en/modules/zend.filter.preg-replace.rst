.. _zend.filter.set.pregreplace:

PregReplace
-----------

``Zend\Filter\PregReplace`` performs a search using regular expressions and replaces all found elements.

.. _zend.filter.set.pregreplace.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\PregReplace``:

- **pattern**: The pattern which will be searched for.

- **replacement**: The string which is used as replacement for the matches.

.. _zend.filter.set.pregreplace.basic:

.. rubric:: Basic Usage

To use this filter properly you must give two options:

The option ``pattern`` has to be given to set the pattern which will be searched for. It can be a string for a
single pattern, or an array of strings for multiple pattern.

To set the pattern which will be used as replacement the option ``replacement`` has to be used. It can be a string
for a single pattern, or an array of strings for multiple pattern.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\PregReplace(array(
       'pattern'     => '/bob/',
       'replacement' => 'john',
   ));
   $input  = 'Hi bob!';

   $filter->filter($input);
   // returns 'Hi john!'

You can use ``getPattern()`` and ``setPattern()`` to set the matching pattern afterwards. To set the
replacement pattern you can use ``getReplacement()`` and ``setReplacement()``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\PregReplace();
   $filter->setMatchPattern(array('bob', 'Hi'))
         ->setReplacement(array('john', 'Bye'));
   $input  = 'Hi bob!';

   $filter->filter($input);
   // returns 'Bye john!'

For a more complex usage take a look into *PHP*'s `PCRE Pattern Chapter`_.



.. _`PCRE Pattern Chapter`: http://www.php.net/manual/en/reference.pcre.pattern.modifiers.php
