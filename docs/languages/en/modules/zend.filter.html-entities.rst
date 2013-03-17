.. _zend.filter.set.htmlentities:

HtmlEntities
------------

Returns the string ``$value``, converting characters to their corresponding *HTML* entity equivalents where they
exist.

.. _zend.filter.set.htmlentities.options:

.. rubric:: Supported Options

The following options are supported for ``Zend\Filter\HtmlEntities``:

- **quotestyle**: Equivalent to the *PHP* htmlentities native function parameter **quote_style**. This allows you
  to define what will be done with 'single' and "double" quotes. The following constants are accepted:
  ``ENT_COMPAT``, ``ENT_QUOTES`` ``ENT_NOQUOTES`` with the default being ``ENT_COMPAT``.

- **charset**: Equivalent to the *PHP* htmlentities native function parameter **charset**. This defines the
  character set to be used in filtering. Unlike the *PHP* native function the default is 'UTF-8'. See
  "http://php.net/htmlentities" for a list of supported character sets.

  .. note::

     This option can also be set via the ``$options`` parameter as a Traversable object or array. The option
     key will be accepted as either charset or encoding.

- **doublequote**: Equivalent to the *PHP* htmlentities native function parameter **double_encode**. If set to
  false existing html entities will not be encoded. The default is to convert everything (true).

  .. note::

     This option must be set via the ``$options`` parameter or the ``setDoubleEncode()`` method.

.. _zend.filter.set.htmlentities.basic:

.. rubric:: Basic Usage

See the following example for the default behavior of this filter.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities();

   print $filter->filter('<');

.. _zend.filter.set.htmlentities.quotestyle:

.. rubric:: Quote Style

``Zend\Filter\HtmlEntities`` allows changing the quote style used. This can be useful when you want to leave
double, single, or both types of quotes un-filtered. See the following example:

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities(array('quotestyle' => ENT_QUOTES));

   $input  = "A 'single' and " . '"double"';
   print $filter->filter($input);

The above example returns ``A &#039;single&#039; and &quot;double&quot;``. Notice that ``'single'`` as well as
``"double"`` quotes are filtered.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities(array('quotestyle' => ENT_COMPAT));

   $input  = "A 'single' and " . '"double"';
   print $filter->filter($input);

The above example returns ``A 'single' and &quot;double&quot;``. Notice that ``"double"`` quotes are filtered while
``'single'`` quotes are not altered.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities(array('quotestyle' => ENT_NOQUOTES));

   $input  = "A 'single' and " . '"double"';
   print $filter->filter($input);

The above example returns ``A 'single' and "double"``. Notice that neither ``"double"`` or ``'single'`` quotes are
altered.

.. _zend.filter.set.htmlentities.:

.. rubric:: Helper Methods

To change or retrieve the ``quotestyle`` after instantiation, the two methods ``setQuoteStyle()`` and
``getQuoteStyle()`` may be used respectively. ``setQuoteStyle()`` accepts one parameter ``$quoteStyle``. The
following constants are accepted: ``ENT_COMPAT``, ``ENT_QUOTES``, ``ENT_NOQUOTES``

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities();

   $filter->setQuoteStyle(ENT_QUOTES);
   print $filter->getQuoteStyle(ENT_QUOTES);

To change or retrieve the ``charset`` after instantiation, the two methods ``setCharSet()`` and ``getCharSet()``
may be used respectively. ``setCharSet()`` accepts one parameter ``$charSet``. See "http://php.net/htmlentities"
for a list of supported character sets.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities();

   $filter->setQuoteStyle(ENT_QUOTES);
   print $filter->getQuoteStyle(ENT_QUOTES);

To change or retrieve the ``doublequote`` option after instantiation, the two methods ``setDoubleQuote()`` and
``getDoubleQuote()`` may be used respectively. ``setDoubleQuote()`` accepts one boolean parameter ``$doubleQuote``.

.. code-block:: php
   :linenos:

   $filter = new Zend\Filter\HtmlEntities();

   $filter->setQuoteStyle(ENT_QUOTES);
   print $filter->getQuoteStyle(ENT_QUOTES);


