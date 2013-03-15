.. _zend.i18n.filter.alpha:

Alpha
-----

The ``Alpha`` filter can be used to return only alphabetic characters in the unicode "letter" category. All other
characters are suppressed.

.. _zend.i18n.filter.alpha.options:

.. rubric:: Supported Options for Alpha Filter

The following options are supported for ``Alpha``:

``Alpha([ boolean $allowWhiteSpace [, string $locale ]])``

- ``$allowWhiteSpace``: If set to true then whitespace characters are allowed. Otherwise they are suppressed.
  Default is "false" (whitespace is not allowed).

  Methods for getting/setting the allowWhiteSpace option are also available: ``getAllowWhiteSpace()`` and
  ``setAllowWhiteSpace()``

- ``$locale``: The locale string used in identifying the characters to filter (locale name, e.g. en_US). If unset,
  it will use the default locale (``Locale::getDefault()``).

  Methods for getting/setting the locale are also available: ``getLocale()`` and ``setLocale()``

.. _zend.i18n.filter.alpha.usage:

.. rubric:: Alpha Filter Usage

.. code-block:: php
   :linenos:

   // Default settings, deny whitespace
   $filter = new \Zend\I18n\Filter\Alpha();
   echo $filter->filter("This is (my) content: 123");
   // Returns "Thisismycontent"

   // Allow whitespace
   $filter = new \Zend\I18n\Filter\Alpha(true);
   echo $filter->filter("This is (my) content: 123");
   // Returns "This is my content "

.. note::

   ``Alpha`` works on almost all languages, except: Chinese, Japanese and Korean. Within these languages the
   english alphabet is used instead of the characters from these languages. The language itself is detected using
   the ``Locale``.


