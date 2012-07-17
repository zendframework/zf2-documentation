
.. _migration.110:

Zend Framework 1.10
===================

When upgrading from a previous release to Zend Framework 1.10 or higher you should note the following migration notes.


.. _migration.110.zend.controller.front:

Zend_Controller_Front
---------------------

A wrong behaviour was fixed, when there was no module route and no route matched the given request. Previously, the router returned an unmodified request object, so the front controller just displayed the default controller and action. Since Zend Framework 1.10, the router will correctly as noted in the router interface, throw an exception if no route matches. The error plugin will then catch that exception and forward to the error controller. You can then test for that specific error with the constant ``Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE``:

.. code-block:: php
   :linenos:

   /**
    * Before 1.10
    */
       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
       // ...

   /**
    * With 1.10
    */
       public function errorAction()
       {
           $errors = $this->_getParam('error_handler');

           switch ($errors->type) {
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ROUTE:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_CONTROLLER:
               case Zend_Controller_Plugin_ErrorHandler::EXCEPTION_NO_ACTION:
       // ...


.. _migration.110.zend.feed.reader:

Zend_Feed_Reader
----------------

With the introduction of Zend Framework 1.10, ``Zend_Feed_Reader``'s handling of retrieving Authors and Contributors was changed, introducing a break in backwards compatibility. This change was an effort to harmonise the treatment of such data across the RSS and Atom classes of the component and enable the return of Author and Contributor data in more accessible, usable and detailed form. It also rectifies an error in that it was assumed any author element referred to a name. In RSS this is incorrect as an author element is actually only required to provide an email address. In addition, the original implementation applied its RSS limits to Atom feeds significantly reducing the usefulness of the parser with that format.

The change means that methods like ``getAuthors()`` and ``getContributors`` no longer return a simple array of strings parsed from the relevant RSS and Atom elements. Instead, the return value is an ``ArrayObject`` subclass called ``Zend_Feed_Reader_Collection_Author`` which simulates an iterable multidimensional array of Authors. Each member of this object will be a simple array with three potential keys (as the source data permits). These include: name, email and uri.

The original behaviour of such methods would have returned a simple array of strings, each string attempting to present a single name, but in reality this was unreliable since there is no rule governing the format of RSS Author strings.

The simplest method of simulating the original behaviour of these methods is to use the ``Zend_Feed_Reader_Collection_Author``'s ``getValues()`` which also returns a simple array of strings representing the "most relevant data", for authors presumed to be their name. Each value in the resulting array is derived from the "name" value attached to each Author (if present). In most cases this simple change is easy to apply as demonstrated below.

.. code-block:: php
   :linenos:

   /**
    * Before 1.10
    */
   $feed = Zend_Feed_Reader::import('http://example.com/feed');
   $authors = $feed->getAuthors();

   /**
    * With 1.10
    */
   $feed = Zend_Feed_Reader::import('http://example.com/feed');
   $authors = $feed->getAuthors()->getValues();


.. _migration.110.zend.file.transfer:

Zend_File_Transfer
------------------


.. _migration.110.zend.file.transfer.files:

Security change
^^^^^^^^^^^^^^^

For security reasons ``Zend_File_Transfer`` does no longer store the original mimetype and filesize which is given from the requesting client into its internal storage. Instead the real values will be detected at initiation.

Additionally the original values within ``$_FILES`` will be overridden within the real values at initiation. This makes also ``$_FILES`` secure.

When you are in need of the original values you can either store them before initiating ``Zend_File_Transfer`` or use the ``disableInfos`` option at initiation. Note that this option is useless when its given after initiation.


.. _migration.110.zend.file.transfer.count:

Count validation
^^^^^^^^^^^^^^^^

Before release 1.10 the ``MimeType`` validator used a wrong naming. For consistency the following constants have been changed:


.. _migration.110.zend.file.transfer.count.table:

.. table:: Changed Validation Messages

   +--------+--------+-------------------------------------------------------------------+
   |Old     |New     |Value                                                              |
   +========+========+===================================================================+
   |TOO_MUCH|TOO_MANY|Too many files, maximum '%max%' are allowed but '%count%' are given|
   +--------+--------+-------------------------------------------------------------------+
   |TOO_LESS|TOO_FEW |Too few files, minimum '%min%' are expected but '%count%' are given|
   +--------+--------+-------------------------------------------------------------------+


When you are translating these messages within your code then use the new constants. As benefit you don't need to translate the original string anymore to get a correct spelling.


.. _migration.110.zend.filter.html-entities:

Zend_Filter_HtmlEntities
------------------------

In order to default to a more secure character encoding, ``Zend_Filter_HtmlEntities`` now defaults to *UTF-8* instead of *ISO-8859-1*.

Additionally, because the actual mechanism is dealing with character encodings and not character sets, two new methods have been added, ``setEncoding()`` and ``getEncoding()``. The previous methods ``setCharSet()`` and ``setCharSet()`` are now deprecated and proxy to the new methods. Finally, instead of using the protected members directly within the ``filter()`` method, these members are retrieved by their explicit accessors. If you were extending the filter in the past, please check your code and unit tests to ensure everything still continues to work.


.. _migration.110.zend.filter.strip-tags:

Zend_Filter_StripTags
---------------------

``Zend_Filter_StripTags`` contains a flag, ``commentsAllowed``, that, in previous versions, allowed you to optionally whitelist *HTML* comments in *HTML* text filtered by the class. However, this opens code enabling the flag to *XSS* attacks, particularly in Internet Explorer (which allows specifying conditional functionality via *HTML* comments). Starting in version 1.9.7 (and backported to versions 1.8.5 and 1.7.9), the ``commentsAllowed`` flag no longer has any meaning, and all *HTML* comments, including those containing other *HTML* tags or nested commments, will be stripped from the final output of the filter.


.. _migration.110.zend.translator:

Zend_Translator
---------------


.. _migration.110.zend.translator.xliff:

Xliff adapter
^^^^^^^^^^^^^

In past the Xliff adapter used the source string as message Id. According to the Xliff standard the trans-unit Id should be used. This behaviour was corrected with Zend Framework 1.10. Now the trans-unit Id is used as message Id per default.

But you can still get the incorrect and old behaviour by setting the ``useId`` option to ``FALSE``.

.. code-block:: php
   :linenos:

   $trans = new Zend_Translator(
       'xliff', '/path/to/source', $locale, array('useId' => false)
   );


.. _migration.110.zend.validate:

Zend_Validate
-------------


.. _migration.110.zend.validate.selfwritten:

Self written validators
^^^^^^^^^^^^^^^^^^^^^^^

When setting returning a error from within a self written validator you have to call the ``_error()`` method. Before Zend Framework 1.10 you were able to call this method without giving a parameter. It used then the first found message template.

This behaviour is problematic when you have validators with more than one different message to be returned. Also when you extend an existing validator you can get unexpected results. This could lead to the problem that your user get not the message you expected.

.. code-block:: php
   :linenos:

   My_Validator extends Zend_Validate_Abstract
   {
       public isValid($value)
       {
           ...
           $this->_error(); // unexpected results between different OS
           ...
       }
   }

To prevent this problem the ``_error()`` method is no longer allowed to be called without giving a parameter.

.. code-block:: php
   :linenos:

   My_Validator extends Zend_Validate_Abstract
   {
       public isValid($value)
       {
           ...
           $this->_error(self::MY_ERROR); // defined error, no unexpected results
           ...
       }
   }


.. _migration.110.zend.validate.datevalidator:

Simplification in date validator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before Zend Framework 1.10 2 identical messages were thrown within the date validator. These were ``NOT_YYYY_MM_DD`` and ``FALSEFORMAT``. As of Zend Framework 1.10 only the ``FALSEFORMAT`` message will be returned when the given date does not match the set format.


.. _migration.110.zend.validate.barcodevalidator:

Fixes in Alpha, Alnum and Barcode validator
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Before Zend Framework 1.10 the messages within the 2 barcode adapters, the Alpha and the Alnum validator were identical. This introduced problems when using custom messages, translations or multiple instances of these validators.

As with Zend Framework 1.10 the values of the constants were changed to be unique. When you used the constants as proposed in the manual there is no change for you. But when you used the content of the constants in your code then you will have to change them. The following table shows you the changed values:


.. _migration.110.zend.validate.barcodevalidator.table:

.. table:: Available Validation Messages

   +-------------+--------------+------------------+
   |Validator    |Constant      |Value             |
   +=============+==============+==================+
   |Alnum        |STRING_EMPTY  |alnumStringEmpty  |
   +-------------+--------------+------------------+
   |Alpha        |STRING_EMPTY  |alphaStringEmpty  |
   +-------------+--------------+------------------+
   |Barcode_Ean13|INVALID       |ean13Invalid      |
   +-------------+--------------+------------------+
   |Barcode_Ean13|INVALID_LENGTH|ean13InvalidLength|
   +-------------+--------------+------------------+
   |Barcode_UpcA |INVALID       |upcaInvalid       |
   +-------------+--------------+------------------+
   |Barcode_UpcA |INVALID_LENGTH|upcaInvalidLength |
   +-------------+--------------+------------------+
   |Digits       |STRING_EMPTY  |digitsStringEmpty |
   +-------------+--------------+------------------+



