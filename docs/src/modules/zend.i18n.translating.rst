.. _zend.i18n.translating:

Translating
===========

Zend\I18n comes with a complete translation suite which supports all major formats and includes popular features
like plural translations and text domains. The Translator component is mostly dependency free, except for the
fallback to a default locale, where it relies on the Intl PHP extension.

The translator itself is initialized without any parameters, as any configuration to it is optional. A translator
without any translations will actually do nothing but just return the given message IDs.

.. _zend.i18n.translating.adding-translations:

Adding translations
-------------------

To add translations to the translator, there are two options. You can either add every translation file
individually, which is the best way if you use translation formats which store multiple locales in the same file,
or you can add translations via a pattern, which works best for formats which contain one locale per file.

To add a single file to the translator, use the ``addTranslationFile()`` method:

.. code-block:: php
   :linenos:

   use Zend\I18n\Translator\Translator;

   $translator = new Translator();
   $translator->addTranslationFile($type, $filename, $textDomain, $locale);

The type given there is a name of one of the format loaders listed in the next section. Filename points to the
file containing the translations, and the text domain specifies a category name for the translations.
If the text domain is omitted, it will default to the "default" value. The locale specifies which language the
translated strings are from and is only required for formats which contain translations for a single locale.

.. note::

   For each text domain and locale combination, there can only be one file loaded. Every successive file would
   override the translations which were loaded prior.

When storing one locale per file, you should specify those files via a pattern. This allows you to add new
translations to the file system, without touching your code. Patterns are added with the
``addTranslationFilePattern()`` method:

.. code-block:: php
   :linenos:

   use Zend\I18n\Translator\Translator;

   $translator = new Translator();
   $translator->addTranslationFilePattern($type, $baseDir, $pattern, $textDomain);

The parameters for adding patterns is pretty similar to adding individual files, except that you don't specify a locale
and give the file location as a sprintf pattern. The locale is passed to the sprintf call, so you can either use %s
or %1$s where it should be substituted. So when your translation files are located in
/var/messages/LOCALE/messages.mo, you would specify your pattern as /var/messages/%s/messages.mo.

.. _zend.i18n.translating.supported-formats:

Supported formats
-----------------

The translator supports the following major translation formats:

- PHP arrays

- Gettext

- INI

.. _zend.i18n.translating.setting-a-locale:

Setting a locale
----------------

By default, the translator will get the locale to use from the Intl extension's ``Locale`` class. If you want to
set an alternative locale explicitly, you can do so by passing it to the ``setLocale()`` method.

When there is no translation for a specific message ID in a locale, the message ID itself will be returned by
default. Alternatively you can set a fallback locale which is used to retrieve a fallback translation. To do so,
pass it to the ``setFallbackLocale()`` method.

.. _zend.i18n.translating.translating-messages:

Translating messages
--------------------

Translating messages can accomplished by calling the ``translate()`` method of the translator:

.. code-block:: php
   :linenos:

   $translator->translate($message, $textDomain, $locale);

The message is the ID of your message to translate. If it does not exist in the loader translations or is empty,
the original message ID will be returned. The text domain parameter is the one you specified when adding
translations. If omitted, the default text domain will be used. The locale parameter will usually not be used in
this context, as by default the locale is taken from the locale set in the translator.

To translate plural messages, you can use the ``translatePlural()`` method. It works similar to ``translate()``,
but instead of a single message it takes a singular and a plural value and an additional integer number on which
the returned plural form is based on:

.. code-block:: php
   :linenos:

   $translator->translatePlural($singular, $plural, $number, $textDomain, $locale);

Plural translations are only available if the underlying format supports the transport of plural messages and
plural rule definitions.

.. _zend.i18n.translating.caching:

Caching
-------

In production it makes sense to cache your translations. This not only saves you from loading and parsing the
individual formats each time, but also guarantees an optimized loading procedure. To enable caching, simply pass a
``Zend\Cache\Storage\Adapter`` to the ``setCache()`` method. To disable the cache, you can just pass a null value
to it.


