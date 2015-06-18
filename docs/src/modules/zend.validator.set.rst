.. _zend.validator.set:

Standard Validation Classes
===========================

Zend Framework comes with a standard set of validation classes, which are ready for you to use.

.. _zend.validator.included-validators:

Included Validators
-------------------

- :ref:`Alnum <zend.i18n.validator.alnum>`
- :ref:`Alpha <zend.i18n.validator.alpha>`
- :ref:`Barcode <zend.validator.barcode>`
- :ref:`Between <zend.validator.between>`
- :ref:`Callback <zend.validator.callback>`
- :ref:`CreditCard <zend.validator.creditcard>`
- :ref:`Date <zend.validator.date>`
- :ref:`Db\\RecordExists and Db\\NoRecordExists <zend.validator.db>`
- :ref:`Digits <zend.validator.digits>`
- :ref:`EmailAddress <zend.validator.email_address>`
- :ref:`File Validation Classes <zend.validator.file>`
- :ref:`GreaterThan <zend.validator.greaterthan>`
- :ref:`Hex <zend.validator.hex>`
- :ref:`Hostname <zend.validator.hostname>`
- :ref:`Iban <zend.validator.iban>`
- :ref:`Identical <zend.validator.identical>`
- :ref:`InArray <zend.validator.in_array>`
- :ref:`Ip <zend.validator.ip>`
- :ref:`Isbn <zend.validator.isbn>`
- :ref:`IsFloat <zend.i18n.validator.float>`
- :ref:`IsInt <zend.i18n.validator.int>`
- :ref:`LessThan <zend.validator.lessthan>`
- :ref:`NotEmpty <zend.validator.notempty>`
- :ref:`PostCode <zend.validator.post_code>`
- :ref:`Regex <zend.validator.regex>`
- :ref:`Sitemap <zend.validator.sitemap>`
- :ref:`Step <zend.validator.step>`
- :ref:`StringLength <zend.validator.stringlength>`
- :ref:`Timezone <zend.validator.timezone>`
- :ref:`Uri <zend.validator.uri>`

.. _zend.validator.set.deprecated-validators:

Deprecated Validators
---------------------

.. _zend.validator.set.ccnum:

Ccnum
^^^^^

The ``Ccnum`` validator has been deprecated in favor of the ``CreditCard`` validator. For security reasons you
should use CreditCard instead of Ccnum.
