.. _zend.validator.isbn:

Isbn Validator
==============

``Zend\Validator\Isbn`` allows you to validate an *ISBN-10* or *ISBN-13* value.

.. _zend.validator.isbn.options:

Supported options for Zend\\Validator\\Isbn
-------------------------------------------

The following options are supported for ``Zend\Validator\Isbn``:

- **separator**: Defines the allowed separator for the *ISBN* number. It defaults to an empty string.

- **type**: Defines the allowed type of *ISBN* numbers. It defaults to ``Zend\Validator\Isbn::AUTO``. For details
  take a look at :ref:`this section <zend.validator.isbn.type-explicit>`.

.. _zend.validator.isbn.basic:

Basic usage
-----------

A basic example of usage is below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Isbn();
   if ($validator->isValid($isbn)) {
       // isbn is valid
   } else {
       // isbn is not valid
   }

This will validate any *ISBN-10* and *ISBN-13* without separator.

.. _zend.validator.isbn.type-explicit:

Setting an explicit ISBN validation type
----------------------------------------

An example of an *ISBN* type restriction is below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Isbn();
   $validator->setType(Zend\Validator\Isbn::ISBN13);
   // OR
   $validator = new Zend\Validator\Isbn(array(
       'type' => Zend\Validator\Isbn::ISBN13,
   ));

   if ($validator->isValid($isbn)) {
       // this is a valid ISBN-13 value
   } else {
       // this is an invalid ISBN-13 value
   }

The above will validate only *ISBN-13* values.

Valid types include:

- ``Zend\Validator\Isbn::AUTO`` (default)

- ``Zend\Validator\Isbn::ISBN10``

- ``Zend\Validator\Isbn::ISBN13``

.. _zend.validator.isbn.separator:

Specifying a separator restriction
----------------------------------

An example of separator restriction is below:

.. code-block:: php
   :linenos:

   $validator = new Zend\Validator\Isbn();
   $validator->setSeparator('-');
   // OR
   $validator = new Zend\Validator\Isbn(array(
       'separator' => '-',
   ));

   if ($validator->isValid($isbn)) {
       // this is a valid ISBN with separator
   } else {
       // this is an invalid ISBN with separator
   }

.. note::

   **Values without separator**

   This will return ``FALSE`` if ``$isbn`` doesn't contain a separator **or** if it's an invalid *ISBN* value.

Valid separators include:

- "" (empty) (default)

- "-" (hyphen)

- " " (space)


