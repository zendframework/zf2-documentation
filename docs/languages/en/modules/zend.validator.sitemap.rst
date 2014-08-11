:orphan:

.. _zend.validator.sitemap:

Sitemap Validators
==================

The following validators conform to the `Sitemap XML protocol`_.

.. _zend.validator.sitemap.changefreq:

Sitemap\\Changefreq
-------------------

Validates whether a string is valid for using as a 'changefreq' element in a Sitemap *XML* document. Valid values
are: 'always', 'hourly', 'daily', 'weekly', 'monthly', 'yearly', or 'never'.

Returns ``TRUE`` if and only if the value is a string and is equal to one of the frequencies specified above.

.. _zend.validator.sitemap.lastmod:

Sitemap\\Lastmod
----------------

Validates whether a string is valid for using as a 'lastmod' element in a Sitemap *XML* document. The lastmod
element should contain a *W3C* date string, optionally discarding information about time.

Returns ``TRUE`` if and only if the given value is a string and is valid according to the protocol.

.. _zend.validator.sitemap.lastmod.example:

.. rubric:: Sitemap Lastmod Validator

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Sitemap\Lastmod();

   $validator->isValid('1999-11-11T22:23:52-02:00'); // true
   $validator->isValid('2008-05-12T00:42:52+02:00'); // true
   $validator->isValid('1999-11-11'); // true
   $validator->isValid('2008-05-12'); // true

   $validator->isValid('1999-11-11t22:23:52-02:00'); // false
   $validator->isValid('2008-05-12T00:42:60+02:00'); // false
   $validator->isValid('1999-13-11'); // false
   $validator->isValid('2008-05-32'); // false
   $validator->isValid('yesterday'); // false

.. _zend.validator.sitemap.loc:

Sitemap\\Loc
------------

Validates whether a string is valid for using as a 'loc' element in a Sitemap *XML* document. This uses
``Zend\Uri\Uri::isValid()`` internally. Read more at :ref:`URI Validation <zend.uri.validation>`.

.. _zend.validator.sitemap.priority:

Sitemap\\Priority
-----------------

Validates whether a value is valid for using as a 'priority' element in a Sitemap *XML* document. The value should
be a decimal between 0.0 and 1.0. This validator accepts both numeric values and string values.

.. _zend.validator.sitemap.priority.example:

.. rubric:: Sitemap Priority Validator

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Sitemap\Priority();

   $validator->isValid('0.1'); // true
   $validator->isValid('0.789'); // true
   $validator->isValid(0.8); // true
   $validator->isValid(1.0); // true

   $validator->isValid('1.1'); // false
   $validator->isValid('-0.4'); // false
   $validator->isValid(1.00001); // false
   $validator->isValid(0xFF); // false
   $validator->isValid('foo'); // false

.. _zend.validator.sitemap.options:

Supported options for Zend\\Validator\\Sitemap_*
------------------------------------------------

There are no supported options for any of the Sitemap validators.



.. _`Sitemap XML protocol`: http://www.sitemaps.org/protocol.php
