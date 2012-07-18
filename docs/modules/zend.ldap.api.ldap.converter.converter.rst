.. _zend.ldap.api.reference.zend-ldap-converter-converter:

Zend\\Ldap\\Converter\\Converter
================================

``Zend\Ldap\Converter\Converter`` is a helper class providing only static methods to manipulate arrays suitable to
the data format required by the *LDAP* server. *PHP* data types are converted the following way:

**string**
   No conversion will be done.

**integer and float**
   The value will be converted to a string.

**boolean**
   ``TRUE`` will be converted to **'TRUE'** and ``FALSE`` to **'FALSE'**

**object and array**
   The value will be converted to a string by using ``serialize()``.

**Date/Time**
   The value will be converted to a string with the following ``date()`` format *YmdHisO*, UTC timezone (+0000)
   will be replaced with a *Z*. For example *01-30-2011 01:17:32 PM GMT-6* will be *20113001131732-0600* and
   *30-01-2012 15:17:32 UTC* will be *20120130151732Z*

**resource**
   If a *stream* resource is given, the data will be fetched by calling ``stream_get_contents()``.

**others**
   All other data types (namely non-stream resources) will be omitted.

On reading values the following conversion will take place:

**'TRUE'**
   Converted to ``TRUE``.

**'FALSE'**
   Converted to ``FALSE``.

**others**
   All other strings won't be automatically converted and are passed as they are.

.. _zend.ldap.api.reference.zend-ldap-converter-converter.table:

.. table:: Zend\\Ldap\\Converter\\Converter API

   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |Method                                                                   |Description                                                                                                                                                                                                                                                                                                           |
   +=========================================================================+======================================================================================================================================================================================================================================================================================================================+
   |string ascToHex32(string $string)                                        |Convert all Ascii characters with decimal value less than 32 to hexadecimal value.                                                                                                                                                                                                                                    |
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |string hex32ToAsc(string $string)                                        |Convert all hexadecimal characters by his Ascii value.                                                                                                                                                                                                                                                                |
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |string|null toLdap(mixed $value, int $type)                              |Converts a PHP data type into its LDAP representation. $type argument is used to set the conversion method by default Converter::STANDARD where the function will try to guess the conversion method to use, others possibilities are Converter::BOOLEAN and Converter::GENERALIZED_TIME See introduction for details.|
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |mixed fromLdap(string $value, int $type, boolean $dateTimeAsUtc)         |Converts an LDAP value into its PHP data type. See introduction and toLdap() and toLdapDateTime() for details.                                                                                                                                                                                                        |
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |string|null toLdapDateTime(integer|string|DateTime $date, boolean $asUtc)|Converts a timestamp, a DateTime Object, a string that is parseable by strtotime() or a DateTime into its LDAP date/time representation. If $asUtc is TRUE ( FALSE by default) the resulting LDAP date/time string will be inUTC, otherwise a local date/time string will be returned.                                |
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |DateTime fromLdapDateTime(string $date, boolean $asUtc)                  |Converts LDAP date/time representation into a PHP DateTime object.                                                                                                                                                                                                                                                    |
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |string toLdapBoolean(boolean|integer|string $value)                      |Converts a PHP data type into its LDAP boolean representation. By default always return 'FALSE' except if the value is true , 'true' or 1                                                                                                                                                                             |
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |boolean fromLdapBoolean(string $value)                                   |Converts LDAP boolean representation into a PHP boolean data type.                                                                                                                                                                                                                                                    |
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |string toLdapSerialize(mixed $value)                                     |The value will be converted to a string by using serialize().                                                                                                                                                                                                                                                         |
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   |mixed fromLdapUnserialize(string $value)                                 |The value will be converted from a string by using unserialize().                                                                                                                                                                                                                                                     |
   +-------------------------------------------------------------------------+----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+


