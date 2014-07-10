.. _performance.localization:

Internationalization (i18n) and Localization (l10n)
===================================================

Internationalizing and localizing a site are fantastic ways to expand your audience and ensure that all visitors
can get to the information they need. However, it often comes with a performance penalty. Below are some strategies
you can employ to reduce the overhead of i18n and l10n.

.. _performance.localization.translationadapter:

Which translation adapter should I use?
---------------------------------------

Not all translation adapters are made equal. Some have more features than others, and some perform better than
others. Additionally, you may have business requirements that force you to use a particular adapter. However, if
you have a choice, which adapters are fastest?

.. _performance.localization.translationadapter.fastest:

Use non-XML translation adapters for greatest speed
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Zend Framework ships with a variety of translation adapters. Fully half of them utilize an *XML* format, incurring
memory and performance overhead. Fortunately, there are several adapters that utilize other formats that can be
parsed much more quickly. In order of speed, from fastest to slowest, they are:

- **Array**: this is the fastest, as it is, by definition, parsed into a native *PHP* format immediately on
  inclusion.

- **CSV**: uses ``fgetcsv()`` to parse a *CSV* file and transform it into a native *PHP* format.

- **INI**: uses ``parse_ini_file()`` to parse an *INI* file and transform it into a native *PHP* format. This and
  the *CSV* adapter are roughly equivalent performance-wise.

- **Gettext**: The gettext adapter from Zend Framework does **not** use the gettext extension as it is not thread
  safe and does not allow specifying more than one locale per server. As a result, it is slower than using the
  gettext extension directly, but, because the gettext format is binary, it's faster to parse than *XML*.

If high performance is one of your concerns, we suggest utilizing one of the above adapters.

.. _performance.localization.cache:

How can I make translation and localization even faster?
--------------------------------------------------------

Maybe, for business reasons, you're limited to an *XML*-based translation adapter. Or perhaps you'd like to speed
things up even more. Or perhaps you want to make l10n operations faster. How can you do this?

.. _performance.localization.cache.usage:

Use translation and localization caches
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Both ``Zend_Translator`` and ``Zend_Locale`` implement caching functionality that can greatly affect performance.
In the case of each, the major bottleneck is typically reading the files, not the actual lookups; using a cache
eliminates the need to read the translation and/or localization files.

You can read about caching of translation and localization strings in the following locations:

- :ref:`Zend_Translator adapter caching <zend.translator.adapter.caching>`

- :ref:`Zend_Locale caching <zend.locale.cache>`


