.. _zend.i18n.filter.alnum:

Alnum
-----

The ``Alnum`` filter can be used to return only alphabetic characters and digits in the unicode "letter" and
"number" categories, respectively. All other characters are suppressed.

.. _zend.i18n.filter.alnum.options:

.. rubric:: Supported Options for Alnum Filter

The following options are supported for ``Alnum``:

``Alnum([ boolean $allowWhiteSpace [, string $locale ]])``

- ``$allowWhiteSpace``: If set to true then whitespace characters are allowed. Otherwise they are suppressed.
  Default is "false" (whitespace is not allowed).

  Methods for getting/setting the allowWhiteSpace option are also available: ``getAllowWhiteSpace()`` and
  ``setAllowWhiteSpace()``

- ``$locale``: The locale string used in identifying the characters to filter (locale name, e.g. en_US). If unset,
  it will use the default locale (``Locale::getDefault()``).

  Methods for getting/setting the locale are also available: ``getLocale()`` and ``setLocale()``

.. _zend.i18n.filter.alnum.usage:

.. rubric:: Alnum Filter Usage

.. code-block:: php
   :linenos:

   // Default settings, deny whitespace
   $filter = new \Zend\I18n\Filter\Alnum();
   echo $filter->filter("This is (my) content: 123");
   // Returns "Thisismycontent123"

   // First param in constructor is $allowWhiteSpace
   $filter = new \Zend\I18n\Filter\Alnum(true);
   echo $filter->filter("This is (my) content: 123");
   // Returns "This is my content 123"

.. note::

   ``Alnum`` works on almost all languages, except: Chinese, Japanese and Korean. Within these languages the
   english alphabet is used instead of the characters from these languages. The language itself is detected using
   the ``Locale``.


